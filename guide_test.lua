-- =========================
-- guide_test.lua
-- Small “Test” guide to exercise all step types including TRAVEL and USE_ITEM.
-- Keep titles/levels consistent with in-game data for best auto-matching.
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["Test"] = {
    title    = "Test",
    minLevel = 1,
    maxLevel = 10,

    chapters = 
    {    
        {
            id       = "Test-New",
            title    = "Test-New",
            zone     = "Test",
            minLevel = 1,
            maxLevel = 6,

            steps = {
                              -- The Woodland Protector (part 1)


                { 
                  type="ACCEPT", 
                  title="Test Quest 1", 
                  questId=123,                
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  npc = { name="Melithar Staghelm" },
                  note="From Melithar Staghelm, Shadowglen."
                },

                { 
                  type="ACCEPT", 
                  title="Test Quest 2", 
                  questId=124,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  npc = { name="Melithar Staghelm" },
                  note="From Melithar Staghelm, Shadowglen."
                },

                -- Travel example: arrive near a spot (radius defaults to 0.3)
                {
                  type="TRAVEL",
                  title="Run to the Well",
                  coords={ x=60.2, y=42.6, map="Teldrassil" },
                  radius=0.35,
                  note="Head to the Moonwell north of the starting area."
                },

                -- Balance of Nature (part 1)
                { 
                  type="ACCEPT", 
                  title="The Balance of Nature", 
                  questId=456,
                  level=2,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  npc = { name="Conservator Ilthalaine" },
                  note="From Conservator Ilthalaine, Shadowglen." 
                },

                { 
                  type="ACCEPT", 
                  title="Test Quest 3", 
                  questId=124,
                  level=1,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  npc = { name="Melithar Staghelm" },
                  note="From Melithar Staghelm, Shadowglen."
                },

                -- Travel example: arrive near a spot (radius defaults to 0.3)
                {
                  type="TRAVEL",
                  title="Run to the Well 2",
                  coords={ x=60.2, y=42.6, map="Teldrassil" },
                  radius=0.35,
                  level=1,
                  note="Head to the Moonwell north of the starting area."
                },
            }
        },

        {
            id       = "Test",
            title    = "Test",
            zone     = "Test",
            minLevel = 1,
            maxLevel = 12,

            steps = {

                                -- The Woodland Protector (part 1)
                { 
                  type="ACCEPT", 
                  title="The Woodland Protector", 
                  questId=111,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  level=1,
                  npc = { name="Melithar Staghelm" },
                  note="From Melithar Staghelm, Shadowglen."
                },

                -- Travel example: arrive near a spot (radius defaults to 0.3)
                {
                  type="TRAVEL",
                  title="Run to the Well",
                  coords={ x=60.2, y=42.6, map="Teldrassil" },
                  radius=0.35,
                  note="Head to the Moonwell north of the starting area."
                },

                -- Balance of Nature (part 1)
                { 
                  type="ACCEPT", 
                  title="The Balance of Nature", 
                  questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  level=2,
                  npc = { name="Conservator Ilthalaine" },
                  note="From Conservator Ilthalaine, Shadowglen." 
                },

                { type="COMPLETE", title="The Balance of Nature", questId=456,
                  coords={ x=61.0, y=43.0, map="Teldrassil" },
                  note="Kill Young Nightsaber and Young Thistle Boar",
                  level=2,
                  objectives = {
                    { kind="kill", label="Young Nightsaber", target=7 },
                    { kind="kill", label="Young Thistle Boar", target=4 }
                  } 
                },

                { type="TURNIN", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  level=2,
                  note="Back to Ilthalaine." 
                },

                -- Balance of Nature (part 2)
                { 
                  type="ACCEPT",   title="The Balance of Nature", questId=457,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  level=3,
                  npc = { name="Conservator Ilthalaine" },
                  note="Follow-up from Ilthalaine." 
                },

                { type="COMPLETE", title="The Balance of Nature", questId=457,
                  coords={ x=60.5, y=38.5, map="Teldrassil" },
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar north of Shadowglen.",
                  level=2,
                  objectives = {
                      { kind="kill", label="Mangy Nightsaber", target=7 },
                      { kind="kill", label="Thistle Boar", target=7 }                   
                  }  
                },              

                -- USE_ITEM example: Hearthstone (no target required)
                {
                  type="USE_ITEM",
                  title="Hearth back to Shadowglen",
                  itemId=6948,                 -- Hearthstone
                  itemName="Hearthstone",      -- UI label
                  note="Use your Hearthstone."
                },

                -- USE_ITEM with target requirement example (imaginary item)
                {
                  type="USE_ITEM",
                  title="Use Flask at Ilthalaine",
                  itemId=99999,
                  itemName="Moonwell Flask",
                  npc = { name="Conservator Ilthalaine" }, -- must be selected when using
                  note="Target Ilthalaine and use the Moonwell Flask."
                },

                { type="TURNIN", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  level=2,
                  note="Back to Ilthalaine." }
            },
        }
    },
}
