ring_s01_LST = {
 -- Band
    minimumLevel = 0,
    maximumLevel = -1,
    customObjectName = "Ring of Master Kit Fisto",
    directObjectTemplate = "object/tangible/wearables/ring/ring_s01.iff",
    craftingValues = {},
	skillMods = {
		{"force_assembly", 50},
		{"force_experimentation", 50},
		{"jedi_saber_assembly", 50},
		{"jedi_saber_experimentation", 50},
    {"force_failure_reduction", 50},   
{"lightsaber_toughness", 25},
		{"forceintimidate_accuracy", 50},
		{"forceknockdown_accuracy", 50},
		{"forcelightning_accuracy", 50},
		{"forceweaken_accuracy", 50},
    {"forcethrow_accuracy", 25},
    {"mindblast_accuracy", 25},
    {"force_choke", 25},  
    customizationStringNames = {},
    customizationValues = {}
}

addLootItemTemplate("ring_s01_LST", ring_s01_LST)
