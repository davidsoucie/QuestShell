# Conversion Issues Report: 01_12_Dun_Morogh

**Total Issues Found:** 23

## Summary
- **Invalid Coordinate:** 2 issues
- **Truncated Npc Name:** 5 issues
- **Missing Objectives:** 9 issues
- **Duplicate Step:** 2 issues
- **Quest Chain Issue:** 5 issues

## Invalid Coordinate

### Issue #1
**Description:** Invalid Y coordinate: 616.36 (fixing to 61.6)

### Issue #2
**Description:** Invalid Y coordinate: 616.36 (fixing to 61.6)

## Truncated Npc Name

### Issue #1
**Description:** NPC name appears truncated: 'in Stoutlager Inn (34.88' → 'in Stoutlager'

### Issue #2
**Description:** NPC name appears truncated: 'Chunk of Boar Meat and Young Black Bear to collect 2 Thick Bear Fur' → 'Chunk of Boar Meat'

### Issue #3
**Description:** NPC name appears truncated: 'Deeprun Rat by using the Rat Catcher's Flute. Lead the rats back to Monty. Don't forget to turn in the flute when you're finishe' → 'Deeprun Rat by using the Rat Catcher's Flute. Lead the rats back'

### Issue #4
**Description:** NPC name appears truncated: 'Trogg Stone Tooth' → 'Trogg Stone'

### Issue #5
**Description:** NPC name appears truncated: 'in Stoutlager Inn (34.88' → 'in Stoutlager'

## Missing Objectives

### Issue #1
**Description:** COMPLETE step missing objectives: Find MacGrann's Meat Locker in the cave guarded by...
**Line:** 104
**Quest ID:** 312

### Issue #2
**Description:** COMPLETE step missing objectives: Use Taming Rod to tame a Large Crag Boar in Steelg...
**Line:** 156
**Quest ID:** 6064

### Issue #3
**Description:** COMPLETE step missing objectives: Use Taming Rod to tame a Snow Leopard Iceflow Lake...
**Line:** 159
**Quest ID:** 6084

### Issue #4
**Description:** COMPLETE step missing objectives: Use Taming Rod to tame a Ice Claw Bear in Iceflow ...
**Line:** 162
**Quest ID:** 6085

### Issue #5
**Description:** COMPLETE step missing objectives: Kill Vejrek and collect Vejrek's Head in Frostmane...
**Line:** 170
**Quest ID:** 1678

### Issue #6
**Description:** COMPLETE step missing objectives: Collect Umbral Ore from the Ironband lockbox in Ir...
**Line:** 177
**Quest ID:** 1681

### Issue #7
**Description:** COMPLETE step missing objectives: Keep going down the stair until you find the purpl...
**Line:** 210
**Quest ID:** 1689

### Issue #8
**Description:** COMPLETE step missing objectives: Collect Mage-tastic Gizmonitor from Blink toolbox ...
**Line:** 216
**Quest ID:** 1880

### Issue #9
**Description:** COMPLETE step missing objectives: Kill Mangeclaw and collect Mangy Claw (78.5, 37.6)...
**Line:** 223
**Quest ID:** 417

## Duplicate Step

### Issue #1
**Description:** Duplicate step found: Travel to Brewnall Village (Quest 319)
**Line:** 88

### Issue #2
**Description:** Duplicate step found: Travel to The Great Forge (Quest 2238)
**Line:** 140

## Quest Chain Issue

### Issue #1
**Description:** Quest 291 accepted but never turned in

### Issue #2
**Description:** Quest 237 accepted but never turned in

### Issue #3
**Description:** Quest 416 accepted but never turned in

### Issue #4
**Description:** Quest 418 accepted but never turned in

### Issue #5
**Description:** Quest 1338 accepted but never turned in

## Suggested Fixes

### Truncated NPC Names
- Search for NPC names ending with incomplete text
- Remove trailing artifacts like 'at the', 'north', etc.
- Verify NPC names against game database

### Duplicate Steps
- Review flagged duplicate steps
- Remove unnecessary duplicates
- Verify quest objective grouping is correct

### Quest Chain Issues
- Review quest accept/complete/turnin sequences
- Add missing quest steps where appropriate
- Verify quest prerequisites are correct

### Missing Objectives
- Review COMPLETE steps that lack proper objectives
- Add objectives structure for collection/kill tasks
- Verify quest completion requirements

### Invalid Coordinates
- Review coordinate values that seem out of range
- Fix obvious typos in coordinate values
- Verify coordinates match in-game locations
