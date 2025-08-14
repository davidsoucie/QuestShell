-- =========================
-- 01_12_Dun_Morogh.lua
-- Converted from TourGuide format on 2025-08-13 16:20:25
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["01_12_Dun_Morogh"] = {
    title    = "01_12_Dun_Morogh",
    minLevel = 1,
    maxLevel = 20,

    chapters = 
    {    
        {
            id       = "01_12_Dun_Morogh",
            title    = "01_12_Dun_Morogh",
            zone     = "Unknown",
            minLevel = 1,
            maxLevel = 20,

            steps = {

                {
                    type="ACCEPT",
                    title="Dwarven Outfitters",
                    questId=179,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="COMPLETE",
                    title="Dwarven Outfitters",
                    questId=179,
                    coords={ x=30.0, y=73.0 },
                    note="Collect 8 pieces of Tough Wolf Meat dropped by Ragged Timber Wolf and Ragged Young Wolf (30, 73)"
                },

                {
                    type="TURNIN",
                    title="Dwarven Outfitters",
                    questId=179,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Encrypted Rune",
                    questId=3109,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Dwarf",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Etched Rune",
                    questId=3108,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Dwarf",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Hallowed Rune",
                    questId=3110,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Dwarf",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Simple Rune",
                    questId=3106,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Dwarf",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Consecrated Rune",
                    questId=3107,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Dwarf",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Tainted Memorandum",
                    questId=3115,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Gnome",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Glyphic Memorandum",
                    questId=3114,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Gnome",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Encrypted Memorandum",
                    questId=3113,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Gnome",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Simple Memorandum",
                    questId=3112,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    race="Gnome",
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="Coldridge Valley Mail Delivery (Part 1)",
                    questId=233,
                    coords={ x=29.92, y=71.23, map="Coldridge Valley" },
                    npc = { name="Sten Stoutarm" },
                    note="Sten Stoutarm in Coldridge Valley (29.92, 71.23)"
                },

                {
                    type="ACCEPT",
                    title="A New Threat",
                    questId=170,
                    coords={ x=29.71, y=71.26, map="Coldridge Valley" },
                    npc = { name="Balir Frosthammer" },
                    note="Balir Frosthammer in Coldridge Valley (29.71, 71.26)"
                },

                {
                    type="COMPLETE",
                    title="A New Threat",
                    questId=170,
                    coords={ x=31.0, y=74.0, map="Coldridge Valley" },
                    objectives = {
                        { kind="kill", label="Rockjaw Trogg", target=6 },
                        { kind="kill", label="Burly Rockjaw Trogg in Coldridge Valley", target=6 }
                    },
                    note="Kill 6 Rockjaw Trogg and 6 Burly Rockjaw Trogg in Coldridge Valley (31, 74) (30, 74)"
                },

                {
                    type="TURNIN",
                    title="A New Threat",
                    questId=170,
                    coords={ x=29.71, y=71.26, map="Coldridge Valley" },
                    npc = { name="Balir Frosthammer" },
                    note="Balir Frosthammer in Coldridge Valley (29.71, 71.26)"
                },

                {
                    type="TURNIN",
                    title="Encrypted Rune",
                    questId=3109,
                    coords={ x=28.4, y=68.5, map="Coldridge Valley" },
                    npc = { name="Solm Hargrin" },
                    race="Dwarf",
                    note="Solm Hargrin in Coldridge Valley (28.4, 68.5)"
                },

                {
                    type="TURNIN",
                    title="Etched Rune",
                    questId=3108,
                    coords={ x=29.1, y=67.5, map="Coldridge Valley" },
                    npc = { name="Thorgas Grimson" },
                    race="Dwarf",
                    note="Thorgas Grimson in Coldridge Valley (29.1, 67.5)"
                },

                {
                    type="TURNIN",
                    title="Hallowed Rune",
                    questId=3110,
                    coords={ x=28.6, y=66.4, map="Coldridge Valley" },
                    npc = { name="Branstock Khalder" },
                    race="Dwarf",
                    note="Branstock Khalder in Coldridge Valley (28.6, 66.4)"
                },

                {
                    type="TURNIN",
                    title="Simple Rune",
                    questId=3106,
                    coords={ x=28.8, y=67.3, map="Coldridge Valley" },
                    npc = { name="Thran Khorman" },
                    race="Dwarf",
                    note="Thran Khorman in Coldridge Valley (28.8, 67.3)"
                },

                {
                    type="TURNIN",
                    title="Consecrated Rune",
                    questId=3107,
                    coords={ x=28.8, y=68.3, map="Coldridge Valley" },
                    npc = { name="Bromos Grummner" },
                    race="Dwarf",
                    note="Bromos Grummner in Coldridge Valley (28.8, 68.3)"
                },

                {
                    type="TURNIN",
                    title="Tainted Memorandum",
                    questId=3115,
                    coords={ x=28.7, y=66.2, map="Coldridge Valley" },
                    npc = { name="Alamar Grimm" },
                    race="Gnome",
                    note="Alamar Grimm in Coldridge Valley (28.7, 66.2)"
                },

                {
                    type="TURNIN",
                    title="Glyphic Memorandum",
                    questId=3114,
                    coords={ x=28.7, y=66.4, map="Coldridge Valley" },
                    npc = { name="Marryk Nurribit" },
                    race="Gnome",
                    note="Marryk Nurribit in Coldridge Valley (28.7, 66.4)"
                },

                {
                    type="TURNIN",
                    title="Encrypted Memorandum",
                    questId=3113,
                    coords={ x=28.4, y=68.5, map="Coldridge Valley" },
                    npc = { name="Solm Hargrin" },
                    race="Gnome",
                    note="Solm Hargrin in Coldridge Valley (28.4, 68.5)"
                },

                {
                    type="TURNIN",
                    title="Simple Memorandum",
                    questId=3112,
                    coords={ x=28.8, y=67.3, map="Coldridge Valley" },
                    npc = { name="Thran Khorman" },
                    race="Gnome",
                    note="Thran Khorman in Coldridge Valley (28.8, 67.3)"
                },

                {
                    type="ACCEPT",
                    title="A Refugee's Quandary",
                    questId=3361,
                    coords={ x=28.56, y=67.74, map="Coldridge Valley" },
                    npc = { name="Felix Whindlebolt" },
                    note="Felix Whindlebolt in Coldridge Valley (28.56, 67.74)"
                },

                {
                    type="ACCEPT",
                    title="Beginnings",
                    questId=1599,
                    coords={ x=28.64, y=66.15, map="Coldridge Valley" },
                    npc = { name="Alamar Grimm" },
                    note="Alamar Grimm in Coldridge Valley (28.64, 66.15)"
                },

                {
                    type="TURNIN",
                    title="Coldridge Valley Mail Delivery (Part 1)",
                    questId=233,
                    coords={ x=22.57, y=71.38, map="Coldridge Valley" },
                    npc = { name="Talin Keeneye" },
                    note="Talin Keeneye in Coldridge Valley (22.57, 71.38)"
                },

                {
                    type="ACCEPT",
                    title="Coldridge Valley Mail Delivery (Part 2)",
                    questId=234,
                    coords={ x=22.57, y=71.38, map="Coldridge Valley" },
                    npc = { name="Talin Keeneye" },
                    note="Talin Keeneye in Coldridge Valley (22.57, 71.38)"
                },

                {
                    type="ACCEPT",
                    title="The Boar Hunter",
                    questId=183,
                    coords={ x=22.57, y=71.38, map="Coldridge Valley" },
                    npc = { name="Talin Keeneye" },
                    note="Talin Keeneye in Coldridge Valley (22.57, 71.38)"
                },

                {
                    type="COMPLETE",
                    title="The Boar Hunter",
                    questId=183,
                    coords={ x=21.0, y=72.0, map="Coldridge Valley" },
                    objectives = {
                        { kind="kill", label="Small Crag Boar", target=12 }
                    },
                    note="Kill 12 Small Crag Boar in Coldridge Valley (21, 72)"
                },

                {
                    type="TURNIN",
                    title="The Boar Hunter",
                    questId=183,
                    coords={ x=22.57, y=71.38, map="Coldridge Valley" },
                    npc = { name="Talin Keeneye" },
                    note="Talin Keeneye in Coldridge Valley (22.57, 71.38)"
                },

                {
                    type="TURNIN",
                    title="Coldridge Valley Mail Delivery (Part 2)",
                    questId=234,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="ACCEPT",
                    title="The Troll Cave",
                    questId=182,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="ACCEPT",
                    title="Scalding Mornbrew Delivery",
                    questId=3364,
                    coords={ x=25.0, y=75.94, map="Coldridge Valley" },
                    npc = { name="Nori Pridedrift" },
                    note="Nori Pridedrift in Coldridge Valley (25.00, 75.94)"
                },

                {
                    type="TURNIN",
                    title="Scalding Mornbrew Delivery",
                    questId=3364,
                    coords={ x=28.75, y=66.36, map="Coldridge Valley" },
                    npc = { name="Durnan Furcutter" },
                    note="Durnan Furcutter in Coldridge Valley (28.75, 66.36)"
                },

                {
                    type="ACCEPT",
                    title="Bring Back the Mug",
                    questId=3365,
                    coords={ x=28.75, y=616.36, map="Coldridge Valley" },
                    npc = { name="Durnan Furcutter" },
                    note="Durnan Furcutter in Coldridge Valley (28.75, 616.36)"
                },

                {
                    type="TURNIN",
                    title="Bring Back the Mug",
                    questId=3365,
                    coords={ x=25.0, y=75.94, map="Coldridge Valley" },
                    npc = { name="Nori Pridedrift" },
                    note="Nori Pridedrift in Coldridge Valley (25.00, 75.94)"
                },

                {
                    type="Note",
                    title="Felix's Box |QID|3361.1|",
                    note="Collect Felix's Box from the ground at the troll camp (20.9, 76.1)"
                },

                {
                    type="Note",
                    title="Felix's Chest |QID|3361.2|",
                    note="Collect Felix's Chest from the ground at the troll camp (22.8, 79.9)"
                },

                {
                    type="Note",
                    title="Felix's Bucket of Bolts |QID|3361.3|",
                    note="Collect Felix's Bucket of Bolts from the ground at the troll camp (26.3, 79.3)"
                },

                {
                    type="COMPLETE",
                    title="Beginnings",
                    questId=1599,
                    coords={ x=26.79, y=79.71, map="Coldridge Valley" },
                    note="Kill Frostmane Novice for 3 in Coldridge Valley, go into the cave and follow the path to the left, there are only 3 Frostmane Novice inside the cave total (26.79, 79.71) (28.10, 80.12) (30.37, 79.71) (29.41, 81.07)"
                },

                {
                    type="COMPLETE",
                    title="The Troll Cave",
                    questId=182,
                    coords={ x=26.0, y=78.0, map="Coldridge Valley" },
                    objectives = {
                        { kind="kill", label="Frostmane Troll Whelp", target=14 }
                    },
                    note="Kill 14 Frostmane Troll Whelp in Coldridge Valley (26, 78)"
                },

                {
                    type="TURNIN",
                    title="The Troll Cave",
                    questId=182,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="ACCEPT",
                    title="The Stolen Journal",
                    questId=218,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="TURNIN",
                    title="Beginnings",
                    questId=1599,
                    coords={ x=28.7, y=66.17, map="Coldridge Valley" },
                    npc = { name="Alamar Grimm" },
                    note="Alamar Grimm in Coldridge Valley (28.70, 66.17)"
                },

                {
                    type="COMPLETE",
                    title="The Stolen Journal",
                    questId=218,
                    coords={ x=26.76, y=79.75 },
                    note="Go to the cave and kill Grik'nir the Cold and collect Grelin Whitebeard's Journal (26.76, 79.75) (27.56, 80.92) (29.12, 78.84) (30.49, 80.10)"
                },

                {
                    type="TURNIN",
                    title="The Stolen Journal",
                    questId=218,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="ACCEPT",
                    title="Senir's Observations (Part 1)",
                    questId=282,
                    coords={ x=25.1, y=75.76, map="Coldridge Valley" },
                    npc = { name="Grelin Whitebeard" },
                    note="Grelin Whitebeard in Coldridge Valley (25.10, 75.76)"
                },

                {
                    type="TURNIN",
                    title="A Refugee's Quandary",
                    questId=3361,
                    coords={ x=28.8, y=68.99, map="Coldridge Valley" },
                    npc = { name="Felix Whindlebolt" },
                    note="Felix Whindlebolt in Coldridge Valley (28.80, 68.99) (28.56, 67.74)"
                },

                {
                    type="TURNIN",
                    title="Senir's Observations (Part 1)",
                    questId=282,
                    coords={ x=33.47, y=71.83, map="Coldridge Pass" },
                    npc = { name="Mountaineer Thalos" },
                    note="Mountaineer Thalos in Coldridge Pass (33.47, 71.83)"
                },

                {
                    type="ACCEPT",
                    title="Senir's Observations (Part 2)",
                    questId=420,
                    coords={ x=33.47, y=71.83, map="Coldridge Pass" },
                    npc = { name="Mountaineer Thalos" },
                    note="Mountaineer Thalos in Coldridge Pass (33.47, 71.83)"
                },

                {
                    type="ACCEPT",
                    title="Supplies to Tannok",
                    questId=2160,
                    coords={ x=33.83, y=72.21, map="Coldridge Pass" },
                    npc = { name="Hands Springsprocket" },
                    note="Hands Springsprocket in Coldridge Pass (33.83, 72.21)"
                },

                {
                    type="TRAVEL",
                    title="Kharanos",
                    questId=384,
                    coords={ x=35.64, y=65.68 },
                    note="Travel to Kharanos (35.64, 65.68) (36.27, 62.00) (45.19, 63.40) (47.02, 58.48) (46.66, 53.83)"
                },

                {
                    type="TURNIN",
                    title="Senir's Observations (Part 2)",
                    questId=420,
                    coords={ x=46.66, y=53.83, map="Kharanos" },
                    npc = { name="Senir Whitebeard" },
                    note="Senir Whitebeard in Kharanos (46.66, 53.83)"
                },

                {
                    type="Note",
                    title="Train Cooking |QID|384|",
                    note="Speak to Gremlock Pilsnor and train cooking skill, you need this to accept the next quest. Tick this step (47.6, 52.4)"
                },

                {
                    type="ACCEPT",
                    title="Beer Basted Boar Ribs",
                    questId=384,
                    coords={ x=46.81, y=52.37 },
                    npc = { name="Ragnar Thunderbrew" },
                    note="Ragnar Thunderbrew in Kharanos. You need to train the cooking skill for this quest to appear, speak to Gremlock Pilsnor inside Thunderbrew Distillery to train the skill (46.81, 52.37)"
                },

                {
                    type="TRAVEL",
                    title="Thunderbrew Distillery",
                    questId=400,
                    coords={ x=47.24, y=52.15 },
                    note="Travel to Thunderbrew Distillery (47.24, 52.15)"
                },

                {
                    type="TURNIN",
                    title="Supplies to Tannok",
                    questId=2160,
                    coords={ x=47.24, y=52.15, map="Thunderbrew Distillery" },
                    npc = { name="Tannok Frosthammer" },
                    note="Tannok Frosthammer in Thunderbrew Distillery (47.24, 52.15)"
                },

                {
                    type="SET_HEARTH",
                    title="Thunderbrew Distillery |QID|400|",
                    coords={ x=47.4, y=52.5 },
                    npc = { name="Speak to Innkeeper Belm and set hearth" },
                    note="Speak to Innkeeper Belm and set hearth at Thunderbrew Distillery (47.4, 52.5)"
                },

                {
                    type="ACCEPT",
                    title="Tools for Steelgrill",
                    questId=400,
                    coords={ x=46.03, y=51.75, map="Kharanos" },
                    npc = { name="Tharek Blackstone" },
                    note="Tharek Blackstone in Kharanos (46.03, 51.75)"
                },

                {
                    type="TRAVEL",
                    title="Steelgrill's Depot",
                    questId=5541,
                    coords={ x=50.42, y=49.13 },
                    note="Travel to Steelgrill's Depot (50.42, 49.13)"
                },

                {
                    type="TURNIN",
                    title="Tools for Steelgrill",
                    questId=400,
                    coords={ x=50.42, y=49.13, map="Steelgrill's Depot" },
                    npc = { name="Beldin Steelgrill" },
                    note="Beldin Steelgrill in Steelgrill's Depot (50.42, 49.13)"
                },

                {
                    type="ACCEPT",
                    title="Ammo for Rumbleshot",
                    questId=5541,
                    coords={ x=50.07, y=49.26, map="Steelgrill's Depot" },
                    npc = { name="Loslor Rudge" },
                    note="Loslor Rudge in Steelgrill's Depot (50.07, 49.26)"
                },

                {
                    type="ACCEPT",
                    title="The Grizzled Den",
                    questId=313,
                    coords={ x=49.66, y=48.57, map="Steelgrill's Depot" },
                    npc = { name="Pilot Stonegear" },
                    note="Pilot Stonegear in Steelgrill's Depot (49.66, 48.57)"
                },

                {
                    type="ACCEPT",
                    title="Stocking Jetsteam",
                    questId=317,
                    coords={ x=49.49, y=48.37, map="Steelgrill's Depot" },
                    npc = { name="Pilot Bellowfiz" },
                    note="Pilot Bellowfiz in Steelgrill's Depot (49.49, 48.37)"
                },

                {
                    type="COMPLETE",
                    title="Ammo for Rumbleshot",
                    questId=5541,
                    coords={ x=44.1, y=56.9 },
                    note="Open the crate and collect Rumbleshot's Ammo near The Grizzled Den (44.1, 56.9)"
                },

                {
                    type="COMPLETE",
                    title="The Grizzled Den",
                    questId=313,
                    coords={ x=42.0, y=54.0 },
                    note="Kill Young Wendigo and Wendigo to gather 8 Wendigo Mane in The Grizzled Den (42, 54)"
                },

                {
                    type="TURNIN",
                    title="Ammo for Rumbleshot",
                    questId=5541,
                    coords={ x=40.69, y=65.14, map="Dun Morogh" },
                    npc = { name="Hegnar Rumbleshot" },
                    note="Hegnar Rumbleshot in Dun Morogh (40.69, 65.14)"
                },

                {
                    type="COMPLETE",
                    title="Stocking Jetsteam",
                    questId=317,
                    coords={ x=50.0, y=52.0 },
                    note="Kill Dire Mottled Boar to collect 4 Chunk of Boar Meat and Young Black Bear to collect 2 Thick Bear Fur (50, 52)"
                },

                {
                    type="TRAVEL",
                    title="Steelgrill's Depot",
                    questId=318,
                    coords={ x=49.66, y=48.57 },
                    note="Travel to Steelgrill's Depot (49.66, 48.57)"
                },

                {
                    type="TURNIN",
                    title="The Grizzled Den",
                    questId=313,
                    coords={ x=49.66, y=48.57, map="Steelgrill's Depot" },
                    npc = { name="Pilot Stonegear" },
                    note="Pilot Stonegear in Steelgrill's Depot (49.66, 48.57)"
                },

                {
                    type="TURNIN",
                    title="Stocking Jetsteam",
                    questId=317,
                    coords={ x=49.49, y=48.37, map="Steelgrill's Depot" },
                    npc = { name="Pilot Bellowfiz" },
                    note="Pilot Bellowfiz in Steelgrill's Depot (49.49, 48.37)"
                },

                {
                    type="ACCEPT",
                    title="Evershine",
                    questId=318,
                    coords={ x=49.49, y=48.37, map="Steelgrill's Depot" },
                    npc = { name="Pilot Bellowfiz" },
                    note="Pilot Bellowfiz in Steelgrill's Depot (49.49, 48.37)"
                },

                {
                    type="TURNIN",
                    title="Beer Basted Boar Ribs",
                    questId=384,
                    coords={ x=46.81, y=52.37, map="Kharanos" },
                    npc = { name="Ragnar Thunderbrew" },
                    note="Ragnar Thunderbrew in Kharanos (46.81, 52.37)"
                },

                {
                    type="ACCEPT",
                    title="Frostmane Hold",
                    questId=287,
                    coords={ x=46.66, y=53.83, map="Kharanos" },
                    npc = { name="Senir Whitebeard" },
                    note="Senir Whitebeard in Kharanos (46.66, 53.83)"
                },

                {
                    type="ACCEPT",
                    title="Operation Recombobulation",
                    questId=412,
                    coords={ x=45.8, y=49.2, map="Kharanos" },
                    npc = { name="Razzle Sprysprocket" },
                    note="Razzle Sprysprocket in Kharanos (45.8, 49.2)"
                },

                {
                    type="TRAVEL",
                    title="Chill Breeze Valley",
                    questId=312,
                    coords={ x=43.52, y=56.65 },
                    note="Travel to Chill Breeze Valley (43.52, 56.65) (37.54, 60.37) (34.87, 58.14) (34.74, 56.54)"
                },

                {
                    type="ACCEPT",
                    title="Tundra MacGrann's Stolen Stash",
                    questId=312,
                    coords={ x=36.7, y=52.13, map="Chill Breeze Valley" },
                    npc = { name="Tundra MacGrann" },
                    note="Tundra MacGrann in Chill Breeze Valley (36.70, 52.13) (35.16, 51.83) (34.57, 51.63)"
                },

                {
                    type="COMPLETE",
                    title="Tundra MacGrann's Stolen Stash",
                    questId=312,
                    coords={ x=38.0, y=54.0, map="and loot MacGrann's Dried Meats and run back out" },
                    note="Find MacGrann's Meat Locker in the cave guarded by Old Icebeard. Wait until he patrols out away from the chest and quickly run in and loot MacGrann's Dried Meats and run back out (38, 54)"
                },

                {
                    type="TURNIN",
                    title="Tundra MacGrann's Stolen Stash",
                    questId=312,
                    coords={ x=34.57, y=51.63, map="Chill Breeze Valley" },
                    npc = { name="Tundra MacGrann" },
                    note="Tundra MacGrann in Chill Breeze Valley (34.57, 51.63)"
                },

                {
                    type="TRAVEL",
                    title="Brewnall Village",
                    questId=319,
                    coords={ x=30.2, y=45.62 },
                    note="Travel to Brewnall Village (30.20, 45.62)"
                },

                {
                    type="TURNIN",
                    title="Evershine",
                    questId=318,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="ACCEPT",
                    title="A Favor for Evershine",
                    questId=319,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="ACCEPT",
                    title="The Perfect Stout",
                    questId=315,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="ACCEPT",
                    title="Bitter Rivals",
                    questId=310,
                    coords={ x=30.22, y=45.54, map="Brewnall Village" },
                    npc = { name="Marleth Barleybrew" },
                    note="Marleth Barleybrew in Brewnall Village (30.22, 45.54)"
                },

                {
                    type="COMPLETE",
                    title="The Perfect Stout",
                    questId=315,
                    coords={ x=40.0, y=43.0 },
                    objectives = {
                        { kind="loot", label="Shimmerweed dropped by Frostmane Seer and", target=6 }
                    },
                    note="Collect 6 Shimmerweed dropped by Frostmane Seer and from the Shimmerweed Baskets in the area (40, 43)"
                },

                {
                    type="COMPLETE",
                    title="A Favor for Evershine",
                    questId=319,
                    coords={ x=28.0, y=48.5 },
                    note="Kill 6 Ice Claw Bear, 8 Elder Crag Boar and 8 Snow Leopard found west of Brewnall Village (28, 48.5)"
                },

                {
                    type="TRAVEL",
                    title="Brewnall Village",
                    questId=319,
                    coords={ x=30.2, y=45.62 },
                    note="Travel to Brewnall Village (30.20, 45.62)"
                },

                {
                    type="TURNIN",
                    title="The Perfect Stout",
                    questId=315,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="TURNIN",
                    title="A Favor for Evershine",
                    questId=319,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="ACCEPT",
                    title="Return to Bellowfiz",
                    questId=320,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village (30.20, 45.62)"
                },

                {
                    type="ACCEPT",
                    title="Shimmer Stout",
                    questId=413,
                    coords={ x=30.2, y=45.62, map="Brewnall Village" },
                    npc = { name="Rejold Barleybrew" },
                    note="Rejold Barleybrew in Brewnall Village, level 8 required (30.20, 45.62)"
                },

                {
                    type="TRAVEL",
                    title="Thunderbrew Distillery",
                    questId=311,
                    coords={ x=47.4, y=52.5 },
                    note="Travel to Thunderbrew Distillery<br/><b>You can die on purpose and resurrect to get there quicker (47.4, 52.5)"
                },

                {
                    type="TURNIN",
                    title="Bitter Rivals",
                    questId=310,
                    coords={ x=47.7, y=52.7 },
                    npc = { name="Give the Thunder Ale to Jarven downstairs" },
                    note="Give the Thunder Ale to Jarven downstairs, then talk to the barrel (47.7, 52.7)"
                },

                {
                    type="ACCEPT",
                    title="Return to Marleth",
                    questId=311,
                    coords={ x=47.7, y=52.7 },
                    note="Unguarded Thunder Ale Barrel (47.7, 52.7)"
                },

                {
                    type="TRAVEL",
                    title="Brewnall Village",
                    questId=287,
                    coords={ x=30.22, y=45.54 },
                    note="Travel to Brewnall Village (30.22, 45.54)"
                },

                {
                    type="TURNIN",
                    title="Return to Marleth",
                    questId=311,
                    coords={ x=30.22, y=45.54, map="Brewnall Village" },
                    npc = { name="Marleth Barleybrew" },
                    note="Marleth Barleybrew in Brewnall Village (30.22, 45.54)"
                },

                {
                    type="TRAVEL",
                    title="Frostmane Hold",
                    questId=287,
                    coords={ x=24.9, y=50.94 },
                    note="Travel to Frostmane Hold (24.90, 50.94)"
                },

                {
                    type="COMPLETE",
                    title="Frostmane Hold",
                    questId=287,
                    coords={ x=24.9, y=50.94 },
                    note="Go inside the cave to explore Frostmane Hold and kill 5 Frostmane Headhunter (24.90, 50.94) (22.88, 52.07)"
                },

                {
                    type="TRAVEL",
                    title="Gnomeregan",
                    questId=412,
                    coords={ x=24.9, y=50.94 },
                    note="Travel to Gnomeregan (24.90, 50.94) (25.05, 42.90)"
                },

                {
                    type="COMPLETE",
                    title="Operation Recombobulation",
                    questId=412,
                    coords={ x=25.05, y=42.9, map="Gnomeregan" },
                    note="Kill Leper Gnome and collect 8 Restabilization Cog and 8 Gyromechanic Gear in Gnomeregan (25.05, 42.90)"
                },

                {
                    type="TRAVEL",
                    title="Kharanos",
                    questId=291,
                    coords={ x=46.66, y=53.83 },
                    note="Travel to Kharanos<br/><b>You can die on purpose and resurrect to get there quicker (46.66, 53.83)"
                },

                {
                    type="TURNIN",
                    title="Frostmane Hold",
                    questId=287,
                    coords={ x=46.66, y=53.83, map="Kharanos" },
                    npc = { name="Senir Whitebeard" },
                    note="Senir Whitebeard in Kharanos (46.66, 53.83)"
                },

                {
                    type="ACCEPT",
                    title="The Reports",
                    questId=291,
                    coords={ x=46.66, y=53.83, map="Kharanos" },
                    npc = { name="Senir Whitebeard" },
                    note="Senir Whitebeard in Kharanos (46.66, 53.83)"
                },

                {
                    type="TURNIN",
                    title="Operation Recombobulation",
                    questId=412,
                    coords={ x=45.8, y=49.2, map="Kharanos" },
                    npc = { name="Razzle Sprysprocket" },
                    note="Razzle Sprysprocket in Kharanos (45.8, 49.2)"
                },

                {
                    type="TRAVEL",
                    title="Steelgrill's Depot |TID|320|",
                    coords={ x=49.49, y=48.37 },
                    note="Travel to Steelgrill's Depot (49.49, 48.37)"
                },

                {
                    type="TURNIN",
                    title="Return to Bellowfiz",
                    questId=320,
                    coords={ x=49.49, y=48.37, map="Steelgrill's Depot" },
                    npc = { name="Pilot Bellowfiz" },
                    note="Pilot Bellowfiz in Steelgrill's Depot (49.49, 48.37)"
                },

                {
                    type="TRAVEL",
                    title="Gol'Bolar Quarry",
                    questId=433,
                    coords={ x=56.54, y=47.72 },
                    note="Travel to Gol'Bolar Quarry (56.54, 47.72) (63.39, 54.87) (68.65, 55.95)"
                },

                {
                    type="ACCEPT",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=68.7, y=56.02, map="Gol'Bolar Quarry" },
                    npc = { name="Senator Mehr Stonehallow" },
                    note="Senator Mehr Stonehallow in Gol'Bolar Quarry (68.70, 56.02)"
                },

                {
                    type="ACCEPT",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=69.1, y=56.3 },
                    npc = { name="Foreman Stonebrow" },
                    note="Foreman Stonebrow at Gol'Bolar Quarry (69.1, 56.3)"
                },

                {
                    type="COMPLETE",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=70.58, y=56.69 },
                    objectives = {
                        { kind="kill", label="Rockjaw Bonesnapper", target=10 }
                    },
                    note="Kill 10 Rockjaw Bonesnapper around the Gol'Bolar Quarry (70.58, 56.69)"
                },

                {
                    type="COMPLETE",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=70.58, y=56.69 },
                    objectives = {
                        { kind="kill", label="Rockjaw Skullthumper", target=6 }
                    },
                    note="Kill 6 Rockjaw Skullthumper around the Gol'Bolar Quarry (70.58, 56.69)"
                },

                {
                    type="TURNIN",
                    title="The Public Servant",
                    questId=433,
                    coords={ x=68.7, y=56.02, map="Gol'Bolar Quarry" },
                    npc = { name="Senator Mehr Stonehallow" },
                    note="Senator Mehr Stonehallow in Gol'Bolar Quarry (68.70, 56.02)"
                },

                {
                    type="TURNIN",
                    title="Those Blasted Troggs!",
                    questId=432,
                    coords={ x=69.12, y=56.3, map="Gol'Bolar Quarry" },
                    npc = { name="Foreman Stonebrow" },
                    note="Foreman Stonebrow in Gol'Bolar Quarry (69.12, 56.30)"
                },

                {
                    type="TRAVEL",
                    title="Thunderbrew Distillery",
                    questId=1679,
                    coords={ x=47.35, y=52.64 },
                    note="Travel to Thunderbrew Distillery<br/><b>Level 10 required<br/><b>You can die on purpose and resurrect to get there quicker (47.35, 52.64)"
                },

                {
                    type="ACCEPT",
                    title="Speak with Bink",
                    questId=1879,
                    coords={ x=47.36, y=51.92, map="Thunderbrew Distillery" },
                    npc = { name="Magis Sparkmantle" },
                    note="Magis Sparkmantle in Thunderbrew Distillery (47.36, 51.92)"
                },

                {
                    type="ACCEPT",
                    title="Road to Salvation",
                    questId=2218,
                    coords={ x=47.59, y=52.46, map="Thunderbrew Distillery" },
                    npc = { name="Hogral Bakkan" },
                    note="Hogral Bakkan in Thunderbrew Distillery (47.59, 52.46)"
                },

                {
                    type="ACCEPT",
                    title="Taming the Beast (Part 1)",
                    questId=6064,
                    coords={ x=45.82, y=53.03, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.82, 53.03)"
                },

                {
                    type="COMPLETE",
                    title="Taming the Beast (Part 1)",
                    questId=6064,
                    coords={ x=47.92, y=47.13, map="Steelgrill's Depot" },
                    objectives = {
                        { kind="use_item", label="Taming Rod", target=1, itemId=15911 }
                    },
                    note="Use Taming Rod to tame a Large Crag Boar in Steelgrill's Depot (47.92, 47.13)"
                },

                {
                    type="TURNIN",
                    title="Taming the Beast (Part 1)",
                    questId=6064,
                    coords={ x=45.81, y=53.02, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.81, 53.02)"
                },

                {
                    type="ACCEPT",
                    title="Taming the Beast (Part 2)",
                    questId=6084,
                    coords={ x=45.81, y=53.02, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.81, 53.02)"
                },

                {
                    type="COMPLETE",
                    title="Taming the Beast (Part 2)",
                    questId=6084,
                    coords={ x=34.6, y=47.08 },
                    objectives = {
                        { kind="use_item", label="Taming Rod", target=1, itemId=15913 }
                    },
                    note="Use Taming Rod to tame a Snow Leopard Iceflow Lake (34.60, 47.08)"
                },

                {
                    type="TURNIN",
                    title="Taming the Beast (Part 2)",
                    questId=6084,
                    coords={ x=45.81, y=53.05, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.81, 53.05)"
                },

                {
                    type="ACCEPT",
                    title="Taming the Beast (Part 3)",
                    questId=6085,
                    coords={ x=45.81, y=53.05, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.81, 53.05)"
                },

                {
                    type="COMPLETE",
                    title="Taming the Beast (Part 3)",
                    questId=6085,
                    coords={ x=31.7, y=38.78, map="Iceflow Lake" },
                    objectives = {
                        { kind="use_item", label="Taming Rod", target=1, itemId=15908 }
                    },
                    note="Use Taming Rod to tame a Ice Claw Bear in Iceflow Lake (31.70, 38.78)"
                },

                {
                    type="TURNIN",
                    title="Taming the Beast (Part 3)",
                    questId=6085,
                    coords={ x=45.8, y=53.04, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (45.80, 53.04)"
                },

                {
                    type="ACCEPT",
                    title="Training the Beast",
                    questId=6086,
                    coords={ x=46.13, y=52.29, map="Kharanos" },
                    npc = { name="Grif Wildheart" },
                    note="Grif Wildheart in Kharanos (46.13, 52.29)"
                },

                {
                    type="ACCEPT",
                    title="Muren Stormpike",
                    questId=1679,
                    coords={ x=47.35, y=52.64, map="Thunderbrew Distillery" },
                    npc = { name="Granis Swiftaxe" },
                    note="Granis Swiftaxe in Thunderbrew Distillery, level 10 required (47.35, 52.64)"
                },

                {
                    type="TURNIN",
                    title="Muren Stormpike",
                    questId=1679,
                    coords={ x=70.76, y=90.48, map="Hall of Arms" },
                    npc = { name="Muren Stormpike" },
                    note="Muren Stormpike in Hall of Arms (70.76, 90.48)"
                },

                {
                    type="ACCEPT",
                    title="Vejrek",
                    questId=1678,
                    coords={ x=70.76, y=90.48, map="Hall of Arms" },
                    npc = { name="Muren Stormpike" },
                    note="Muren Stormpike in Hall of Arms (70.76, 90.48)"
                },

                {
                    type="TRAVEL",
                    title="Frostmane Hold",
                    questId=1678,
                    coords={ x=24.78, y=50.88 },
                    note="Travel to Frostmane Hold (24.78, 50.88)"
                },

                {
                    type="COMPLETE",
                    title="Vejrek",
                    questId=1678,
                    coords={ x=27.66, y=57.78, map="Frostmane Hold" },
                    note="Kill Vejrek and collect Vejrek's Head in Frostmane Hold (27.66, 57.78)"
                },

                {
                    type="TURNIN",
                    title="Vejrek",
                    questId=1678,
                    coords={ x=62.42, y=35.6, map="Hall of Arms" },
                    npc = { name="Muren Stormpike" },
                    note="Muren Stormpike in Hall of Arms (62.42, 35.60)"
                },

                {
                    type="ACCEPT",
                    title="Tormus Deepforge",
                    questId=1680,
                    coords={ x=62.34, y=35.67 },
                    note="in Hall of Arms (62.34, 35.67)"
                },

                {
                    type="TURNIN",
                    title="Tormus Deepforge",
                    questId=1680,
                    coords={ x=48.74, y=42.44, map="Ironforge" },
                    npc = { name="Tormus Deepforge" },
                    note="Tormus Deepforge in The Great Forge (48.74, 42.44)"
                },

                {
                    type="ACCEPT",
                    title="Ironband's Compound",
                    questId=1681,
                    coords={ x=48.74, y=42.44, map="Ironforge" },
                    npc = { name="Tormus Deepforge" },
                    note="Tormus Deepforge in The Great Forge (48.74, 42.44)"
                },

                {
                    type="TRAVEL",
                    title="Ironband's Compound",
                    questId=1681,
                    coords={ x=57.32, y=51.83 },
                    note="Travel to Ironband's Compound (57.32, 51.83) (74.79, 56.02) (77.95, 62.21)"
                },

                {
                    type="COMPLETE",
                    title="Ironband's Compound",
                    questId=1681,
                    coords={ x=77.95, y=62.21, map="Ironband's Compound" },
                    note="Collect Umbral Ore from the Ironband lockbox in Ironband's Compound (77.95, 62.21)"
                },

                {
                    type="TRAVEL",
                    title="The Great Forge",
                    questId=2238,
                    coords={ x=47.2, y=42.18, map="Ironforge" },
                    note="Travel to The Great Forge<br/><b>You can die on purpose and resurrect to get there quicker (47.20, 42.18) (51.48, 39.74) (53.87, 34.44) (48.65, 43.07)"
                },

                {
                    type="TRAVEL",
                    title="The Great Forge",
                    questId=2238,
                    coords={ x=47.2, y=42.18, map="Ironforge" },
                    note="Travel to The Great Forge<br/><b>You can die on purpose and resurrect to get there quicker (47.20, 42.18) (51.48, 39.74) (53.87, 34.44) (48.65, 43.07)"
                },

                {
                    type="TURNIN",
                    title="Ironband's Compound",
                    questId=1681,
                    coords={ x=48.65, y=43.07, map="Ironforge" },
                    npc = { name="Tormus Deepforge" },
                    note="Tormus Deepforge in The Great Forge (48.65, 43.07)"
                },

                {
                    type="TURNIN",
                    title="Training the Beast",
                    questId=6086,
                    coords={ x=70.93, y=85.66, map="Hall of Arms" },
                    npc = { name="Belia Thundergranite" },
                    note="Belia Thundergranite in Hall of Arms (70.93, 85.66)"
                },

                {
                    type="TURNIN",
                    title="Road to Salvation",
                    questId=2218,
                    coords={ x=51.88, y=14.66, map="Ironforge" },
                    npc = { name="Hulfdan Blackbeard" },
                    note="Hulfdan Blackbeard in The Forlorn Cavern (51.88, 14.66)"
                },

                {
                    type="ACCEPT",
                    title="Simple Subterfugin'",
                    questId=2238,
                    coords={ x=51.88, y=14.66, map="Ironforge" },
                    npc = { name="Hulfdan Blackbeard" },
                    note="Hulfdan Blackbeard in The Forlorn Cavern (51.88, 14.66)"
                },

                {
                    type="TRAVEL",
                    title="Gnomeregan",
                    questId=2239,
                    coords={ x=25.18, y=44.44 },
                    note="Travel to Gnomeregan (25.18, 44.44)"
                },

                {
                    type="TURNIN",
                    title="Simple Subterfugin'",
                    questId=2238,
                    coords={ x=25.18, y=44.44, map="Gnomeregan" },
                    npc = { name="Onin MacHammar" },
                    note="Onin MacHammar in Gnomeregan (25.18, 44.44)"
                },

                {
                    type="ACCEPT",
                    title="Onin's Report",
                    questId=2239,
                    coords={ x=25.18, y=44.44, map="Gnomeregan" },
                    npc = { name="Onin MacHammar" },
                    note="Onin MacHammar in Gnomeregan (25.18, 44.44)"
                },

                {
                    type="TRAVEL",
                    title="The Forlorn Cavern |TID|2239|",
                    coords={ x=51.89, y=14.85, map="Ironforge" },
                    note="The Forlorn Cavern (51.89, 14.85)"
                },

                {
                    type="TURNIN",
                    title="Onin's Report",
                    questId=2239,
                    coords={ x=51.89, y=14.85, map="Ironforge" },
                    npc = { name="Hulfdan Blackbeard" },
                    note="Hulfdan Blackbeard in The Forlorn Cavern (51.89, 14.85)"
                },

                {
                    type="ACCEPT",
                    title="The Slaughtered Lamb",
                    questId=1715,
                    coords={ x=47.64, y=9.76, map="Ironforge" },
                    npc = { name="Lago Blackwrench," },
                    note="Lago Blackwrench, in The Forlorn Cavern (47.64, 9.76)"
                },

                {
                    type="TRAVEL",
                    title="Deeprun Tram",
                    questId=6661,
                    coords={ x=76.31, y=51.13, map="Ironforge" },
                    note="In the Dwarven District (76.31,51.13)"
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
                    title="Stormwind City",
                    questId=1688,
                    note="Take the portal to Stormwind City"
                },

                {
                    type="TURNIN",
                    title="The Slaughtered Lamb",
                    questId=1715,
                    coords={ x=46.2, y=77.4, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    note="Gakin the Darkbinder in The Slaughtered Lamb (46.2, 77.4) (39.2, 85.2)"
                },

                {
                    type="ACCEPT",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=39.2, y=85.2, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    note="Gakin the Darkbinder in The Slaughtered Lamb (39.2, 85.2)"
                },

                {
                    type="TRAVEL",
                    title="Brackwell Pumpkin Patch",
                    questId=1688,
                    coords={ x=71.02, y=80.76, map="Elwynn Forest" },
                    note="Travel to Brackwell Pumpkin Patch (71.02, 80.76)"
                },

                {
                    type="COMPLETE",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=71.02, y=80.76, map="Elwynn Forest" },
                    note="Kill Surena Caledon and collect Surena's Choker in Brackwell Pumpkin Patch. She is guarded by 2 other enemies, you will need to pull them away (71.02, 80.76)"
                },

                {
                    type="TRAVEL",
                    title="The Slaughtered Lamb",
                    questId=1689,
                    coords={ x=39.2, y=85.2, map="Stormwind City" },
                    note="Travel to The Slaughtered Lamb (39.2, 85.2)"
                },

                {
                    type="TURNIN",
                    title="Surena Caledon",
                    questId=1688,
                    coords={ x=39.2, y=85.2, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    note="Gakin the Darkbinder in The Slaughtered Lamb (39.2, 85.2)"
                },

                {
                    type="ACCEPT",
                    title="The Binding",
                    questId=1689,
                    coords={ x=39.2, y=85.2, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    note="Gakin the Darkbinder in The Slaughtered Lamb (39.2, 85.2)"
                },

                {
                    type="COMPLETE",
                    title="The Binding",
                    questId=1689,
                    coords={ x=38.3, y=84.9, map="Stormwind City" },
                    note="Keep going down the stair until you find the purple summoning circle and use Bloodstone Choker to summon and kill a Summoned Voidwalker in The Slaughtered Lamb (38.3, 84.9) (39.1, 84,4)"
                },

                {
                    type="TURNIN",
                    title="The Binding",
                    questId=1689,
                    coords={ x=39.2, y=85.2, map="Stormwind City" },
                    npc = { name="Gakin the Darkbinder" },
                    note="Gakin the Darkbinder in The Slaughtered Lamb (39.2, 85.2)"
                },

                {
                    type="TURNIN",
                    title="Speak with Bink",
                    questId=1879,
                    coords={ x=27.23, y=8.33, map="Hall of Mysteries" },
                    npc = { name="Bink" },
                    note="Bink in Hall of Mysteries (27.23, 8.33)"
                },

                {
                    type="ACCEPT",
                    title="Mage-tastic Gizmonitor",
                    questId=1880,
                    coords={ x=27.23, y=8.33, map="Hall of Mysteries" },
                    npc = { name="Bink" },
                    note="Bink in Hall of Mysteries (27.23, 8.33)"
                },

                {
                    type="TRAVEL",
                    title="Gnomeregan",
                    questId=1880,
                    coords={ x=27.69, y=36.42, map="Dun Morogh" },
                    note="Travel to Gnomeregan (27.69, 36.42)"
                },

                {
                    type="COMPLETE",
                    title="Mage-tastic Gizmonitor",
                    questId=1880,
                    coords={ x=27.69, y=36.42, map="Gnomeregan" },
                    note="Collect Mage-tastic Gizmonitor from Blink toolbox in Gnomeregan (27.69, 36.42)"
                },

                {
                    type="TURNIN",
                    title="Mage-tastic Gizmonitor",
                    questId=1880,
                    coords={ x=27.24, y=8.31, map="Hall of Mysteries" },
                    npc = { name="Bink" },
                    note="Bink in Hall of Mysteries (27.24, 8.31)"
                },

                {
                    type="TRAVEL",
                    title="North Gate Pass",
                    questId=417,
                    coords={ x=80.96, y=42.95 },
                    note="Travel to North Gate Pass (80.96, 42.95)"
                },

                {
                    type="ACCEPT",
                    title="The Lost Pilot",
                    questId=419,
                    coords={ x=80.96, y=42.95, map="North Gate Outpost" },
                    npc = { name="Pilot Hammerfoot" },
                    note="Pilot Hammerfoot in North Gate Outpost (80.96, 42.95) (83.90, 39.10)"
                },

                {
                    type="TURNIN",
                    title="The Lost Pilot",
                    questId=419,
                    coords={ x=79.7, y=36.2, map="North Gate Outpost" },
                    npc = { name="A Dwarven Corpse" },
                    note="A Dwarven Corpse in North Gate Outpost (79.7, 36.2)"
                },

                {
                    type="ACCEPT",
                    title="A Pilot's Revenge",
                    questId=417,
                    coords={ x=79.7, y=36.2, map="North Gate Outpost" },
                    npc = { name="A Dwarven Corpse" },
                    note="A Dwarven Corpse in North Gate Outpost (79.7, 36.2)"
                },

                {
                    type="COMPLETE",
                    title="A Pilot's Revenge",
                    questId=417,
                    coords={ x=78.5, y=37.6 },
                    note="Kill Mangeclaw and collect Mangy Claw (78.5, 37.6)"
                },

                {
                    type="TURNIN",
                    title="A Pilot's Revenge",
                    questId=417,
                    coords={ x=83.9, y=39.1, map="North Gate Outpost" },
                    npc = { name="Pilot Hammerfoot" },
                    note="Pilot Hammerfoot in North Gate Outpost (83.90, 39.10)"
                },

                {
                    type="TURNIN",
                    title="Shimmer Stout",
                    questId=413,
                    coords={ x=79.06, y=51.55, map="South Gate Outpost" },
                    npc = { name="Mountaineer Barleybrew" },
                    note="Mountaineer Barleybrew in South Gate Outpost (79.06, 51.55) (82.30, 53.40) (86.29, 48.86)"
                },

                {
                    type="ACCEPT",
                    title="Stout to Kadrell",
                    questId=414,
                    coords={ x=86.29, y=48.86, map="South Gate Outpost" },
                    npc = { name="Mountaineer Barleybrew" },
                    note="Mountaineer Barleybrew in South Gate Outpost (86.29, 48.86)"
                },

                {
                    type="TRAVEL",
                    title="Valley of Kings",
                    questId=224,
                    coords={ x=16.75, y=58.94, map="Loch Modan" },
                    note="Travel to Valley of Kings (16.75, 58.94) (21.85, 73.43)"
                },

                {
                    type="ACCEPT",
                    title="In Defense of the King's Lands (Part 1)",
                    questId=224,
                    coords={ x=21.85, y=73.43, map="Valley of Kings" },
                    npc = { name="Mountaineer Cobbleflint" },
                    note="Mountaineer Cobbleflint in Valley of Kings (21.85, 73.43)"
                },

                {
                    type="ACCEPT",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=23.23, y=73.66, map="Valley of Kings" },
                    npc = { name="Captain Rugelfuss" },
                    note="Captain Rugelfuss in Valley of Kings (23.23, 73.66)"
                },

                {
                    type="COMPLETE",
                    title="In Defense of the King's Lands (Part 1)",
                    questId=224,
                    coords={ x=29.0, y=53.0, map="Loch Modan" },
                    objectives = {
                        { kind="kill", label="Stonesplinter Trogg", target=10 },
                        { kind="kill", label="Stonesplinter Scout which can be found in the area west of Thelsammar", target=10 }
                    },
                    note="Kill 10 Stonesplinter Trogg and 10 Stonesplinter Scout which can be found in the area west of Thelsammar (29, 53)"
                },

                {
                    type="COMPLETE",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=29.0, y=53.0, map="Loch Modan" },
                    note="Kill Stonesplinter Scout and Stonesplinter Trogg in the area west of Thelsammar to collect 8 Trogg Stone Tooth (29, 53)"
                },

                {
                    type="TURNIN",
                    title="The Trogg Threat",
                    questId=267,
                    coords={ x=23.23, y=73.66, map="Valley of Kings" },
                    npc = { name="Captain Rugelfuss" },
                    note="Captain Rugelfuss in Valley of Kings (23.23, 73.66)"
                },

                {
                    type="TURNIN",
                    title="In Defense of the King's Lands (Part 1)",
                    questId=224,
                    coords={ x=22.03, y=73.05, map="Valley of Kings" },
                    npc = { name="Mountaineer Cobbleflint" },
                    note="Mountaineer Cobbleflint in Valley of Kings (22.03, 73.05)"
                },

                {
                    type="ACCEPT",
                    title="In Defense of the King's Lands (Part 2)",
                    questId=237,
                    coords={ x=23.52, y=76.37, map="Valley of Kings" },
                    npc = { name="Mountaineer Gravelgaw" },
                    note="Mountaineer Gravelgaw in Valley of Kings (23.52, 76.37)"
                },

                {
                    type="TRAVEL",
                    title="Thelsamar",
                    questId=1339,
                    coords={ x=28.27, y=65.68, map="Loch Modan" },
                    note="Travel to Thelsamar (28.27, 65.68) (33.9, 50.9)"
                },

                {
                    type="TURNIN",
                    title="Stout to Kadrell |Z|Loch Modan|",
                    questId=414,
                    coords={ x=34.94, y=47.04, map="Thelsamar" },
                    npc = { name="Mountaineer Kadrell" },
                    note="Mountaineer Kadrell in Thelsamar (34.94, 47.04)"
                },

                {
                    type="ACCEPT",
                    title="Rat Catching |Z|Loch Modan|",
                    questId=416,
                    coords={ x=34.94, y=47.04, map="Thelsamar" },
                    npc = { name="Mountaineer Kadrell" },
                    note="Mountaineer Kadrell in Thelsamar (34.94, 47.04)"
                },

                {
                    type="ACCEPT",
                    title="Mountaineer Stormpike's Task",
                    questId=1339,
                    coords={ x=35.1, y=47.02, map="Thelsamar" },
                    npc = { name="Mountaineer Kadrell" },
                    note="Mountaineer Kadrell in Thelsamar (35.10, 47.02)"
                },

                {
                    type="ACCEPT",
                    title="Thelsamar Blood Sausages",
                    questId=418,
                    coords={ x=34.88, y=49.18, map="Loch Modan" },
                    note="in Stoutlager Inn (34.88, 49.18)"
                },

                {
                    type="ACCEPT",
                    title="Honor Students",
                    questId=6387,
                    coords={ x=37.07, y=47.79, map="Thelsamar" },
                    npc = { name="Brock Stoneseeker" },
                    note="Brock Stoneseeker in Thelsamar (37.07, 47.79)"
                },

                {
                    type="TRAVEL",
                    title="Algaz Station |OID|1338|",
                    coords={ x=24.79, y=18.4, map="Loch Modan" },
                    note="Travel to Algaz Station (24.79, 18.40)"
                },

                {
                    type="TURNIN",
                    title="Mountaineer Stormpike's Task",
                    questId=1339,
                    coords={ x=24.79, y=18.4, map="Algaz Station" },
                    npc = { name="Mountaineer Stormpike" },
                    note="Mountaineer Stormpike in Algaz Station (24.79, 18.40)"
                },

                {
                    type="ACCEPT",
                    title="Stormpike's Order",
                    questId=1338,
                    coords={ x=24.79, y=18.4, map="Algaz Station" },
                    npc = { name="Mountaineer Stormpike" },
                    note="Mountaineer Stormpike in Algaz Station (24.79, 18.40)"
                },

                {
                    type="TRAVEL",
                    title="Thelsamar",
                    questId=6391,
                    coords={ x=33.88, y=50.95, map="Loch Modan" },
                    note="Travel to Thelsamar (33.88, 50.95)"
                },

                {
                    type="TURNIN",
                    title="Honor Students",
                    questId=6387,
                    coords={ x=33.88, y=50.95, map="Thelsamar" },
                    npc = { name="Thorgrum Borrelson" },
                    note="Thorgrum Borrelson in Thelsamar (33.88, 50.95)"
                },

                {
                    type="ACCEPT",
                    title="Ride to Ironforge",
                    questId=6391,
                    coords={ x=33.88, y=50.95, map="Thelsamar" },
                    npc = { name="Thorgrum Borrelson" },
                    note="Thorgrum Borrelson in Thelsamar (33.88, 50.95)"
                },

                {
                    type="TRAVEL",
                    title="The Great Forge",
                    questId=6388,
                    coords={ x=51.5, y=26.3, map="Ironforge" },
                    note="Travel to The Great Forge (51.50, 26.30)"
                },

                {
                    type="TURNIN",
                    title="Ride to Ironforge",
                    questId=6391,
                    coords={ x=51.5, y=26.3, map="Ironforge" },
                    note="Golnir Bouldertoe in The Great Forge (51.50, 26.30)"
                },

                {
                    type="ACCEPT",
                    title="Gryth Thurden",
                    questId=6388,
                    coords={ x=51.3, y=27.89, map="Ironforge" },
                    note="Golnir Bouldertoe in The Great Forge (51.30, 27.89)"
                },

                {
                    type="TURNIN",
                    title="Gryth Thurden",
                    questId=6388,
                    coords={ x=55.48, y=47.87, map="Ironforge" },
                    npc = { name="Gryth Thurden" },
                    note="Gryth Thurden in The Great Forge (55.48, 47.87)"
                },

                {
                    type="ACCEPT",
                    title="Return to Brock",
                    questId=6392,
                    coords={ x=55.48, y=47.87, map="Ironforge" },
                    npc = { name="Gryth Thurden" },
                    note="Gryth Thurden in The Great Forge (55.48, 47.87)"
                },

                {
                    type="TRAVEL",
                    title="Thelsamar |TID|6392|",
                    coords={ x=37.07, y=47.79, map="Loch Modan" },
                    note="Travel to Thelsamar (37.07, 47.79)"
                },

                {
                    type="TURNIN",
                    title="Return to Brock",
                    questId=6392,
                    coords={ x=37.07, y=47.79, map="Thelsamar" },
                    npc = { name="Brock Stoneseeker" },
                    note="Brock Stoneseeker in Thelsamar (37.07, 47.79)"
                },

                {
                    type="Note",
                    title="Guide Complete",
                    note="Tick to continue to the next guide"
                }

            }},
        }}
    }},
}}