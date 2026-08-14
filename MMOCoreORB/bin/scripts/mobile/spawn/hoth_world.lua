-- Hoth Spawn Groups

hoth_world = {
	mobile = {
		-- Wampas
		{"wampa", 300, -1, -1, -1, 100, 25},
		{"giant_wampa", 300, -1, -1, -1, 100, 15},
		{"wampa_boss", 300, -1, -1, -1, 100, 8},
		{"wampa_baby", 300, -1, -1, -1, 100, 20},
		{"wampa_christmas", 300, -1, -1, -1, 100, 15},
		{"wampa_christmas_babys", 300, -1, -1, -1, 100, 15},
		
		-- Other creatures
		{"tauntaun", 300, -1, -1, -1, 100, 30},
		{"sherkar", 300, -1, -1, -1, 100, 20},
		{"sherkarmini", 300, -1, -1, -1, 100, 20},
		{"hoth_mynock", 300, -1, -1, -1, 100, 20},
		
		-- Imperial/Rebel troops
		{"snow_trooper", 300, -1, -1, -1, 100, 20},
		{"rebel_snow_trooper", 300, -1, -1, -1, 100, 20},
		{"rebel_echo_officer", 300, -1, -1, -1, 100, 15},
		{"rebel_echo_pilot", 300, -1, -1, -1, 100, 15},
		{"rebel_echo_comm", 300, -1, -1, -1, 100, 15},
		
		-- Force beings (7 types)
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 12},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 12},
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 12},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 15},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 15},
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 15},
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 15},
	},
}

addSpawnGroup("hoth_world", hoth_world);
