-- =========================
-- guide_alliance_1_20.lua
-- Campaign guide with chapters: Teldrassil 1–12 → Darkshore 12–20
-- Turtle/Vanilla 1.12, QuestShell chapters-ready format
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["Alliance 1-20"] = {
    title    = "Alliance 1–20",
    minLevel = 1,
    maxLevel = 20,

    chapters = {

        -- ---------------------
        -- Chapter 1: Teldrassil 1–12
        -- ---------------------
        {
            id       = "teldrassil-1-12",
            title    = "Teldrassil",
            zone     = "Teldrassil",
            minLevel = 1,
            maxLevel = 12,

            steps = {
                -- Balance of Nature (part 1)
                { type="ACCEPT", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="From Conservator Ilthalaine, Shadowglen." },

                { type="COMPLETE", title="The Balance of Nature", questId=456,
                  coords={ x=61.0, y=43.0, map="Teldrassil" },
                  note="Kill Young Nightsaber and Young Thistle Boar",
                  objectives = {
                    { kind="kill" },  -- “Young Nightsaber slain: 0/7”
                    { kind="kill" },  -- “Young Thistle Boar slain: 0/4”
                  } 
                },

                { type="TURNIN", title="The Balance of Nature", questId=456,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="Back to Ilthalaine." },

                -- Balance of Nature (part 2)
                { type="ACCEPT",   title="The Balance of Nature", questId=457,
                  coords={ x=58.7, y=44.4, map="Teldrassil" },
                  npc = { name="Conservator Ilthalaine" },
                  note="Follow-up from Ilthalaine." },

                { type="COMPLETE", title="The Balance of Nature", questId=457,
                  coords={ x=60.5, y=38.5, map="Teldrassil" },
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar north of Shadowglen." },

                { type="TURNIN",   title="The Balance of Nature", questId=457,
                  coords={ x=58.7, y=44.4, map="Teldrassil" } },

                -- Shadowglen → exit errands (example extra)
                { type="ACCEPT",   title="A Good Friend",
                  coords={ x=57.7, y=45.0, map="Teldrassil" },
                  note="From Dirania Silvershine near the road." },

                { type="COMPLETE", title="A Good Friend",
                  coords={ x=54.6, y=33.0, map="Teldrassil" },
                  note="Find Iverron northwest in the glade." },

                { type="TURNIN",   title="A Good Friend",
                  coords={ x=54.6, y=33.0, map="Teldrassil" } },

                -- Hand-off to Dolanaar (travel as part of a COMPLETE)
                { type="COMPLETE", title="Move to Dolanaar",
                  coords={ x=55.5, y=57.0, map="Teldrassil" },
                  note="Head south to Dolanaar and set your hearth." },

                -- Example Dolanaar quest to mark chapter end
                { type="ACCEPT",   title="The Road to Darnassus",
                  coords={ x=55.7, y=59.8, map="Teldrassil" },
                  note="From Sentinel Arynia Cloudsbreak in Dolanaar." },

                { type="COMPLETE", title="The Road to Darnassus",
                  coords={ x=49.0, y=44.0, map="Teldrassil" },
                  note="Patrol the road and deal with Furbolg threats." },

                { type="TURNIN",   title="The Road to Darnassus",
                  coords={ x=55.7, y=59.8, map="Teldrassil" },
                  note="Back in Dolanaar. This concludes the Teldrassil intro." },
            },
        },

        -- ---------------------
        -- Chapter 2: Darkshore 12–20 (sample)
        -- Titles only; questIds optional. Add/adjust as you like.
        -- ---------------------
        {
            id       = "darkshore-12-20",
            title    = "Darkshore",
            zone     = "Darkshore",
            minLevel = 12,
            maxLevel = 20,

            steps = {
                -- Arrival
                { type="COMPLETE", title="Arrive in Auberdine",
                  coords={ x=36.3, y=45.6, map="Darkshore" },
                  note="Boat from Rut'theran to Auberdine. Set hearth." },

                -- Washed Ashore (intro chain)
                { type="ACCEPT",   title="Washed Ashore",
                  coords={ x=37.0, y=44.1, map="Darkshore" },
                  note="From the questgiver near the docks." },

                { type="COMPLETE", title="Washed Ashore",
                  coords={ x=36.5, y=50.6, map="Darkshore" },
                  note="Loot the Beached Sea Creature along the coast south of Auberdine." },

                { type="TURNIN",   title="Washed Ashore",
                  coords={ x=37.0, y=44.1, map="Darkshore" } },

                -- Buzzbox (sample)
                { type="ACCEPT",   title="Buzzbox 827",
                  coords={ x=36.6, y=46.3, map="Darkshore" },
                  note="From the Buzzbox on the beach east of Auberdine." },

                { type="COMPLETE", title="Buzzbox 827",
                  coords={ x=39.0, y=53.0, map="Darkshore" },
                  note="Collect four crawler legs along the shoreline." },

                { type="TURNIN",   title="Buzzbox 827",
                  coords={ x=36.6, y=46.3, map="Darkshore" } },

                -- Wrap-up
                { type="COMPLETE", title="Reach level 14+",
                  coords={ x=37.0, y=44.0, map="Darkshore" },
                  note="Grind/quests around Auberdine to prep for further chapters." },
            },
        },
    },
}