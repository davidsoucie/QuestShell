#!/usr/bin/env python3
"""
TourGuide -> QuestShell converter (fixed)
- Parses current/next/faction from TourGuide:RegisterGuide("Zone (x-y)", "Next (y-z)", "Alliance", function()
- Emits flat steps (no chapters)
- Prefers quest titles from quests.lua / quests_db.json when questId is present
- Supports pfDB["quests"]["<locale>"][id] = { ["T"] = "Title", ... } and simple formats
- Merges consecutive COMPLETE steps for same quest (e.g., 3521.1 + 3521.2)
- Strips stray TG tokens like |REACH| from notes
- Keys and filenames are QS_-prefixed:
    input:  01_12_Teldrassil.lua
    output: QS_01_12_Teldrassil.lua and QS_01_12_Teldrassil_README.md
    nextKey also becomes QS_<...>
"""

import os, re, json
from dataclasses import dataclass
from typing import Optional, Dict, Any, List, Iterable

Coord = Dict[str, Any]
NPC = Dict[str, str]

# -------------------- Regexes --------------------
COORD_RE = re.compile(r'\(([0-9]+(?:\.[0-9]+)?),\s*([0-9]+(?:\.[0-9]+)?)\)')
QID_RE   = re.compile(r'\|QID\|(\d+)(?:\.\d+)?\|', re.I)
NOTE_RE  = re.compile(r'\|N\|((?:[^|]|\|(?![A-Za-z0-9]+\|))+)\|', re.I)
USE_RE   = re.compile(r'\|U\|(\d+)\|', re.I)
CLASS_RE = re.compile(r'\|C\|([A-Za-z,]+)\|', re.I)
RACE_RE  = re.compile(r'\|R\|([A-Za-z,]+)\|', re.I)
LOOT_RE  = re.compile(r'\|L\|(\d+)\s+(\d+)\|', re.I)

REGISTER_RE = re.compile(
    r'TourGuide:RegisterGuide\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*function',
    re.IGNORECASE,
)

# quests.lua patterns (simple/legacy)
QL_SIMPLE_DQ = re.compile(r'\[\s*(\d+)\s*\]\s*=\s*"([^"]+)"')
QL_SIMPLE_SQ = re.compile(r"\[\s*(\d+)\s*\]\s*=\s*'([^']+)'")
QL_NAME_DQ   = re.compile(r'\[\s*"?(\d+)"?\s*\]\s*=\s*\{[^}]*?\bname\s*=\s*"([^"]+)"', re.S)
QL_NAME_SQ   = re.compile(r"\[\s*\"?(\d+)\"?\s*\]\s*=\s*\{[^}]*?\bname\s*=\s*'([^']+)'", re.S)
# pfDB-style entry: [916] = { ["T"] = "Title", ... } (supports single/double quotes and string keys)
PFDB_ENTRY = re.compile(r'\[\s*"?(\d+)"?\s*\]\s*=\s*\{(.*?)\}', re.S)
PFDB_T_DQ  = re.compile(r'\[\s*"(?:T)"\s*\]\s*=\s*"((?:[^"\\]|\\.)*)"')
PFDB_T_SQ  = re.compile(r"\[\s*'(?:T)'\s*\]\s*=\s*'((?:[^'\\]|\\.)*)'")

# -------------------- Helpers --------------------
def first_coords(text: str) -> Optional[Coord]:
    m = COORD_RE.search(text or '')
    if not m:
        return None
    try:
        x = float(m.group(1)); y = float(m.group(2))
        return {"x": x, "y": y}
    except Exception:
        return None

def extract_qid(text: str) -> Optional[int]:
    m = QID_RE.search(text or '')
    return int(m.group(1)) if m else None

def clean_note_text(note: str) -> str:
    if not note:
        return ""
    note = re.sub(r'\s*\|[A-Za-z][A-Za-z0-9]*\|\s*', ' ', note)  # drop |REACH|, |NC|, etc.
    note = note.replace('|', ' ')
    note = re.sub(r'\s+', ' ', note).strip()
    return note

def extract_note(text: str) -> str:
    m = NOTE_RE.search(text or '')
    if not m:
        return ""
    return clean_note_text(m.group(1))

def extract_item_use(text: str) -> Optional[int]:
    m = USE_RE.search(text or '')
    return int(m.group(1)) if m else None

def extract_loot(text: str):
    m = LOOT_RE.search(text or '')
    if not m:
        return None, None
    return int(m.group(1)), int(m.group(2))

def extract_class(text: str) -> Optional[str]:
    m = CLASS_RE.search(text or '')
    return m.group(1).strip() if m else None

def extract_race(text: str) -> Optional[str]:
    m = RACE_RE.search(text or '')
    return m.group(1).strip() if m else None

def clean_title(raw: str) -> str:
    title = (raw or '').strip()
    title = re.sub(r'\s*\(Part\s*\d+\)\s*', '', title, flags=re.I)
    return title.strip()

def parse_register_header(src: str):
    m = REGISTER_RE.search(src or "")
    if not m:
        return None, None, None
    return m.group(1).strip(), m.group(2).strip(), m.group(3).strip()

def parse_minmax_from_title(title: Optional[str]):
    if not title:
        return 1, 60
    m = re.search(r'\((\d+)\s*-\s*(\d+)\)', title or '')
    if m:
        try:
            return int(m.group(1)), int(m.group(2))
        except Exception:
            pass
    return 1, 60

def sanitize_key(title: str) -> str:
    if not title:
        return "ConvertedGuide"
    m = re.search(r'^(.*?)[\s_]*\((\d+)\s*-\s*(\d+)\)\s*$', title.strip())
    if m:
        zone = re.sub(r'\s+', '_', m.group(1).strip())
        zone = re.sub(r'[^A-Za-z0-9_]', '', zone)
        return f"{zone}_{m.group(2)}_{m.group(3)}"
    key = re.sub(r'\s+', '_', title.strip())
    key = re.sub(r'[^A-Za-z0-9_]', '', key)
    return key

def qs_prefixed(key: str) -> str:
    if not key:
        return "QS_ConvertedGuide"
    return key if key.startswith("QS_") else f"QS_{key}"

# -------------------- NPC inference --------------------
NPC_PATTERNS = [
    re.compile(r'(?:speak|talk)\s+(?:to\s+)?([A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,4})', re.I),
    re.compile(r'(Innkeeper\s+[A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,3})', re.I),
    re.compile(r'([A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,4})\s*,?\s+(?:in|at)\s+', re.I),
]
STOPWORDS = set(['and','grab','get','buy','sell','train','then','for','the','a','an','flight','path','fp','fly','to','from'])

def _refine_npc(raw: str) -> str:
    if not raw: return ""
    parts = raw.strip().split()
    kept = []
    for token in parts:
        if token.lower() in STOPWORDS:
            break
        if token[:1].isupper():
            kept.append(token)
        else:
            break
    return " ".join(kept).strip()

def infer_npc(note: str) -> Optional[str]:
    text = note or ""
    for pat in NPC_PATTERNS:
        m = pat.search(text)
        if m:
            name = _refine_npc(m.group(1))
            if name:
                return name
    return None

# -------------------- BUY/SELL as NOTE --------------------
def is_buy_or_sell(line: str, title: str, note: str) -> bool:
    hay = f"{title} {note}".lower()
    if " sell " in f" {hay} " or hay.startswith("sell "):
        return True
    if " buy " in f" {hay} " or hay.startswith("buy "):
        return True
    if line[:1] in ("B", "b"):
        return True
    return False

# -------------------- Quest DB --------------------
def _walk_files(roots: Iterable[str], names: Iterable[str], max_depth: int = 6) -> List[str]:
    seen = set()
    found = []
    for root in roots:
        if not root or not os.path.isdir(root):
            continue
        root = os.path.abspath(root)
        for dirpath, dirnames, filenames in os.walk(root):
            depth = os.path.relpath(dirpath, root).count(os.sep)
            if depth > max_depth:
                del dirnames[:]  # prune deep
                continue
            for nm in names:
                if nm in filenames:
                    fp = os.path.join(dirpath, nm)
                    if fp not in seen:
                        seen.add(fp); found.append(fp)
    return found

def _parse_quests_lua_text(txt: str, quest_map: Dict[int,str]) -> None:
    # simple mappings
    for m in QL_SIMPLE_DQ.finditer(txt):
        quest_map[int(m.group(1))] = m.group(2)
    for m in QL_SIMPLE_SQ.finditer(txt):
        quest_map[int(m.group(1))] = m.group(2)
    for m in QL_NAME_DQ.finditer(txt):
        quest_map[int(m.group(1))] = m.group(2)
    for m in QL_NAME_SQ.finditer(txt):
        quest_map[int(m.group(1))] = m.group(2)
    # pfDB-style: extract ["T"]
    for m in PFDB_ENTRY.finditer(txt):
        qid = int(m.group(1))
        body = m.group(2)
        t = None
        m1 = PFDB_T_DQ.search(body)
        if m1:
            t = m1.group(1)
        else:
            m2 = PFDB_T_SQ.search(body)
            if m2:
                t = m2.group(1)
        if t is not None:
            t = t.replace('\\"','"').replace("\\'", "'")
            quest_map[qid] = t

def load_quest_db(search_roots: List[str]) -> Dict[int, str]:
    paths = list(dict.fromkeys([p for p in (search_roots or []) if p]))
    cwd = os.getcwd()
    if cwd not in paths: paths.append(cwd)

    quest_map: Dict[int, str] = {}

    # JSON exact + recursive
    json_files = []
    for d in paths:
        jf = os.path.join(d, "quests_db.json")
        if os.path.isfile(jf): json_files.append(jf)
    if not json_files:
        json_files = _walk_files(paths, ["quests_db.json"], max_depth=6)

    for jf in json_files:
        try:
            with open(jf, "r", encoding="utf-8") as f:
                raw = json.load(f)
            for k, v in raw.items():
                try:
                    quest_map[int(k)] = str(v)
                except Exception:
                    continue
        except Exception:
            pass

    # Lua exact + recursive
    lua_files = []
    for d in paths:
        lf = os.path.join(d, "quests.lua")
        if os.path.isfile(lf): lua_files.append(lf)
    if not lua_files:
        lua_files = _walk_files(paths, ["quests.lua"], max_depth=6)

    for lf in lua_files:
        try:
            txt = open(lf, "r", encoding="utf-8", errors="ignore").read()
            _parse_quests_lua_text(txt, quest_map)
        except Exception:
            pass

    return quest_map

# -------------------- Step model --------------------
@dataclass
class Step:
    type: str
    title: str = ""
    questId: Optional[int] = None
    coords: Optional[Coord] = None
    npc: Optional[NPC] = None
    note: str = ""
    itemId: Optional[int] = None
    itemCount: Optional[int] = None
    destination: Optional[str] = None
    klass: Optional[str] = None
    race: Optional[str] = None
    line_num: int = 0
    src_op: str = ""  # original TG opcode (A/T/C/L/K/...)

    def to_lua(self) -> str:
        fields: List[str] = [f'type="{self.type}"']

        def add_str(key: str, val: Optional[str]):
            if val is None or val == "":
                return
            s = val.replace('\\', '\\\\').replace('"', '\\"')
            fields.append(f'{key}="{s}"')

        def add_int(key: str, val: Optional[int]):
            if val is None:
                return
            fields.append(f'{key}={val}')

        def add_coords(c: Optional[Coord]):
            if not c:
                return
            if "map" in c:
                fields.append(f'coords={{ x={c["x"]}, y={c["y"]}, map="{c["map"]}" }}')
            else:
                fields.append(f'coords={{ x={c["x"]}, y={c["y"]} }}')

        def add_npc(n: Optional[NPC]):
            if not n:
                return
            fields.append(f'npc = {{ name="{n.get("name","")}" }}')

        # restriction tags
        add_str("class", self.klass)
        add_str("race", self.race)

        t = self.type.upper()

        if t in ("ACCEPT", "TURNIN"):
            add_str("title", self.title)
            add_int("questId", self.questId)
            add_coords(self.coords)
            add_npc(self.npc)
            add_str("note", self.note)

        elif t == "COMPLETE":
            add_str("title", self.title)
            add_int("questId", self.questId)
            add_int("itemId", self.itemId)
            if self.itemCount is not None:
                add_int("itemCount", self.itemCount)
            add_coords(self.coords)
            add_str("note", self.note)

        elif t == "SET_HEARTH":
            add_str("title", self.title)
            add_coords(self.coords)
            add_npc(self.npc)
            add_str("note", self.note)

        elif t == "FLY":
            add_coords(self.coords)
            add_npc(self.npc)
            add_str("destination", self.destination)
            add_str("note", self.note)

        elif t == "FLIGHTPATH":
            add_npc(self.npc)
            add_coords(self.coords)
            add_str("note", self.note)

        elif t == "TRAVEL":
            add_coords(self.coords)
            add_str("note", self.note)

        elif t == "NOTE":
            add_str("note", self.note if self.note else self.title)
            add_coords(self.coords)

        else:
            add_str("title", self.title)
            add_coords(self.coords)
            if self.questId is not None and t != "NOTE":
                add_int("questId", self.questId)
            add_str("note", self.note)

        return "{ " + ", ".join(fields) + " }"

# -------------------- Converter --------------------
class TourGuideConverter:
    def __init__(self, quest_db_dirs: Optional[List[str]] = None):
        self.stats = {"total_lines": 0, "converted_steps": 0, "issues_found": 0}
        self._now = None
        self.quest_titles: Dict[int, str] = {}
        if quest_db_dirs:
            self.quest_titles = load_quest_db(quest_db_dirs)

    def convert_guide(self, input_path: str, output_path: Optional[str] = None, guide_name: Optional[str] = None):
        from pathlib import Path

        # Build search roots: input dir, its parent, CWD
        roots = []
        inp_dir = str(Path(input_path).parent)
        roots.append(inp_dir)
        roots.append(str(Path(inp_dir).parent))
        roots.append(os.getcwd())

        if not self.quest_titles:
            self.quest_titles = load_quest_db(roots)

        src = Path(input_path).read_text(encoding="utf-8", errors="ignore")

        # Parse header for titles + faction
        display_title, next_title, faction = parse_register_header(src)
        min_level, max_level = parse_minmax_from_title(display_title)

        # Build steps
        steps = self._parse_tourguide(src)

        # Merge multiple COMPLETE lines for the same quest into one
        steps = self._merge_same_quest_completes(steps)

        # Always prefer DB quest title when questId exists
        for s in steps:
            if s.questId and s.questId in self.quest_titles:
                s.title = self.quest_titles[s.questId]

        # Determine key (guide_name arg wins; otherwise sanitize from display title; fallback)
        base_key = guide_name or (sanitize_key(display_title) if display_title else self._extract_guide_name(src) or "ConvertedGuide")
        key = qs_prefixed(base_key)

        out = self._render_lua(
            key=key,
            display_title=display_title or base_key,
            next_title=next_title,
            faction=faction,
            min_level=min_level,
            max_level=max_level,
            steps=steps
        )

        # Default output filenames: QS_<input-stem>.lua and QS_<input-stem>_README.md
        if not output_path:
            in_stem = Path(input_path).stem
            out_stem = in_stem if in_stem.startswith("QS_") else f"QS_{in_stem}"
            output_path = str(Path(input_path).with_name(out_stem).with_suffix(".lua"))
        Path(output_path).write_text(out, encoding="utf-8")

        readme = self._render_readme(key, len(steps), display_title, next_title, faction)
        # README next to output, with QS_ prefix
        out_stem_for_readme = Path(output_path).stem
        readme_path = str(Path(output_path).with_name(out_stem_for_readme + "_README.md"))
        Path(readme_path).write_text(readme, encoding="utf-8")

        return output_path, readme_path

    def _extract_guide_name(self, src: str) -> Optional[str]:
        m = re.search(r'TourGuide:RegisterGuide\("([^"]+)"', src)
        if m:
            title = m.group(1)
            m2 = re.search(r'(.+)\s+\((\d+)\-(\d+)\)', title)
            if m2:
                zone = m2.group(1).strip().replace(" ", "_")
                zone = re.sub(r'[^A-Za-z0-9_]', '', zone)
                return f"{zone}_{m2.group(2)}_{m2.group(3)}"
            return re.sub(r'[^A-Za-z0-9_]', '', title.replace(" ", "_"))
        return None

    def _parse_tourguide(self, src: str) -> List[Step]:
        body_match = re.search(r'return\s+\[\[(.*)\]\]', src, re.S | re.I)
        if not body_match:
            return []

        body = body_match.group(1)
        lines = [ln.strip() for ln in body.splitlines() if ln.strip()]
        steps: List[Step] = []

        for i, raw_line in enumerate(lines, start=1):
            self.stats["total_lines"] += 1

            # Drop TG tokens we don't support (e.g., |REACH|) before parsing
            line = re.sub(r'\s*\|REACH\|', '', raw_line, flags=re.I)

            op = line[:1]
            rest = line[1:].strip() if len(line) > 1 else ""
            qid = extract_qid(line)
            note = extract_note(line)
            coords = first_coords(line)
            item_id = extract_item_use(line)            
            klass = extract_class(line)
            race = extract_race(line)

            title = rest.split("|", 1)[0].strip()
            title = clean_title(title)

            type_map = {
                "A": "ACCEPT",
                "T": "TURNIN",
                "C": "COMPLETE",
                "R": "TRAVEL",
                "h": "SET_HEARTH",
                "F": "FLY",
                "f": "FLIGHTPATH",
                "N": "NOTE",
                "L": "COMPLETE",
                "K": "COMPLETE",
                "B": "NOTE",
                "b": "NOTE",
            }
            stype = type_map.get(op, "NOTE")

            if is_buy_or_sell(line, title, note):
                stype = "NOTE"

            npc = None
            if stype in ("ACCEPT","TURNIN","SET_HEARTH","FLIGHTPATH","FLY"):
                npc_name = infer_npc(note)
                if npc_name:
                    npc = {"name": npc_name}

            destination = None
            if stype == "FLY":
                m = re.search(r'fly\s+to\s+([A-Za-z\'\-\s]+)', f"{title} {note}", re.I)
                if m:
                    destination = m.group(1).strip()

            step = Step(
                type=stype,
                title=title,
                questId=qid,
                coords=coords,
                npc=npc,
                note=note,
                itemId=item_id,
                destination=destination,
                klass=klass,
                race=race,
                line_num=i,
                src_op=op
            )
            steps.append(step)
            self.stats["converted_steps"] += 1

        return steps

    def _merge_same_quest_completes(self, steps: List[Step]) -> List[Step]:
        merged: List[Step] = []
        i = 0
        n = len(steps)
        while i < n:
            s = steps[i]
            if s.type == "COMPLETE" and s.questId:
                notes = [s.note] if s.note else []
                first_coords = s.coords
                item_ids = []
                if s.itemId:
                    item_ids.append((s.itemId, s.itemCount))
                j = i + 1
                while j < n:
                    t = steps[j]
                    if t.type == "COMPLETE" and t.questId == s.questId:
                        if t.note:
                            notes.append(t.note)
                        if t.itemId:
                            item_ids.append((t.itemId, t.itemCount))
                        if not first_coords and t.coords:
                            first_coords = t.coords
                        j += 1
                    else:
                        break
                combined = Step(
                    type="COMPLETE",
                    title=s.title,
                    questId=s.questId,
                    coords=first_coords,
                    note=" | ".join([x for x in notes if x]),
                    itemId=item_ids[0][0] if item_ids else None,
                    itemCount=item_ids[0][1] if (item_ids and item_ids[0][1] is not None) else None,
                    klass=s.klass, race=s.race
                )
                merged.append(combined)
                i = j
            else:
                merged.append(s)
                i += 1
        return merged

    def _render_lua(self, key: str, display_title: str, next_title: Optional[str],
                    faction: Optional[str], min_level: int, max_level: int, steps: List[Step]) -> str:
        from datetime import datetime
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self._now = now
        lines: List[str] = []
        lines.append("-- =========================")
        lines.append(f"-- {key}.lua")
        lines.append(f"-- Converted from TourGuide format on {now}")
        lines.append("-- =========================\n")
        lines.append("QuestShellGuides = QuestShellGuides or {}\n")
        lines.append(f'QuestShellGuides["{key}"] = {{')
        lines.append(f'  title    = "{display_title}",')
        if next_title:
            next_key = qs_prefixed(sanitize_key(next_title))
            lines.append(f'  next     = "{next_title}",')
            lines.append(f'  nextKey  = "{next_key}",')
        if faction:
            lines.append(f'  faction  = "{faction}",')
        lines.append(f'  minLevel = {min_level},')
        lines.append(f'  maxLevel = {max_level},')
        lines.append('  steps = {')
        for s in steps:
            lines.append("    " + s.to_lua() + ",")
        lines.append('  }')
        lines.append('}\n')
        return "\n".join(lines)

    def _render_readme(self, key: str, step_count: int,
                       display_title: Optional[str], next_title: Optional[str], faction: Optional[str]) -> str:
        from datetime import datetime
        now = self._now or datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        meta = []
        if display_title: meta.append(f"- Title: {display_title}")
        if next_title:    meta.append(f"- Next: {next_title} (key: {qs_prefixed(sanitize_key(next_title))})")
        if faction:       meta.append(f"- Faction: {faction}")
        meta = "\\n".join(meta)

        return f"""# Conversion Report: {key}

- Date: {now}
- Steps written: {step_count}
{meta and meta or ""}

## Emission Rules
- Flat schema (no chapters). Fields at guide level: title, next?, nextKey?, faction?, minLevel, maxLevel, steps[].
- COMPLETE  -> title, questId, itemId?, itemCount?, coords, note
- ACCEPT    -> questId, title, npc, coords, note
- TURNIN    -> questId, title, npc, coords, note
- SET_HEARTH-> title, coords, npc, note
- FLY       -> coords, npc, destination, note
- FLIGHTPATH-> npc, coords, note
- TRAVEL    -> coords, note
- NOTE      -> note, coords

## Extras
- class/race restriction tags emitted when present.
- Robust quests.lua parser incl. pfDB format; recursive search over provided roots.
- NPC inference handles 'Speak to', 'Innkeeper', and ', in/at ...' forms.
"""
if __name__ == "__main__":
    import sys
    quest_dirs = []
    # Usage: python3 converter.py <input.lua> [output.lua] [guide_key] [quest_dir ...]
    if len(sys.argv) < 2:
        print("Usage: python3 converter.py <input.lua> [output.lua] [guide_key] [quest_dir ...]")
        sys.exit(1)
    if len(sys.argv) >= 5:
        quest_dirs = sys.argv[4:]
    conv = TourGuideConverter(quest_dirs or None)
    inp = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) >= 3 else None
    key = sys.argv[3] if len(sys.argv) >= 4 else None
    out_path, readme_path = conv.convert_guide(inp, out, key)
    print("✅ Wrote:", out_path)
    print("📝 Report:", readme_path)
