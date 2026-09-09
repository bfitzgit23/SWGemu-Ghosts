bracelet_leftpower = {
  minimumLevel = 0,
  maximumLevel = -1,
  customObjectName = "Bracelet of Dark Power",
  directObjectTemplate = "object/tangible/wearables/bracelet/bracelet_s06_l.iff",
  craftingValues = {},
  customizationStringNames = {},
  customizationValues = {},
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
	}
}

addLootItemTemplate("bracelet_leftpower", bracelet_leftpower)