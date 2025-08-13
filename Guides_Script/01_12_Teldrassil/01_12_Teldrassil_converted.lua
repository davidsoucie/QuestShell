-- =========================
-- Teldrassil (1-12)
-- Converted from TourGuide format
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["Teldrassil (1-12)"] = {
    title    = "Teldrassil (1-12)",
    minLevel = 1,
    maxLevel = 60,

    chapters =
    {
        {
            id       = "Teldrassil (1-12)",
            title    = "Teldrassil (1-12)",
            zone     = "Unknown",
            minLevel = 1,
            maxLevel = 60,

            steps = {

                {
                  type="ACCEPT",
                  title="The Balance of Nature",
                  questId=456,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="COMPLETE",
                  title="The Balance of Nature",
                  questId=456,
                  objectives = {
                    { kind="kill", label="Young Nightsaber", target=7, coords={ x=61.0, y=43.0 } },
                    { kind="kill", label="Young Thistle Boar", target=4, coords={ x=61.0, y=43.0 } }
                  },
                  note="Kill 7 Young Nightsaber and 4 Young Thistle Boar in Shadowglen (61, 43)"
                },

                {
                  type="TURNIN",
                  title="The Balance of Nature",
                  questId=456,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="The Balance of Nature",
                  questId=457,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="Encrypted Sigil",
                  questId=3118,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="ROGUE",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="Etched Sigil",
                  questId=3117,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="HUNTER",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="Hallowed Sigil",
                  questId=3119,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="PRIEST",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="Simple Sigil",
                  questId=3116,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="WARRIOR",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="ACCEPT",
                  title="Verdant Sigil",
                  questId=3120,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  class="DRUID",
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="TURNIN",
                  title="Encrypted Sigil",
                  questId=3118,
                  coords={ x=59.62, y=38.69 },
                  npc = { name="Frahun Shadewhisper" },
                  class="ROGUE",
                  note="Frahun Shadewhisper in Aldrassil (59.62, 38.69)"
                },

                {
                  type="TURNIN",
                  title="Etched Sigil",
                  questId=3117,
                  coords={ x=58.6, y=40.5 },
                  npc = { name="Ayanna Everstride" },
                  class="HUNTER",
                  note="Ayanna Everstride in Aldrassil (58.6, 40.5)"
                },

                {
                  type="TURNIN",
                  title="Hallowed Sigil",
                  questId=3119,
                  coords={ x=59.2, y=40.5 },
                  npc = { name="Shanda" },
                  class="PRIEST",
                  note="Shanda in Aldrassil (59.2, 40.5)"
                },

                {
                  type="TURNIN",
                  title="Simple Sigil",
                  questId=3116,
                  coords={ x=59.6, y=38.5 },
                  npc = { name="Alyissia" },
                  class="WARRIOR",
                  note="Alyissia in Aldrassil (59.6, 38.5)"
                },

                {
                  type="TURNIN",
                  title="Verdant Sigil",
                  questId=3120,
                  coords={ x=58.6, y=40.4 },
                  npc = { name="Mardant Strongoak" },
                  class="DRUID",
                  note="Mardant Strongoak in Aldrassil (58.6, 40.4)"
                },

                {
                  type="Note",
                  title="As you go...",
                  questId=457,
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar in Shadowglen"
                },

                {
                  type="ACCEPT",
                  title="The Woodland Protector",
                  questId=458,
                  coords={ x=59.9, y=42.51 },
                  npc = { name="Melithar Staghelm" },
                  note="Melithar Staghelm in Aldrassil (59.90, 42.51)"
                },

                {
                  type="ACCEPT",
                  title="A Good Friend",
                  questId=4495,
                  coords={ x=60.83, y=42.01 },
                  npc = { name="Dirania Silvershine" },
                  note="Dirania Silvershine in Shadowglen (60.83, 42.01)"
                },

                {
                  type="TURNIN",
                  title="The Woodland Protector",
                  questId=458,
                  coords={ x=57.75, y=45.21 },
                  npc = { name="Tarindrella" },
                  note="Tarindrella in Shadowglen (57.75, 45.21)"
                },

                {
                  type="ACCEPT",
                  title="The Woodland Protector",
                  questId=459,
                  coords={ x=57.75, y=45.21 },
                  npc = { name="Tarindrella" },
                  note="Tarindrella in Shadowglen (57.75, 45.21)"
                },

                {
                  type="COMPLETE",
                  title="The Woodland Protector",
                  questId=459,
                  objectives = {
                    { kind="loot", label="Fel Moss", target=8, itemId=5168, coords={ { x=56.0, y=45.9 }, { x=61.2, y=45.9 }, { x=56.4, y=41.6 } } }
                  },
                  note="Kill Grell located in Shadowglen and collect 8 Fel Moss (56, 45.9) (61.2, 45.9) (56.4, 41.6)"
                },

                {
                  type="TURNIN",
                  title="The Woodland Protector",
                  questId=459,
                  coords={ x=57.75, y=45.21 },
                  npc = { name="Tarindrella" },
                  note="Tarindrella in Shadowglen (57.75, 45.21)"
                },

                {
                  type="ACCEPT",
                  title="Webwood Venom",
                  questId=916,
                  coords={ x=57.81, y=41.63 },
                  npc = { name="Gilshalan Windwalker" },
                  note="Gilshalan Windwalker in Aldrassil (57.81, 41.63)"
                },

                {
                  type="COMPLETE",
                  title="The Balance of Nature",
                  questId=457,
                  objectives = {
                    { kind="kill", label="Mangy Nightsaber", target=7, coords={ x=60.0, y=37.0 } },
                    { kind="kill", label="Thistle Boar", target=7, coords={ x=60.0, y=37.0 } }
                  },
                  note="Kill 7 Mangy Nightsaber and 7 Thistle Boar in Shadowglen (60, 37)"
                },

                {
                  type="COMPLETE",
                  title="Webwood Venom",
                  questId=916,
                  objectives = {
                    { kind="loot", label="Webwood Venom Sac", target=10, itemId=5166, coords={ x=57.0, y=34.0 } }
                  },
                  note="Kill Webwood Spider in the north of Shadowglen and collect 10 Webwood Venom Sac (57, 34)"
                },

                {
                  type="TURNIN",
                  title="A Good Friend",
                  questId=4495,
                  coords={ x=54.6, y=32.98 },
                  npc = { name="Iverron" },
                  note="Iverron in Shadowglen (54.60, 32.98)"
                },

                {
                  type="ACCEPT",
                  title="A Friend in Need",
                  questId=3519,
                  coords={ x=54.6, y=32.98 },
                  npc = { name="Iverron" },
                  note="Iverron in Shadowglen (54.60, 32.98)"
                },

                {
                  type="TURNIN",
                  title="Webwood Venom",
                  questId=916,
                  coords={ x=57.81, y=41.63 },
                  npc = { name="Gilshalan Windwalker" },
                  note="Gilshalan Windwalker in Aldrassil (57.81, 41.63)"
                },

                {
                  type="ACCEPT",
                  title="Webwood Egg",
                  questId=917,
                  coords={ x=57.81, y=41.63 },
                  npc = { name="Gilshalan Windwalker" },
                  note="Gilshalan Windwalker in Aldrassil (57.81, 41.63)"
                },

                {
                  type="TURNIN",
                  title="The Balance of Nature",
                  questId=457,
                  coords={ x=58.69, y=44.35 },
                  npc = { name="Conservator Ilthalaine" },
                  note="Conservator Ilthalaine in Shadowglen (58.69, 44.35)"
                },

                {
                  type="TURNIN",
                  title="A Friend in Need",
                  questId=3519,
                  coords={ x=60.84, y=41.98 },
                  npc = { name="Dirania Silvershine" },
                  note="Dirania Silvershine in Shadowglen (60.84, 41.98)"
                },

                {
                  type="ACCEPT",
                  title="Iverron's Antidote",
                  questId=3521,
                  coords={ x=60.84, y=41.98 },
                  npc = { name="Dirania Silvershine" },
                  note="Dirania Silvershine in Shadowglen (60.84, 41.98)"
                },

                {
                  type="COMPLETE",
                  title="Iverron's Antidote",
                  questId=3521,
                  objectives = {
                    { kind="loot", label="Moonpetal Lily", target=4, itemId=5168, coords={ x=57.0, y=37.0 } },
                    { kind="loot", label="Hyacinth Mushroom", target=7, itemId=5167, coords={ x=57.0, y=37.0 } }
                  },
                  note="Collect 4 Moonpetal Lily found around the edge of the pond in Shadowglen (57, 37)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Shadowthread Cave",
                  questId=917,
                  coords={ x=56.8, y=31.65 },
                  note="Enter Shadowthread Cave (56.80, 31.65)"
                },

                {
                  type="COMPLETE",
                  title="Webwood Egg",
                  questId=917,
                  objectives = {
                    { kind="loot", label="Webwood Egg", target=1, itemId=5169, coords={ { x=56.82, y=27.35 }, { x=55.85, y=24.93 }, { x=56.65, y=26.48 } } }
                  },
                  note="Follow the path inside Shadowthread Cave and collect Webwood Egg near the giant spider (56.82, 27.35) (55.85, 24.93) (56.65, 26.48)"
                },

                {
                  type="COMPLETE",
                  title="Iverron's Antidote",
                  questId=3521,
                  objectives = {
                    { kind="loot", label="Webwood Ichor", target=1, itemId=5166, coords={ x=57.31, y=34.25 } }
                  },
                  note="Collect Webwood Ichor from Webwood Spider in Shadowglen cave (57.31, 34.25)"
                },

                {
                  type="TURNIN",
                  title="Webwood Egg",
                  questId=917,
                  coords={ x=57.81, y=41.63 },
                  npc = { name="Gilshalan Windwalker" },
                  note="Gilshalan Windwalker in Aldrassil (57.81, 41.63)"
                },

                {
                  type="ACCEPT",
                  title="Tenaron's Summons",
                  questId=920,
                  coords={ x=57.81, y=41.63 },
                  npc = { name="Gilshalan Windwalker" },
                  note="Gilshalan Windwalker in Aldrassil (57.81, 41.63)"
                },

                {
                  type="TURNIN",
                  title="Tenaron's Summons",
                  questId=920,
                  coords={ x=58.19, y=39.04 },
                  note="Go up the path to the top of the tree to find Tenaron Stormgrip in Aldrassil (58.19, 39.04) (59.09, 39.39)"
                },

                {
                  type="ACCEPT",
                  title="Crown of the Earth",
                  questId=921,
                  coords={ x=59.09, y=39.39 },
                  npc = { name="Tenaron Stormgrip" },
                  note="Tenaron Stormgrip in Aldrassil (59.09, 39.39)"
                },

                {
                  type="TURNIN",
                  title="Iverron's Antidote",
                  questId=3521,
                  coords={ x=60.84, y=41.98 },
                  npc = { name="Dirania Silvershine" },
                  note="Dirania Silvershine in Shadowglen (60.84, 41.98)"
                },

                {
                  type="ACCEPT",
                  title="Iverron's Antidote",
                  questId=3522,
                  coords={ x=60.84, y=41.98 },
                  npc = { name="Dirania Silvershine" },
                  note="Dirania Silvershine in Shadowglen (60.84, 41.98)"
                },

                {
                  type="USE_ITEM",
                  title="Crown of the Earth",
                  questId=921,
                  coords={ x=59.9, y=33.1 },
                  itemId=5185,
                  note="Use the Crystal Phial at the moonwell in Shadowglen (59.9, 33.1)"
                },

                {
                  type="TURNIN",
                  title="Iverron's Antidote",
                  questId=3522,
                  coords={ x=54.6, y=32.98 },
                  npc = { name="Iverron" },
                  note="Iverron in Shadowglen. Note: You've got 5 minutes to reach Iverron and turn in the quest. Watch the timer (54.60, 32.98)"
                },

                {
                  type="TURNIN",
                  title="Crown of the Earth",
                  questId=921,
                  coords={ x=58.19, y=39.04 },
                  npc = { name="Tenaron Stormgrip" },
                  note="Tenaron Stormgrip in Aldrassil (58.19, 39.04) (59.09, 39.39)"
                },

                {
                  type="ACCEPT",
                  title="Crown of the Earth",
                  questId=928,
                  coords={ x=59.09, y=39.39 },
                  npc = { name="Tenaron Stormgrip" },
                  note="Tenaron Stormgrip in Aldrassil (59.09, 39.39)"
                },

                {
                  type="ACCEPT",
                  title="Dolanaar Delivery",
                  questId=2159,
                  coords={ x=61.2, y=47.71 },
                  npc = { name="Porthannius" },
                  note="Porthannius in Shadowglen (61.20, 47.71)"
                },

                {
                  type="ACCEPT",
                  title="Zenn's Bidding",
                  questId=488,
                  coords={ x=60.41, y=56.26 },
                  npc = { name="Zenn Foulhoof" },
                  note="Zenn Foulhoof in Dolanaar (60.41, 56.26)"
                },

                {
                  type="Note",
                  title="As you go...",
                  questId=488,
                  note="Kill these scarce mobs as you go, it takes a long time to complete"
                },

                {
                  type="COMPLETE",
                  title="Zenn's Bidding",
                  questId=488,
                  objectives = {
                    { kind="loot", label="Nightsaber Fang", target=3, itemId=3409 },
                    { kind="loot", label="Strigid Owl Feather", target=3, itemId=3411 },
                    { kind="loot", label="Webwood Spider Silk", target=3, itemId=3412 }
                  },
                  note="Kill Nightsabers to collect fangs"
                },

                {
                  type="TRAVEL",
                  title="Travel to Lake Al'Ameth",
                  questId=918,
                  coords={ x=60.91, y=68.45 },
                  note="Travel to Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="Denalan's Earth",
                  questId=997,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="ACCEPT",
                  title="Timberling Seeds",
                  questId=918,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="ACCEPT",
                  title="Timberling Sprouts",
                  questId=919,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="COMPLETE",
                  title="Crown of the Earth",
                  questId=929,
                  coords={ x=63.37, y=58.09 },
                  itemId=5619,
                  objectives = {
                    { kind="use_item", label="Jade Phial", itemId=5619, coords={ x=68.0, y=59.6 } }
                  },                  
                  note="Use Jade Phial at the moonwell in Starbreeze Village (63.37, 58.09)"
                },

                {
                  type="TURNIN",
                  title="A Troubling Breeze",
                  questId=475,
                  coords={ x=66.27, y=58.57 },
                  npc = { name="Gaerolas Talvethren" },
                  note="Gaerolas Talvethren in Starbreeze Village (66.27, 58.57)"
                },

                {
                  type="ACCEPT",
                  title="Gnarlpine Corruption",
                  questId=476,
                  coords={ x=66.27, y=58.57 },
                  npc = { name="Gaerolas Talvethren" },
                  note="Gaerolas Talvethren in Starbreeze Village (66.27, 58.57)"
                },

                {
                  type="ACCEPT",
                  title="The Emerald Dreamcatcher",
                  questId=2438,
                  coords={ x=55.5, y=56.9 },
                  npc = { name="Tallonkai Swiftroot" },
                  note="Tallonkai Swiftroot at the top of the tower in Dolanaar (55.5, 56.9)"
                },

                {
                  type="COMPLETE",
                  title="The Emerald Dreamcatcher",
                  questId=2438,
                  objectives = {
                    { kind="loot", label="Emerald Dreamcatcher", target=1, itemId=8048, coords={ x=68.0, y=59.6 } }
                  },
                  note="Click on Tallonkai's Dresser and collect the Emerald Dreamcatcher (68.0, 59.6)"
                },

                {
                  type="Note",
                  title="As you go...",
                  questId=488,
                  note="Kill these scarce mobs as you go for the quest 'Zenn's Bidding', it takes a long time to collect all the items required"
                },

                {
                  type="COMPLETE",
                  title="Zenn's Bidding",
                  questId=488,
                  objectives = {
                    { kind="loot", label="Nightsaber Fang", target=3, itemId=3409 },
                    { kind="loot", label="Strigid Owl Feather", target=3, itemId=3411 },
                    { kind="loot", label="Webwood Spider Silk", target=3, itemId=3412 }
                  },
                  note="Kill Nightsabers, Strigid Owls and Webwood Spiders to collect the items"
                },

                {
                  type="TRAVEL",
                  title="Travel to Dolanaar",
                  questId=929,
                  coords={ x=55.7, y=59.8 },
                  note="Travel to Dolanaar (55.7, 59.8)"
                },

                {
                  type="TURNIN",
                  title="Dolanaar Delivery",
                  questId=2159,
                  coords={ x=55.7, y=59.8 },
                  npc = { name="Innkeeper Keldamyr" },
                  note="Innkeeper Keldamyr in Dolanaar (55.7, 59.8)"
                },

                {
                  type="SET_HEARTH",
                  title="Set your hearthstone",
                  questId=929,
                  coords={ x=55.7, y=59.8 },
                  npc = { name="Innkeeper Keldamyr" },
                  note="Speeak to Innkeeper Keldamyr and set hearth in Dolanaar (55.7, 59.8)"
                },

                {
                  type="TURNIN",
                  title="Crown of the Earth",
                  questId=929,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="ACCEPT",
                  title="Crown of the Earth",
                  questId=933,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="TURNIN",
                  title="Gnarlpine Corruption",
                  questId=476,
                  coords={ x=55.95, y=57.28 },
                  npc = { name="Athridas Bearmantle" },
                  note="Athridas Bearmantle in Dolanaar (55.95, 57.28)"
                },

                {
                  type="ACCEPT",
                  title="The Relics of Wakening",
                  questId=483,
                  coords={ x=55.95, y=57.28 },
                  npc = { name="Athridas Bearmantle" },
                  note="Athridas Bearmantle in Dolanaar (55.95, 57.28)"
                },

                {
                  type="TURNIN",
                  title="The Emerald Dreamcatcher",
                  questId=2438,
                  coords={ x=55.5, y=56.9 },
                  npc = { name="Tallonkai Swiftroot" },
                  note="Tallonkai Swiftroot at the top of the tower in Dolanaar (55.5, 56.9)"
                },

                {
                  type="ACCEPT",
                  title="Ferocitas the Dream Eater",
                  questId=2459,
                  coords={ x=55.5, y=56.9 },
                  npc = { name="Tallonkai Swiftroot at the" },
                  note="Tallonkai Swiftroot at the top of the tower in Dolanaar (55.5, 56.9)"
                },

                {
                  type="COMPLETE",
                  title="Timberling Seeds",
                  questId=918,
                  objectives = {
                    { kind="loot", label="Timberling Seed", target=8, itemId=5170, coords={ { x=59.0, y=72.0 }, { x=56.0, y=65.0 } } }
                  },
                  note="Kill Timberling around Lake Al'Ameth and collect 8 Timberling Seed (59, 72) (56, 65)"
                },

                {
                  type="COMPLETE",
                  title="Timberling Sprouts",
                  questId=919,
                  objectives = {
                    { kind="loot", label="Timberling Sprout", target=12, itemId=5171, coords={ x=59.0, y=71.0 } }
                  },
                  note="Collect 12 Timberling Sprout from the ground around Lake Al'Ameth (59, 71)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Dolanaar",
                  coords={ x=56.2, y=61.63 },
                  note="Travel to Dolanaar (56.20, 61.63)"
                },

                {
                  type="TURNIN",
                  title="Crown of the Earth",
                  questId=933,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="ACCEPT",
                  title="Crown of the Earth",
                  questId=7383,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="TURNIN",
                  title="The Relics of Wakening",
                  questId=483,
                  coords={ x=55.95, y=57.28 },
                  npc = { name="Athridas Bearmantle" },
                  note="Athridas Bearmantle in Dolanaar (55.95, 57.28)"
                },

                {
                  type="ACCEPT",
                  title="Ursal the Mauler",
                  questId=486,
                  coords={ x=55.95, y=57.28 },
                  npc = { name="Athridas Bearmantle" },
                  note="Athridas Bearmantle in Dolanaar (55.95, 57.28)"
                },

                {
                  type="TURNIN",
                  title="Seek Redemption!",
                  questId=489,
                  coords={ x=60.41, y=56.26 },
                  npc = { name="Zenn Foulhoof" },
                  note="Zenn Foulhoof in Teldrassil (60.41, 56.26)"
                },

                {
                  type="Note",
                  title="Train (spell:2366)",
                  questId=6121,
                  class="DRUID",
                  zone="TELDRASSIL",
                  note="Highly recommend as a Druid that you train (spell:2366) from Malorne Bladeleaf, you will need it to gather 5 Earthroot for your level 14 class quest. Note: You need level 15 (spell:2366) to gather Earthroot, so level up as you go. Tick this step (57.6, 60.6)"
                },

                {
                  type="Note",
                  title="Level 10 Required",
                  note="Grind to level 10 so you can pick up class quests before heading to Darnassus"
                },

                {
                  type="ACCEPT",
                  title="The Apple Falls",
                  questId=2241,
                  coords={ x=56.36, y=60.17 },
                  npc = { name="Jannok Breezesong" },
                  class="ROGUE",
                  note="Jannok Breezesong in Dolanaar, level 10 required (56.36, 60.17)"
                },

                {
                  type="COMPLETE",
                  title="Destiny Calls",
                  questId=2242,
                  objectives = {
                    { kind="loot", label="Sethir's Journal", target=1, itemId=8050, coords={ x=37.21, y=23.24 } }
                  },
                  class="ROGUE",
                  prerequisites={2241},
                  note="Find Sethir the Ancient north of the The Oracle Glade and use the (spell:921) ability on him from behind while stealth to get his Journal from him (37.21, 23.24)"
                },

                {
                  type="ACCEPT",
                  title="Heeding the Call",
                  questId=5923,
                  coords={ x=55.95, y=61.56 },
                  npc = { name="Kal" },
                  class="DRUID",
                  note="Kal in Dolanaar (55.95, 61.56)"
                },

                {
                  type="ACCEPT",
                  title="Elanaria",
                  questId=1684,
                  coords={ x=56.2, y=59.2 },
                  npc = { name="Kyra Windblade" },
                  class="WARRIOR",
                  note="Kyra Windblade in Dolanaar (56.2, 59.2)"
                },

                {
                  type="ACCEPT",
                  title="Taming the Beast",
                  questId=6063,
                  coords={ x=56.68, y=59.5 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.68, 59.50)"
                },

                {
                  type="COMPLETE",
                  title="Taming the Beast",
                  questId=6063,
                  coords={ x=59.63, y=60.23 },
                  class="HUNTER",
                  itemId=15921,
                  objectives = {
                    { kind="use_item", label="Taming Rod", itemId=15921, coords={ x=68.0, y=59.6 } }
                  },                  
                  note="Use the Taming Rod to tame a Webwood Lurker (59.63, 60.23)"
                },

                {
                  type="TURNIN",
                  title="Taming the Beast",
                  questId=6063,
                  coords={ x=56.69, y=59.5 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.69, 59.50)"
                },

                {
                  type="ACCEPT",
                  title="Taming the Beast",
                  questId=6101,
                  coords={ x=56.8, y=59.86 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.80, 59.86)"
                },

                {
                  type="TURNIN",
                  title="The Road to Darnassus",
                  questId=487,
                  coords={ x=50.0, y=54.0 },
                  npc = { name="Moon Priestess Amara" },
                  note="Moon Priestess Amara, she patrols (50, 54) (55, 58)"
                },

                {
                  type="COMPLETE",
                  title="Taming the Beast",
                  questId=6101,
                  coords={ x=40.14, y=55.88 },
                  class="HUNTER",
                  itemId=15922,
                  objectives = {
                    { kind="use_item", label="Taming Rod", itemId=15922, coords={ x=68.0, y=59.6 } }
                  },   
                  note="Use the Taming Rod to tame a Nightsaber Stalker (40.14, 55.88)"
                },

                {
                  type="TURNIN",
                  title="Taming the Beast",
                  questId=6101,
                  coords={ x=56.67, y=59.48 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.67, 59.48)"
                },

                {
                  type="ACCEPT",
                  title="Taming the Beast",
                  questId=6102,
                  coords={ x=56.67, y=59.48 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.67, 59.48)"
                },

                {
                  type="COMPLETE",
                  title="Taming the Beast",
                  questId=6102,
                  coords={ x=42.57, y=52.31 },
                  class="HUNTER",
                  itemId=15923,
                  objectives = {
                    { kind="use_item", label="Taming Rod", itemId=15923, coords={ x=68.0, y=59.6 } }
                  },   
                  note="Use the Taming Rod to tame a Strigid Screecher (42.57, 52.31)"
                },

                {
                  type="TURNIN",
                  title="Taming the Beast",
                  questId=6102,
                  coords={ x=56.68, y=59.5 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.68, 59.50)"
                },

                {
                  type="ACCEPT",
                  title="Training the Beast",
                  questId=6103,
                  coords={ x=56.41, y=58.57 },
                  npc = { name="Dazalar" },
                  class="HUNTER",
                  note="Dazalar in Dolanaar (56.41, 58.57)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Darnassus",
                  questId=923,
                  coords={ x=27.0, y=55.0 },
                  note="Travel to Darnassus (27, 55)"
                },

                {
                  type="ACCEPT",
                  title="Nessa Shadowsong",
                  questId=6344,
                  coords={ x=70.5, y=43.8, map="Darnassus" },
                  npc = { name="Mydrannul" },
                  race="NIGHT ELF",
                  zone="DARNASSUS",
                  note="Mydrannul in Warrior's Terrace (70.5, 43.8)"
                },

                {
                  type="TURNIN",
                  title="Rellian Greenspyre",
                  questId=922,
                  coords={ x=38.26, y=21.27, map="Darnassus" },
                  npc = { name="Rellian Greenspyre" },
                  zone="DARNASSUS",
                  note="Rellian Greenspyre in Cenarion Enclave (38.26, 21.27)"
                },

                {
                  type="ACCEPT",
                  title="Tumors",
                  questId=923,
                  coords={ x=38.26, y=21.27, map="Darnassus" },
                  npc = { name="Rellian Greenspyre" },
                  zone="DARNASSUS",
                  note="Rellian Greenspyre in Cenarion Enclave (38.26, 21.27)"
                },

                {
                  type="TURNIN",
                  title="The Apple Falls",
                  questId=2241,
                  coords={ x=32.63, y=16.16, map="Darnassus" },
                  npc = { name="Syurna" },
                  class="ROGUE",
                  zone="DARNASSUS",
                  note="Syurna down in the tunnel in Cenarion Enclave (32.63, 16.16) (36.86, 21.88)"
                },

                {
                  type="ACCEPT",
                  title="Destiny Calls",
                  questId=2242,
                  coords={ x=36.86, y=21.88, map="Darnassus" },
                  npc = { name="Syurna" },
                  class="ROGUE",
                  zone="DARNASSUS",
                  note="Syurna down in the tunnel in Cenarion Enclave (36.86, 21.88)"
                },

                {
                  type="ACCEPT",
                  title="The Temple of the Moon",
                  questId=2519,
                  coords={ x=29.0, y=45.5, map="Darnassus" },
                  npc = { name="Sister Aquinne" },
                  zone="DARNASSUS",
                  note="Sister Aquinne in The Temple Gardens (29, 45.5)"
                },

                {
                  type="TURNIN",
                  title="Training the Beast",
                  questId=6103,
                  coords={ x=40.39, y=8.6, map="Darnassus" },
                  npc = { name="Jocaste" },
                  class="HUNTER",
                  zone="DARNASSUS",
                  note="Jocaste in Cenarion Enclave (40.39, 8.60)"
                },

                {
                  type="TURNIN",
                  title="Heeding the Call",
                  questId=5923,
                  coords={ x=35.38, y=8.42, map="Darnassus" },
                  npc = { name="Mathrengyl Bearwalker" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Mathrengyl Bearwalker in Cenarion Enclave (35.38, 8.42)"
                },

                {
                  type="ACCEPT",
                  title="Moonglade",
                  questId=5921,
                  coords={ x=35.38, y=8.42, map="Darnassus" },
                  npc = { name="Mathrengyl Bearwalker" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Mathrengyl Bearwalker in Cenarion Enclave (35.38, 8.42)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Nighthaven",
                  questId=5929,
                  coords={ x=56.23, y=30.6, map="Thunder Bluff" },
                  class="DRUID",
                  zone="THUNDER BLUFF",
                  note="Use (spell:18960) to get to Nighthaven in Moonglade (56.23, 30.60)"
                },

                {
                  type="TURNIN",
                  title="Moonglade",
                  questId=5921,
                  coords={ x=56.24, y=30.64, map="Moonglade" },
                  npc = { name="Dendrite Starblaze" },
                  class="DRUID",
                  zone="MOONGLADE",
                  note="Dendrite Starblaze in Nighthaven (56.24, 30.64)"
                },

                {
                  type="ACCEPT",
                  title="Great Bear Spirit",
                  questId=5929,
                  coords={ x=56.24, y=30.64, map="Moonglade" },
                  npc = { name="Dendrite Starblaze" },
                  class="DRUID",
                  zone="MOONGLADE",
                  note="Dendrite Starblaze in Nighthaven (56.24, 30.64)"
                },

                {
                  type="Note",
                  title="Great Bear Spirit",
                  questId=5929,
                  class="DRUID",
                  zone="MOONGLADE",
                  note="Speak to Great Bear Spirit in Moonglade (39.09, 27.54)"
                },

                {
                  type="TURNIN",
                  title="Great Bear Spirit",
                  questId=5929,
                  coords={ x=56.24, y=30.64, map="Moonglade" },
                  npc = { name="Dendrite Starblaze" },
                  class="DRUID",
                  zone="MOONGLADE",
                  note="Dendrite Starblaze in Nighthaven (56.24, 30.64)"
                },

                {
                  type="ACCEPT",
                  title="Back to Darnassus",
                  questId=5931,
                  coords={ x=56.2, y=30.64, map="Moonglade" },
                  npc = { name="Dendrite Starblaze" },
                  class="DRUID",
                  zone="MOONGLADE",
                  note="Dendrite Starblaze in Nighthaven (56.20, 30.64)"
                },

                {
                  type="FLY",
                  title="Fly to Rut'theran Village",
                  coords={ x=58.33, y=93.89 },
                  npc = { name="Silva Fil'naveth" },
                  destination = "Rut'theran Village",
                  class="DRUID",
                  note="Speak to Silva Fil'naveth and fly to Rut'theran Village (58.33, 93.89)"
                },

                {
                  type="TURNIN",
                  title="Back to Darnassus",
                  questId=5931,
                  coords={ x=34.9, y=8.25, map="Darnassus" },
                  npc = { name="Mathrengyl Bearwalker" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Mathrengyl Bearwalker in Cenarion Enclave (34.90, 8.25)"
                },

                {
                  type="ACCEPT",
                  title="Body and Heart",
                  questId=6001,
                  coords={ x=34.9, y=8.25, map="Darnassus" },
                  npc = { name="Mathrengyl Bearwalker" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Mathrengyl Bearwalker in Cenarion Enclave (34.90, 8.25)"
                },

                {
                  type="TURNIN",
                  title="Elanaria",
                  questId=1684,
                  coords={ x=57.3, y=34.57, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.30, 34.57)"
                },

                {
                  type="ACCEPT",
                  title="Vorlus Vilehoof",
                  questId=1683,
                  coords={ x=57.3, y=34.57, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.30, 34.57)"
                },

                {
                  type="TURNIN",
                  title="The Temple of the Moon",
                  questId=2519,
                  coords={ x=36.55, y=86.11, map="Darnassus" },
                  npc = { name="Priestess A'moora" },
                  zone="DARNASSUS",
                  note="Priestess A'moora in Temple of the Moon (36.55, 86.11)"
                },

                {
                  type="ACCEPT",
                  title="Tears of the Moon",
                  questId=2518,
                  coords={ x=36.55, y=86.11, map="Darnassus" },
                  npc = { name="Priestess A'moora" },
                  zone="DARNASSUS",
                  note="Priestess A'moora in Temple of the Moon (36.55, 86.11)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Teldrassil",
                  questId=923,
                  coords={ x=38.0, y=54.7 },
                  reach=true,
                  note="Travel to Teldrassil (38.0, 54.7)"
                },

                {
                  type="COMPLETE",
                  title="Ursal the Mauler",
                  questId=486,
                  objectives = {
                    { kind="kill", label="Ursal the Mauler", target=1, coords={ x=38.8, y=78.9 } }
                  },
                  note="Kill Ursal the Mauler, consider skipping (x) this quest if the quest rewards Defender Axe or Thornroot Club is useless for your character (38.8, 78.9)"
                },

                {
                  type="COMPLETE",
                  title="Vorlus Vilehoof",
                  questId=1683,
                  objectives = {
                    { kind="loot", label="Horn of Vorlus", target=1, itemId=5182, coords={ { x=49.11, y=61.8 }, { x=48.75, y=62.84 }, { x=49.05, y=65.0 }, { x=47.31, y=63.65 } } }
                  },
                  note="Follow the path up, kill Vorlus Vilehoof and collect Horn of Vorlus near the Moonwell in Teldrassil (49.11, 61.80) (48.75, 62.84) (49.05, 65.00) (47.31, 63.65)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Wellspring River",
                  questId=923,
                  coords={ x=43.65, y=34.46 },
                  note="Travel to Wellspring River (43.65, 34.46)"
                },

                {
                  type="COMPLETE",
                  title="Tumors",
                  questId=923,
                  objectives = {
                    { kind="loot", label="Mossy Tumor", target=5, itemId=5172, coords={ x=43.65, y=34.46 } }
                  },
                  note="Kill Timberling Mire Beast or Timberling Trampler in Wellspring River and collect 5 Mossy Tumor (43.65, 34.46)"
                },

                {
                  type="COMPLETE",
                  title="Oakenscowl",
                  questId=2499,
                  objectives = {
                    { kind="loot", label="Gargantuan Tumor", target=1, itemId=5173, coords={ x=53.55, y=74.99 } }
                  },
                  note="Kill Oakenscowl in Lake Al'Ameth. This is a group quest but can be soloed for good XP but you can safely skip this quest if it's too hard (53.55, 74.99)"
                },

                {
                  type="COMPLETE",
                  title="The Moss-twined Heart",
                  questId=927,
                  optional=true,
                  objectives = {
                    { kind="loot", label="Moss-twined Heart", target=1, itemId=5179, coords={ { x=42.7, y=36.8 }, { x=42.5, y=26.0 } } }
                  },
                  note="Kill Blackmoss the Fetid in Wellspring River. He is a rare NPC, skip if you can't find him (42.7, 36.8) (42.5, 26)"
                },

                {
                  type="TRAVEL",
                  title="Travel to The Oracle Glade",
                  questId=937,
                  coords={ x=38.3, y=34.4 },
                  note="Travel to The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="ACCEPT",
                  title="The Enchanted Glade",
                  questId=937,
                  coords={ x=38.3, y=34.4 },
                  npc = { name="Sentinel Arynia Cloudsbreak" },
                  note="Sentinel Arynia Cloudsbreak in The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="ACCEPT",
                  title="Mist",
                  questId=938,
                  coords={ x=31.54, y=31.61 },
                  npc = { name="Mist" },
                  note="Mist north west of The Oracle Glade (31.54, 31.61)"
                },

                {
                  type="ACCEPT",
                  title="The Shimmering Frond",
                  questId=931,
                  coords={ x=34.8, y=28.9 },
                  npc = { name="Strange Fronded Plant" },
                  note="Strange Fronded Plant in The Oracle Glade (34.8, 28.9)"
                },

                {
                  type="COMPLETE",
                  title="Mist",
                  questId=938,
                  coords={ x=31.4, y=31.6 },
                  note="Escort Mist to Sentinel Arynia Cloudsbreak at the moon well near the Oracle Tree (31.4, 31.6) (38.3, 34.4)"
                },

                {
                  type="COMPLETE",
                  title="The Enchanted Glade",
                  questId=937,
                  objectives = {
                    { kind="loot", label="Bloodfeather Belt", target=6, coords={ x=35.0, y=38.0 } }
                  },
                  note="Kill Bloodfeather mobs and collect 6 Bloodfeather Belt in The Oracle Glade (35, 38)"
                },

                {
                  type="TURNIN",
                  title="Mist",
                  questId=938,
                  coords={ x=38.3, y=34.4 },
                  npc = { name="Sentinel Arynia Cloudsbreak" },
                  note="Sentinel Arynia Cloudsbreak in The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="TURNIN",
                  title="The Enchanted Glade",
                  questId=937,
                  coords={ x=38.3, y=34.4 },
                  npc = { name="Sentinel Arynia Cloudsbreak" },
                  note="Sentinel Arynia Cloudsbreak in The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="ACCEPT",
                  title="Teldrassil",
                  questId=940,
                  coords={ x=38.3, y=34.4 },
                  npc = { name="Sentinel Arynia Cloudsbreak" },
                  note="Sentinel Arynia Cloudsbreak in The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="COMPLETE",
                  title="Ferocitas the Dream Eater",
                  questId=2459,
                  objectives = {                    
                    { kind="kill", label="Gnarlpine Mystic", target=7, itemId=5166, coords={ x=69.8, y=53.0 } },
                    { kind="loot", label="Tallonkai's Jewel", target=1, itemId=8050, coords={ x=69.8, y=53.0 } }
                  },
                  note="Kill Ferocitas the Dream Eater north of Starbreeze Village and collect Tallonkai's Jewel (69.8, 53.0)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Fel Rock",
                  questId=932,
                  coords={ x=53.74, y=53.62 },
                  note="Travel to Fel Rock cave north of Dolanaar (53.74, 53.62) (54.61, 52.62)"
                },

                {
                  type="COMPLETE",
                  title="Twisted Hatred",
                  questId=932,
                  objectives = {
                    { kind="loot", label="Melenas' Head", target=1, itemId=5175, coords={ x=51.27, y=50.77 } }
                  },
                  note="Kill Lord Melenas and collect Melenas' Head in Fel Rock (51.27, 50.77)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Dolanaar",
                  coords={ x=54.61, y=52.62 },
                  note="Exit to Dolanaar (54.61, 52.62) (55.5, 56.9)"
                },

                {
                  type="TURNIN",
                  title="Twisted Hatred",
                  questId=932,
                  coords={ x=55.5, y=56.9 },
                  npc = { name="Tallonkai Swiftroot" },
                  note="Tallonkai Swiftroot at the top of the tower in Dolanaar (55.5, 56.9)"
                },

                {
                  type="TURNIN",
                  title="Ferocitas the Dream Eater",
                  questId=2459,
                  coords={ x=55.5, y=56.9 },
                  npc = { name="Tallonkai Swiftroot" },
                  note="Tallonkai Swiftroot at the top of the tower in Dolanaar (55.5, 56.9)"
                },

                {
                  type="ACCEPT",
                  title="The Road to Darnassus",
                  questId=487,
                  coords={ x=50.0, y=54.0 },
                  npc = { name="Moon Priestess Amara" },
                  note="Moon Priestess Amara in Dolanaar (50, 54) (55, 58)"
                },

                {
                  type="COMPLETE",
                  title="The Road to Darnassus",
                  questId=487,
                  objectives = {
                    { kind="kill", label="Gnarlpine Ambusher", target=6, itemId=5166, coords={ x=45.92, y=52.8 } }
                  },
                  note="Kill 6 Gnarlpine Ambusher in in Ban'ethil Hollow (45.92, 52.80)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Pools of Arlithrien",
                  questId=933,
                  coords={ x=42.37, y=67.12 },
                  note="Travel to Pools of Arlithrien (42.37, 67.12)"
                },

                {
                  type="COMPLETE",
                  title="Crown of the Earth",
                  questId=933,
                  coords={ x=42.37, y=67.12 },
                  itemId=5621,
                  objectives = {
                    { kind="use_item", label="Tourmaline Phial", itemId=5621, coords={ { x=42.7, y=36.8 }, { x=42.5, y=26.0 } } }
                  },
                  note="Use Tourmaline Phial in Pools of Arlithrien (42.37, 67.12)"
                },

                {
                  type="COMPLETE",
                  title="Seek Redemption!",
                  questId=489,
                  objectives = {
                    { kind="loot", label="Fel Cone", target=3, itemId=3418, coords={ x=57.0, y=63.0 } }
                  },
                  note="Collect 3 Fel Cone from around the bottom area of large trees (57, 63)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Ban'ethil Barrow Den",
                  questId=483,
                  coords={ x=44.28, y=58.08 },
                  note="Travel to Ban'ethil Barrow Den (44.28, 58.08)"
                },

                {
                  type="COMPLETE",
                  title="The Sleeping Druid",
                  questId=2541,
                  objectives = {
                    { kind="loot", label="Voodoo Charm", target=1, itemId=8149, coords={ x=44.0, y=59.0 } }
                  },
                  note="Kill Gnarlpine Shaman until you find a Voodoo Charm, the item only drop froms shaman and very low drop rate. The quest chain will reward Sleeping Robes and Brushwood Blade, consider skipping this quest and the follow up if the rewards is useless for your character (44, 59)"
                },

                {
                  type="COMPLETE",
                  title="The Relics of Wakening",
                  questId=483,
                  objectives = {
                    { kind="loot", label="Rune of Nesting", target=1, itemId=5169, coords={ x=44.4, y=60.62 } },
                    { kind="loot", label="Black Feather Quill", target=1, itemId=5170, coords={ x=43.76, y=61.2 } },
                    { kind="loot", label="Raven Claw Talisman", target=1, itemId=5171, coords={ { x=45.51, y=58.96 }, { x=46.22, y=58.21 }, { x=45.71, y=57.33 } } },
                    { kind="loot", label="Sapphire of Sky", target=1, itemId=5172, coords={ x=44.65, y=62.5 } }
                  },
                  note="Head down into the Ban'ethil Barrow Den at the first set of bridges take the left bridge and collect Rune of Nesting from the chest (44.40, 60.62)"
                },

                {
                  type="ACCEPT",
                  title="The Sleeping Druid",
                  questId=2541,
                  coords={ x=44.96, y=61.46 },
                  npc = { name="Oben Rageclaw" },
                  note="Oben Rageclaw in Ban'ethil Barrow Den (44.96, 61.46)"
                },

                {
                  type="TURNIN",
                  title="The Sleeping Druid",
                  questId=2541,
                  coords={ x=44.96, y=61.46 },
                  npc = { name="Oben Rageclaw" },
                  note="Oben Rageclaw in Ban'ethil Barrow Den (44.96, 61.46)"
                },

                {
                  type="ACCEPT",
                  title="Druid of the Claw",
                  questId=2561,
                  coords={ x=44.96, y=61.46 },
                  npc = { name="Oben Rageclaw" },
                  note="Oben Rageclaw in Ban'ethil Barrow Den (44.96, 61.46)"
                },

                {
                  type="COMPLETE",
                  title="Druid of the Claw",
                  questId=2561,
                  objectives = {
                    { kind="loot", label="Rageclaw", target=1, itemId=5175, coords={ x=44.9, y=61.5 } }
                  },
                  note="Kill Rageclaw (44.9, 61.5)"
                },

                {
                  type="COMPLETE",
                  title="Druid of the Claw",
                  questId=2561,
                  itemId=8149,
                  objectives = {
                    { kind="use_item", label="Voodoo Charm", itemId=8149, coords={ x=44.9, y=61.5 } }
                  },
                  note="Use the Voodoo Charm on Rageclaw's body"
                },

                {
                  type="TURNIN",
                  title="Druid of the Claw",
                  questId=2561,
                  coords={ x=44.96, y=61.46 },
                  npc = { name="Oben Rageclaw" },
                  note="Oben Rageclaw in Ban'ethil Barrow Den (44.96, 61.46)"
                },

                {
                  type="COMPLETE",
                  title="Crown of the Earth",
                  questId=7383,
                  coords={ x=38.0, y=34.0 },
                  itemId=18152,
                  objectives = {
                    { kind="use_item", label="Amethyst Phial", itemId=18152, coords={ x=44.9, y=61.5 } }
                  },
                  note="Use Amethyst Phial at the moonwell (38, 34)"
                },

                {
                  type="ACCEPT",
                  title="The Moss-twined Heart",
                  questId=927,
                  itemId=5179,
                  optional=true,
                  note="Use Moss-twined Heart to accept the quest"
                },

                {
                  type="TRAVEL",
                  title="Travel to The Oracle Glade",
                  questId=937,
                  coords={ x=38.3, y=34.4 },
                  note="Travel to The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="ACCEPT",
                  title="The Enchanted Glade",
                  questId=937,
                  coords={ x=38.3, y=34.4 },
                  npc = { name="Sentinel Arynia Cloudsbreak" },
                  note="Sentinel Arynia Cloudsbreak in The Oracle Glade (38.3, 34.4)"
                },

                {
                  type="TURNIN",
                  title="Tumors",
                  questId=923,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="Oakenscowl",
                  questId=2499,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  optional=true,
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Shimmering Frond",
                  questId=931,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Moss-twined Heart",
                  questId=927,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Darnassus",
                  questId=952,
                  coords={ x=27.0, y=55.0 },
                  note="Travel to Darnassus (27, 55)"
                },

                {
                  type="COMPLETE",
                  title="Tears of the Moon",
                  questId=2518,
                  objectives = {
                    { kind="loot", label="Silvery Spinnerets", target=1, itemId=8047, coords={ x=39.28, y=25.7 } }
                  },
                  note="Kill Lady Sathrah north of The Oracle Glade and collect Silvery Spinnerets (39.28, 25.70)"
                },

                {
                  type="COMPLETE",
                  title="The Shade of Elura",
                  questId=1686,
                  objectives = {
                    { kind="loot", label="Elunite Ore", target=8, itemId=5174, coords={ x=32.0, y=46.34, map="Darkshore" } },
                    { kind="loot", label="Elura's Medallion", target=1, itemId=5182, coords={ x=31.56, y=44.87, map="Darkshore" } }
                  },
                  class="WARRIOR",
                  zone="DARKSHORE",
                  note="Collect Elura's Medallion and 8 Elunite Ore from the crates underwater in The Long Wash (32.00, 46.34)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Cenarion Enclave",
                  questId=2498,
                  coords={ x=36.88, y=21.97, map="Darnassus" },
                  zone="DARNASSUS",
                  note="Travel to Darnassus (36.88, 21.97)"
                },

                {
                  type="TURNIN",
                  title="Destiny Calls",
                  questId=2242,
                  coords={ x=36.88, y=21.97, map="Darnassus" },
                  npc = { name="Syurna" },
                  class="ROGUE",
                  zone="DARNASSUS",
                  prerequisites={2241},
                  note="Syurna in Cenarion Enclave (36.88, 21.97)"
                },

                {
                  type="TURNIN",
                  title="Vorlus Vilehoof",
                  questId=1683,
                  coords={ x=57.31, y=34.62, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.31, 34.62)"
                },

                {
                  type="ACCEPT",
                  title="The Shade of Elura",
                  questId=1686,
                  coords={ x=57.31, y=34.62, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.31, 34.62)"
                },

                {
                  type="TURNIN",
                  title="Tumors",
                  questId=923,
                  coords={ x=38.26, y=21.27, map="Darnassus" },
                  npc = { name="Rellian Greenspyre" },
                  zone="DARNASSUS",
                  note="Rellian Greenspyre in Cenarion Enclave (38.26, 21.27)"
                },

                {
                  type="ACCEPT",
                  title="Return to Denalan",
                  questId=2498,
                  coords={ x=38.26, y=21.27, map="Darnassus" },
                  npc = { name="Rellian Greenspyre" },
                  zone="DARNASSUS",
                  note="Rellian Greenspyre in Cenarion Enclave (38.26, 21.27)"
                },

                {
                  type="TURNIN",
                  title="Tears of the Moon",
                  questId=2518,
                  coords={ x=36.55, y=86.11, map="Darnassus" },
                  npc = { name="Priestess A'moora" },
                  zone="DARNASSUS",
                  note="Priestess A'moora in Temple of the Moon (36.55, 86.11)"
                },

                {
                  type="ACCEPT",
                  title="Sathrah's Sacrifice",
                  questId=2520,
                  coords={ x=36.55, y=86.11, map="Darnassus" },
                  npc = { name="Priestess A'moora" },
                  zone="DARNASSUS",
                  note="Priestess A'moora in Temple of the Moon (36.55, 86.11)"
                },

                {
                  type="COMPLETE",
                  title="Sathrah's Sacrifice",
                  questId=2520,
                  coords={ x=39.0, y=86.5, map="Darnassus" },
                  zone="DARNASSUS",
                  itemId=8155,
                  objectives = {
                    { kind="use_item", label="Sathrah's Sacrifice", itemId=8155, coords={ x=39.28, y=25.7 } }
                  },
                  note="Use Sathrah's Sacrifice at the fountain inside the temple (39, 86.5)"
                },

                {
                  type="TURNIN",
                  title="Sathrah's Sacrifice",
                  questId=2520,
                  coords={ x=36.55, y=86.11, map="Darnassus" },
                  npc = { name="Priestess A'moora" },
                  zone="DARNASSUS",
                  note="Priestess A'moora in Temple of the Moon (36.55, 86.11)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Dolanaar",
                  questId=935,
                  coords={ x=40.5, y=54.7 },
                  note="Travel to Dolanaar (40.5, 54.7) (55.95, 57.28)"
                },

                {
                  type="TURNIN",
                  title="Ursal the Mauler",
                  questId=486,
                  coords={ x=55.95, y=57.28 },
                  npc = { name="Athridas Bearmantle" },
                  note="Athridas Bearmantle in Dolanaar (55.95, 57.28)"
                },

                {
                  type="TURNIN",
                  title="Crown of the Earth",
                  questId=7383,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="ACCEPT",
                  title="Crown of the Earth",
                  questId=935,
                  coords={ x=56.2, y=61.63 },
                  npc = { name="Corithras Moonrage" },
                  note="Corithras Moonrage in Dolanaar (56.20, 61.63)"
                },

                {
                  type="TURNIN",
                  title="Return to Denalan",
                  questId=2498,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="ACCEPT",
                  title="Oakenscowl",
                  questId=2499,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Glowing Fruit",
                  questId=930,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Shimmering Frond",
                  questId=931,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Moss-twined Heart",
                  questId=927,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="COMPLETE",
                  title="Crown of the Earth",
                  questId=7383,
                  coords={ x=38.0, y=34.0 },
                  itemId=18152,
                  objectives = {
                    { kind="use_item", label="Amethyst Phial", itemId=18152, coords={ x=38.0, y=34.0 } }
                  },
                  note="Use Amethyst Phial at the moonwell (38, 34)"
                },

                {
                  type="ACCEPT",
                  title="The Moss-twined Heart",
                  questId=927,
                  itemId=5179,
                  optional=true,
                  note="Use Moss-twined Heart to accept the quest"
                },

                {
                  type="TURNIN",
                  title="Tumors",
                  questId=923,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Shimmering Frond",
                  questId=931,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="The Moss-twined Heart",
                  questId=927,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TURNIN",
                  title="Oakenscowl",
                  questId=2499,
                  coords={ x=60.91, y=68.45 },
                  npc = { name="Denalan" },
                  optional=true,
                  note="Denalan in Lake Al'Ameth (60.91, 68.45)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Darnassus",
                  questId=952,
                  coords={ x=27.0, y=55.0 },
                  note="Travel to Darnassus (27, 55)"
                },

                {
                  type="TURNIN",
                  title="Crown of the Earth",
                  questId=935,
                  coords={ x=34.86, y=8.97, map="Darnassus" },
                  npc = { name="Arch Druid Fandral Staghelm" },
                  zone="DARNASSUS",
                  note="Arch Druid Fandral Staghelm in Cenarion Enclave (34.86, 8.97)"
                },

                {
                  type="TURNIN",
                  title="Teldrassil",
                  questId=940,
                  coords={ x=34.86, y=8.97, map="Darnassus" },
                  npc = { name="Arch Druid Fandral Staghelm" },
                  zone="DARNASSUS",
                  note="Arch Druid Fandral Staghelm in Cenarion Enclave (34.86, 8.97)"
                },

                {
                  type="ACCEPT",
                  title="Grove of the Ancients",
                  questId=952,
                  coords={ x=34.86, y=8.97, map="Darnassus" },
                  npc = { name="Arch Druid Fandral Staghelm" },
                  zone="DARNASSUS",
                  note="Arch Druid Fandral Staghelm in Cenarion Enclave (34.86, 8.97)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Rut'theran Village",
                  questId=6341,
                  coords={ x=30.5, y=41.4, map="Darnassus" },
                  race="NIGHT ELF",
                  zone="DARNASSUS",
                  note="Run thru the portal west of the bank (30.5, 41.4)"
                },

                {
                  type="TURNIN",
                  title="Nessa Shadowsong",
                  questId=6344,
                  coords={ x=56.25, y=92.36 },
                  npc = { name="Nessa Shadowsong" },
                  note="Nessa Shadowsong in Rut'theran Village (56.25, 92.36)"
                },

                {
                  type="ACCEPT",
                  title="The Bounty of Teldrassil",
                  questId=6341,
                  coords={ x=56.25, y=92.36 },
                  npc = { name="Nessa Shadowsong" },
                  note="Nessa Shadowsong in Rut'theran Village (56.25, 92.36)"
                },

                {
                  type="TURNIN",
                  title="The Bounty of Teldrassil",
                  questId=6341,
                  coords={ x=58.39, y=94.0 },
                  npc = { name="Vesprystus" },
                  note="Vesprystus in Rut'theran Village (58.39, 94.00)"
                },

                {
                  type="ACCEPT",
                  title="Flight to Auberdine",
                  questId=6342,
                  coords={ x=58.39, y=94.0 },
                  npc = { name="Vesprystus" },
                  note="Vesprystus in Rut'theran Village (58.39, 94.00)"
                },

                {
                  type="FLY",
                  title="Fly to Auberdine",
                  questId=6342,
                  coords={ x=58.39, y=94.0 },
                  npc = { name="Vesprystus" },
                  destination = "Auberdine",
                  note="Speak to Vesprystus in Rut'theran Village and fly to Auberdine (58.39, 94.00)"
                },

                {
                  type="TURNIN",
                  title="Flight to Auberdine",
                  questId=6342,
                  coords={ x=36.77, y=44.32 },
                  npc = { name="Laird" },
                  note="Laird in Auberdine (36.77, 44.32)"
                },

                {
                  type="COMPLETE",
                  title="Body and Heart",
                  questId=6001,
                  coords={ x=43.48, y=45.95, map="Darkshore" },
                  class="DRUID",
                  zone="DARKSHORE",
                  objectives = {
                    { kind="use_item", label="Cenarion Lunardust", coords={ x=38.0, y=34.0 } }
                  },
                  note="Use the Cenarion Lunardust on the on the Moonkin Stone of Auberdine to summon Turak Runetotem (43.48, 45.95)"
                },

                {
                  type="COMPLETE",
                  title="The Shade of Elura",
                  questId=1686,
                  objectives = {
                    { kind="loot", label="Shade of Elura", target=1, itemId=5182, coords={ x=31.56, y=44.87, map="Darkshore" } },
                    { kind="loot", label="Elunite Ore", target=8, itemId=5174, coords={ x=32.0, y=46.34, map="Darkshore" } }
                  },
                  class="WARRIOR",
                  zone="DARKSHORE",
                  note="Kill Shade of Elura and collect Elura's Medallion in The Long Wash (31.56, 44.87)"
                },

                {
                  type="COMPLETE",
                  title="The Shade of Elura",
                  questId=1686,
                  coords={ x=32.0, y=46.34, map="Darkshore" },
                  class="WARRIOR",
                  zone="DARKSHORE",
                  note="Bring 8 Elunite Ore and the Elura's Medallion to Elanaria in The Long Wash (32.00, 46.34)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Cenarion Enclave",
                  coords={ x=34.9, y=8.25, map="Darnassus" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Travel to Cenarion Enclave (34.90, 8.25)"
                },

                {
                  type="TURNIN",
                  title="Body and Heart",
                  questId=6001,
                  coords={ x=34.9, y=8.25, map="Darnassus" },
                  npc = { name="Mathrengyl Bearwalker" },
                  class="DRUID",
                  zone="DARNASSUS",
                  note="Mathrengyl Bearwalker in Cenarion Enclave (34.90, 8.25)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Darnassus",
                  coords={ x=57.31, y=34.62, map="Darnassus" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Travel to Darnassus (57.31, 34.62)"
                },

                {
                  type="TURNIN",
                  title="The Shade of Elura",
                  questId=1686,
                  coords={ x=57.31, y=34.62, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.31, 34.62)"
                },

                {
                  type="ACCEPT",
                  title="Smith Mathiel",
                  questId=1692,
                  coords={ x=57.31, y=34.62, map="Darnassus" },
                  npc = { name="Elanaria" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Elanaria in Darnassus (57.31, 34.62)"
                },

                {
                  type="TURNIN",
                  title="Smith Mathiel",
                  questId=1692,
                  coords={ x=59.44, y=45.36, map="Darnassus" },
                  npc = { name="Mathiel" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Mathiel in Darnassus (59.44, 45.36)"
                },

                {
                  type="TURNIN",
                  title="Weapons of Elunite",
                  questId=1693,
                  coords={ x=59.44, y=45.36, map="Darnassus" },
                  npc = { name="Mathiel" },
                  class="WARRIOR",
                  zone="DARNASSUS",
                  note="Mathiel in Darnassus (59.44, 45.36)"
                },

                {
                  type="Note",
                  title="Guide Complete",
                  note="Tick to continue to the next guide"
                }

            },
        }
    },
}