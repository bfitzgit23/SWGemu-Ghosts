-- Dromund Kaas (Kaas) Spawn Groups

kaas_world = {
	mobile = {
		-- Dangerous creatures
		{"kell_dragon", 300, -1, -1, -1, 100, 15},
		{"gundark", 300, -1, -1, -1, 100, 20},
		{"sleen", 300, -1, -1, -1, 100, 25},
		{"vine_cat", 300, -1, -1, -1, 100, 30},
		{"mailoc", 300, -1, -1, -1, 100, 25},
		{"ysalamiri", 300, -1, -1, -1, 100, 15},
		
		-- Sith/Force creatures
		{"sith_ghost", 300, -1, -1, -1, 100, 15},
		{"insane_vitiate_cultist", 300, -1, -1, -1, 100, 20},
		{"vitiate", 300, -1, -1, -1, 100, 5}, -- Rare
		
		-- Nanite horrors
		{"nanite_infected_human_cyborg", 300, -1, -1, -1, 100, 15},
		{"nanite_reanimated_clone_trooper", 300, -1, -1, -1, 100, 15},
		{"chiss_hunter_herald", 300, -1, -1, -1, 100, 10},
		
		-- Droids
		{"kaas_battle_droid", 300, -1, -1, -1, 100, 15},
		{"kaas_s_battle_droid", 300, -1, -1, -1, 100, 15},
		{"kaas_droideka", 300, -1, -1, -1, 100, 10},
		
		-- Force beings (20 types) - HEAVY PRESENCE
		{"dark_jedi_master", 300, -1, -1, -1, 100, 12},
		{"dark_jedi_master", 300, -1, -1, -1, 100, 12}, -- Duplicate for more spawns
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 18},
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 18}, -- Duplicate for more spawns
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 18},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 18}, -- Duplicate for more spawns
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 15},
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 15}, -- Duplicate
		{"force_trained_archaist", 300, -1, -1, -1, 100, 20},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 20}, -- Duplicate
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 22},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 22}, -- Duplicate
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 20},
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 20}, -- Duplicate
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 20},
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 20}, -- Duplicate
		{"novice_force_mystic", 300, -1, -1, -1, 100, 22},
		{"novice_force_mystic", 300, -1, -1, -1, 100, 22}, -- Duplicate
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 18},
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 18}, -- Duplicate
	},
}

addSpawnGroup("kaas_world", kaas_world);
