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
            id       = "Test",
            title    = "Test",
            zone     = "Test",
            minLevel = 1,
            maxLevel = 12,

            steps = {

                -- ACCEPT always has a quest title, questId, coords, and an npc
                {                              
                  type="ACCEPT", 
                  title="The Woodland Protector", 
                  questId=111,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },                
                  npc = { name="Melithar Staghelm" },
                  note="From Melithar Staghelm, Shadowglen."
                },

                -- Every type can also have a property class.
                {
                  type="ACCEPT",
                  title="Etched Sigil",
                  questId=3117,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="HUNTER",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                -- TRAVEL always has coords
                {
                  type="TRAVEL",
                  title="Run to the Well",
                  coords={ x=60.2, y=42.6, map="Teldrassil" },
                  note="Head to the Moonwell north of the starting area."
                },

                { 
                  type="ACCEPT", 
                  title="The Balance of Nature", 
                  questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="From Conservator Ilthalaine, Shadowglen." 
                },
                
                {
                  type="Note",
                  title="Just some note",
                  note="Be careful when fighting this boss"
                },

                -- COMPLETE always has the title, questiD, coords and objectives
                -- Objectives have the kind (kill, loot, use_item) and always a label
                -- kill and loot objectives always have a target (amount)
                -- use_item always has the itemId
                { type="COMPLETE", title="The Balance of Nature", questId=456,
                  coords={ x=61.0, y=43.0, map="Teldrassil" },
                  note="Kill Young Nightsaber and Young Thistle Boar",
                  objectives = {
                    { kind="kill", label="Young Nightsaber", target=7 },
                    { kind="kill", label="Young Thistle Boar", target=4 }
                  } 
                },

                -- TURNIN always has a title, a questid, coords, and either an npc with a name.
                -- the npc can also be an object , like a door or a keg for example (but its not an item)
                { type="TURNIN", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="Back to Ilthalaine." 
                },

                { 
                  type="ACCEPT",   title="The Balance of Nature", questId=457,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="Follow-up from Ilthalaine." 
                },

                { 
                  type="COMPLETE", title="The Balance of Nature", questId=457,
                  coords={ x=60.5, y=38.5, map="Teldrassil" },
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar north of Shadowglen.",
                  objectives = {
                      { kind="kill", label="Mangy Nightsaber", target=7 },
                      { kind="kill", label="Thistle Boar", target=7 }                   
                  }  
                },              

                -- USE_ITEM always has an itemId nad itemName
                {
                  type="USE_ITEM",
                  title="Hearth back to Shadowglen",
                  itemId=6948,
                  itemName="Hearthstone",
                  note="Use your Hearthstone."
                },

                { 
                  type="COMPLETE", title="The Balance of Nature", questId=457,
                  coords={ x=60.5, y=38.5, map="Teldrassil" },
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar north of Shadowglen.",
                  objectives = {
                      { kind="kill", label="Mangy Nightsaber", target=7 },
                      { kind="kill", label="Thistle Boar", target=7 }                   
                  }  
                },  

                -- Notes always have a title and a note
                {
                  type="Note",
                  title="Level 10 Required",
                  note="Grind to level 10 so you can pick up class quests before heading to Darnassus"
                },

                -- Example of a complete type with objective use_item
                -- Always has the label (name of the item) and the itemId as well as coords.
                {
                  type="COMPLETE",
                  title="Crown of the Earth",
                  questId=933,
                  coords={ x=60.5, y=38.5, map="Teldrassil" },
                  objectives = {                    
                    { kind="use_item", label="Tourmaline Phial", itemId=5621, coords={ x=69.8, y=53.0 } }
                  },
                  note="Target Ilthalaine and use the Moonwell Flask."
                },

                -- Objectives themselves also have coords if there is multiple coords and they are per objective
                {
                  type="COMPLETE",
                  title="Ferocitas the Dream Eater",
                  questId=2459,
                  objectives = {                    
                    { kind="kill", label="Gnarlpine Mystic", target=7, coords={ x=69.8, y=53.0 } },
                    { kind="loot", label="Tallonkai's Jewel", target=1, itemId=8050, coords={ x=69.8, y=53.0 } }
                  },
                  note="Kill Ferocitas the Dream Eater north of Starbreeze Village and collect Tallonkai's Jewel (69.8, 53.0)"
                },


                { type="TURNIN", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="Back to Ilthalaine." 
                },

                -- FLY always has an npc and a destination location
                {
                  type="FLY",
                  title="Fly to Rut'theran Village",
                  coords={ x=58.33, y=93.89 },
                  npc = { name="Silva Fil'naveth" },
                  destination = "Rut'theran Village",
                  class="DRUID",
                  note="Speak to Silva Fil'naveth and fly to Rut'theran Village (58.33, 93.89)"
                },

                -- SET_HEARTH is always done with Inkeepers , they have Inkeeper at the start of their name.
                -- For example: Inkeeper Keldamyr
                {
                  type="SET_HEARTH",              
                  title="Set your hearthstone",
                  coords={ x=55.7, y=59.8 },
                  npc = { name="Innkeeper Keldamyr" },
                  note="Speeak to Innkeeper Keldamyr and set hearth in Dolanaar (55.7, 59.8)"
                },
            },
        }
    },
}
