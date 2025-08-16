#!/usr/bin/env python3
"""
TourGuide to QuestShell Converter (NPC extraction + BUY/SELL as NOTE + QID .obj fix)
-----------------------------------------------------------------------------------
- QID regex accepts suffix (|QID|488.1| → questId=488).
- Stronger NPC extraction:
    • "Speak to|with <NPC>"
    • "Talk to|with <NPC>"
    • "Innkeeper <Name>"
    • "<NPC>, in|at ..." or "<NPC> in|at ..."
- BUY/SELL are emitted as NOTE steps with only { note, coords } (as requested).
- NOTE emission prunes to { note, coords }.
- Class/Race still emitted when present.
- Optional quest DB title override still supported.
"""

import os, re, json
from dataclasses import dataclass
from typing import Optional, Dict, Any, List


Coord = Dict[str, Any]
NPC = Dict[str, str]


COORD_RE = re.compile(r'\(([0-9]+(?:\.[0-9]+)?),\s*([0-9]+(?:\.[0-9]+)?)\)')
QID_RE   = re.compile(r'\|QID\|(\d+)(?:\.\d+)?\|', re.I)
NOTE_RE  = re.compile(r'\|N\|((?:[^|]|\|(?!\w\|))+)\|', re.I)
USE_RE   = re.compile(r'\|U\|(\d+)\|', re.I)
CLASS_RE = re.compile(r'\|C\|([A-Za-z,]+)\|', re.I)
RACE_RE  = re.compile(r'\|R\|([A-Za-z,]+)\|', re.I)


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


def extract_note(text: str) -> str:
    m = NOTE_RE.search(text or '')
    if not m:
        return ""
    return m.group(1).strip()


def extract_item_use(text: str) -> Optional[int]:
    m = USE_RE.search(text or '')
    return int(m.group(1)) if m else None


def extract_class(text: str) -> Optional[str]:
    m = CLASS_RE.search(text or '')
    return m.group(1).strip() if m else None


def extract_race(text: str) -> Optional[str]:
    m = RACE_RE.search(text or '')
    return m.group(1).strip() if m else None


def clean_title(raw: str) -> str:
    title = raw.strip()
    title = re.sub(r'\s*\(Part\s*\d+\)\s*', '', title, flags=re.I)
    return title.strip()



NPC_PATTERNS = [
    # "Speak to/with <NPC>" or "Speak <NPC>"
    re.compile(r'(?:speak|talk)\s+(?:to\s+)?([A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,4})', re.I),
    # "Innkeeper <Name>"
    re.compile(r'(Innkeeper\s+[A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,3})', re.I),
    # "<NPC>, in/at ..." or "<NPC> in/at ..."
    re.compile(r'([A-Z][A-Za-z\'’`\-]+(?:\s+[A-Z][A-Za-z\'’`\-]+){0,4})\s*,?\s+(?:in|at)\s+', re.I),
]

STOPWORDS = set(['and','grab','get','buy','sell','train','then','for','the','a','an','flight','path','fp','fly','to','from'])

def _refine_npc(raw: str) -> str:
    # Trim trailing non-name words based on capitalization + stopwords
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


def is_buy_or_sell(line: str, title: str, note: str) -> bool:
    hay = f"{title} {note}".lower()
    if " sell " in f" {hay} " or hay.startswith("sell "):
        return True
    if " buy " in f" {hay} " or hay.startswith("buy "):
        return True
    if line[:1] in ("B", "b"):
        return True
    return False


def load_quest_db(search_dirs: List[str]) -> Dict[int, str]:
    for d in search_dirs:
        json_path = os.path.join(d, "quests_db.json")
        if os.path.isfile(json_path):
            try:
                with open(json_path, "r", encoding="utf-8") as f:
                    raw = json.load(f)
                return {int(k): v for k, v in raw.items()}
            except Exception:
                pass
    lua_map: Dict[int, str] = {}
    for d in search_dirs:
        lua_path = os.path.join(d, "quests.lua")
        if os.path.isfile(lua_path):
            try:
                txt = open(lua_path, "r", encoding="utf-8", errors="ignore").read()
                for mid, mt in re.findall(r'\[\s*(\d+)\s*\]\s*=\s*"([^"]+)"', txt):
                    lua_map[int(mid)] = mt
            except Exception:
                pass
    return lua_map


@dataclass
class Step:
    type: str
    title: str = ""
    questId: Optional[int] = None
    coords: Optional[Coord] = None
    npc: Optional[NPC] = None
    note: str = ""
    itemId: Optional[int] = None
    destination: Optional[str] = None
    klass: Optional[str] = None
    race: Optional[str] = None
    line_num: int = 0

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

        # emit restriction tags on ANY type if present
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
            # explicitly prune to { note, coords }
            add_str("note", self.note if self.note else self.title)
            add_coords(self.coords)

        else:
            # fallback (shouldn't happen)
            add_str("title", self.title)
            add_coords(self.coords)
            if self.questId is not None and t != "NOTE":
                add_int("questId", self.questId)
            add_str("note", self.note)

        return "{ " + ", ".join(fields) + " }"


class TourGuideConverter:
    def __init__(self, quest_db_dirs: Optional[List[str]] = None):
        self.stats = {"total_lines": 0, "converted_steps": 0, "issues_found": 0}
        self._now = None
        self.quest_titles: Dict[int, str] = {}
        if quest_db_dirs:
            self.quest_titles = load_quest_db(quest_db_dirs)

    def convert_guide(self, input_path: str, output_path: Optional[str] = None, guide_name: Optional[str] = None):
        from pathlib import Path
        from datetime import datetime
        if not self.quest_titles:
            self.quest_titles = load_quest_db([str(Path(input_path).parent)])

        src = Path(input_path).read_text(encoding="utf-8", errors="ignore")
        steps = self._parse_tourguide(src)

        # Override titles from quest DB when questId exists
        for s in steps:
            if s.questId and s.questId in self.quest_titles:
                s.title = self.quest_titles[s.questId]

        base = guide_name or self._extract_guide_name(src) or "ConvertedGuide"
        out = self._render_lua(base, steps)

        if not output_path:
            output_path = str(Path(input_path).with_suffix("").as_posix() + "_converted.lua")
        Path(output_path).write_text(out, encoding="utf-8")

        readme = self._render_readme(base, len(steps))
        readme_path = str(Path(output_path).with_suffix("").as_posix() + "_README.md")
        Path(readme_path).write_text(readme, encoding="utf-8")

        return output_path, readme_path

    def _extract_guide_name(self, src: str) -> Optional[str]:
        m = re.search(r'TourGuide:RegisterGuide\("([^"]+)"', src)
        if m:
            title = m.group(1)
            m2 = re.search(r'(.+)\s+\((\d+)\-(\d+)\)', title)
            if m2:
                zone = m2.group(1).strip().replace(" ", "")
                return f"{m2.group(2)}_{m2.group(3)}_{zone}"
            return title.replace(" ", "_")
        return None

    def _parse_tourguide(self, src: str) -> List[Step]:
        body_match = re.search(r'return\s+\[\[(.*)\]\]', src, re.S | re.I)
        if not body_match:
            return []

        body = body_match.group(1)
        lines = [ln.strip() for ln in body.splitlines() if ln.strip()]
        steps: List[Step] = []

        for i, line in enumerate(lines, start=1):
            self.stats["total_lines"] += 1

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

            # opcode mapping
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

            # BUY/SELL phrases become NOTE
            if is_buy_or_sell(line, title, note):
                stype = "NOTE"

            # Infer NPC only for types that should have it
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
                line_num=i
            )
            steps.append(step)
            self.stats["converted_steps"] += 1

        return steps

    def _render_lua(self, guide_name: str, steps: List[Step]) -> str:
        from datetime import datetime
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self._now = now
        lines: List[str] = []
        lines.append("-- =========================")
        lines.append(f"-- {guide_name}.lua")
        lines.append(f"-- Converted from TourGuide format on {now}")
        lines.append("-- =========================\n")
        lines.append("QuestShellGuides = QuestShellGuides or {} \n")
        lines.append(f'QuestShellGuides["{guide_name}"] = {{')
        lines.append(f'    title    = "{guide_name}",')
        lines.append(f'    minLevel = 1,')
        lines.append(f'    maxLevel = 60,\n')
        lines.append("    chapters = ")
        lines.append("    {    ")
        lines.append("        {")
        lines.append(f'            id       = "{guide_name}",')
        lines.append(f'            title    = "{guide_name}",')
        lines.append(f'            zone     = "",')
        lines.append(f'            minLevel = 1,')
        lines.append(f'            maxLevel = 60,\n')
        lines.append("            steps = {")
        lines.append("")
        for s in steps:
            lines.append("                " + s.to_lua() + ",")
            lines.append("")
        lines.append("            }")
        lines.append("        }")
        lines.append("    }")
        lines.append("}\n")
        return "\n".join(lines)

    def _render_readme(self, guide_name: str, step_count: int) -> str:
        from datetime import datetime
        now = self._now or datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        return f"""# Conversion Report: {guide_name}

- Date: {now}
- Steps written: {step_count}

## Emission Rules Applied
- COMPLETE  -> title, questId, itemId?, coords, note
- ACCEPT    -> questId, title, npc, coords, note
- TURNIN    -> questId, title, npc, coords, note
- SET_HEARTH-> title, coords, npc, note
- FLY       -> coords, npc, destination, note
- FLIGHTPATH-> npc, coords, note
- TRAVEL    -> coords, note
- NOTE      -> note, coords

## Extras
- class/race restriction tags emitted when present.
- Optional quest title override from quests_db.json or quests.lua (if present).
- NPC inference handles 'Speak to', 'Innkeeper', and ', in/at ...' forms.
"""
if __name__ == "__main__":
    import sys
    quest_dirs = []
    # Usage: python3 tourguide_converter.py <input.lua> [output.lua] [guide_name] [quest_db_dir ...]
    if len(sys.argv) < 2:
        print("Usage: python3 tourguide_converter.py <input.lua> [output.lua] [guide_name] [quest_db_dir ...]")
        sys.exit(1)
    if len(sys.argv) >= 5:
        quest_dirs = sys.argv[4:]
    conv = TourGuideConverter(quest_dirs or None)
    inp = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) >= 3 else None
    name = sys.argv[3] if len(sys.argv) >= 4 else None
    out_path, readme_path = conv.convert_guide(inp, out, name)
    print("✅ Wrote:", out_path)
    print("📝 Report:", readme_path)
