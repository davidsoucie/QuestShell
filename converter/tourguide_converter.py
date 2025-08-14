#!/usr/bin/env python3
"""
TourGuide to QuestShell Converter (with conflict summary)
------------------------------------------------------------------
- Preserves order of grouped L-lines (inserted at group position)
- K -> COMPLETE with kill objective
- L-lines are always loot-first (even if note says "Kill ...")
- Per-objective notes for grouped L objectives
- Better "Use ..." parsing
- NPC extraction: uppercase initial, extra patterns ("find <Name> in", "<Name>, ...")
- Accept w/ item: don't require NPC
- Title backfill from ACCEPT, TURNIN, COMPLETE
- Title cleanup (strip (Part N), |TAG|...|)
- Bring N Item parsing; Kill-until-find parsing
- Kill objectives never keep itemId
- Skip [[ and ]] lines even with trailing comments
- README includes detailed issues; writes *_issues.json
- Writes *_mappings.json (questId->title, itemId->name)
- NEW: logs duplicate item IDs with different names and writes *_conflicts.json
"""

import re, os, sys, json
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class ConversionIssue:
    line_number: int
    issue_type: str
    description: str
    original_line: str
    severity: str = "medium"

@dataclass
class QuestStep:
    step_type: str
    title: str
    quest_id: Optional[int] = None
    coords: Optional[Dict[str, Any]] = None
    npc: Optional[Dict[str, str]] = None
    note: str = ""
    objectives: List[Dict[str, Any]] = field(default_factory=list)
    class_restriction: Optional[str] = None
    race_restriction: Optional[str] = None
    destination: Optional[str] = None
    optional: bool = False
    prerequisite: Optional[int] = None
    as_you_go: bool = False
    item_id: Optional[int] = None
    item_name: Optional[str] = None
    line_num: int = 0

class TourGuideConverter:
    def __init__(self):
        self.issues: List[ConversionIssue] = []
        self.stats = {'total_lines':0,'converted_steps':0,'skipped_lines':0,'issues_found':0}
        self.found_item_ids:set[int]=set()
        self.found_quest_ids:set[int]=set()
        self.found_npcs:set[str]=set()
        self.found_zones:set[str]=set()
        # Mappings
        self.quest_id_to_title: Dict[int,str] = {}
        self.item_id_to_name: Dict[int,str] = {}
        # Name history & conflict events
        self._item_id_names: Dict[int, List[str]] = {}
        self.item_conflicts: List[Dict[str, Any]] = []

    # ---------- helpers ----------
    def log_issue(self, ln, t, d, orig, sev="medium"):
        self.issues.append(ConversionIssue(ln,t,d,orig,sev)); self.stats['issues_found']+=1

    def clean_title(self, t:str)->str:
        if not t: return ''
        t = re.sub(r'\s*\(Part\s+\d+\)', '', t, flags=re.I)
        t = re.sub(r'\|[A-Z]+?\|.*?\|', '', t)  # strip accidental |TAG|...|
        return t.strip()

    def normalize_common_typos(self, s:str)->str:
        if not s: return s
        for pat,rep in [
            (r'\bSpee+ak\b','Speak'),
            (r'\bSpeaaak\b','Speak'),
            (r'\bect\b','etc'),
            (r'\bteh\b','the'),
        ]:
            s = re.sub(pat,rep,s,flags=re.I)
        return s

    def _sanitize_item_label(self, label:str)->str:
        if not label: return label
        # strip trailing helper words like 'found' / 'dropped' and anything after
        label = re.sub(r'\b(found|dropped)\b.*$', '', label, flags=re.I).strip()
        label = re.sub(r'\s+', ' ', label).strip(' ,.;:')
        return label

    def _choose_item_label(self, header_name:str, collect_label:Optional[str])->str:
        """Prefer a clean 'collect' label unless it looks generic; else use header."""
        h = (header_name or '').strip()
        c = self._sanitize_item_label(collect_label) if collect_label else None
        if not c:
            return h
        generic = {'fang', 'fangs', 'feather', 'feathers', 'silk', 'spider silk', 'book', 'ore', 'moss', 'seed', 'sprout', 'jewel', 'rod', 'item'}
        if c.lower() in generic:
            return h or c
        # If collect label is one token but header has multiple capitalized tokens, prefer header
        if len(c.split()) == 1 and len(h.split()) >= 2:
            return h
        return c

    def _norm_for_compare(self, name:str)->str:
        s = name.lower().strip()
        s = re.sub(r"[^\w\s']", " ", s)
        s = re.sub(r"\b(the|a|an)\b", " ", s)
        s = re.sub(r"\s+", " ", s).strip()
        if s.endswith('s') and not s.endswith('ss'):
            s = s[:-1]
        return s

    def _is_generic_label(self, name:str)->bool:
        if not name: return True
        generic = {'fang','feather','silk','book','ore','moss','seed','sprout','jewel','rod','item','feathers','fangs'}
        s = self._norm_for_compare(name)
        return s in generic or (len(s.split()) == 1 and s in generic)

    def _add_conflict_event(self, kind:str, item_id:int, kept:str, new:str, ln:int, orig:str, ctx:str):
        self.item_conflicts.append({
            "type": kind,
            "itemId": item_id,
            "kept_name": kept,
            "new_name": new,
            "line_number": ln,
            "context": ctx,
            "snippet": orig.strip()
        })

    def _record_item_mapping(self, item_id:int, name:str, ln:int, original_line:str, context:str):
        """
        Canonicalize item_id -> name, prefer specific over generic, and log conflicts.
        """
        name_clean = self._sanitize_item_label(name)
        current = self.item_id_to_name.get(item_id)

        # track history
        self._item_id_names.setdefault(item_id, [])
        if name_clean not in self._item_id_names[item_id]:
            self._item_id_names[item_id].append(name_clean)

        if current is None:
            self.item_id_to_name[item_id] = name_clean
            return

        if self._norm_for_compare(current) == self._norm_for_compare(name_clean):
            # same after normalization; no issue
            return

        curr_generic = self._is_generic_label(current)
        new_generic  = self._is_generic_label(name_clean)

        if curr_generic and not new_generic:
            # Replace generic with specific
            self.item_id_to_name[item_id] = name_clean
            self.log_issue(ln,"ITEM_ID_GENERIC_REPLACED",
                           f"Replaced generic '{current}' with specific '{name_clean}' for itemId {item_id} ({context})",
                           original_line,"low")
            self._add_conflict_event("ITEM_ID_GENERIC_REPLACED", item_id, name_clean, current, ln, original_line, context)
            return

        if not curr_generic and new_generic:
            # Keep specific, ignore generic
            self.log_issue(ln,"ITEM_ID_GENERIC_IGNORED",
                           f"Ignored generic '{name_clean}' for itemId {item_id}; keeping '{current}' ({context})",
                           original_line,"low")
            self._add_conflict_event("ITEM_ID_GENERIC_IGNORED", item_id, current, name_clean, ln, original_line, context)
            return

        # Both non-generic and different: conflict
        self.log_issue(ln,"ITEM_ID_NAME_CONFLICT",
                       f"ItemId {item_id} seen as '{current}' and '{name_clean}' ({context})",
                       original_line,"high")
        self._add_conflict_event("ITEM_ID_NAME_CONFLICT", item_id, current, name_clean, ln, original_line, context)
        # Keep the first-seen (do not overwrite)

    def extract_all_coords(self, text:str)->List[Tuple[float,float]]:
        return [(float(a),float(b)) for a,b in re.findall(r'\(([0-9]+(?:\.[0-9]+)?),\s*([0-9]+(?:\.[0-9]+)?)\)', text or '')]

    def coords_obj(self, pairs, map_name):
        if not pairs: return None
        d={'x':pairs[0][0],'y':pairs[0][1]}
        if map_name: d['map']=map_name
        return d

    def extract_map_from_text(self, text:str)->Optional[str]:
        if not text: return None
        for p in [r'\bin\s+([A-Za-z][A-Za-z\s\'-]+?)\s*\(',
                  r'\bin\s+([A-Za-z][A-Za-z\s\'-]+?)\s*(?:\||$)',
                  r'\bat\s+([A-Za-z][A-Za-z\s\'-]+?)\s*\(']:
            m=re.search(p,text)
            if m:
                s=m.group(1).strip()
                s=re.split(r'\s+(?:and|then|to)\s+', s)[0]
                if len(s)>2 and not re.match(r'^(the|a|an)\s',s,flags=re.I): return s
        return None

    def extract_npc(self, text:str)->Optional[str]:
        if not text: return None
        text=self.normalize_common_typos(text)
        patterns=[
            r'\bSpeak to Innkeeper\s+([A-Za-z][A-Za-z\s\'\.-]+?)(?=\s+(?:in|at|and|for|to|with)\b|\s*[,(\.]|$)',
            r'\bInnkeeper\s+([A-Za-z][A-Za-z\s\'\.-]+?)(?=\s+(?:in|at|and|for|to|with)\b|\s*[,(\.]|$)',
            r'\bfind\s+([A-Z][A-Za-z\'\.-]+(?:\s+[A-Z][A-Za-z\'\.-]+)*)\s+in\b',
            r'^([A-Z][A-Za-z\'\.-]+(?:\s+[A-Z][A-Za-z\'\.-]+)*),',
            r'\bSpeak to\s+([A-Za-z][A-Za-z\s\'\.-]+?)\s+in\b',
            r'\bTalk to\s+([A-Za-z][A-Za-z\s\'\.-]+?)\s+in\b',
            r'^([A-Za-z][A-Za-z\s\'\.-]+?)\s+(?:in|at)\s+[A-Za-z]',
            r'^([A-Za-z][A-Za-z\s\'\.-]+?)\s+\(',
            r'\bSpeak to\s+([A-Za-z][A-Za-z\s\'\.-]+?)(?=\s+(?:and|for|to|with)\b|\s*[,(\.]|$)',
            r'\bTalk to\s+([A-Za-z][A-Za-z\s\'\.-]+?)(?=\s+(?:and|for|to|with)\b|\s*[,(\.]|$)',
            r'\bto\s+([A-Za-z][A-Za-z\s\'\.-]+)\s+and\b',
        ]
        for p in patterns:
            m=re.search(p,text,flags=re.I)
            if m:
                npc=m.group(1).strip().rstrip('.')
                if re.search(r'Innkeeper', p, re.I) and not npc.lower().startswith('innkeeper'):
                    npc='Innkeeper '+npc
                npc=re.sub(r'\s+(?:in|at|and|then|for|to|with|down|up|north|south|east|west)\b.*$', '', npc)
                if not re.match(r'^[A-Z]', npc):
                    continue
                if not re.match(r'^(Travel|Go|Use|Kill|Collect|Find|Enter|Exit|Head|Run|Follow|Click|Take|Escort|Reach|Bring|Turn|Hand|Deliver)\b', npc, re.I):
                    return npc
        return None

    def extract_special_codes(self, line:str)->Dict[str,Any]:
        c={}
        m=re.search(r'\|C\|([A-Z][A-Za-z]+)\|',line);   c['class']=m.group(1) if m else None
        m=re.search(r'\|R\|([A-Za-z\s/]+)\|',line);     c['race']=m.group(1).strip() if m else None
        m=re.search(r'\|Z\|([A-Za-z\s\'-]+)\|',line);   c['zone']=m.group(1).strip() if m else None
        c['optional']='|O|' in line
        m=re.search(r'\|PRE\|(\d+)\|',line);            c['prerequisite']=int(m.group(1)) if m else None
        c['as_you_go']='|AYG|' in line
        m=re.search(r'\|U\|(\d+)\|',line);              c['use_item']=int(m.group(1)) if m else None
        m=re.search(r'\|L\|(\d+)\s+(\d+)\|',line);      
        if m: c['loot_item_id'],c['loot_amount']=int(m.group(1)),int(m.group(2))
        m=re.search(r'\|TID\|(\d+)\|',line);            c['tid']=int(m.group(1)) if m else None
        m=re.search(r'\|OID\|(\d+)\|',line);            c['oid']=int(m.group(1)) if m else None
        return {k:v for k,v in c.items() if v is not None}

    def extract_objectives_from_note(self, note:str, codes:Dict[str,Any])->List[Dict[str,Any]]:
        if not note: return []
        note=self.normalize_common_typos(note)
        objs=[]

        # Escort
        esc = re.search(r'\b[Ee]scort\s+([A-Z][A-Za-z\'\-]+(?:\s+[A-Z][A-Za-z\'\-]+)*)\s+(?:to|back to|into|through|down|up|across)\b', note)
        if not esc:
            esc = re.search(r'\b[Ee]scort\s+([A-Z][A-Za-z\'\-]+)', note)
        if esc:
            name = esc.group(1).strip()
            objs.append({"kind":"escort","label":f"{name} escorted","target":1})
            return objs

        # Bring N Item (treat as loot objective)
        m=re.search(r'\b[Bb]ring\s+(\d+)\s+([A-Za-z][A-Za-z\s\'-]+?)(?:\s+(?:and|to)\b|\s*$)', note)
        if m:
            num,item=m.groups()
            item_clean = self._sanitize_item_label(item.strip())
            o={"kind":"loot","label":item_clean,"target":int(num)}
            objs.append(o)
            m2=re.search(r"\band\s+the\s+([A-Za-z][A-Za-z\s\'-]+)", note)
            if m2:
                objs.append({"kind":"loot","label":self._sanitize_item_label(m2.group(1).strip()),"target":1})
            return objs

        # Collect N Item
        m=re.search(r'\b[Cc]ollect\s+(\d+)\s+([A-Za-z][A-Za-z\s\'-]+?)(?:\s+(?:from|in|around|at|near)\b|\s*$)', note)
        if m:
            num,item=m.groups()
            item_clean = self._sanitize_item_label(item.strip())
            o={"kind":"loot","label":item_clean,"target":int(num)}
            if 'loot_item_id' in codes:
                o['itemId']=codes['loot_item_id']; self.found_item_ids.add(codes['loot_item_id'])
                self._record_item_mapping(codes['loot_item_id'], item_clean, 0, note, "collect")
            objs.append(o); return objs

        # Kill A and B
        m=re.search(r'\b[Kk]ill\s+(\d+)\s+([A-Za-z][A-Za-z\s\'-]+?)\s+and\s+(\d+)\s+([A-Za-z][A-Za-z\s\'-]+?)(?:\s+(?:in|and|around|at|near)\b|\s*$)', note)
        if m:
            n1,m1,n2,m2=m.groups()
            objs.append({"kind":"kill","label":m1.strip(),"target":int(n1)})
            objs.append({"kind":"kill","label":m2.strip(),"target":int(n2)})
            return objs

        # Kill N Mob
        m=re.search(r'\b[Kk]ill\s+(\d+)\s+([A-Za-z][A-Za-z\s\'-]+?)(?:\s+(?:in|and|around|at|near)\b|\s*$)', note)
        if m:
            num,mob=m.groups(); objs.append({"kind":"kill","label":mob.strip(),"target":int(num)})

        # Kill X until you find Y
        m=re.search(r'\b[Kk]ill\s+([A-Za-z][A-Za-z\s\'-]+?)\s+until you (?:find|get)\s+([A-Za-z][A-Za-z\s\'-]+)', note)
        if m:
            mob,item=m.groups()
            objs.append({"kind":"kill","label":mob.strip(),"target":1})
            item_clean = self._sanitize_item_label(item.strip())
            o={"kind":"loot","label":item_clean,"target":codes.get('loot_amount',1)}
            if 'loot_item_id' in codes:
                o['itemId']=codes['loot_item_id']; self.found_item_ids.add(codes['loot_item_id'])
                self._record_item_mapping(codes['loot_item_id'], item_clean, 0, note, "kill-until-find")
            objs.append(o)

        # Use item
        use_pat = r'\bUse\s+(?:the\s+)?([A-Za-z][A-Za-z\s\'-]+?)(?=\s+(?:at|on|to|in|near|with)\b|\s*\(|\s*$)'
        if 'use_item' in codes:
            self.found_item_ids.add(codes['use_item'])
            m=re.search(use_pat, note)
            label=m.group(1).strip() if m else f"Item {codes['use_item']}"
            label_clean = self._sanitize_item_label(label)
            objs.append({"kind":"use_item","label":label_clean,"target":1,"itemId":codes['use_item']})
            if not label.startswith('Item '):
                self._record_item_mapping(codes['use_item'], label_clean, 0, note, "use-item")
        else:
            m=re.search(use_pat, note)
            if m: objs.append({"kind":"use_item","label":self._sanitize_item_label(m.group(1).strip()),"target":1})

        return objs

    def parse_quest_id(self, s:str)->Optional[int]:
        if not s: return None
        try: return int(s.split('.')[0])
        except: return None

    # ---------- converters ----------
    def convert_accept_step(self, line, ln):
        m=re.match(r'^A\s+(.+?)\s+\|QID\|([\d\.]+)\|\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse ACCEPT",line,"high"); return None
        title,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s); codes=self.extract_special_codes(line)
        if qid: self.found_quest_ids.add(qid)
        note=self.normalize_common_typos(note)
        map_name=codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note)
        coords=self.coords_obj(self.extract_all_coords(note), map_name)
        npc=self.extract_npc(note)
        if map_name: self.found_zones.add(map_name)
        if npc: self.found_npcs.add(npc)
        if not npc and not codes.get('use_item') and not re.search(r'\bUse\b.*\bto accept\b', note, flags=re.I):
            self.log_issue(ln,"MISSING_NPC","No NPC for ACCEPT",line,"medium")
        return QuestStep("ACCEPT", self.clean_title(title), qid, coords, {"name":npc} if npc else None, note,
                         class_restriction=codes.get('class'), race_restriction=codes.get('race'),
                         optional=codes.get('optional',False), prerequisite=codes.get('prerequisite'), line_num=ln)

    def convert_complete_step(self, line, ln):
        m=re.match(r'^C\s+(.+?)\s+\|QID\|([\d\.]+)\|\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse COMPLETE",line,"high"); return None
        title,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s); codes=self.extract_special_codes(line)
        if qid: self.found_quest_ids.add(qid)
        note=self.normalize_common_typos(note)
        map_name=codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note)
        coords=self.coords_obj(self.extract_all_coords(note), map_name)
        if map_name: self.found_zones.add(map_name)
        objectives=self.extract_objectives_from_note(note,codes)
        if not objectives: self.log_issue(ln,"MISSING_OBJECTIVES","No objectives parsed",line,"medium")
        return QuestStep("COMPLETE", self.clean_title(title), qid, coords, None, note, objectives,
                         class_restriction=codes.get('class'), race_restriction=codes.get('race'),
                         optional=codes.get('optional',False), as_you_go=codes.get('as_you_go',False), line_num=ln)

    def convert_turnin_step(self, line, ln):
        m=re.match(r'^T\s+(.+?)\s+\|QID\|([\d\.]+)\|\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse TURNIN",line,"high"); return None
        title,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s); codes=self.extract_special_codes(line)
        if qid: self.found_quest_ids.add(qid)
        note=self.normalize_common_typos(note)
        map_name=codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note)
        coords=self.coords_obj(self.extract_all_coords(note), map_name)
        npc=self.extract_npc(note)
        if map_name: self.found_zones.add(map_name)
        if npc: self.found_npcs.add(npc)
        if not npc: self.log_issue(ln,"MISSING_NPC","No NPC for TURNIN",line,"medium")
        return QuestStep("TURNIN", self.clean_title(title), qid, coords, {"name":npc} if npc else None, note,
                         class_restriction=codes.get('class'), race_restriction=codes.get('race'),
                         optional=codes.get('optional',False), line_num=ln)

    def convert_travel_step(self, line, ln):
        m=re.match(r'^R\s+(.+?)\s+(?:\|QID\|([^|]*)\|)?\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse TRAVEL",line,"medium"); return None
        title,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s) if qid_s else None; codes=self.extract_special_codes(line)
        if qid: self.found_quest_ids.add(qid)
        note=self.normalize_common_typos(note)
        map_name=codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note)
        coords=self.coords_obj(self.extract_all_coords(note), map_name)
        if map_name: self.found_zones.add(map_name)
        return QuestStep("TRAVEL", self.clean_title(title), qid, coords, None, note, optional=codes.get('optional',False), prerequisite=codes.get('prerequisite'), line_num=ln)

    def convert_fly_step(self, line, ln):
        m=re.match(r'^F\s+(.+?)\s+\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse FLY",line,"medium"); return None
        title,note=m.groups(); codes=self.extract_special_codes(line)
        note=self.normalize_common_typos(note)
        coords=self.coords_obj(self.extract_all_coords(note), codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note))
        npc=self.extract_npc(note)
        if npc: self.found_npcs.add(npc)
        destination=title.strip()
        m2=re.search(r'\bfly to\s+([A-Za-z][A-Za-z\s\'-]+)', note, flags=re.I)
        if m2: destination=m2.group(1).strip()
        return QuestStep("FLY", self.clean_title(title), None, coords, {"name":npc} if npc else None, note,
                         class_restriction=codes.get('class'), race_restriction=codes.get('race'), destination=destination, line_num=ln)

    def convert_flightpath_step(self, line, ln):
        m=re.match(r'^f\s+(.+?)\s+(?:\|TID\|([^|]*)\|)?\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse FLIGHTPATH",line,"medium"); return None
        title,tid,note=m.groups(); codes=self.extract_special_codes(line)
        note=self.normalize_common_typos(note)
        coords=self.coords_obj(self.extract_all_coords(note), codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note))
        npc=self.extract_npc(note)
        st=QuestStep("FLIGHTPATH", self.clean_title(title), None, coords, {"name":npc} if npc else None, note, line_num=ln)
        if tid and tid.strip().isdigit(): st.item_id=int(tid)
        return st

    def convert_hearth_step(self, line, ln):
        m=re.match(r'^h\s+(.+?)\s+(?:\|QID\|([^|]*)\|)?\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse HEARTH",line,"medium"); return None
        title,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s) if qid_s else None
        note=self.normalize_common_typos(note)
        coords=self.coords_obj(self.extract_all_coords(note), self.extract_map_from_text(line) or self.extract_map_from_text(note))
        npc=self.extract_npc(note)
        return QuestStep("SET_HEARTH", self.clean_title(title), qid, coords, {"name":npc} if npc else None, note, line_num=ln)

    def convert_note_step(self, line, ln):
        m=re.match(r'^N\s+(.+?)\s+\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse NOTE",line,"low"); return None
        title,note=m.groups(); codes=self.extract_special_codes(line)
        note=self.normalize_common_typos(note)
        return QuestStep("NOTE", self.clean_title(title), None, None, None, note,
                         class_restriction=codes.get('class'), as_you_go=codes.get('as_you_go',False), optional=codes.get('optional',False), line_num=ln)

    def convert_buy_step(self, line, ln):
        m=re.match(r'^B\s+(.+?)\s+(?:\|QID\|([^|]*)\|)?\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse BUY",line,"low"); return None
        item_name,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s) if qid_s else None; codes=self.extract_special_codes(line)
        note=self.normalize_common_typos(note)
        coords=self.coords_obj(self.extract_all_coords(note), codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note))
        npc=self.extract_npc(note);  item_id=codes.get('loot_item_id')
        if npc: self.found_npcs.add(npc)
        if item_id:
            self.found_item_ids.add(item_id)
            self._record_item_mapping(item_id, item_name.strip(), ln, line, "buy")
        return QuestStep("BUY", f"Buy {item_name.strip()}", qid, coords, {"name":npc} if npc else None, note, item_id=item_id, item_name=item_name.strip(), line_num=ln)

    def convert_kill_step(self, line, ln):
        m=re.match(r'^K\s+(.+?)\s+(?:\|QID\|([^|]*)\|)?\s*\|N\|(.+?)\|', line)
        if not m: self.log_issue(ln,"PARSE_ERROR","Could not parse KILL",line,"low"); return None
        label,qid_s,note=m.groups(); qid=self.parse_quest_id(qid_s) if qid_s else None; codes=self.extract_special_codes(line)
        note=self.normalize_common_typos(note)
        map_name=codes.get('zone') or self.extract_map_from_text(line) or self.extract_map_from_text(note)
        coords=self.coords_obj(self.extract_all_coords(note), map_name)
        amt=1; m2=re.search(r'\b[Kk]ill\s+(\d+)\s+', note);  amt=int(m2.group(1)) if m2 else 1
        obj={"kind":"kill","label":label.strip(),"target":amt}
        return QuestStep("COMPLETE", f"Kill {label.strip()}", qid, coords, None, note, [obj],
                         class_restriction=codes.get('class'), race_restriction=codes.get('race'), line_num=ln)

    def convert_loot_line(self, line, ln):
        m=re.match(r'^L\s+(\d+)\s+(.+?)\s*\|QID\|([^|]+)\|\s*\|N\|(.+?)\|', line)
        if not m:
            self.log_issue(ln,"PARSE_ERROR","Could not parse LOOT line",line,"medium")
            return None
        amount,item_name,qid_s,note=m.groups()
        codes=self.extract_special_codes(line)
        coords=self.coords_obj(self.extract_all_coords(note), self.extract_map_from_text(line) or self.extract_map_from_text(note))
        # Prefer collected item in note; number is optional; stop at coords/punctuation/context words
        collect_m = re.search(
            r"(?:[Cc]ollect|[Oo]btain|[Ll]oot|[Rr]etrieve|[Gg]et|[Tt]ake)\s+(?:the\s+)?(?:\d+\s+)?([A-Za-z][A-Za-z\s\'-]*?[A-Za-z])(?=\s+(?:from|in|around|at|near|off|on|inside|under|by|within|and|with|to|for|of|dropped|found)\b|\s*\(|[.,;)]|$)",
            note
        )
        collect_label = collect_m.group(1).strip() if collect_m else None
        best_label = self._choose_item_label(item_name.strip(), collect_label)
        if 'loot_item_id' in codes:
            self.found_item_ids.add(codes['loot_item_id'])
            self._record_item_mapping(codes['loot_item_id'], best_label, ln, line, "L-line")
        return {
            "item_name": item_name.strip(),
            "amount": int(amount),
            "quest_id_str": qid_s,
            "base_quest_id": self.parse_quest_id(qid_s),
            "note": self.normalize_common_typos(note),
            "coords": coords,
            "codes": codes,
            "line_num": ln,
            "collect_label": collect_label,
            "best_label": best_label
        }

    def create_objective_from_loot_data(self, ld:Dict)->Optional[Dict[str,Any]]:
        try:
            # L-lines are always loot-first. "Kill ..." in note is context for getting the loot.
            label = ld.get("best_label") or ld.get("collect_label") or ld["item_name"]
            label = self._sanitize_item_label(label)
            obj={"label":label,"target":ld["amount"],"kind":"loot","note":ld.get("note","")}
            if ld.get("coords"):
                obj["coords"]={"x":ld["coords"]["x"],"y":ld["coords"]["y"]}
            if ld["codes"].get('loot_item_id'):
                obj["itemId"]=ld["codes"]['loot_item_id']
                self._record_item_mapping(ld['codes']['loot_item_id'], label, ld.get("line_num",0), ld.get("note",""), "L->objective")
            else:
                self.log_issue(ld.get("line_num",0),"MISSING_ITEM_ID",f"No item ID for loot objective: {label}", f"L line for {label}", "low")
            return obj
        except Exception as e:
            self.log_issue(ld.get("line_num",0),"OBJECTIVE_ERROR",f"Error creating objective: {e}", f"L line for {ld.get('item_name','unknown')}", "medium")
            return None

    def group_consecutive_loot_lines(self, loot_lines:List[Dict])->List[List[Dict]]:
        if not loot_lines: return []
        groups=[]; cur=[loot_lines[0]]; cur_q=loot_lines[0]["base_quest_id"]
        for i in range(1,len(loot_lines)):
            a=loot_lines[i-1]; b=loot_lines[i]
            if b["base_quest_id"]==cur_q and b["line_num"]==a["line_num"]+1:
                cur.append(b)
            else:
                groups.append(cur); cur=[b]; cur_q=b["base_quest_id"]
        if cur: groups.append(cur)
        return groups

    def _find_insert_index_by_line(self, steps:List["QuestStep"], line_num:int)->int:
        idx = 0
        for i, s in enumerate(steps):
            if getattr(s, "line_num", 0) < line_num:
                idx = i + 1
            else:
                break
        return idx

    def process_loot_lines(self, loot_lines:List[Dict], quest_titles:Dict[int,str], steps:List[QuestStep]):
        for group in self.group_consecutive_loot_lines(loot_lines):
            if not group: continue
            qid = group[0]["base_quest_id"]
            qtitle = self.clean_title(quest_titles.get(qid, f"Quest {qid}"))
            objectives=[]
            for ld in group:
                o=self.create_objective_from_loot_data(ld)
                if o: objectives.append(o)
            if not objectives: continue
            coords = objectives[0].get("coords") if objectives[0].get("coords") else None
            group_start = min(ld['line_num'] for ld in group)
            step = QuestStep(
                step_type="COMPLETE",
                title=qtitle,
                quest_id=qid,
                coords=coords,
                note=f"Complete objectives for {qtitle}",
                objectives=objectives,
                line_num=group_start
            )
            idx = self._find_insert_index_by_line(steps, group_start)
            steps.insert(idx, step)
            self.stats['converted_steps']+=1

    def convert_line(self, line:str, ln:int)->Optional[QuestStep]:
        raw=line.strip()
        if (not raw or raw.startswith('--') or raw.startswith('TourGuide') or raw.startswith('return') or raw.startswith('[[') or raw.startswith(']]') or raw in ['[[',']]'] or raw=='end)'):
            self.stats['skipped_lines']+=1; return None
        t=raw[0]
        try:
            if t=='A': return self.convert_accept_step(raw,ln)
            if t=='C': return self.convert_complete_step(raw,ln)
            if t=='T': return self.convert_turnin_step(raw,ln)
            if t=='R': return self.convert_travel_step(raw,ln)
            if t=='F': return self.convert_fly_step(raw,ln)
            if t=='f': return self.convert_flightpath_step(raw,ln)
            if t=='h': return self.convert_hearth_step(raw,ln)
            if t=='N': return self.convert_note_step(raw,ln)
            if t=='B': return self.convert_buy_step(raw,ln)
            if t=='K': return self.convert_kill_step(raw,ln)
            if t=='L': return None
            self.log_issue(ln,"UNKNOWN_STEP_TYPE",f"Unknown step type: {t}",raw,"low"); return None
        except Exception as e:
            self.log_issue(ln,"CONVERSION_ERROR",f"Error converting: {e}",raw,"high")
            return None

    # ---------- output ----------
    def _lua_escape(self, s:str)->str:
        if s is None: return ""
        return s.replace('\\', '\\\\').replace('"','\\"').replace('\n','\\n')

    def format_step_to_lua(self, step:QuestStep, is_last=False)->str:
        indent="                "
        out=f"{indent}{{\n"
        out+=f'{indent}    type="{step.step_type}",\n'
        out+=f'{indent}    title="{self._lua_escape(step.title)}",\n'
        if step.quest_id is not None: out+=f'{indent}    questId={step.quest_id},\n'
        if step.coords:
            c=step.coords; cs=f"{{ x={c['x']}, y={c['y']}"
            if 'map' in c: cs+=f', map="{self._lua_escape(c["map"])}"'
            cs +=" }"
            out+=f'{indent}    coords={cs},\n'
        if step.npc: out+=f'{indent}    npc = {{ name="{self._lua_escape(step.npc["name"])}" }},\n'
        if step.class_restriction: out+=f'{indent}    class="{self._lua_escape(step.class_restriction)}",\n'
        if step.race_restriction: out+=f'{indent}    race="{self._lua_escape(step.race_restriction)}",\n'
        if step.destination: out+=f'{indent}    destination = "{self._lua_escape(step.destination)}",\n'
        if step.optional: out+=f'{indent}    optional = true,\n'
        if step.prerequisite: out+=f'{indent}    prerequisite = {step.prerequisite},\n'
        if step.as_you_go: out+=f'{indent}    asYouGo = true,\n'
        if step.item_id: out+=f'{indent}    itemId={step.item_id},\n'
        if step.item_name: out+=f'{indent}    itemName="{self._lua_escape(step.item_name)}",\n'
        if step.objectives:
            out+=f'{indent}    objectives = {{\n'
            for i,obj in enumerate(step.objectives):
                kind=obj.get("kind","unknown")
                label=self._lua_escape(obj.get("label","Unknown"))
                target=obj.get("target",1)
                out+=f'{indent}        {{ kind="{kind}", label="{label}", target={target}'
                if obj.get('itemId'): out+=f', itemId={obj["itemId"]}'
                if obj.get('coords'): c=obj['coords']; out+=f', coords={{ x={c["x"]}, y={c["y"]} }}'
                if obj.get('note'): out+=f', note="{self._lua_escape(obj["note"])}"'
                out+=' }'
                if i < len(step.objectives)-1: out+=','
                out+='\n'
            out+=f'{indent}    }},\n'
        if step.note:
            out+=f'{indent}    note="{self._lua_escape(step.note)}"\n'
        else:
            if out.endswith(',\n'): out=out[:-2]+"\n"
        out+=f"{indent}}}"
        if not is_last: out+=','
        out+="\n\n"
        return out

    def format_output(self, steps:List[QuestStep], name:str)->str:
        header=f"""-- =========================
-- {name}.lua
-- Converted from TourGuide format on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
-- =========================

QuestShellGuides = QuestShellGuides or {{}}

QuestShellGuides["{name}"] = {{
    title    = "{name}",
    minLevel = 1,
    maxLevel = 20,

    chapters = 
    {{    
        {{
            id       = "{name}",
            title    = "{name}",
            zone     = "Unknown",
            minLevel = 1,
            maxLevel = 20,

            steps = {{

"""
        body="".join(self.format_step_to_lua(s, i==len(steps)-1) for i,s in enumerate(steps))
        footer="""            }},
        }}
    }},
}"""
        return header+body+footer

    def generate_readme(self, name:str, input_file:str, output_file:str)->str:
        def fmt_issue(issue):
            return (f"- **Line {issue.line_number}** — {issue.issue_type.replace('_',' ').title()}: {issue.description}\n"
                    f"  ```\n  {issue.original_line.strip()}\n  ```\n")
        sev_order = ['high','medium','low']
        issues_by_sev = {s:[] for s in sev_order}
        for it in self.issues:
            issues_by_sev.get(it.severity, issues_by_sev['medium']).append(it)
        parts=[
            f"# {name} - Conversion Report\n\n",
            f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  \n",
            f"**Source:** {input_file}  \n",
            f"**Output:** {output_file}\n\n",
            f"- Total Lines: {self.stats['total_lines']}\n",
            f"- Steps Converted: {self.stats['converted_steps']}\n",
            f"- Lines Skipped: {self.stats['skipped_lines']}\n",
            f"- Issues Found: {self.stats['issues_found']}\n\n",
        ]
        if self.issues:
            parts.append("## ⚠️ Issues Requiring Review\n\n")
            for sev in sev_order:
                iss = issues_by_sev[sev]
                if not iss: continue
                emoji = {'high':'🔴','medium':'🟡','low':'🟢'}[sev]
                parts.append(f"### {emoji} {sev.upper()} Priority ({len(iss)})\n\n")
                types = {}
                for it in iss:
                    types.setdefault(it.issue_type, []).append(it)
                for tname, items in types.items():
                    parts.append(f"#### {tname.replace('_',' ').title()} ({len(items)})\n\n")
                    for it in items[:10]:
                        parts.append(fmt_issue(it))
                    if len(items) > 10:
                        parts.append(f"… and {len(items)-10} more.\n\n")
        else:
            parts.append("## ✅ No issues found\n\n")
        parts.append("## 🔍 Discovered Data\n\n")
        parts.append(f"### Quest IDs Found ({len(self.found_quest_ids)})\n\n```\n")
        parts.append(', '.join(map(str, sorted(self.found_quest_ids))) + "\n```\n\n")
        parts.append(f"### Item IDs Found ({len(self.found_item_ids)})\n\n```\n")
        parts.append(', '.join(map(str, sorted(self.found_item_ids))) + "\n```\n\n")
        parts.append(f"### NPCs Found ({len(self.found_npcs)})\n\n```\n")
        parts.append(', '.join(sorted(self.found_npcs)) + "\n```\n\n")
        parts.append(f"### Zones/Maps Found ({len(self.found_zones)})\n\n```\n")
        parts.append(', '.join(sorted(self.found_zones)) + "\n```\n\n")
        return ''.join(parts)

    # ---------- orchestration ----------
    def convert_guide(self, input_file:str, output_file:str, guide_name:str=None):
        if not guide_name: guide_name=os.path.splitext(os.path.basename(input_file))[0]
        print(f"Converting {input_file} to QuestShell format...")
        with open(input_file,'r',encoding='utf-8') as f: lines=f.readlines()
        self.stats['total_lines']=len(lines)
        steps=[]; loot_lines=[]; quest_titles={}
        for ln,line in enumerate(lines,1):
            raw=line.strip()
            if (not raw or raw.startswith('--') or raw.startswith('TourGuide') or raw.startswith('return') or raw.startswith('[[') or raw.startswith(']]') or raw in ['[[',']]'] or raw=='end)'):
                self.stats['skipped_lines']+=1
                continue
            if raw.startswith('L '):
                ld=self.convert_loot_line(line,ln)
                if ld: loot_lines.append(ld)
            else:
                st=self.convert_line(line,ln)
                if st:
                    steps.append(st); self.stats['converted_steps']+=1
                    if st.quest_id and st.step_type in ("ACCEPT","TURNIN","COMPLETE"):
                        quest_titles[st.quest_id]=st.title
                        self.quest_id_to_title[st.quest_id]=st.title

        if loot_lines: self.process_loot_lines(loot_lines, quest_titles, steps)

        output=self.format_output(steps, guide_name)
        with open(output_file,'w',encoding='utf-8') as f: f.write(output)

        readme_file=output_file.replace('.lua','_README.md')
        with open(readme_file,'w',encoding='utf-8') as f: f.write(self.generate_readme(guide_name, input_file, output_file))

        # issues JSON
        issues_json = output_file.replace('.lua','_issues.json')
        try:
            with open(issues_json,'w',encoding='utf-8') as jf:
                json.dump([{
                    'line_number': it.line_number,
                    'issue_type': it.issue_type,
                    'description': it.description,
                    'original_line': it.original_line,
                    'severity': it.severity,
                } for it in self.issues], jf, ensure_ascii=False, indent=2)
        except Exception:
            pass

        # mappings JSON (quests & items)
        try:
            mappings = {
                'quests': {str(k): v for k, v in sorted(self.quest_id_to_title.items())},
                'items': {str(k): v for k, v in sorted(self.item_id_to_name.items())}
            }
            map_file = output_file.replace('.lua','_mappings.json')
            with open(map_file,'w',encoding='utf-8') as mf:
                json.dump(mappings, mf, ensure_ascii=False, indent=2)
        except Exception:
            pass

        # conflicts JSON (summary of dup itemId name issues)
        try:
            conflicts = {
                "generated": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "events": self.item_conflicts,
                "by_item_id": {
                    str(item_id): {
                        "canonical": self.item_id_to_name.get(item_id),
                        "seen": self._item_id_names.get(item_id, [])
                    } for item_id in sorted(set(self._item_id_names.keys()) | set(self.item_id_to_name.keys()))
                }
            }
            conflicts_file = output_file.replace('.lua','_conflicts.json')
            with open(conflicts_file,'w',encoding='utf-8') as cf:
                json.dump(conflicts, cf, ensure_ascii=False, indent=2)
        except Exception:
            pass

        print("✅ Conversion complete!"); print(f"📄 Output: {output_file}"); print(f"📋 README: {readme_file}")
        print(f"📊 Stats: {self.stats['converted_steps']}/{self.stats['total_lines']} lines converted"); print(f"⚠️  Issues: {self.stats['issues_found']} found")
        return output_file, readme_file

def main():
    import argparse
    p=argparse.ArgumentParser(description='Convert TourGuide format to QuestShell format')
    p.add_argument('input'); p.add_argument('-o','--output'); p.add_argument('-n','--name'); p.add_argument('--batch')
    a=p.parse_args()
    if a.batch:
        import glob
        files=glob.glob(os.path.join(a.batch,"*.lua"))
        print(f"🔄 Batch converting {len(files)} files...")
        for f in files:
            try:
                conv=TourGuideConverter()
                out=f.replace('.lua','_converted.lua'); name=os.path.splitext(os.path.basename(f))[0]
                conv.convert_guide(f,out,name)
                print(f"✅ {f} -> {out}")
            except Exception as e:
                print(f"❌ Failed to convert {f}: {e}")
    else:
        if not os.path.exists(a.input): print(f"❌ Input file not found: {a.input}"); sys.exit(1)
        out=a.output or a.input.replace('.lua','_converted.lua'); name=a.name or os.path.splitext(os.path.basename(a.input))[0]
        try:
            conv=TourGuideConverter(); conv.convert_guide(a.input,out,name)
        except Exception as e:
            print(f"❌ Conversion failed: {e}"); sys.exit(1)

if __name__=="__main__":
    main()
