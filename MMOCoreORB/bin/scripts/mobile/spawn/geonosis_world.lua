-- Geonosis Spawn Groups

geonosis_world = {
	mobile = {
		-- Droids
		{"battle_droids", 300, -1, -1, -1, 100, 25},
		{"sbd4_droids", 300, -1, -1, -1, 100, 20},
		{"sbd6_droids", 300, -1, -1, -1, 100, 20},
		{"spider_droids", 300, -1, -1, -1, 100, 20},
		{"spider_droid_brown", 300, -1, -1, -1, 100, 20},
		{"geo_pit_droid", 300, -1, -1, -1, 100, 25},
		{"security2_droid", 300, -1, -1, -1, 100, 18},
		{"security5_droid", 300, -1, -1, -1, 100, 18},
		{"security6_droid", 300, -1, -1, -1, 100, 18},
		
		-- Troops & Bosses
		{"imperial_clone_trooper", 300, -1, -1, -1, 100, 20},
		{"geoworld_boss2", 300, -1, -1, -1, 100, 8},
		{"geoworld_boss5", 300, -1, -1, -1, 100, 8},
		{"rare_force3", 300, -1, -1, -1, 100, 10},
		{"rare_force7", 300, -1, -1, -1, 100, 10},
		{"ig88_upgrade", 300, -1, -1, -1, 100, 10},
		
		-- Force beings (8 types)
		{"dark_jedi_master", 300, -1, -1, -1, 100, 10},
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 15},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 15},
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 15},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 18},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 18},
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 18},
		{"novice_force_mystic", 300, -1, -1, -1, 100, 20},
	},
}

addSpawnGroup("geonosis_world", geonosis_world);
