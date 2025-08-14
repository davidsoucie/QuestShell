# 01_12_Elwynn_Forest - Conversion Report

**Generated:** 2025-08-14 13:49:24  
**Source:** /Users/dfrankov/Git/Private/QuestShell/Guides_Script/01_12_Elwynn_Forest/01_12_Elwynn_Forest.lua  
**Output:** /Users/dfrankov/Git/Private/QuestShell/Guides_Script/01_12_Elwynn_Forest/01_12_Elwynn_Forest_converted.lua

- Total Lines: 336
- Steps Converted: 266
- Lines Skipped: 69
- Issues Found: 33

## ⚠️ Issues Requiring Review

### 🔴 HIGH Priority (1)

#### Parse Error (1)

- **Line 330** — Parse Error: Could not parse TURNIN
  ```
  T A Rat Catching|QID|416| |N|Mountaineer Kadrell in Thelsamar, he patrols (32.91, 49.53)| |Z|Loch Modan|
  ```
### 🟡 MEDIUM Priority (32)

#### Missing Objectives (21)

- **Line 13** — Missing Objectives: No objectives parsed
  ```
  C Wolves Across the Border |QID|33| |N|Kill Young Wolf and Timber Wolf to collect 8 pieces of Tough Wolf Meat (47, 38) (46, 35)|
  ```
- **Line 35** — Missing Objectives: No objectives parsed
  ```
  C The Stolen Tome |QID|1598| |N|Collect Powers of the Void from the ground near the tent in Northshire Valley (56.70, 44.01)| |C|Warlock|
  ```
- **Line 51** — Missing Objectives: No objectives parsed
  ```
  C Milly's Harvest |QID|3904| |N|Clear the area around each crate of Northshire Vineyardsto collect 8 of Milly's Harvest (55, 47)| |OBJ|3012|
  ```
- **Line 52** — Missing Objectives: No objectives parsed
  ```
  C Bounty on Garrick Padfoot |QID|6| |N|Find and kill Garrick Padfoot and collect Garrick's Head. He is surrounded by two guards but both can easily be pulled seperately in Northshire Vineyards (57, 48)|
  ```
- **Line 82** — Missing Objectives: No objectives parsed
  ```
  C Pie for Billy |QID|86| |N|Kill any of the boars surrounding Elywnn Forest to collect 4 Chunk of Boar Meat. Rockhide Boar are easily found around to the south of Goldshire (47, 81)|
  ```
- **Line 98** — Missing Objectives: No objectives parsed
  ```
  C Goldtooth |QID|87| |N|Kill Goldtooth and get Bernice's Necklace in Fargodeep Mine (41.6, 78.8)|
  ```
- **Line 99** — Missing Objectives: No objectives parsed
  ```
  C The Fargodeep Mine |QID|62| |N|Travel inside The in Fargodeep Mine at to have it investigated (40.60, 81.92)|
  ```
- **Line 100** — Missing Objectives: No objectives parsed
  ```
  C Gold Dust Exchange |QID|47| |N|Kill the Kobolds surrounding the Fargodeep Mineto collect 10 Gold Dust (39, 80)|
  ```
- **Line 101** — Missing Objectives: No objectives parsed
  ```
  C Kobold Candles |QID|60| |N|Kill the Kobolds surrounding the in Fargodeep Mine to collect 8 Large Candle (39, 80)|
  ```
- **Line 121** — Missing Objectives: No objectives parsed
  ```
  C The Jasperlode Mine |QID|76| |N|Scout through the Jasperlode Mine (60.45, 50.35)|
  ```
… and 11 more.

#### Missing Npc (11)

- **Line 67** — Missing Npc: No NPC for TURNIN
  ```
  T Report to Goldshire |QID|54| |N| Marshal Dughan in Goldshire (42.14, 65.90)|
  ```
- **Line 69** — Missing Npc: No NPC for ACCEPT
  ```
  A Gold Dust Exchange |QID|47| |N|Remy \Two Times\ in Goldshire (42.19, 67.05)|
  ```
- **Line 75** — Missing Npc: No NPC for ACCEPT
  ```
  A Lost Necklace |QID|85| |N|\Auntie\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)|
  ```
- **Line 85** — Missing Npc: No NPC for TURNIN
  ```
  T Pie for Billy |QID|86| |N|\Auntie\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)|
  ```
- **Line 86** — Missing Npc: No NPC for ACCEPT
  ```
  A Back to Billy |QID|84| |N|\Auntie\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)|
  ```
- **Line 104** — Missing Npc: No NPC for TURNIN
  ```
  T Gold Dust Exchange |QID|47| |N|Remy \Two Times\ in Goldshire (42.19, 67.05)|
  ```
- **Line 105** — Missing Npc: No NPC for ACCEPT
  ```
  A A Fishy Peril |QID|40| |N|Remy \Two Times\ in Goldshire (42.19, 67.05)|
  ```
- **Line 106** — Missing Npc: No NPC for TURNIN
  ```
  T A Fishy Peril |QID|40| |N| Marshal Dughan in Goldshire (42.14, 65.90)|
  ```
- **Line 167** — Missing Npc: No NPC for TURNIN
  ```
  T Goldtooth |QID|87| |N|\Auntie\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)|
  ```
- **Line 215** — Missing Npc: No NPC for TURNIN
  ```
  T Bartleby the Drunk |QID|1639| |N|in Old Town (73.79, 36.31)| |C|Warrior| |Z|Stormwind City|
  ```
… and 1 more.

## 🔍 Discovered Data

### Quest IDs Found (89)

```
6, 7, 9, 11, 15, 18, 21, 22, 33, 35, 36, 37, 38, 39, 40, 45, 46, 47, 52, 54, 59, 60, 61, 62, 64, 71, 76, 83, 84, 85, 86, 87, 88, 106, 107, 109, 111, 112, 114, 123, 147, 151, 176, 184, 224, 237, 239, 244, 267, 353, 416, 418, 432, 433, 436, 783, 1097, 1338, 1339, 1598, 1638, 1639, 1640, 1665, 1666, 1667, 1685, 1688, 1689, 1860, 2158, 2205, 2206, 3100, 3101, 3102, 3103, 3104, 3105, 3903, 3904, 3905, 5261, 5545, 6181, 6261, 6281, 6285, 6661
```

### Item IDs Found (1)

```
17117
```

### NPCs Found (60)

```
A Half-eaten Body, Bartleby, Billy Maclure, Brother Neals, Brother Sammuel, Captain Rugelfuss, Deputy Feldon, Deputy Rainer, Deputy Willem, Drusilla La Salle, Dungar Longdrink, Eagan Peltskinner, Falkhaan Isenstrider, Farmer Furlbrow, Farmer Saldean, Foreman Stonebrow, Gakin the Darkbinder, Gramma Stonefield, Grimand Elmore, Gryan Stoutmantle, Guard Parker, Guard Thomas, Harry Burlguard, Innkeeper Farley, Jern Hornhelm, Jorik Kerridan, Keryn Sylvius, Khelden Bremen, Llane Beshere, Lyria Du Lac, Ma Stonefield, Marshal Dughan, Marshal Haggard, Marshal McBride, Master Mathias Shaw, Maybell Maclure, Milly Osworth, Monty, Morgan Pestle, Mountaineer Cobbleflint, Mountaineer Gravelgaw, Mountaineer Kadrell, Mountaineer Stormpike, Osric Strang, Priestess Anetta, Quartermaster Lewis, Remen Marcot, Rolf's corpse, Salma Saldean, Sara Timberlain, Senator Mehr Stonehallow, Smith Argus, Supervisor Raelen, Thor, Tommy Joe Stonefield, Verna Furlbrow, Vidra Hearthstove, Wanted Poster, William Pestle, Zaldimar Wefhellt
```

### Zones/Maps Found (17)

```
Dun Morogh, Eastvale Logging Camp, Elwynn Forest, Fargodeep Mine, Fargodeep Mine at, Goldshire, Jerod's Landing, Loch Modan, Northshire Abbey, Northshire Valley, Northshire Vineyards, Redridge Mountains, Ridgepoint Tower, Stone Cairn Lake, Stormwind City, Westbrook Garrison, Westfall
```

