-- =========================
-- 01_12_Elwynn_Forest.lua
-- Converted from TourGuide format on 2025-08-14 13:49:24
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["01_12_Elwynn_Forest"] = {
    title    = "01_12_Elwynn_Forest",
    minLevel = 1,
    maxLevel = 20,

    chapters = 
    {    
        {
            id       = "01_12_Elwynn_Forest",
            title    = "01_12_Elwynn_Forest",
            zone     = "Unknown",
            minLevel = 1,
            maxLevel = 20,

            steps = {

                {
                    type="ACCEPT",
                    title="A Threat Within",
                    questId=783,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="TURNIN",
                    title="A Threat Within",
                    questId=783,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Kobold Camp Cleanup",
                    questId=7,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Eagan Peltskinner",
                    questId=5261,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="TURNIN",
                    title="Eagan Peltskinner",
                    questId=5261,
                    coords={ x=48.92, y=40.11, map="Northshire Valley" },
                    npc = { name="Eagan Peltskinner" },
                    note="Eagan Peltskinner in Northshire Valley (48.92, 40.11)"
                },

                {
                    type="ACCEPT",
                    title="Wolves Across the Border",
                    questId=33,
                    coords={ x=48.92, y=40.11, map="Northshire Valley" },
                    npc = { name="Eagan Peltskinner" },
                    note="Eagan Peltskinner in Northshire Valley (48.92, 40.11)"
                },

                {
                    type="COMPLETE",
                    title="Kobold Camp Cleanup",
                    questId=7,
                    coords={ x=49.0, y=35.0, map="Northshire Valley" },
                    objectives = {
                        { kind="kill", label="Kobold Vermin which can be found", target=10 }
                    },
                    note="Kill 10 Kobold Vermin which can be found around the mine in Northshire Valley (49, 35)"
                },

                {
                    type="COMPLETE",
                    title="Wolves Across the Border",
                    questId=33,
                    coords={ x=47.0, y=38.0 },
                    note="Kill Young Wolf and Timber Wolf to collect 8 pieces of Tough Wolf Meat (47, 38) (46, 35)"
                },

                {
                    type="TURNIN",
                    title="Wolves Across the Border",
                    questId=33,
                    coords={ x=48.92, y=40.11, map="Northshire Valley" },
                    npc = { name="Eagan Peltskinner" },
                    note="Eagan Peltskinner in Northshire Valley (48.92, 40.11)"
                },

                {
                    type="ACCEPT",
                    title="Brotherhood of Thieves",
                    questId=18,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="TURNIN",
                    title="Kobold Camp Cleanup",
                    questId=7,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Investigate Echo Ridge",
                    questId=15,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Consecrated Letter",
                    questId=3101,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Paladin",
                    race="Human",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Glyphic Letter",
                    questId=3104,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Mage",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Encrypted Letter",
                    questId=3102,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Rogue",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Simple Letter",
                    questId=3100,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Warrior",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Hallowed Letter",
                    questId=3103,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Priest",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Tainted Letter",
                    questId=3105,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    class="Warlock",
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="TURNIN",
                    title="Consecrated Letter",
                    questId=3101,
                    coords={ x=50.4, y=42.1, map="Northshire Abbey" },
                    npc = { name="Brother Sammuel" },
                    class="Paladin",
                    race="Human",
                    note="Brother Sammuel in Northshire Abbey (50.4, 42.1)"
                },

                {
                    type="TURNIN",
                    title="Glyphic Letter",
                    questId=3104,
                    coords={ x=49.66, y=39.38, map="Northshire Abbey" },
                    npc = { name="Khelden Bremen" },
                    class="Mage",
                    note="Khelden Bremen in Northshire Abbey (49.66, 39.38)"
                },

                {
                    type="TURNIN",
                    title="Encrypted Letter",
                    questId=3102,
                    coords={ x=50.4, y=39.9, map="Northshire Abbey" },
                    npc = { name="Jorik Kerridan" },
                    class="Rogue",
                    note="Jorik Kerridan in Northshire Abbey (50.4, 39.9)"
                },

                {
                    type="TURNIN",
                    title="Simple Letter",
                    questId=3100,
                    coords={ x=50.2, y=42.2, map="Northshire Abbey" },
                    npc = { name="Llane Beshere" },
                    class="Warrior",
                    note="Llane Beshere in Northshire Abbey (50.2, 42.2)"
                },

                {
                    type="TURNIN",
                    title="Hallowed Letter",
                    questId=3103,
                    coords={ x=49.8, y=39.6, map="Northshire Abbey" },
                    npc = { name="Priestess Anetta" },
                    class="Priest",
                    note="Priestess Anetta in Northshire Abbey (49.8, 39.6)"
                },

                {
                    type="TURNIN",
                    title="Tainted Letter",
                    questId=3105,
                    coords={ x=49.9, y=42.7, map="Northshire Abbey" },
                    npc = { name="Drusilla La Salle" },
                    class="Warlock",
                    note="Drusilla La Salle in Northshire Abbey (49.9, 42.7)"
                },

                {
                    type="ACCEPT",
                    title="The Stolen Tome",
                    questId=1598,
                    coords={ x=49.87, y=42.65, map="Northshire Valley" },
                    npc = { name="Drusilla La Salle" },
                    class="Warlock",
                    note="Drusilla La Salle in Northshire Valley (49.87, 42.65)"
                },

                {
                    type="COMPLETE",
                    title="The Stolen Tome",
                    questId=1598,
                    coords={ x=56.7, y=44.01, map="Northshire Valley" },
                    class="Warlock",
                    note="Collect Powers of the Void from the ground near the tent in Northshire Valley (56.70, 44.01)"
                },

                {
                    type="COMPLETE",
                    title="Brotherhood of Thieves",
                    questId=18,
                    coords={ x=54.0, y=45.0, map="Northshire Vineyards" },
                    objectives = {
                        { kind="loot", label="Red Burlap Bandana", target=12 }
                    },
                    note="Kill the Defias Thug which surround the area to the Southeast across the river to collect 12 Red Burlap Bandana in Northshire Vineyards (54, 45)"
                },

                {
                    type="TURNIN",
                    title="The Stolen Tome",
                    questId=1598,
                    coords={ x=49.87, y=42.65, map="Northshire Valley" },
                    npc = { name="Drusilla La Salle" },
                    class="Warlock",
                    note="Drusilla La Salle in Northshire Valley (49.87, 42.65)"
                },

                {
                    type="TRAVEL",
                    title="Northshire Valley",
                    questId=15,
                    coords={ x=51.63, y=36.76 },
                    note="Travel to Northshire Valley (51.63, 36.76)"
                },

                {
                    type="COMPLETE",
                    title="Investigate Echo Ridge",
                    questId=15,
                    coords={ x=51.63, y=36.76 },
                    objectives = {
                        { kind="kill", label="Kobold Worker which can be found", target=10 }
                    },
                    note="Kill 10 Kobold Worker which can be found in the mine in Northshire Valley (51.63, 36.76)"
                },

                {
                    type="TRAVEL",
                    title="Northshire Valley",
                    questId=3904,
                    coords={ x=47.75, y=41.97 },
                    note="Travel to Northshire Valley (47.75, 41.97)"
                },

                {
                    type="TURNIN",
                    title="Brotherhood of Thieves",
                    questId=18,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="ACCEPT",
                    title="Bounty on Garrick Padfoot",
                    questId=6,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="ACCEPT",
                    title="Milly Osworth",
                    questId=3903,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="TURNIN",
                    title="Investigate Echo Ridge",
                    questId=15,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Skirmish at Echo Ridge",
                    questId=21,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="TURNIN",
                    title="Milly Osworth",
                    questId=3903,
                    coords={ x=50.69, y=39.32, map="Northshire Valley" },
                    npc = { name="Milly Osworth" },
                    note="Milly Osworth in Northshire Valley (50.69, 39.32)"
                },

                {
                    type="ACCEPT",
                    title="Milly's Harvest",
                    questId=3904,
                    coords={ x=50.69, y=39.32, map="Northshire Valley" },
                    npc = { name="Milly Osworth" },
                    note="Milly Osworth in Northshire Valley (50.69, 39.32)"
                },

                {
                    type="COMPLETE",
                    title="Milly's Harvest",
                    questId=3904,
                    coords={ x=55.0, y=47.0 },
                    note="Clear the area around each crate of Northshire Vineyardsto collect 8 of Milly's Harvest (55, 47)"
                },

                {
                    type="COMPLETE",
                    title="Bounty on Garrick Padfoot",
                    questId=6,
                    coords={ x=57.0, y=48.0, map="Northshire Vineyards" },
                    note="Find and kill Garrick Padfoot and collect Garrick's Head. He is surrounded by two guards but both can easily be pulled seperately in Northshire Vineyards (57, 48)"
                },

                {
                    type="TURNIN",
                    title="Milly's Harvest",
                    questId=3904,
                    coords={ x=50.69, y=39.32, map="Northshire Valley" },
                    npc = { name="Milly Osworth" },
                    note="Milly Osworth in Northshire Valley (50.69, 39.32)"
                },

                {
                    type="ACCEPT",
                    title="Grape Manifest",
                    questId=3905,
                    coords={ x=50.69, y=39.32, map="Northshire Valley" },
                    npc = { name="Milly Osworth" },
                    note="Milly Osworth in Northshire Valley (50.69, 39.32)"
                },

                {
                    type="TRAVEL",
                    title="Echo Ridge Mine",
                    questId=21,
                    coords={ x=48.71, y=27.81 },
                    note="Travel to Echo Ridge Mine (48.71, 27.81)"
                },

                {
                    type="COMPLETE",
                    title="Skirmish at Echo Ridge",
                    questId=21,
                    coords={ x=48.0, y=29.0 },
                    objectives = {
                        { kind="kill", label="Kobold Laborer which can be found", target=12 }
                    },
                    note="Kill 12 Kobold Laborer which can be found around the Echo Ridge Mine (48, 29)"
                },

                {
                    type="TRAVEL",
                    title="Northshire Abbey",
                    questId=54,
                    coords={ x=47.75, y=41.97 },
                    note="Travel to Northshire Abbey (47.75, 41.97)"
                },

                {
                    type="TURNIN",
                    title="Bounty on Garrick Padfoot",
                    questId=6,
                    coords={ x=48.18, y=42.93, map="Northshire Valley" },
                    npc = { name="Deputy Willem" },
                    note="Deputy Willem in Northshire Valley (48.18, 42.93)"
                },

                {
                    type="TURNIN",
                    title="Skirmish at Echo Ridge",
                    questId=21,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="ACCEPT",
                    title="Report to Goldshire",
                    questId=54,
                    coords={ x=48.91, y=41.6, map="Northshire Abbey" },
                    npc = { name="Marshal McBride" },
                    note="Marshal McBride in Northshire Abbey (48.91, 41.60)"
                },

                {
                    type="TURNIN",
                    title="Grape Manifest",
                    questId=3905,
                    coords={ x=49.46, y=41.56, map="Northshire Abbey" },
                    npc = { name="Brother Neals" },
                    note="Brother Neals in Northshire Abbey (49.46, 41.56)"
                },

                {
                    type="ACCEPT",
                    title="Rest and Relaxation",
                    questId=2158,
                    coords={ x=45.51, y=47.72, map="Northshire Valley" },
                    npc = { name="Falkhaan Isenstrider" },
                    note="Falkhaan Isenstrider in Northshire Valley (45.51, 47.72)"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    questId=62,
                    coords={ x=42.14, y=65.9, map="Elwynn Forest" },
                    note="Travel to Goldshire (42.14, 65.90)"
                },

                {
                    type="TURNIN",
                    title="Report to Goldshire",
                    questId=54,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    note=" Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="The Fargodeep Mine",
                    questId=62,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="Gold Dust Exchange",
                    questId=47,
                    coords={ x=42.19, y=67.05, map="Goldshire" },
                    note="Remy \\Two Times\\ in Goldshire (42.19, 67.05)"
                },

                {
                    type="ACCEPT",
                    title="Kobold Candles",
                    questId=60,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="TURNIN",
                    title="Rest and Relaxation",
                    questId=2158,
                    coords={ x=43.78, y=65.86, map="Goldshire" },
                    npc = { name="Innkeeper Farley" },
                    note="Innkeeper Farley in Goldshire (43.78, 65.86)"
                },

                {
                    type="SET_HEARTH",
                    title="Goldshire",
                    questId=60,
                    coords={ x=43.78, y=65.86, map="Goldshire" },
                    npc = { name="Innkeeper Farley" },
                    note="Innkeeper Farley in Goldshire (43.78, 65.86)"
                },

                {
                    type="TRAVEL",
                    title="The Stonefield Farm",
                    questId=85,
                    coords={ x=34.5, y=84.3 },
                    note="Travel to The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="ACCEPT",
                    title="Lost Necklace",
                    questId=85,
                    coords={ x=34.5, y=84.3 },
                    note="\\Auntie\\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="TRAVEL",
                    title="The Maclure Vineyards",
                    questId=106,
                    coords={ x=43.12, y=89.55 },
                    note="Travel to The Maclure Vineyards (43.12, 89.55)"
                },

                {
                    type="ACCEPT",
                    title="Young Lovers",
                    questId=106,
                    coords={ x=43.12, y=89.55 },
                    npc = { name="Maybell Maclure" },
                    note="Maybell Maclure in The Maclure Vineyards (43.12, 89.55)"
                },

                {
                    type="TURNIN",
                    title="Lost Necklace",
                    questId=85,
                    coords={ x=43.12, y=85.77 },
                    npc = { name="Billy Maclure" },
                    note="Billy Maclure in The Maclure Vineyards (43.12, 85.77)"
                },

                {
                    type="ACCEPT",
                    title="Pie for Billy",
                    questId=86,
                    coords={ x=43.12, y=85.77 },
                    npc = { name="Billy Maclure" },
                    note="Billy Maclure in The Maclure Vineyards (43.12, 85.77)"
                },

                {
                    type="COMPLETE",
                    title="Pie for Billy",
                    questId=86,
                    coords={ x=47.0, y=81.0 },
                    note="Kill any of the boars surrounding Elywnn Forest to collect 4 Chunk of Boar Meat. Rockhide Boar are easily found around to the south of Goldshire (47, 81)"
                },

                {
                    type="TRAVEL",
                    title="The Stonefield Farm",
                    questId=84,
                    coords={ x=34.5, y=84.3 },
                    note="Travel to The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="TURNIN",
                    title="Pie for Billy",
                    questId=86,
                    coords={ x=34.5, y=84.3 },
                    note="\\Auntie\\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="ACCEPT",
                    title="Back to Billy",
                    questId=84,
                    coords={ x=34.5, y=84.3 },
                    note="\\Auntie\\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="ACCEPT",
                    title="Princess Must Die!",
                    questId=88,
                    coords={ x=34.61, y=84.43 },
                    npc = { name="Ma Stonefield" },
                    note="Ma Stonefield in The Stonefield Farm (34.61, 84.43)"
                },

                {
                    type="TURNIN",
                    title="Young Lovers",
                    questId=106,
                    coords={ x=29.86, y=85.9 },
                    npc = { name="Tommy Joe Stonefield" },
                    note="Tommy Joe Stonefield in The Stonefield Farm (29.86, 85.90)"
                },

                {
                    type="ACCEPT",
                    title="Speak with Gramma",
                    questId=111,
                    coords={ x=29.86, y=85.9 },
                    npc = { name="Tommy Joe Stonefield" },
                    note="Tommy Joe Stonefield in The Stonefield Farm (29.86, 85.90)"
                },

                {
                    type="TURNIN",
                    title="Speak with Gramma",
                    questId=111,
                    coords={ x=34.95, y=83.84 },
                    npc = { name="Gramma Stonefield" },
                    note="Gramma Stonefield in The Stonefield Farm (34.95, 83.84)"
                },

                {
                    type="ACCEPT",
                    title="Note to William",
                    questId=107,
                    coords={ x=34.95, y=83.84 },
                    npc = { name="Gramma Stonefield" },
                    note="Gramma Stonefield in The Stonefield Farm (34.95, 83.84)"
                },

                {
                    type="TRAVEL",
                    title="The Maclure Vineyards",
                    questId=87,
                    coords={ x=43.12, y=85.77 },
                    note="Travel to The Maclure Vineyards (43.12, 85.77)"
                },

                {
                    type="TURNIN",
                    title="Back to Billy",
                    questId=84,
                    coords={ x=43.12, y=85.77 },
                    npc = { name="Billy Maclure" },
                    note="Billy Maclure in The Maclure Vineyards (43.12, 85.77)"
                },

                {
                    type="ACCEPT",
                    title="Goldtooth",
                    questId=87,
                    coords={ x=43.12, y=85.77 },
                    npc = { name="Billy Maclure" },
                    note="Billy Maclure in The Maclure Vineyards (43.12, 85.77)"
                },

                {
                    type="TRAVEL",
                    title="Fargodeep Mine",
                    questId=87,
                    coords={ x=38.94, y=81.85 },
                    note="Travel to Fargodeep Mine (38.94, 81.85)"
                },

                {
                    type="COMPLETE",
                    title="Goldtooth",
                    questId=87,
                    coords={ x=41.6, y=78.8, map="Fargodeep Mine" },
                    note="Kill Goldtooth and get Bernice's Necklace in Fargodeep Mine (41.6, 78.8)"
                },

                {
                    type="COMPLETE",
                    title="The Fargodeep Mine",
                    questId=62,
                    coords={ x=40.6, y=81.92, map="Fargodeep Mine at" },
                    note="Travel inside The in Fargodeep Mine at to have it investigated (40.60, 81.92)"
                },

                {
                    type="COMPLETE",
                    title="Gold Dust Exchange",
                    questId=47,
                    coords={ x=39.0, y=80.0 },
                    note="Kill the Kobolds surrounding the Fargodeep Mineto collect 10 Gold Dust (39, 80)"
                },

                {
                    type="COMPLETE",
                    title="Kobold Candles",
                    questId=60,
                    coords={ x=39.0, y=80.0 },
                    note="Kill the Kobolds surrounding the in Fargodeep Mine to collect 8 Large Candle (39, 80)"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    questId=112,
                    coords={ x=43.43, y=66.05 },
                    note="Travel or Hearthstone to Goldshire (43.43, 66.05)"
                },

                {
                    type="TURNIN",
                    title="Gold Dust Exchange",
                    questId=47,
                    coords={ x=42.19, y=67.05, map="Goldshire" },
                    note="Remy \\Two Times\\ in Goldshire (42.19, 67.05)"
                },

                {
                    type="ACCEPT",
                    title="A Fishy Peril",
                    questId=40,
                    coords={ x=42.19, y=67.05, map="Goldshire" },
                    note="Remy \\Two Times\\ in Goldshire (42.19, 67.05)"
                },

                {
                    type="TURNIN",
                    title="A Fishy Peril",
                    questId=40,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    note=" Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="Further Concerns",
                    questId=35,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="TURNIN",
                    title="The Fargodeep Mine",
                    questId=62,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="The Jasperlode Mine",
                    questId=76,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="TURNIN",
                    title="Kobold Candles",
                    questId=60,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="ACCEPT",
                    title="Shipment to Stormwind",
                    questId=61,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="TURNIN",
                    title="Note to William",
                    questId=107,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="ACCEPT",
                    title="Collecting Kelp",
                    questId=112,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="NOTE",
                    title="Train First Aid",
                    note="Speak to Michelle Belle and train First Aid. Tick this step (43.43, 65.55)"
                },

                {
                    type="TRAVEL",
                    title="Crystal Lake",
                    questId=112,
                    coords={ x=54.0, y=66.0 },
                    note="Travel to Crystal Lake (54, 66)"
                },

                {
                    type="COMPLETE",
                    title="Collecting Kelp",
                    questId=112,
                    coords={ x=54.0, y=66.0 },
                    objectives = {
                        { kind="loot", label="Crystal Kelp Frond", target=4 }
                    },
                    note="Kill Murloc and Murloc Streamrunner and collect 4 Crystal Kelp Frond around the Crystal Lake (54, 66)"
                },

                {
                    type="TRAVEL",
                    title="Jasperlode Mine",
                    questId=76,
                    coords={ x=61.7, y=53.76 },
                    note="Travel to Jasperlode Mine (61.70, 53.76)"
                },

                {
                    type="COMPLETE",
                    title="The Jasperlode Mine",
                    questId=76,
                    coords={ x=60.45, y=50.35 },
                    note="Scout through the Jasperlode Mine (60.45, 50.35)"
                },

                {
                    type="TURNIN",
                    title="Further Concerns",
                    questId=35,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="ACCEPT",
                    title="Find the Lost Guards",
                    questId=37,
                    coords={ x=61.79, y=54.04, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (61.79, 54.04) (73.89, 72.18)"
                },

                {
                    type="ACCEPT",
                    title="Protect the Frontier",
                    questId=52,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="TRAVEL",
                    title="Eastvale Logging Camp",
                    questId=83,
                    coords={ x=79.47, y=68.75 },
                    note="Travel to Eastvale Logging Camp (79.47, 68.75)"
                },

                {
                    type="ACCEPT",
                    title="Red Linen Goods",
                    questId=83,
                    coords={ x=79.47, y=68.75, map="Eastvale Logging Camp" },
                    npc = { name="Sara Timberlain" },
                    note="Sara Timberlain in Eastvale Logging Camp (79.47, 68.75)"
                },

                {
                    type="ACCEPT",
                    title="A Bundle of Trouble",
                    questId=5545,
                    coords={ x=81.45, y=66.19, map="Eastvale Logging Camp" },
                    npc = { name="Supervisor Raelen" },
                    note="Supervisor Raelen in Eastvale Logging Camp (81.45, 66.19)"
                },

                {
                    type="NOTE",
                    title="As you go...",
                    asYouGo = true,
                    note="Collect 8 Bundle of Wood near the base of the trees and kill 8 Prowler and 5 Young Forest Bear"
                },

                {
                    type="TURNIN",
                    title="Find the Lost Guards",
                    questId=37,
                    coords={ x=72.7, y=60.5, map="Stone Cairn Lake" },
                    npc = { name="A Half-eaten Body" },
                    note="A Half-eaten Body in Stone Cairn Lake (72.7, 60.5)"
                },

                {
                    type="ACCEPT",
                    title="Discover Rolf's Fate",
                    questId=45,
                    coords={ x=72.7, y=60.5, map="Stone Cairn Lake" },
                    npc = { name="A Half-eaten Body" },
                    note="A Half-eaten Body in Stone Cairn Lake (72.7, 60.5)"
                },

                {
                    type="TURNIN",
                    title="Discover Rolf's Fate",
                    questId=45,
                    coords={ x=79.8, y=55.6, map="Stone Cairn Lake" },
                    npc = { name="Rolf's corpse" },
                    note="Rolf's corpse in Stone Cairn Lake (79.8, 55.6)"
                },

                {
                    type="ACCEPT",
                    title="Report to Thomas",
                    questId=71,
                    coords={ x=79.8, y=55.6, map="Stone Cairn Lake" },
                    npc = { name="Rolf's corpse" },
                    note="Rolf's corpse in Stone Cairn Lake (79.8, 55.6)"
                },

                {
                    type="COMPLETE",
                    title="A Bundle of Trouble",
                    questId=5545,
                    coords={ x=80.25, y=60.11, map="Stone Cairn Lake" },
                    objectives = {
                        { kind="loot", label="Bundle of Wood", target=8 }
                    },
                    note="Collect 8 Bundle of Wood near the base of the trees in Stone Cairn Lake (80.25, 60.11)"
                },

                {
                    type="COMPLETE",
                    title="Protect the Frontier",
                    questId=52,
                    coords={ x=81.0, y=62.0 },
                    objectives = {
                        { kind="kill", label="Prowler", target=8 },
                        { kind="kill", label="Young Forest Bear which can both be found to the east", target=5 }
                    },
                    note="Kill 8 Prowler and 5 Young Forest Bear which can both be found to the east around Eastvale Logging Camp as well as in the southern area across the bridge (81, 62) (83, 78)"
                },

                {
                    type="TRAVEL",
                    title="Eastvale Logging Camp",
                    questId=39,
                    coords={ x=81.45, y=66.19 },
                    note="Travel to Eastvale Logging Camp (81.45, 66.19)"
                },

                {
                    type="TURNIN",
                    title="A Bundle of Trouble",
                    questId=5545,
                    coords={ x=81.45, y=66.19, map="Eastvale Logging Camp" },
                    npc = { name="Supervisor Raelen" },
                    note="Supervisor Raelen in Eastvale Logging Camp (81.45, 66.19)"
                },

                {
                    type="COMPLETE",
                    title="Red Linen Goods",
                    questId=83,
                    coords={ x=90.09, y=80.19 },
                    note="Kill the Defias Bandit in the area to collect 6 Red Linen Bandana (90.09, 80.19) (69.99, 80.31)"
                },

                {
                    type="COMPLETE",
                    title="Kill Defias Bandit",
                    questId=184,
                    coords={ x=69.99, y=80.31 },
                    objectives = {
                        { kind="kill", label="Defias Bandit", target=1 }
                    },
                    note="Keep killing Defias Bandit until you find Westfall Deed to begin a quest (69.99, 80.31)"
                },

                {
                    type="ACCEPT",
                    title="Furlbrow's Deed",
                    questId=184,
                    optional = true,
                    note="Use Westfall Deed to accept quest"
                },

                {
                    type="TRAVEL",
                    title="Stone Cairn Lake",
                    questId=46,
                    coords={ x=79.68, y=55.48 },
                    note="Travel to Stone Cairn Lake (79.68, 55.48)"
                },

                {
                    type="TURNIN",
                    title="Report to Thomas",
                    questId=71,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="ACCEPT",
                    title="Deliver Thomas' Report",
                    questId=39,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="TURNIN",
                    title="Protect the Frontier",
                    questId=52,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="ACCEPT",
                    title="Report to Gryan Stoutmantle",
                    questId=109,
                    coords={ x=73.96, y=72.16, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.96, 72.16)"
                },

                {
                    type="TRAVEL",
                    title="Eastvale Logging Camp",
                    coords={ x=79.47, y=68.75 },
                    note="Travel to Eastvale Logging Camp (79.47, 68.75)"
                },

                {
                    type="TURNIN",
                    title="Red Linen Goods",
                    questId=83,
                    coords={ x=79.47, y=68.75, map="Eastvale Logging Camp" },
                    npc = { name="Sara Timberlain" },
                    note="Sara Timberlain in Eastvale Logging Camp (79.47, 68.75)"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    questId=1860,
                    coords={ x=43.28, y=66.22 },
                    note="Travel or Hearthstone to Goldshire (43.28, 66.22)"
                },

                {
                    type="TURNIN",
                    title="Collecting Kelp",
                    questId=112,
                    coords={ x=43.28, y=66.22, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.28, 66.22)"
                },

                {
                    type="ACCEPT",
                    title="The Escape",
                    questId=114,
                    coords={ x=43.43, y=66.05, map="Goldshire" },
                    npc = { name="William Pestle" },
                    note="William Pestle in Goldshire (43.43, 66.05)"
                },

                {
                    type="TURNIN",
                    title="Deliver Thomas' Report",
                    questId=39,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="Cloth and Leather Armor",
                    questId=59,
                    coords={ x=42.11, y=65.97, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.11, 65.97)"
                },

                {
                    type="TURNIN",
                    title="The Jasperlode Mine",
                    questId=76,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="Westbrook Garrison Needs Help!",
                    questId=239,
                    coords={ x=42.14, y=65.9, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.14, 65.90)"
                },

                {
                    type="ACCEPT",
                    title="Elmore's Task",
                    questId=1097,
                    coords={ x=42.01, y=65.6, map="Goldshire" },
                    npc = { name="Smith Argus" },
                    note="Smith Argus in Goldshire (42.01, 65.60)"
                },

                {
                    type="TRAVEL",
                    title="The Maclure Vineyards",
                    coords={ x=43.12, y=89.55 },
                    note="Travel to The Maclure Vineyards (43.12, 89.55)"
                },

                {
                    type="TURNIN",
                    title="The Escape",
                    questId=114,
                    coords={ x=43.12, y=89.55 },
                    npc = { name="Maybell Maclure" },
                    note="Maybell Maclure in The Maclure Vineyards (43.12, 89.55)"
                },

                {
                    type="TURNIN",
                    title="Goldtooth",
                    questId=87,
                    coords={ x=34.5, y=84.3 },
                    note="\\Auntie\\ Bernice Stonefield in The Stonefield Farm (34.5, 84.3)"
                },

                {
                    type="NOTE",
                    title="Level 10 Required",
                    note="You need to be at least level 10 to continue, keep grinding nearby mobs until you reach level 10"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    questId=1860,
                    coords={ x=43.28, y=66.22 },
                    note="Travel or Hearthstone to Goldshire (43.28, 66.22)"
                },

                {
                    type="ACCEPT",
                    title="Speak with Jennea",
                    questId=1860,
                    coords={ x=43.28, y=66.22, map="Goldshire" },
                    npc = { name="Zaldimar Wefhellt" },
                    class="Mage",
                    note="Zaldimar Wefhellt in Goldshire (43.28, 66.22)"
                },

                {
                    type="ACCEPT",
                    title="A Warrior's Training",
                    questId=1638,
                    coords={ x=41.1, y=65.8, map="Goldshire" },
                    npc = { name="Lyria Du Lac" },
                    class="Warrior",
                    note="Lyria Du Lac in Goldshire (41.1, 65.8)"
                },

                {
                    type="ACCEPT",
                    title="Seek out SI: 7",
                    questId=2205,
                    coords={ x=43.8, y=65.9, map="Goldshire" },
                    npc = { name="Keryn Sylvius" },
                    class="Rogue",
                    note="Keryn Sylvius in Goldshire (43.8, 65.9)"
                },

                {
                    type="ACCEPT",
                    title="Gakin's Summons",
                    questId=1685,
                    coords={ x=44.5, y=66.1, map="Goldshire" },
                    npc = { name="Remen Marcot" },
                    class="Warlock",
                    note="Remen Marcot in Goldshire (44.5, 66.1)"
                },

                {
                    type="TRAVEL",
                    title="Westbrook Garrison",
                    coords={ x=24.26, y=74.54 },
                    note="Travel to Westbrook Garrison (24.26, 74.54)"
                },

                {
                    type="TURNIN",
                    title="Westbrook Garrison Needs Help!",
                    questId=239,
                    coords={ x=24.26, y=74.54, map="Westbrook Garrison" },
                    npc = { name="Deputy Rainer" },
                    note="Deputy Rainer in Westbrook Garrison (24.26, 74.54)"
                },

                {
                    type="ACCEPT",
                    title="Riverpaw Gnoll Bounty",
                    questId=11,
                    coords={ x=24.26, y=74.54, map="Westbrook Garrison" },
                    npc = { name="Deputy Rainer" },
                    note="Deputy Rainer in Westbrook Garrison (24.26, 74.54)"
                },

                {
                    type="ACCEPT",
                    title="Wanted: \"Hogger\"",
                    questId=176,
                    coords={ x=24.47, y=74.74, map="Westbrook Garrison" },
                    npc = { name="Wanted Poster" },
                    note="Wanted Poster in Westbrook Garrison (24.47, 74.74)"
                },

                {
                    type="TRAVEL",
                    title="The Jansen Stead",
                    questId=109,
                    coords={ x=60.0, y=19.37, map="Westfall" },
                    note="Travel to The Jansen Stead (60.00, 19.37)"
                },

                {
                    type="TURNIN",
                    title="Furlbrow's Deed",
                    questId=184,
                    coords={ x=60.0, y=19.37, map="Westfall" },
                    npc = { name="Farmer Furlbrow" },
                    optional = true,
                    note="Farmer Furlbrow in The Jansen Stead (60.00, 19.37)"
                },

                {
                    type="ACCEPT",
                    title="The Forgotten Heirloom",
                    questId=64,
                    coords={ x=60.0, y=19.37, map="Westfall" },
                    npc = { name="Farmer Furlbrow" },
                    note="Farmer Furlbrow in The Jansen Stead (60.00, 19.37)"
                },

                {
                    type="ACCEPT",
                    title="Westfall Stew",
                    questId=36,
                    coords={ x=59.92, y=19.45, map="Westfall" },
                    npc = { name="Verna Furlbrow" },
                    note="Verna Furlbrow in The Jansen Stead (59.92, 19.45)"
                },

                {
                    type="ACCEPT",
                    title="Poor Old Blanchy",
                    questId=151,
                    coords={ x=59.92, y=19.45, map="Westfall" },
                    npc = { name="Verna Furlbrow" },
                    note="Verna Furlbrow in The Jansen Stead (59.92, 19.45)"
                },

                {
                    type="TURNIN",
                    title="Westfall Stew",
                    questId=36,
                    coords={ x=56.4, y=30.55, map="Westfall" },
                    npc = { name="Salma Saldean" },
                    note="Salma Saldean in Saldean's Farm (56.40, 30.55)"
                },

                {
                    type="ACCEPT",
                    title="Westfall Stew",
                    questId=38,
                    coords={ x=56.4, y=30.51, map="Westfall" },
                    npc = { name="Salma Saldean" },
                    note="Salma Saldean in Saldean's Farm (56.40, 30.51)"
                },

                {
                    type="ACCEPT",
                    title="Goretusk Liver Pie",
                    questId=22,
                    coords={ x=56.23, y=30.89, map="Westfall" },
                    npc = { name="Salma Saldean" },
                    note="Salma Saldean in Saldean's Farm (56.23, 30.89)"
                },

                {
                    type="ACCEPT",
                    title="The Killing Fields",
                    questId=9,
                    coords={ x=56.09, y=31.55, map="Westfall" },
                    npc = { name="Farmer Saldean" },
                    note="Farmer Saldean in Saldean's Farm (56.09, 31.55)"
                },

                {
                    type="COMPLETE",
                    title="Poor Old Blanchy",
                    questId=151,
                    note="Start collecting Handful of Oats from Sack of Oats on the ground in Saldean's Farm. Try to get 3-4 Handful of Oats and tick this step to complete later (56.9, 19,3)"
                },

                {
                    type="TRAVEL",
                    title="Sentinel Hill",
                    questId=6181,
                    coords={ x=56.3, y=47.6, map="Westfall" },
                    note="Travel to Sentinel Hill (56.3, 47.6)"
                },

                {
                    type="TURNIN",
                    title="Report to Gryan Stoutmantle",
                    questId=109,
                    coords={ x=56.3, y=47.6, map="Westfall" },
                    npc = { name="Gryan Stoutmantle" },
                    optional = true,
                    note="Gryan Stoutmantle in Sentinel Hill (56.3, 47.6)"
                },

                {
                    type="ACCEPT",
                    title="A Swift Message",
                    questId=6181,
                    coords={ x=56.9, y=47.2, map="Westfall" },
                    npc = { name="Quartermaster Lewis" },
                    race="Human",
                    note="Quartermaster Lewis in Sentinel Hill (56.9, 47.2)"
                },

                {
                    type="TURNIN",
                    title="A Swift Message",
                    questId=6181,
                    coords={ x=56.54, y=52.64, map="Westfall" },
                    npc = { name="Thor" },
                    race="Human",
                    note="Thor in Sentinel Hill (56.54, 52.64)"
                },

                {
                    type="ACCEPT",
                    title="Continue to Stormwind",
                    questId=6281,
                    coords={ x=56.54, y=52.64, map="Westfall" },
                    npc = { name="Thor" },
                    race="Human",
                    note="Thor in Sentinel Hill (56.54, 52.64)"
                },

                {
                    type="FLIGHTPATH",
                    title="Sentinel Hill",
                    coords={ x=56.54, y=52.64, map="Westfall" },
                    npc = { name="Speak" },
                    note="Speak to Thor and grab flight path for Sentinel Hill (56.54, 52.64)"
                },

                {
                    type="TRAVEL",
                    title="Stormwind City",
                    questId=6261,
                    coords={ x=56.23, y=64.59, map="Stormwind City" },
                    note="Travel to Stormwind City (56.23, 64.59)"
                },

                {
                    type="TURNIN",
                    title="Shipment to Stormwind",
                    questId=61,
                    coords={ x=56.23, y=64.59, map="Stormwind City" },
                    npc = { name="Morgan Pestle" },
                    race="Human",
                    note="Morgan Pestle in Trade District (56.23, 64.59)"
                },

                {
                    type="TURNIN",
                    title="Continue to Stormwind",
                    questId=6281,
                    coords={ x=74.21, y=47.53, map="Stormwind City" },
                    npc = { name="Osric Strang" },
                    race="Human",
                    note="Osric Strang in Old Town (74.21, 47.53)"
                },

                {
                    type="ACCEPT",
                    title="Dungar Longdrink",
                    questId=6261,
                    coords={ x=74.21, y=47.53, map="Stormwind City" },
                    npc = { name="Osric Strang" },
                    race="Human",
                    note="Osric Strang in Old Town (74.21, 47.53)"
                },

                {
                    type="TURNIN",
                    title="Dungar Longdrink",
                    questId=6261,
                    coords={ x=66.31, y=62.19, map="Stormwind City" },
                    npc = { name="Dungar Longdrink" },
                    race="Human",
                    note="Dungar Longdrink in Trade District (66.31, 62.19)"
                },

                {
                    type="ACCEPT",
                    title="Return to Lewis",
                    questId=6285,
                    coords={ x=66.31, y=62.19, map="Stormwind City" },
                    npc = { name="Dungar Longdrink" },
                    race="Human",
                    note="Dungar Longdrink in Trade District (66.31, 62.19)"
                },

                {
                    type="TURNIN",
                    title="Gakin's Summons",
                    questId=1685,
                    coords={ x=29.29, y=73.99, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    class="Warlock",
                    note="Gakin the Darkbinder in The Slaughtered Lamb (29.29, 73.99) (25.32, 78.47)"
                },

                {
                    type="ACCEPT",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=25.32, y=78.47, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    class="Warlock",
                    note="Gakin the Darkbinder in The Slaughtered Lamb (25.32, 78.47)"
                },

                {
                    type="TRAVEL",
                    title="Brackwell Pumpkin Patch",
                    questId=1688,
                    coords={ x=71.02, y=80.76 },
                    note="Travel to Brackwell Pumpkin Patch (71.02, 80.76)"
                },

                {
                    type="COMPLETE",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=71.02, y=80.76 },
                    class="Warlock",
                    note="Kill Surena Caledon and collect Surena's Choker in Brackwell Pumpkin Patch. She is guarded by 2 other enemies, you will need to pull them away (71.02, 80.76)"
                },

                {
                    type="TURNIN",
                    title="Seek out SI: 7",
                    questId=2205,
                    coords={ x=75.88, y=59.83, map="Stormwind City" },
                    npc = { name="Master Mathias Shaw" },
                    class="Rogue",
                    note="Master Mathias Shaw in SI:7 (75.88, 59.83)"
                },

                {
                    type="ACCEPT",
                    title="Snatch and Grab",
                    questId=2206,
                    coords={ x=76.47, y=60.13, map="Stormwind City" },
                    npc = { name="Master Mathias Shaw" },
                    class="Rogue",
                    note="Master Mathias Shaw in SI:7 (76.47, 60.13)"
                },

                {
                    type="TURNIN",
                    title="A Warrior's Training",
                    questId=1638,
                    coords={ x=74.24, y=37.26, map="Stormwind City" },
                    npc = { name="Harry Burlguard" },
                    class="Warrior",
                    note="Harry Burlguard in Old Town (74.24, 37.26)"
                },

                {
                    type="ACCEPT",
                    title="Bartleby the Drunk",
                    questId=1639,
                    coords={ x=74.24, y=37.26, map="Stormwind City" },
                    npc = { name="Harry Burlguard" },
                    class="Warrior",
                    note="Harry Burlguard in Old Town (74.24, 37.26)"
                },

                {
                    type="TURNIN",
                    title="Bartleby the Drunk",
                    questId=1639,
                    coords={ x=73.79, y=36.31, map="Stormwind City" },
                    class="Warrior",
                    note="in Old Town (73.79, 36.31)"
                },

                {
                    type="ACCEPT",
                    title="Beat Bartleby",
                    questId=1640,
                    coords={ x=73.79, y=36.31, map="Stormwind City" },
                    npc = { name="Bartleby" },
                    class="Warrior",
                    note="Bartleby in Old Town (73.79, 36.31)"
                },

                {
                    type="COMPLETE",
                    title="Beat Bartleby",
                    questId=1640,
                    coords={ x=73.79, y=36.31, map="Stormwind City" },
                    class="Warrior",
                    note="Beat Bartleby, then talk to him in Old Town (73.79, 36.31)"
                },

                {
                    type="TURNIN",
                    title="Beat Bartleby",
                    questId=1640,
                    coords={ x=73.79, y=36.31, map="Stormwind City" },
                    npc = { name="Bartleby" },
                    class="Warrior",
                    note="Bartleby in Old Town (73.79, 36.31)"
                },

                {
                    type="ACCEPT",
                    title="Bartleby's Mug",
                    questId=1665,
                    coords={ x=73.79, y=36.31, map="Stormwind City" },
                    npc = { name="Bartleby" },
                    class="Warrior",
                    note="Bartleby in Old Town (73.79, 36.31)"
                },

                {
                    type="TURNIN",
                    title="Bartleby's Mug",
                    questId=1665,
                    coords={ x=74.15, y=37.25, map="Stormwind City" },
                    npc = { name="Harry Burlguard" },
                    class="Warrior",
                    note="Harry Burlguard in Old Town (74.15, 37.25)"
                },

                {
                    type="ACCEPT",
                    title="Marshal Haggard",
                    questId=1666,
                    coords={ x=74.06, y=37.4, map="Stormwind City" },
                    npc = { name="Harry Burlguard" },
                    class="Warrior",
                    note="Harry Burlguard in Old Town (74.06, 37.40)"
                },

                {
                    type="TRAVEL",
                    title="Jerod's Landing",
                    questId=2206,
                    coords={ x=48.08, y=87.3 },
                    note="Travel to Jerod's Landing (48.08, 87.30)"
                },

                {
                    type="COMPLETE",
                    title="Snatch and Grab",
                    questId=2206,
                    coords={ x=48.08, y=87.3, map="Jerod's Landing" },
                    class="Rogue",
                    note="Find the Defias Dockmaster use (spell:921) to get Defias Shipping Schedule in Jerod's Landing (48.08, 87.30)"
                },

                {
                    type="TURNIN",
                    title="Snatch and Grab",
                    questId=2206,
                    coords={ x=75.81, y=59.84, map="Stormwind City" },
                    npc = { name="Master Mathias Shaw" },
                    class="Rogue",
                    note="Master Mathias Shaw in SI:7 (75.81, 59.84)"
                },

                {
                    type="TRAVEL",
                    title="The Slaughtered Lamb",
                    questId=1689,
                    coords={ x=25.25, y=78.54, map="Stormwind City" },
                    note="Travel to The Slaughtered Lamb (25.25, 78.54)"
                },

                {
                    type="TURNIN",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=25.25, y=78.54, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    class="Warlock",
                    note="Gakin the Darkbinder in The Slaughtered Lamb (25.25, 78.54)"
                },

                {
                    type="ACCEPT",
                    title="The Binding",
                    questId=1689,
                    coords={ x=25.25, y=78.54, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    class="Warlock",
                    note="Gakin the Darkbinder in The Slaughtered Lamb (25.25, 78.54)"
                },

                {
                    type="COMPLETE",
                    title="The Binding",
                    questId=1689,
                    coords={ x=25.06, y=79.28, map="Stormwind City" },
                    class="Warlock",
                    note="Keep going down the stair until you find the purple summoning circle and use Bloodstone Choker to summon and kill a Summoned Voidwalker in The Slaughtered Lamb (25.06, 79.28) (25.19, 77.33)"
                },

                {
                    type="TURNIN",
                    title="The Binding",
                    questId=1689,
                    coords={ x=25.3, y=78.6, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    class="Warlock",
                    note="Gakin the Darkbinder in The Slaughtered Lamb (25.30, 78.60)"
                },

                {
                    type="TRAVEL",
                    title="Sentinel Hill",
                    questId=353,
                    coords={ x=56.9, y=47.2, map="Westfall" },
                    note="Dungar Longdrink in Trade District (56.9, 47.2)"
                },

                {
                    type="TURNIN",
                    title="Return to Lewis",
                    questId=6285,
                    coords={ x=56.9, y=47.2, map="Westfall" },
                    npc = { name="Quartermaster Lewis" },
                    race="Human",
                    note="Quartermaster Lewis (56.9, 47.2)"
                },

                {
                    type="TRAVEL",
                    title="Forest's Edge",
                    questId=11,
                    coords={ x=63.96, y=26.68 },
                    note="Travel to Forest's Edge (63.96, 26.68) (25, 86)"
                },

                {
                    type="COMPLETE",
                    title="Riverpaw Gnoll Bounty",
                    questId=11,
                    coords={ x=25.0, y=86.0 },
                    objectives = {
                        { kind="loot", label="Painted Gnoll Armband", target=8 }
                    },
                    note="Collect 8 Painted Gnoll Armband from the Riverpaw Outrunner and Riverpaw Runt which can be found to the South (25, 86)"
                },

                {
                    type="COMPLETE",
                    title="Wanted: \"Hogger\"",
                    questId=176,
                    coords={ x=26.14, y=94.34 },
                    note="Kill Hogger and collect Huge Gnoll Claw in Forest's Edge. This is a group quest and safe to skip (26.14, 94.34)"
                },

                {
                    type="NOTE",
                    title="Gold Pickup Schedule",
                    note="Kill Gnolls until you find Gold Pickup Schedule to begin a new quest, you can skip this if you can't find it (25, 86)"
                },

                {
                    type="ACCEPT",
                    title="The Collector",
                    questId=123,
                    optional = true,
                    note="Use Gold Pickup Schedule to accept quest"
                },

                {
                    type="TRAVEL",
                    title="Westbrook Garrison",
                    coords={ x=24.26, y=74.54 },
                    note="Travel to Westbrook Garrison (24.26, 74.54)"
                },

                {
                    type="TURNIN",
                    title="Riverpaw Gnoll Bounty",
                    questId=11,
                    coords={ x=24.26, y=74.54, map="Westbrook Garrison" },
                    npc = { name="Deputy Rainer" },
                    note="Deputy Rainer in Westbrook Garrison (24.26, 74.54)"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    coords={ x=42.12, y=65.96 },
                    note="Travel to Goldshire (42.12, 65.96)"
                },

                {
                    type="TURNIN",
                    title="The Collector",
                    questId=123,
                    coords={ x=42.12, y=65.96, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    optional = true,
                    note="Marshal Dughan in Goldshire (42.12, 65.96)"
                },

                {
                    type="TURNIN",
                    title="Wanted: \"Hogger\"",
                    questId=176,
                    coords={ x=42.12, y=65.96, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.12, 65.96)"
                },

                {
                    type="ACCEPT",
                    title="Manhunt",
                    questId=147,
                    coords={ x=42.12, y=65.96, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.12, 65.96)"
                },

                {
                    type="TRAVEL",
                    title="Brackwell Pumpkin Patch",
                    questId=147,
                    coords={ x=71.01, y=80.55 },
                    note="Travel to Brackwell Pumpkin Patch (71.01, 80.55)"
                },

                {
                    type="COMPLETE",
                    title="Manhunt",
                    questId=147,
                    coords={ x=71.01, y=80.55 },
                    note="Kill Morgan the Collector in Brackwell Pumpkin Patch, you will need to pull the enemies around her first otherwise it is difficult to solo (71.01, 80.55)"
                },

                {
                    type="COMPLETE",
                    title="Princess Must Die!",
                    questId=88,
                    coords={ x=69.0, y=78.0 },
                    note="Kill Princess who patrols the area and loot the Brass Collar. She is a level 9 mob who is surrounded by two guards which are level 7 so grouping with another is recommended, you can skip it if you're unable to complete (69, 78)"
                },

                {
                    type="ACCEPT",
                    title="Bounty on Murlocs",
                    questId=46,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="COMPLETE",
                    title="Bounty on Murlocs",
                    questId=46,
                    coords={ x=79.68, y=55.48, map="Stone Cairn Lake" },
                    objectives = {
                        { kind="loot", label="Torn Murloc Fin", target=8 }
                    },
                    note="Kill Murlocs and collect 8 Torn Murloc Fin in Stone Cairn Lake (79.68, 55.48)"
                },

                {
                    type="TURNIN",
                    title="Bounty on Murlocs",
                    questId=46,
                    coords={ x=73.89, y=72.18, map="Elwynn Forest" },
                    npc = { name="Guard Thomas" },
                    note="Guard Thomas in Elwynn Forest (73.89, 72.18)"
                },

                {
                    type="TRAVEL",
                    title="Eastvale Logging Camp",
                    coords={ x=79.5, y=68.69 },
                    note="Travel to Eastvale Logging Camp (79.50, 68.69)"
                },

                {
                    type="TURNIN",
                    title="Cloth and Leather Armor",
                    questId=59,
                    coords={ x=79.5, y=68.69, map="Eastvale Logging Camp" },
                    npc = { name="Sara Timberlain" },
                    note="Sara Timberlain, in Eastvale Logging Camp (79.50, 68.69)"
                },

                {
                    type="TURNIN",
                    title="Marshal Haggard",
                    questId=1666,
                    coords={ x=84.61, y=69.37, map="Eastvale Logging Camp" },
                    npc = { name="Marshal Haggard" },
                    class="Warrior",
                    note="Marshal Haggard in Eastvale Logging Camp (84.61, 69.37)"
                },

                {
                    type="ACCEPT",
                    title="Dead-tooth Jack",
                    questId=1667,
                    coords={ x=84.61, y=69.37, map="Eastvale Logging Camp" },
                    npc = { name="Marshal Haggard" },
                    class="Warrior",
                    note="Marshal Haggard in Eastvale Logging Camp (84.61, 69.37)"
                },

                {
                    type="COMPLETE",
                    title="Kill Dead-Tooth Jack",
                    questId=1667,
                    coords={ x=89.36, y=78.85, map="Ridgepoint Tower" },
                    class="Warrior",
                    objectives = {
                        { kind="kill", label="Dead-Tooth Jack", target=1 }
                    },
                    note="Kill Dead-Tooth Jack and collect Dead-tooth's Key in Ridgepoint Tower (89.36, 78.85)"
                },

                {
                    type="COMPLETE",
                    title="Dead-tooth Jack",
                    questId=1667,
                    coords={ x=89.36, y=78.85, map="Ridgepoint Tower" },
                    class="Warrior",
                    note="Collect Marshal Haggard's Badge from Dead-tooth Lockbox in Ridgepoint Tower (89.36, 78.85)"
                },

                {
                    type="TURNIN",
                    title="Dead-tooth Jack",
                    questId=1667,
                    coords={ x=84.58, y=69.39, map="Eastvale Logging Camp" },
                    npc = { name="Marshal Haggard" },
                    class="Warrior",
                    note="Marshal Haggard in Eastvale Logging Camp (84.58, 69.39)"
                },

                {
                    type="TRAVEL",
                    title="Goldshire",
                    coords={ x=42.12, y=65.96 },
                    note="Travel to Goldshire (42.12, 65.96)"
                },

                {
                    type="TURNIN",
                    title="Manhunt",
                    questId=147,
                    coords={ x=42.12, y=65.96, map="Goldshire" },
                    npc = { name="Marshal Dughan" },
                    note="Marshal Dughan in Goldshire (42.12, 65.96)"
                },

                {
                    type="TRAVEL",
                    title="The Stonefield Farm",
                    coords={ x=34.61, y=84.43 },
                    note="Travel to The Stonefield Farm (34.61, 84.43)"
                },

                {
                    type="TURNIN",
                    title="Princess Must Die!",
                    questId=88,
                    coords={ x=34.61, y=84.43 },
                    npc = { name="Ma Stonefield" },
                    note="Ma Stonefield in The Stonefield Farm (34.61, 84.43)"
                },

                {
                    type="TRAVEL",
                    title="Three Corners",
                    questId=244,
                    coords={ x=15.36, y=71.44, map="Redridge Mountains" },
                    note="Travel to Three Corners in (map:1433) (15.36, 71.44)"
                },

                {
                    type="ACCEPT",
                    title="Encroaching Gnolls",
                    questId=244,
                    coords={ x=15.36, y=71.44, map="Redridge Mountains" },
                    npc = { name="Guard Parker" },
                    note="Guard Parker in Three Corners (15.36, 71.44)"
                },

                {
                    type="TURNIN",
                    title="Encroaching Gnolls",
                    questId=244,
                    coords={ x=30.74, y=60.06, map="Redridge Mountains" },
                    npc = { name="Deputy Feldon" },
                    note="Deputy Feldon in Lakeshire (30.74, 60.06)"
                },

                {
                    type="FLIGHTPATH",
                    title="Lakeshire",
                    coords={ x=30.59, y=59.47, map="Redridge Mountains" },
                    npc = { name="Speak" },
                    itemId=1097,
                    note="Speak to Ariena Stormfeather to and grab flight path for Lakeshire (30.59, 59.47)"
                },

                {
                    type="TRAVEL",
                    title="Dwarven District",
                    coords={ x=51.75, y=12.03, map="Stormwind City" },
                    note="Travel to Dwarven District in Stormwind City (51.75, 12.03)"
                },

                {
                    type="TURNIN",
                    title="Elmore's Task",
                    questId=1097,
                    coords={ x=51.75, y=12.03, map="Stormwind City" },
                    npc = { name="Grimand Elmore" },
                    note="Grimand Elmore in Dwarven District (51.75, 12.03)"
                },

                {
                    type="ACCEPT",
                    title="Stormpike's Delivery",
                    questId=353,
                    coords={ x=51.75, y=12.03, map="Stormwind City" },
                    npc = { name="Grimand Elmore" },
                    note="Grimand Elmore in Dwarven District (51.75, 12.03)"
                },

                {
                    type="TRAVEL",
                    title="Deeprun Tram",
                    questId=6661,
                    coords={ x=70.3, y=29.5, map="Stormwind City" },
                    note="In the Dwarven District (70.3, 29.5)"
                },

                {
                    type="ACCEPT",
                    title="Deeprun Rat Roundup",
                    questId=6661,
                    npc = { name="Monty" },
                    note="Monty in Deeprun Tram, Ironforge Side. Take the tram to get to the Ironforge side"
                },

                {
                    type="COMPLETE",
                    title="Deeprun Rat Roundup",
                    questId=6661,
                    objectives = {
                        { kind="use_item", label="Item 17117", target=1, itemId=17117 }
                    },
                    note="Capture 5 Deeprun Rat by using the Rat Catcher's Flute. Lead the rats back to Monty. Don't forget to turn in the flute when you're finished"
                },

                {
                    type="TURNIN",
                    title="Deeprun Rat Roundup",
                    questId=6661,
                    npc = { name="Monty" },
                    note="Monty in Deeprun Tram, Ironforge Side"
                },

                {
                    type="TRAVEL",
                    title="City of Ironforge",
                    questId=433,
                    note="Go through the portal to exit to City of Ironforge"
                },

                {
                    type="FLIGHTPATH",
                    title="City of Ironforge",
                    coords={ x=55.55, y=47.76, map="Ironforge" },
                    npc = { name="Speak" },
                    note="Speak to Gryth Thurden and grab flight path for City of Ironforge (55.55, 47.76)"
                },

                {
                    type="TRAVEL",
                    title="Dun Morogh",
                    questId=433,
                    coords={ x=14.0, y=86.0, map="Dun Morogh" },
                    note="Run to Dun Morogh (14, 86)"
                },

                {
                    type="TRAVEL",
                    title="Gol'Bolar Quarry",
                    questId=433,
                    coords={ x=56.54, y=47.72, map="Dun Morogh" },
                    note="Travel to Gol'Bolar Quarry (56.54, 47.72) (63.39, 54.87) (68.65, 55.95)"
                },

                {
                    type="ACCEPT",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=68.7, y=56.02, map="Dun Morogh" },
                    npc = { name="Senator Mehr Stonehallow" },
                    note="Senator Mehr Stonehallow in Gol'Bolar Quarry (68.70, 56.02)"
                },

                {
                    type="ACCEPT",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=69.1, y=56.3, map="Dun Morogh" },
                    npc = { name="Foreman Stonebrow" },
                    note="Foreman Stonebrow at Gol'Bolar Quarry (69.1, 56.3)"
                },

                {
                    type="COMPLETE",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=70.58, y=56.69, map="Dun Morogh" },
                    objectives = {
                        { kind="kill", label="Rockjaw Bonesnapper", target=10 }
                    },
                    note="Kill 10 Rockjaw Bonesnapper around the Gol'Bolar Quarry (70.58, 56.69)"
                },

                {
                    type="COMPLETE",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=70.58, y=56.69, map="Dun Morogh" },
                    objectives = {
                        { kind="kill", label="Rockjaw Skullthumper", target=6 }
                    },
                    note="Kill 6 Rockjaw Skullthumper around the Gol'Bolar Quarry (70.58, 56.69)"
                },

                {
                    type="TURNIN",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=68.7, y=56.02, map="Dun Morogh" },
                    npc = { name="Senator Mehr Stonehallow" },
                    note="Senator Mehr Stonehallow in Gol'Bolar Quarry (68.70, 56.02)"
                },

                {
                    type="TURNIN",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=69.12, y=56.3, map="Dun Morogh" },
                    npc = { name="Foreman Stonebrow" },
                    note="Foreman Stonebrow in Gol'Bolar Quarry (69.12, 56.30)"
                },

                {
                    type="TRAVEL",
                    title="Loch Modan",
                    questId=224,
                    coords={ x=81.13, y=52.98, map="Dun Morogh" },
                    note="Travel to Loch Modan (81.13, 52.98) (82.26, 53.41) (84.42, 51.06) (86.22, 51.32)"
                },

                {
                    type="TRAVEL",
                    title="Loch Modan",
                    questId=224,
                    coords={ x=19.76, y=62.87, map="Loch Modan" },
                    note="Travel to Loch Modan (19.76, 62.87)"
                },

                {
                    type="ACCEPT",
                    title="In Defense of the King's Lands",
                    questId=224,
                    coords={ x=22.0, y=73.1, map="Loch Modan" },
                    npc = { name="Mountaineer Cobbleflint" },
                    note="Mountaineer Cobbleflint in Valley of Kings (22.00, 73.10)"
                },

                {
                    type="ACCEPT",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=23.21, y=73.59, map="Loch Modan" },
                    npc = { name="Captain Rugelfuss" },
                    note="Captain Rugelfuss in Valley of Kings (23.21, 73.59)"
                },

                {
                    type="TRAVEL",
                    title="Stonesplinter Valley",
                    questId=224,
                    coords={ x=28.46, y=66.0, map="Loch Modan" },
                    note="Travel to Stonesplinter Valley (28.46, 66.00) (30.92, 70.58)"
                },

                {
                    type="COMPLETE",
                    title="In Defense of the King's Lands",
                    questId=224,
                    coords={ x=31.0, y=70.5, map="Loch Modan" },
                    objectives = {
                        { kind="kill", label="Stonesplinter Trogg", target=10 },
                        { kind="kill", label="Stonesplinter Scout", target=10 }
                    },
                    note="Kill 10 Stonesplinter Trogg and 10 Stonesplinter Scout in Stonesplinter Valley (31, 70.5) (28, 53)"
                },

                {
                    type="COMPLETE",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=33.0, y=72.0, map="Loch Modan" },
                    objectives = {
                        { kind="loot", label="Trogg Stone Tooth", target=8 }
                    },
                    note="Kill Stonesplinter Scout and Stonesplinter Trogg to collect 8 Trogg Stone Tooth in Stonesplinter Valley (33, 72)"
                },

                {
                    type="TRAVEL",
                    title="Valley of Kings",
                    coords={ x=29.62, y=67.58, map="Loch Modan" },
                    note="Travel to Valley of Kings (29.62, 67.58) (23.21, 73.59)"
                },

                {
                    type="TURNIN",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=23.21, y=73.59, map="Loch Modan" },
                    npc = { name="Captain Rugelfuss" },
                    note="Captain Rugelfuss in Valley of Kings (23.21, 73.59)"
                },

                {
                    type="TURNIN",
                    title="In Defense of the King's Lands",
                    questId=224,
                    coords={ x=22.0, y=73.1, map="Loch Modan" },
                    npc = { name="Mountaineer Cobbleflint" },
                    note="Mountaineer Cobbleflint in Valley of Kings (22.00, 73.10)"
                },

                {
                    type="ACCEPT",
                    title="In Defense of the King's Lands",
                    questId=237,
                    coords={ x=23.52, y=76.37, map="Loch Modan" },
                    npc = { name="Mountaineer Gravelgaw" },
                    note="Mountaineer Gravelgaw in Valley of Kings (23.52, 76.37)"
                },

                {
                    type="TRAVEL",
                    title="Thelsamar",
                    questId=416,
                    coords={ x=25.27, y=67.41, map="Loch Modan" },
                    note="Travel to Thelsamar (25.27, 67.41) (28.17, 64.71) (33.90, 50.98)"
                },

                {
                    type="FLIGHTPATH",
                    title="Thelsamar",
                    coords={ x=33.9, y=50.9, map="Loch Modan" },
                    npc = { name="Speak Thorgrum Borrelson" },
                    note="Speak Thorgrum Borrelson and grab flight path for Thelsamar (33.9, 50.9)"
                },

                {
                    type="ACCEPT",
                    title="Rat Catching",
                    questId=416,
                    coords={ x=32.91, y=49.53, map="Loch Modan" },
                    npc = { name="Mountaineer Kadrell" },
                    note="Mountaineer Kadrell in Thelsamar, he patrols (32.91, 49.53)"
                },

                {
                    type="ACCEPT",
                    title="Mountaineer Stormpike's Task",
                    questId=1339,
                    coords={ x=32.91, y=49.53, map="Loch Modan" },
                    npc = { name="Mountaineer Kadrell" },
                    note="Mountaineer Kadrell in Thelsamar, he patrols (32.91, 49.53)"
                },

                {
                    type="ACCEPT",
                    title="Thelsamar Blood Sausages",
                    questId=418,
                    coords={ x=34.88, y=49.13, map="Loch Modan" },
                    note="in Stoutlager Inn (34.88, 49.13)"
                },

                {
                    type="SET_HEARTH",
                    title="Stoutlager Inn",
                    questId=416,
                    coords={ x=35.5, y=48.42 },
                    npc = { name="Innkeeper Hearthstove" },
                    note="Speak to Innkeeper Hearthstove and set hearth to Stoutlager Inn (35.50, 48.42)"
                },

                {
                    type="NOTE",
                    title="As you go...",
                    asYouGo = true,
                    note="Kill any Bears, Spiders and Wolves for 3 Boar Intestines, 3 Bear Meat and 3 Spider Ichor"
                },

                {
                    type="COMPLETE",
                    title="Rat Catching",
                    questId=416,
                    coords={ x=29.0, y=43.0, map="Loch Modan" },
                    objectives = {
                        { kind="loot", label="Tunnel Rat Ear", target=12 }
                    },
                    note="Kill any of the Tunnel Rat enemies collect 12 Tunnel Rat Ear in Silver Stream Mine (29, 43)"
                },

                {
                    type="TRAVEL",
                    title="Algaz Station",
                    questId=1338,
                    coords={ x=24.78, y=18.45, map="Loch Modan" },
                    note="Travel to Algaz Station (24.78, 18.45)"
                },

                {
                    type="TURNIN",
                    title="Stormpike's Delivery",
                    questId=353,
                    coords={ x=24.78, y=18.45, map="Loch Modan" },
                    npc = { name="Mountaineer Stormpike" },
                    note="Mountaineer Stormpike, in Algaz Station (24.78, 18.45)"
                },

                {
                    type="TURNIN",
                    title="Mountaineer Stormpike's Task",
                    questId=1339,
                    coords={ x=24.78, y=18.45, map="Loch Modan" },
                    npc = { name="Mountaineer Stormpike" },
                    note="Mountaineer Stormpike, in Algaz Station (24.78, 18.45)"
                },

                {
                    type="ACCEPT",
                    title="Stormpike's Order",
                    questId=1338,
                    coords={ x=24.78, y=18.45, map="Loch Modan" },
                    npc = { name="Mountaineer Stormpike" },
                    note="Mountaineer Stormpike, in Algaz Station (24.78, 18.45)"
                },

                {
                    type="COMPLETE",
                    title="Thelsamar Blood Sausages",
                    questId=418,
                    coords={ x=32.42, y=29.97, map="Loch Modan" },
                    note="Kill any Bears, Spiders and Boars for 3 Boar Intestines, 3 Bear Meat and 3 Spider Ichor (32.42, 29.97) (37.28, 36.91) (27.30, 28.24)"
                },

                {
                    type="TRAVEL",
                    title="Thelsamar",
                    coords={ x=32.91, y=49.53, map="Loch Modan" },
                    note="Travel to Thelsamar (32.91, 49.53)"
                },

                {
                    type="TURNIN",
                    title="Thelsamar Blood Sausages",
                    questId=418,
                    coords={ x=34.83, y=49.12, map="Loch Modan" },
                    npc = { name="Vidra Hearthstove" },
                    note="Vidra Hearthstove, in Stoutlager Inn (34.83, 49.12)"
                },

                {
                    type="ACCEPT",
                    title="Ironband's Excavation",
                    questId=436,
                    coords={ x=37.25, y=47.71, map="Loch Modan" },
                    npc = { name="Jern Hornhelm" },
                    note="Jern Hornhelm in Thelsamar (37.25, 47.71)"
                },

                {
                    type="NOTE",
                    title="Guide Complete",
                    note="Tick to continue to the next guide"
                }

            }},
        }}
    }},
}