#!/usr/bin/env python3
"""
TourGuide to QuestShell Converter
Simple drag & drop converter for WoW addon guide formats

Usage:
    python converter.py input_file.lua
    OR just drag and drop the .lua file onto this script
"""

import sys
import os
import re
from pathlib import Path

class TourGuideConverter:
    def __init__(self):
        self.quest_title_lookup = {}
        self.issues = []  # Track issues for README generation
    
    def add_issue(self, issue_type, description, line_number=None, quest_id=None):
        """Add an issue to the issues list"""
        issue = {
            'type': issue_type,
            'description': description,
            'line_number': line_number,
            'quest_id': quest_id
        }
        self.issues.append(issue)
    
    def clean_quest_title(self, title):
        """Remove (Part X) from quest titles"""
        if not title:
            return ""
        return re.sub(r'\s*\(Part\s*[^)]*\)', '', title).strip()
    
    def get_base_quest_id(self, quest_id):
        """Extract base quest ID (remove .1, .2, etc.)"""
        if not quest_id:
            return None
        match = re.match(r'^(\d+)', str(quest_id))
        return int(match.group(1)) if match else None
    
    def clean_proper_name(self, name):
        """Clean and properly capitalize names (NPCs, zones, etc.)"""
        if not name:
            return ""
        
        original_name = name
        
        # Clean up artifacts first
        name = re.sub(r'\s+(and|to|collect|from|cave|tunnel|in|down|will|reward).*', '', name, flags=re.IGNORECASE)
        name = re.sub(r'\s+(north|south|east|west)\s+of.*', '', name, flags=re.IGNORECASE)
        name = re.sub(r'\s*\([^)]*\).*', '', name)  # Remove anything in parentheses and after
        name = name.strip()
        
        # Check for truncated names
        if name != original_name and len(name) < len(original_name) * 0.7:
            self.add_issue("truncated_npc_name", f"NPC name appears truncated: '{original_name}' → '{name}'")
        
        # Handle specific problematic cases
        if name.lower() == 'the':
            self.add_issue("invalid_npc_name", f"Invalid NPC name detected: '{original_name}'")
            return "Unknown"
        
        # Split into words and capitalize each word
        words = name.split()
        capitalized_words = []
        
        for word in words:
            # Don't capitalize articles and prepositions unless they're the first word
            if word.lower() in ['the', 'of', 'in', 'at', 'and', 'or'] and len(capitalized_words) > 0:
                capitalized_words.append(word.lower())
            else:
                capitalized_words.append(word.capitalize())
        
        return ' '.join(capitalized_words)
    
    def parse_coordinates(self, text, default_map="Unknown"):
        """Extract coordinates from text (but not zone names)"""
        coords = []
        
        # Only extract coordinate pairs, don't try to parse zone names from text
        coord_matches = re.findall(r'\(([0-9.]+),\s*([0-9.]+)\)', text)
        for x, y in coord_matches:
            coords.append({
                'x': float(x),
                'y': float(y)
                # No map property - will be added from |Z| syntax if present
            })
        
        return coords, default_map
    
    def parse_npc_from_note(self, note):
        """Extract NPC name from note text"""
        # Pattern: "NPC Name in Location" or "Speak to NPC Name" or "Speeak to NPC Name" (typos)
        patterns = [
            r'Spe+ak to ([^,\s]+(?:\s+[^,\s]+)*?)(?:\s+(?:in|and|at)\s+|\s*$)',  # "Speak/Speeak to NPC Name in/and"
            r'^([^,\s]+(?:\s+[^,\s]+)*?)\s+in\s+',  # "NPC Name in Location"
            r'^([^,]+?)\s*,'  # "NPC Name, rest of text"
        ]
        
        for pattern in patterns:
            match = re.search(pattern, note)
            if match:
                npc_name = match.group(1).strip()
                
                # Only return if it looks like a valid NPC name (not too long, not empty)
                if npc_name and len(npc_name) < 50 and not npc_name.lower().startswith('kill'):
                    return self.clean_proper_name(npc_name)
        
        return None
    
    def parse_kill_objectives(self, text, coords):
        """Parse kill objectives from note text"""
        objectives = []
        
        # Check if this is actually a loot quest disguised as kill
        # Pattern: "Kill [various] mobs and collect X ItemName"
        loot_pattern = r'Kill .+? mobs? and collect (\d+) ([^,\(]+?)(?:\s+in|\s*\()'
        loot_match = re.search(loot_pattern, text)
        if loot_match:
            # This is actually a loot objective
            count, item_name = loot_match.groups()
            objective = {
                'kind': 'loot',
                'label': self.clean_proper_name(item_name.strip()),
                'target': int(count)
            }
            
            # Add coordinates
            if coords:
                if len(coords) == 1:
                    objective['coords'] = coords[0]
                else:
                    objective['coords'] = coords
            
            return [objective]
        
        # Pattern to catch kill objectives before location
        # Examples: "Kill 2 Haldarr Trickster, 2 Haldarr Felsworn and 6 Haldarr Satyr"
        #          "Kill 7 Young Nightsaber and 4 Young Thistle Boar"
        kill_match = re.search(r'Kill (.+?)(?:\s+in\s+|\s*\()', text)
        if not kill_match:
            return objectives
        
        kill_text = kill_match.group(1).strip()
        
        # Split by "and" to separate major groups
        and_parts = re.split(r'\s+and\s+', kill_text)
        
        # Process each part (could contain comma-separated items)
        for i, part in enumerate(and_parts):
            part = part.strip()
            
            # Split by comma to handle lists like "2 Haldarr Trickster, 2 Haldarr Felsworn"
            comma_parts = [p.strip() for p in part.split(',')]
            
            for j, comma_part in enumerate(comma_parts):
                comma_part = comma_part.strip()
                
                # Extract number and mob name: "2 Haldarr Trickster"
                match = re.match(r'(\d+)\s+(.+)', comma_part)
                if match:
                    count, mob_name = match.groups()
                    objective = {
                        'kind': 'kill',
                        'label': mob_name.strip(),
                        'target': int(count)
                    }
                    
                    # Assign coordinates
                    if coords:
                        if len(coords) == 1:
                            # Single coordinate for all objectives
                            objective['coords'] = coords[0]
                        else:
                            # Multiple coordinates - distribute or assign all
                            objective['coords'] = coords
                    
                    objectives.append(objective)
        
        return objectives
    
    def parse_loot_objective(self, step_text, note, coords):
        """Parse loot objective from L step"""
        # Parse: "L 8 Fel Moss |QID|459| ... |L|5168 8|"
        # Extract just the item name from the beginning part
        loot_match = re.match(r'^L\s+(\d+)\s+([^|]+)', step_text)
        item_match = re.search(r'\|L\|(\d+)\s+(\d+)\|', step_text)
        
        if not loot_match:
            return None
        
        quantity, item_name = loot_match.groups()
        
        objective = {
            'kind': 'loot',
            'label': self.clean_proper_name(item_name.strip()),
            'target': int(quantity)
        }
        
        if item_match:
            objective['itemId'] = int(item_match.group(1))
        
        # Add coordinates
        if coords:
            if len(coords) == 1:
                objective['coords'] = coords[0]
            else:
                objective['coords'] = coords
        
        return objective
    
    def extract_step_properties(self, step_text):
        """Extract special properties from step text"""
        properties = {}
        
        # Extract class: |C|Warrior|
        class_match = re.search(r'\|C\|([^|]+)\|', step_text)
        if class_match:
            properties['class'] = class_match.group(1).upper()
        
        # Extract race: |R|Night Elf|
        race_match = re.search(r'\|R\|([^|]+)\|', step_text)
        if race_match:
            properties['race'] = race_match.group(1).upper()
        
        # Extract zone: |Z|Darnassus| - this will be used to add map to coordinates
        zone_match = re.search(r'\|Z\|([^|]+)\|', step_text)
        if zone_match:
            properties['zone'] = zone_match.group(1).upper()
            # Store cleaned zone name for coordinates
            properties['_zone_for_coords'] = self.clean_proper_name(zone_match.group(1))
        
        # Extract prerequisites: |PRE|2241|
        prereq_match = re.search(r'\|PRE\|(\d+)\|', step_text)
        if prereq_match:
            properties['prerequisites'] = [int(prereq_match.group(1))]
        
        # Extract optional: |O|
        if '|O|' in step_text:
            properties['optional'] = True
        
        # Extract item usage: |U|5185|
        item_match = re.search(r'\|U\|(\d+)\|', step_text)
        if item_match:
            properties['itemId'] = int(item_match.group(1))
        
        # Extract reach: |REACH|
        if '|REACH|' in step_text:
            properties['reach'] = True
        
        return properties
    
    def parse_step(self, step_text, line_number=None):
        """Parse a single TourGuide step"""
        step_text = step_text.strip()
        if not step_text:
            return None
        
        # Extract step type
        step_type_match = re.match(r'^([ACTLNRhFf])\s+', step_text)
        if not step_type_match:
            return None
        
        step_type = step_type_match.group(1)
        
        # Extract quest ID
        quest_id_match = re.search(r'\|QID\|([0-9.]+)\|', step_text)
        quest_id = quest_id_match.group(1) if quest_id_match else None
        base_quest_id = self.get_base_quest_id(quest_id)
        
        # Extract note
        note_match = re.search(r'\|N\|([^|]+)\|', step_text)
        note = note_match.group(1) if note_match else ""
        
        # Extract additional properties
        properties = self.extract_step_properties(step_text)
        
        # Parse coordinates
        coords, map_name = self.parse_coordinates(note)
        
        step = {}
        
        if step_type == 'A':  # Accept
            step['type'] = 'ACCEPT'
            title_match = re.match(r'^A\s+([^|]+)', step_text)
            if title_match:
                title = self.clean_quest_title(title_match.group(1).strip())
                step['title'] = title
                if base_quest_id:
                    self.quest_title_lookup[base_quest_id] = title
            
            npc_name = self.parse_npc_from_note(note)
            if npc_name:
                step['npc'] = {'name': npc_name}
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'C':  # Complete
            step['type'] = 'COMPLETE'
            title_match = re.match(r'^C\s+([^|]+)', step_text)
            if title_match:
                step['title'] = self.clean_quest_title(title_match.group(1).strip())
            
            objectives = self.parse_kill_objectives(note, coords)
            if objectives:
                # Add map from |Z| syntax to objectives if present
                if '_zone_for_coords' in properties:
                    for obj in objectives:
                        if 'coords' in obj:
                            if isinstance(obj['coords'], list):
                                for coord in obj['coords']:
                                    coord['map'] = properties['_zone_for_coords']
                            else:
                                obj['coords']['map'] = properties['_zone_for_coords']
                step['objectives'] = objectives
            elif coords:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'T':  # Turn in
            step['type'] = 'TURNIN'
            title_match = re.match(r'^T\s+([^|]+)', step_text)
            if title_match:
                step['title'] = self.clean_quest_title(title_match.group(1).strip())
            
            npc_name = self.parse_npc_from_note(note)
            if npc_name:
                step['npc'] = {'name': npc_name}
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'L':  # Loot
            step['type'] = 'COMPLETE'
            
            # Get title from quest lookup
            if base_quest_id and base_quest_id in self.quest_title_lookup:
                step['title'] = self.quest_title_lookup[base_quest_id]
            else:
                step['title'] = 'Unknown Quest'
                self.add_issue("unknown_quest_title", f"Could not determine quest title for quest ID {base_quest_id}", line_number, base_quest_id)
            
            objective = self.parse_loot_objective(step_text, note, coords)
            if objective:
                # Add map from |Z| syntax to objective if present
                if '_zone_for_coords' in properties and 'coords' in objective:
                    if isinstance(objective['coords'], list):
                        for coord in objective['coords']:
                            coord['map'] = properties['_zone_for_coords']
                    else:
                        objective['coords']['map'] = properties['_zone_for_coords']
                step['objectives'] = [objective]
        
        elif step_type == 'N':  # Note
            step['type'] = 'Note'
            title_match = re.match(r'^N\s+([^|]+)', step_text)
            step['title'] = title_match.group(1).strip() if title_match else 'Note'
        
        elif step_type == 'R':  # Travel
            step['type'] = 'TRAVEL'
            dest_match = re.match(r'^R\s+([^|]+)', step_text)
            if dest_match:
                destination = dest_match.group(1).strip()
                step['title'] = f'Travel to {destination}'
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'h':  # Set hearth
            step['type'] = 'SET_HEARTH'
            step['title'] = 'Set your hearthstone'
            
            npc_name = self.parse_npc_from_note(note)
            if npc_name:
                step['npc'] = {'name': npc_name}
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'F':  # Fly
            step['type'] = 'FLY'
            dest_match = re.match(r'^F\s+([^|]+)', step_text)
            if dest_match:
                destination = dest_match.group(1).strip()
                step['title'] = f'Fly to {destination}'
                step['destination'] = destination
            
            npc_name = self.parse_npc_from_note(note)
            if npc_name:
                step['npc'] = {'name': npc_name}
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        elif step_type == 'f':  # Get flight path
            step['type'] = 'GET_FLIGHTPATH'
            dest_match = re.match(r'^f\s+([^|]+)', step_text)
            if dest_match:
                location = dest_match.group(1).strip()
                step['title'] = f'Get flight path for {location}'
                step['location'] = location
            
            npc_name = self.parse_npc_from_note(note)
            if npc_name:
                step['npc'] = {'name': npc_name}
            
            # Add coordinates
            if coords and coords[0]:
                step['coords'] = coords[0].copy()
                # Add map from |Z| syntax if present
                if '_zone_for_coords' in properties:
                    step['coords']['map'] = properties['_zone_for_coords']
        
        # Add quest ID
        if base_quest_id:
            step['questId'] = base_quest_id
        
        # Add note
        if note and note.strip():
            step['note'] = note.strip()
        
        # Add special properties (excluding internal ones)
        for k, v in properties.items():
            if not k.startswith('_'):
                step[k] = v
        
        # Check for potential issues
        if step.get('title') == 'Unknown Quest':
            self.add_issue("unknown_quest_title", f"Quest title unknown for step: {step_text[:50]}...", line_number, base_quest_id)
        
        if step.get('npc', {}).get('name', '').endswith(' at the'):
            self.add_issue("truncated_npc_name", f"NPC name appears truncated: '{step['npc']['name']}'", line_number, base_quest_id)
        
        return step
    
    def group_loot_steps(self, steps):
        """Group consecutive loot steps with same quest ID"""
        grouped = []
        i = 0
        
        while i < len(steps):
            current = steps[i]
            
            if (current.get('type') == 'COMPLETE' and 
                current.get('objectives') and 
                current['objectives'][0].get('kind') == 'loot'):
                
                quest_id = current.get('questId')
                grouped_objectives = [current['objectives'][0]]
                
                # Look for consecutive loot steps
                j = i + 1
                while j < len(steps):
                    next_step = steps[j]
                    if (next_step.get('type') == 'COMPLETE' and
                        next_step.get('questId') == quest_id and
                        next_step.get('objectives') and
                        next_step['objectives'][0].get('kind') == 'loot'):
                        grouped_objectives.append(next_step['objectives'][0])
                        j += 1
                    else:
                        break
                
                # Create grouped step
                grouped_step = current.copy()
                grouped_step['objectives'] = grouped_objectives
                grouped.append(grouped_step)
                i = j
            else:
                grouped.append(current)
                i += 1
        
        return grouped
    
    def check_for_duplicates(self, steps):
        """Check for duplicate steps and log issues"""
        seen_steps = {}
        for i, step in enumerate(steps):
            key = f"{step.get('type')}_{step.get('questId')}_{step.get('title', '')}"
            if key in seen_steps:
                self.add_issue("duplicate_step", f"Duplicate step found: {step.get('title', 'Unknown')} (Quest {step.get('questId', 'N/A')})", i)
            else:
                seen_steps[key] = i
    
    def check_quest_chains(self, steps):
        """Check for broken quest chains (ACCEPT without TURNIN, etc.)"""
        quest_states = {}  # questId -> 'accepted' | 'completed' | 'turned_in'
        
        for i, step in enumerate(steps):
            quest_id = step.get('questId')
            if not quest_id:
                continue
                
            step_type = step.get('type')
            
            if step_type == 'ACCEPT':
                if quest_id in quest_states:
                    self.add_issue("quest_chain_issue", f"Quest {quest_id} accepted multiple times", i, quest_id)
                quest_states[quest_id] = 'accepted'
            
            elif step_type == 'COMPLETE':
                if quest_id not in quest_states:
                    self.add_issue("quest_chain_issue", f"Quest {quest_id} completed without being accepted", i, quest_id)
                elif quest_states[quest_id] == 'turned_in':
                    self.add_issue("quest_chain_issue", f"Quest {quest_id} completed after being turned in", i, quest_id)
                quest_states[quest_id] = 'completed'
            
            elif step_type == 'TURNIN':
                if quest_id not in quest_states:
                    self.add_issue("quest_chain_issue", f"Quest {quest_id} turned in without being accepted", i, quest_id)
                quest_states[quest_id] = 'turned_in'
        
        # Check for accepted but not turned in quests
        for quest_id, state in quest_states.items():
            if state == 'accepted':
                self.add_issue("quest_chain_issue", f"Quest {quest_id} accepted but never turned in")
    
    def generate_issues_readme(self, guide_name, output_path):
        """Generate a README file with detected issues"""
        if not self.issues:
            return None  # No issues found
        
        readme_path = output_path.parent / f"{output_path.stem}_ISSUES.md"
        
        # Group issues by type
        issues_by_type = {}
        for issue in self.issues:
            issue_type = issue['type']
            if issue_type not in issues_by_type:
                issues_by_type[issue_type] = []
            issues_by_type[issue_type].append(issue)
        
        # Generate README content
        content = []
        content.append(f"# Conversion Issues Report: {guide_name}")
        content.append("")
        content.append(f"**Total Issues Found:** {len(self.issues)}")
        content.append("")
        content.append("## Summary")
        for issue_type, type_issues in issues_by_type.items():
            content.append(f"- **{issue_type.replace('_', ' ').title()}:** {len(type_issues)} issues")
        content.append("")
        
        # Detailed issues
        for issue_type, type_issues in issues_by_type.items():
            content.append(f"## {issue_type.replace('_', ' ').title()}")
            content.append("")
            
            for i, issue in enumerate(type_issues, 1):
                content.append(f"### Issue #{i}")
                content.append(f"**Description:** {issue['description']}")
                if issue['line_number']:
                    content.append(f"**Line:** {issue['line_number']}")
                if issue['quest_id']:
                    content.append(f"**Quest ID:** {issue['quest_id']}")
                content.append("")
        
        # Manual fix suggestions
        content.append("## Suggested Fixes")
        content.append("")
        
        if 'truncated_npc_name' in issues_by_type:
            content.append("### Truncated NPC Names")
            content.append("- Search for NPC names ending with incomplete text")
            content.append("- Remove trailing artifacts like 'at the', 'north', etc.")
            content.append("- Verify NPC names against game database")
            content.append("")
        
        if 'unknown_quest_title' in issues_by_type:
            content.append("### Unknown Quest Titles")
            content.append("- Look up quest IDs in quest database")
            content.append("- Replace 'Unknown Quest' with actual quest names")
            content.append("- Common quest ID mappings:")
            unique_quest_ids = set(issue['quest_id'] for issue in issues_by_type['unknown_quest_title'] if issue['quest_id'])
            for qid in sorted(unique_quest_ids):
                content.append(f"  - Quest ID {qid}: [Look up quest name]")
            content.append("")
        
        if 'duplicate_step' in issues_by_type:
            content.append("### Duplicate Steps")
            content.append("- Review flagged duplicate steps")
            content.append("- Remove unnecessary duplicates")
            content.append("- Verify quest objective grouping is correct")
            content.append("")
        
        if 'quest_chain_issue' in issues_by_type:
            content.append("### Quest Chain Issues")
            content.append("- Review quest accept/complete/turnin sequences")
            content.append("- Add missing quest steps where appropriate")
            content.append("- Verify quest prerequisites are correct")
            content.append("")
        
        # Write README file
        try:
            with open(readme_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(content))
            return readme_path
        except Exception as e:
            print(f"❌ Error writing issues README: {e}")
            return None
    
    def convert(self, content, guide_name=None, min_level=1, max_level=60, zone="Unknown"):
        """Convert TourGuide content to QuestShell format"""
        # Clear previous issues
        self.issues = []
        
        # Extract guide info from content if available
        if not guide_name:
            guide_match = re.search(r'RegisterGuide\("([^"]+)"', content)
            if guide_match:
                guide_name = guide_match.group(1)
            else:
                guide_name = "Converted Guide"
        
        # Extract all lines that look like steps
        lines = []
        for line_num, line in enumerate(content.split('\n'), 1):
            line = line.strip()
            if line and not line.startswith('--') and not line.startswith('return') and line != ']]':
                if re.match(r'^[ACTLNRhFf]\s+', line):
                    lines.append((line, line_num))
        
        # First pass: build quest title lookup
        self.quest_title_lookup = {}
        for line, line_num in lines:
            if line.startswith('A '):
                self.parse_step(line, line_num)
        
        # Second pass: convert all steps
        steps = []
        for line, line_num in lines:
            step = self.parse_step(line, line_num)
            if step:
                steps.append(step)
        
        # Group consecutive loot steps
        steps = self.group_loot_steps(steps)
        
        # Run quality checks
        self.check_for_duplicates(steps)
        self.check_quest_chains(steps)
        
        # Generate output
        output = []
        output.append("-- =========================")
        output.append(f"-- {guide_name}")
        output.append("-- Converted from TourGuide format")
        output.append("-- =========================")
        output.append("")
        output.append("QuestShellGuides = QuestShellGuides or {}")
        output.append("")
        output.append(f'QuestShellGuides["{guide_name}"] = {{')
        output.append(f'    title    = "{guide_name}",')
        output.append(f'    minLevel = {min_level},')
        output.append(f'    maxLevel = {max_level},')
        output.append("")
        output.append("    chapters =")
        output.append("    {")
        output.append("        {")
        output.append(f'            id       = "{guide_name}",')
        output.append(f'            title    = "{guide_name}",')
        output.append(f'            zone     = "{zone}",')
        output.append(f'            minLevel = {min_level},')
        output.append(f'            maxLevel = {max_level},')
        output.append("")
        output.append("            steps = {")
        
        for i, step in enumerate(steps):
            output.append("")
            output.append("                {")
            
            # Required fields
            output.append(f'                  type="{step["type"]}",')
            output.append(f'                  title="{step.get("title", "")}",')
            
            # Optional fields in specific order
            if 'questId' in step:
                output.append(f'                  questId={step["questId"]},')
            
            if 'coords' in step:
                coords = step['coords']
                coord_str = f'{{ x={coords["x"]}, y={coords["y"]}'
                if 'map' in coords:
                    coord_str += f', map="{coords["map"]}"'
                coord_str += ' }'
                output.append(f'                  coords={coord_str},')
            
            if 'npc' in step:
                output.append(f'                  npc = {{ name="{step["npc"]["name"]}" }},')
            
            if 'destination' in step:
                output.append(f'                  destination = "{step["destination"]}",')
            
            if 'objectives' in step:
                output.append("                  objectives = {")
                for j, obj in enumerate(step['objectives']):
                    obj_line = f'                    {{ kind="{obj["kind"]}", label="{obj["label"]}", target={obj["target"]}'
                    
                    if 'itemId' in obj:
                        obj_line += f', itemId={obj["itemId"]}'
                    
                    if 'coords' in obj:
                        if isinstance(obj['coords'], list):
                            coord_strs = []
                            for coord in obj['coords']:
                                coord_str = f'{{ x={coord["x"]}, y={coord["y"]}'
                                if 'map' in coord:
                                    coord_str += f', map="{coord["map"]}"'
                                coord_str += ' }'
                                coord_strs.append(coord_str)
                            obj_line += f', coords={{ {", ".join(coord_strs)} }}'
                        else:
                            coord = obj['coords']
                            coord_str = f'{{ x={coord["x"]}, y={coord["y"]}'
                            if 'map' in coord:
                                coord_str += f', map="{coord["map"]}"'
                            coord_str += ' }'
                            obj_line += f', coords={coord_str}'
                    
                    obj_line += " }"
                    if j < len(step['objectives']) - 1:
                        obj_line += ","
                    
                    output.append(obj_line)
                
                output.append("                  },")
            
            # Special properties
            for prop in ['class', 'race', 'zone', 'itemId', 'level', 'location']:
                if prop in step:
                    if isinstance(step[prop], str):
                        output.append(f'                  {prop}="{step[prop]}",')
                    else:
                        output.append(f'                  {prop}={step[prop]},')
            
            if 'prerequisites' in step:
                prereq_str = "{" + ",".join(map(str, step['prerequisites'])) + "}"
                output.append(f'                  prerequisites={prereq_str},')
            
            if 'optional' in step:
                output.append(f'                  optional={str(step["optional"]).lower()},')
            
            if 'reach' in step:
                output.append(f'                  reach={str(step["reach"]).lower()},')
            
            # Note always last
            if 'note' in step:
                note = step['note'].replace('"', '\\"')
                output.append(f'                  note="{note}"')
            
            output.append("                }" + ("," if i < len(steps) - 1 else ""))
        
        output.append("")
        output.append("            },")
        output.append("        }")
        output.append("    },")
        output.append("}")
        
        return "\n".join(output)


def main():
    print("🎮 TourGuide to QuestShell Converter")
    print("=" * 40)
    
    # Get input file
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    else:
        input_file = input("Drag and drop your .lua file here (or enter path): ").strip().strip('"\'')
    
    # Validate input
    if not os.path.exists(input_file):
        print(f"❌ Error: File '{input_file}' not found!")
        input("Press Enter to exit...")
        return
    
    # Read file
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        print(f"✅ Read file: {os.path.basename(input_file)}")
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        input("Press Enter to exit...")
        return
    
    # Convert
    try:
        converter = TourGuideConverter()
        converted = converter.convert(content)
        print("✅ Conversion completed!")
    except Exception as e:
        print(f"❌ Error during conversion: {e}")
        input("Press Enter to exit...")
        return
    
    # Generate output filename
    input_path = Path(input_file)
    output_file = input_path.parent / f"{input_path.stem}_converted.lua"
    
    # Write output
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(converted)
        print(f"✅ Saved to: {output_file}")
        print(f"📁 Output size: {len(converted)} characters")
    except Exception as e:
        print(f"❌ Error writing output: {e}")
        input("Press Enter to exit...")
        return
    
    # Generate issues README if there are issues
    if converter.issues:
        guide_name = input_path.stem
        readme_path = converter.generate_issues_readme(guide_name, output_file)
        if readme_path:
            print(f"⚠️  Issues detected! Report saved to: {readme_path}")
            print(f"📋 Total issues found: {len(converter.issues)}")
        else:
            print("⚠️  Issues detected but could not write README file")
    else:
        print("✨ No issues detected during conversion!")
    
    print("\n🎉 Conversion successful!")
    input("Press Enter to exit...")


if __name__ == "__main__":
    main()