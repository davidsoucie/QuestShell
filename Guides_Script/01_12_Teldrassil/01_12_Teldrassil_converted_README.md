# 01_12_Teldrassil - Conversion Report

**Generated:** 2025-08-14 19:56:07  
**Source:** S:/TurtleWoW/Interface/AddOns/QuestShell/Guides_Script/01_12_Teldrassil/01_12_Teldrassil.lua  
**Output:** S:/TurtleWoW/Interface/AddOns/QuestShell/Guides_Script/01_12_Teldrassil/01_12_Teldrassil_converted.lua

- Total Lines: 281
- Steps Converted: 210
- Lines Skipped: 60
- Issues Found: 26

## ⚠️ Issues Requiring Review

### 🔴 HIGH Priority (24)

#### Item Id Name Conflict (24)

- **Line 41** — Item Id Name Conflict: ItemId 5168 seen as 'Fel Moss' and 'Moonpetal Lily' (L-line)
  ```
  L 4 Moonpetal Lily |QID|3521.2| |N|Collect 4 Moonpetal Lily found around the edge of the pond in Shadowglen (57, 37)| |L|5168 4|
  ```
- **Line 46** — Item Id Name Conflict: ItemId 5166 seen as 'Webwood Venom Sac' and 'Webwood Ichor' (L-line)
  ```
  L 1 Webwood Ichor |QID|3521.3| |N|Collect Webwood Ichor from Webwood Spider in Shadowglen cave (57.31, 34.25)| |L|5166 1|
  ```
- **Line 174** — Item Id Name Conflict: ItemId 5166 seen as 'Webwood Venom Sac' and 'Gnarlpine Mystic' (L-line)
  ```
  L 7 Gnarlpine Mystic |QID|2459.1| |N|Kill 7 Gnarlpine Mystic north of Starbreeze Village (69.8, 53.0)| |L|5166 7|
  ```
- **Line 177** — Item Id Name Conflict: ItemId 5175 seen as 'Ursal the Mauler' and 'Melenas' Head' (L-line)
  ```
  L 1 Lord Melenas |QID|932| |N|Kill Lord Melenas and collect Melenas' Head in Fel Rock (51.27, 50.77)| |L|5175 1|
  ```
- **Line 183** — Item Id Name Conflict: ItemId 5166 seen as 'Webwood Venom Sac' and 'Gnarlpine Ambusher' (L-line)
  ```
  L 6 Gnarlpine Ambusher |QID|487| |N|Kill 6 Gnarlpine Ambusher in in Ban'ethil Hollow (45.92, 52.80)| |L|5166 6|
  ```
- **Line 191** — Item Id Name Conflict: ItemId 5169 seen as 'Webwood Egg' and 'left bridge' (L-line)
  ```
  L 1 Rune of Nesting |QID|483.4| |N|Head down into the Ban'ethil Barrow Den at the first set of bridges take the left bridge and collect Rune of Nesting from the chest (44.40, 60.62)| |L|5169 1|
  ```
- **Line 192** — Item Id Name Conflict: ItemId 5170 seen as 'Timberling Seed' and 'Black Feather Quill' (L-line)
  ```
  L 1 Black Feather Quill |QID|483.2| |N|Collect Black Feather Quill from the chest across the other bridge (43.76, 61.20)| |L|5170 1|
  ```
- **Line 193** — Item Id Name Conflict: ItemId 5171 seen as 'Timberling Sprout' and 'Raven Claw Talisman' (L-line)
  ```
  L 1 Raven Claw Talisman |QID|483.1| |N|Collect Raven Claw Talisman from the chest (45.51, 58.96) (46.22, 58.21) (45.71, 57.33)| |L|5171 1|
  ```
- **Line 194** — Item Id Name Conflict: ItemId 5172 seen as 'Mossy Tumor' and 'Sapphire of Sky' (L-line)
  ```
  L 1 Sapphire of Sky |QID|483.3| |N|Collect Sapphire of Sky from the small chest (44.65, 62.50)| |L|5172 1|
  ```
- **Line 199** — Item Id Name Conflict: ItemId 5175 seen as 'Ursal the Mauler' and 'Rageclaw' (L-line)
  ```
  L 1 Rageclaw |QID|2561| |N|Kill Rageclaw (44.9, 61.5)| |L|5175 1|
  ```
… and 14 more.

### 🟢 LOW Priority (2)

#### Item Id Generic Replaced (1)

- **Line 173** — Item Id Generic Replaced: Replaced generic 'a book' with specific 'Tallonkai's Jewel' for itemId 8050 (L-line)
  ```
  L 1 Ferocitas the Dream Eater |QID|2459.2| |N|Kill Ferocitas the Dream Eater north of Starbreeze Village and collect Tallonkai's Jewel (69.8, 53.0)| |L|8050 1|
  ```
#### Item Id Generic Ignored (1)

- **Line 105** — Item Id Generic Ignored: Ignored generic 'a book' for itemId 8050; keeping 'Tallonkai's Jewel' (L->objective)
  ```
  Find Sethir the Ancient north of the The Oracle Glade and use the (spell:921) ability on him from behind while stealth to get a book from him (37.21, 23.24)
  ```
## 🔍 Discovered Data

### Quest IDs Found (71)

```
456, 457, 458, 459, 475, 476, 483, 486, 487, 488, 489, 916, 917, 918, 919, 920, 921, 922, 923, 927, 928, 929, 930, 931, 932, 933, 935, 937, 938, 940, 952, 997, 1683, 1684, 1686, 1692, 1693, 2159, 2241, 2242, 2438, 2459, 2498, 2499, 2518, 2519, 2520, 2541, 2561, 3116, 3117, 3118, 3119, 3120, 3519, 3521, 3522, 4495, 5921, 5923, 5929, 5931, 6001, 6063, 6101, 6102, 6103, 6341, 6342, 6344, 7383
```

### Item IDs Found (28)

```
3409, 3411, 3412, 3418, 5166, 5167, 5168, 5169, 5170, 5171, 5172, 5173, 5174, 5175, 5179, 5182, 5185, 5619, 5621, 8047, 8048, 8050, 8149, 8155, 15921, 15922, 15923, 18152
```

### NPCs Found (44)

```
Alyissia, Arch Druid Fandral Staghelm, Athridas Bearmantle, Ayanna Everstride, Conservator Ilthalaine, Corithras Moonrage, Dazalar, Denalan, Dendrite Starblaze, Dirania Silvershine, Elanaria, Frahun Shadewhisper, Gaerolas Talvethren, Gilshalan Windwalker, Innkeeper Keldamyr, Iverron, Jannok Breezesong, Jocaste, Kal, Kyra Windblade, Laird, Mardant Strongoak, Mathiel, Mathrengyl Bearwalker, Melithar Staghelm, Mist, Moon Priestess Amara, Mydrannul, Nessa Shadowsong, Oben Rageclaw, Porthannius, Priestess A'moora, Rellian Greenspyre, Sentinel Arynia Cloudsbreak, Shanda, Sister Aquinne, Speak, Strange Fronded Plant, Syurna, Tallonkai Swiftroot, Tarindrella, Tenaron Stormgrip, Vesprystus, Zenn Foulhoof
```

### Zones/Maps Found (14)

```
Aldrassil, Auberdine, Ban'ethil Barrow Den, Darkshore, Darnassus, Dolanaar, Lake Al'Ameth, Moonglade, Pools of Arlithrien, Rut'theran Village, Shadowglen, Starbreeze Village, Teldrassil, Thunder Bluff
```

