-- =========================
-- Azshara (46-46)
-- Converted from TourGuide format
-- =========================

QuestShellGuides = QuestShellGuides or {}

QuestShellGuides["Azshara (46-46)"] = {
    title    = "Azshara (46-46)",
    minLevel = 1,
    maxLevel = 60,

    chapters =
    {
        {
            id       = "Azshara (46-46)",
            title    = "Azshara (46-46)",
            zone     = "Unknown",
            minLevel = 1,
            maxLevel = 60,

            steps = {

                {
                  type="TRAVEL",
                  title="Travel to Talrendis Point",
                  questId=5535,
                  coords={ x=11.4, y=78.13, map="Azshara" },
                  zone="AZSHARA",
                  note="Travel to Talrendis Point in Azshara (11.40, 78.13)"
                },

                {
                  type="GET_FLIGHTPATH",
                  title="Get flight path for Talrendis Point",
                  questId=5535,
                  coords={ x=11.9, y=77.57, map="Azshara" },
                  npc = { name="Jarrodenus" },
                  zone="AZSHARA",
                  location="Talrendis Point",
                  note="Speak to Jarrodenus and grab flight path for Talrendis Point (11.90, 77.57)"
                },

                {
                  type="ACCEPT",
                  title="Spiritual Unrest",
                  questId=5535,
                  coords={ x=11.4, y=78.13, map="Azshara" },
                  npc = { name="Loh'atu" },
                  zone="AZSHARA",
                  note="Loh'atu in Talrendis Point (11.40, 78.13)"
                },

                {
                  type="ACCEPT",
                  title="A Land Filled with Hatred",
                  questId=5536,
                  coords={ x=11.4, y=78.13, map="Azshara" },
                  npc = { name="Loh'atu" },
                  zone="AZSHARA",
                  note="Loh'atu in Talrendis Point (11.40, 78.13)"
                },

                {
                  type="COMPLETE",
                  title="Spiritual Unrest",
                  questId=5535,
                  objectives = {
                    { kind="kill", label="Highborne Lichling", target=6, coords={ x=16.4, y=68.21, map="Azshara" } },
                    { kind="kill", label="Highborne Apparition", target=6, coords={ x=16.4, y=68.21, map="Azshara" } }
                  },
                  zone="AZSHARA",
                  note="Kill 6 Highborne Lichling and 6 Highborne Apparition in Shadowsong Shrine (16.40, 68.21)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Haldarr Encampment",
                  questId=5536,
                  coords={ x=20.58, y=61.67, map="Azshara" },
                  zone="AZSHARA",
                  note="Travel to Haldarr Encampment (20.58, 61.67)"
                },

                {
                  type="COMPLETE",
                  title="A Land Filled with Hatred",
                  questId=5536,
                  objectives = {
                    { kind="kill", label="Haldarr Trickster", target=2, coords={ x=20.58, y=61.67, map="Azshara" } },
                    { kind="kill", label="Haldarr Felsworn", target=2, coords={ x=20.58, y=61.67, map="Azshara" } },
                    { kind="kill", label="Haldarr Satyr", target=6, coords={ x=20.58, y=61.67, map="Azshara" } }
                  },
                  zone="AZSHARA",
                  note="Kill 2 Haldarr Trickster, 2 Haldarr Felsworn and 6 Haldarr Satyr in Haldarr Encampment (20.58, 61.67)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Talrendis Point",
                  coords={ x=11.37, y=78.15, map="Azshara" },
                  zone="AZSHARA",
                  note="Travel to Talrendis Point (11.37, 78.15)"
                },

                {
                  type="TURNIN",
                  title="Spiritual Unrest",
                  questId=5535,
                  coords={ x=11.37, y=78.15, map="Azshara" },
                  npc = { name="Loh'atu" },
                  zone="AZSHARA",
                  note="Loh'atu in Talrendis Point (11.37, 78.15)"
                },

                {
                  type="TURNIN",
                  title="A Land Filled with Hatred",
                  questId=5536,
                  coords={ x=11.37, y=78.15, map="Azshara" },
                  npc = { name="Loh'atu" },
                  zone="AZSHARA",
                  note="Loh'atu in Talrendis Point (11.37, 78.15)"
                },

                {
                  type="TRAVEL",
                  title="Travel to Gadgetzan",
                  coords={ x=52.35, y=26.91, map="Tanaris" },
                  zone="TANARIS",
                  note="Travel to Gadgetzan (52.35, 26.91)"
                },

                {
                  type="TURNIN",
                  title="The Borrower",
                  questId=2941,
                  coords={ x=52.35, y=26.91, map="Tanaris" },
                  npc = { name="Curgle Cranklehop" },
                  zone="TANARIS",
                  note="Curgle Cranklehop in Gadgetzan (52.35, 26.91)"
                },

                {
                  type="ACCEPT",
                  title="The Super Snapper FX",
                  questId=2944,
                  coords={ x=52.35, y=26.91, map="Tanaris" },
                  npc = { name="Curgle Cranklehop" },
                  zone="TANARIS",
                  note="Curgle Cranklehop in Gadgetzan (52.35, 26.91)"
                },

                {
                  type="Note",
                  title="Bag of Water Elemental Bracers",
                  questId=602,
                  zone="TANARIS",
                  note="Withdraw Bag of Water Elemental Bracers from the bank. Tick this step (52.30, 28.89)"
                },

                {
                  type="Note",
                  title="Seahorn's Sealed Letter",
                  questId=670,
                  zone="TANARIS",
                  note="Withdraw Seahorn's Sealed Letter from the bank. Tick this step (52.30, 28.89)"
                },

                {
                  type="Note",
                  title="Letter of Commendation",
                  questId=1052,
                  zone="TANARIS",
                  note="Withdraw Letter of Commendation from the bank. Tick this step (52.30, 28.89)"
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