QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["Test"] = {
    title    = "Test",
    minLevel = 1,
    maxLevel = 10,

    chapters = 
    {    
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
                  level=3,
                  objectives = {
                      { kind="kill", label="Mangy Nightsaber", target=7 },
                      { kind="kill", label="Thistle Boar", target=7 }                   
                  }  
                },    
                
                {
                    type="SET_HEARTH",
                    title="Astranaar",
                    questId=929,
                    coords={ x=36.6, y=49.3, map="Astranaar" },
                    npc = { name="Innkeeper Kimlya" },
                    note="Speak to Innkeeper Kimlya and set hearth in Astranaar (36.6, 59.8)"
                },

                {
                    type="COMPLETE",
                    title="Hearth back to Shadowglen",
                    questId=921,
                    coords={ x=59.9, y=33.1, map="Shadowglen" },
                    objectives = {
                        { kind="use_item", label="Hearthstone", itemId=6948 }
                    },
                    note="Use your Hearthstone"
                },

                {
                    type="COMPLETE",
                    title="Hearth back to Shadowgle Test",
                    questId=921,
                    coords={ x=59.9, y=33.1, map="Shadowglen" },
                    objectives = {
                        { kind="use_item", label="Hearthstone"}
                    },
                    note="Use your Hearthstone Test"
                },

                {
                    type="COMPLETE",
                    title="Eat some food",
                    objectives = {
                        { kind="use_item", label="Tough Jerky"}
                    },
                    note="Eat some jerky !"
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
