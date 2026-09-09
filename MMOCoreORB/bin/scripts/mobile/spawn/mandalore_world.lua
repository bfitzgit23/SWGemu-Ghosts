-- Mandalore Spawn Groups

mandalore_world = {
	mobile = {
		-- Named NPCs (Bosses)
		{"mandalore_the_resurrector", 300, -1, -1, -1, 100, 5},
		{"darth_caedus", 300, -1, -1, -1, 100, 5},
		{"tor_vizsla", 300, -1, -1, -1, 100, 8},
		{"toborro_the_hutt", 300, -1, -1, -1, 100, 8},
		
		-- Clan members
		{"taung_warrior", 300, -1, -1, -1, 100, 15},
		{"dexton_clan_hunter", 300, -1, -1, -1, 100, 18},
		{"bralor_clan_mercenary", 300, -1, -1, -1, 100, 18},
		{"vizsla_loyalist", 300, -1, -1, -1, 100, 18},
		{"pyke_syndicate_criminal", 300, -1, -1, -1, 100, 18},
		
		-- Combat units
		{"deathwatch_sbd", 300, -1, -1, -1, 100, 15},
		{"darth_caedus_follower", 300, -1, -1, -1, 100, 15},
		
		-- Creatures
		{"narglatch_bruiser", 300, -1, -1, -1, 100, 20},
		{"baz_nitch_terror", 300, -1, -1, -1, 100, 20},
		{"mytho_king", 300, -1, -1, -1, 100, 15},
		{"rancor_guard", 300, -1, -1, -1, 100, 15},
		
		-- Force beings (added for variety)
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 12},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 12},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 15},
	},
}

addSpawnGroup("mandalore_world", mandalore_world);
