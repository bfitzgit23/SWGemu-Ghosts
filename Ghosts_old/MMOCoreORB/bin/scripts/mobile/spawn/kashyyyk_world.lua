-- Kashyyyk Spawn Groups

kashyyyk_world = {
	mobile = {
		-- Bosses
		{"general_grievous", 300, -1, -1, -1, 100, 5},
		
		-- Dangerous creatures
		{"webweaver", 300, -1, -1, -1, 100, 18},
		{"bolotaur", 300, -1, -1, -1, 100, 20},
		{"mouf", 300, -1, -1, -1, 100, 20},
		{"uller", 300, -1, -1, -1, 100, 20},
		{"kkorrwrot", 300, -1, -1, -1, 100, 18},
		{"walluga", 300, -1, -1, -1, 100, 20},
		{"urnsoris", 300, -1, -1, -1, 100, 20},
		{"varactyl", 300, -1, -1, -1, 100, 18},
		{"minstyngar", 300, -1, -1, -1, 100, 15},
		{"katarn", 300, -1, -1, -1, 100, 15},
		{"kazabecca", 300, -1, -1, -1, 100, 15},
		{"shockree", 300, -1, -1, -1, 100, 15},
		{"kiruarracca", 300, -1, -1, -1, 100, 15},
		{"kashyyyk_bantha", 300, -1, -1, -1, 100, 20},
		
		-- Force beings (added for variety)
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 12},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 12},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 15},
	},
}

addSpawnGroup("kashyyyk_world", kashyyyk_world);
