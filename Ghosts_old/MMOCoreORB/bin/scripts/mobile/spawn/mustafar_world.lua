-- Mustafar Spawn Groups

mustafar_world = {
	mobile = {
		-- Lava creatures
		{"sherkar", 300, -1, -1, -1, 100, 25},
		{"sherkarmini", 300, -1, -1, -1, 100, 30},
		
		-- Force beings (5 types)
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 15},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 15},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 20},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 20},
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 20},
	},
}

addSpawnGroup("mustafar_world", mustafar_world);
