-- Nal Hutta Spawn Groups

nalhutta_world = {
	mobile = {
		-- Hutta guards
		{"hutta_gamorrean_guard", 300, -1, -1, -1, 100, 25},
		
		-- Force beings (7 types)
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 15},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 15},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 18},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 18},
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 18},
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 18},
		{"novice_force_mystic", 300, -1, -1, -1, 100, 20},
	},
}

addSpawnGroup("nalhutta_world", nalhutta_world);
