-- Global Hard Spawn Group - Dark Jedi Lairs + 147 Creatures
-- This should be named "global_hard" not "global"

global_hard = {
	lairSpawns = {
		{
			lairTemplateName = "global_dark_adept_neutral_none",
			spawnLimit = 5,
			minDifficulty = 136,
			maxDifficulty = 145,
			numberToSpawn = 0,
			weighting = 3,
			size = 25
		},
		{
			lairTemplateName = "global_dark_jedi_camp_dark_jedi_theater",
			spawnLimit = 3,
			minDifficulty = 261,
			maxDifficulty = 270,
			numberToSpawn = 0,
			weighting = 1,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_knight_neutral_none",
			spawnLimit = 3,
			minDifficulty = 261,
			maxDifficulty = 270,
			numberToSpawn = 0,
			weighting = 1,
			size = 25
		},
		{
			lairTemplateName = "global_dark_jedi_master_neutral_none",
			spawnLimit = 2,
			minDifficulty = 287,
			maxDifficulty = 296,
			numberToSpawn = 0,
			weighting = 1,
			size = 25
		}
	},  -- <-- FIXED: Added closing brace and comma
	
	mobile = {
		-- ============================================================
		-- LEGENDARY BOSSES (Level 300+)
		-- ============================================================
		{"mythosaur", 300, -1, -1, -1, 100, 2},  -- EXTREMELY RARE - Level 300
		{"outbreak_rancor_boss", 300, -1, -1, -1, 100, 3},  -- VERY RARE - Mutant Rancor level 320
		{"outbreak_mini_boss", 300, -1, -1, -1, 100, 4},  -- RARE - Inquisitor level 320
		{"meatlump_king", 300, -1, -1, -1, 100, 5},  -- Rare boss
		
		-- ============================================================
		-- HIGH-TIER CREATURES
		-- ============================================================
		{"sith_ghost", 300, -1, -1, -1, 100, 10}, -- Sith spirit (hologram)
		{"mutant_acklay", 300, -1, -1, -1, 100, 10},
		{"hailfire_droid", 300, -1, -1, -1, 100, 8},
		{"exar_kun_warrior", 300, -1, -1, -1, 100, 12},
		{"exar_kun_warrior_f", 300, -1, -1, -1, 100, 12},
		
		-- ============================================================
		-- RAKQUA NPCS (31 variants - Tribal enemies)
		-- ============================================================
		{"dressed_rakqua_overlord", 300, -1, -1, -1, 100, 5},
		{"dressed_rakqua_witch_01", 300, -1, -1, -1, 100, 10},
		{"dressed_rakqua_witch_02", 300, -1, -1, -1, 100, 10},
		{"dressed_rakqua_witch_03", 300, -1, -1, -1, 100, 10},
		{"dressed_rakqua_witch_04", 300, -1, -1, -1, 100, 10},
		{"dressed_rakqua_witch_05", 300, -1, -1, -1, 100, 10},
		{"dressed_rakqua_shaman_01", 300, -1, -1, -1, 100, 12},
		{"dressed_rakqua_shaman_02", 300, -1, -1, -1, 100, 12},
		{"dressed_rakqua_shaman_03", 300, -1, -1, -1, 100, 12},
		{"dressed_rakqua_shaman_04", 300, -1, -1, -1, 100, 12},
		{"dressed_rakqua_shaman_05", 300, -1, -1, -1, 100, 12},
		{"dressed_rakqua_warrior_01", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_warrior_02", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_warrior_03", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_warrior_04", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_warrior_05", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_guard_01", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_guard_02", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_guard_03", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_guard_04", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_guard_05", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_rifle_01", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_rifle_02", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_rifle_03", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_rifle_04", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_rifle_05", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_bowman_01", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_bowman_02", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_bowman_03", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_bowman_04", 300, -1, -1, -1, 100, 14},
		{"dressed_rakqua_bowman_05", 300, -1, -1, -1, 100, 14},
		
		-- ============================================================
		-- DRESSED DARK JEDI MASTERS (25 variants - Rare)
		-- ============================================================
		{"dressed_dark_jedi_master_male_human_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_human_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_human_03", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_human_04", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_human_05", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_human_06", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_twk_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_twk_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_twk_03", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_twk_04", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_zab_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_zab_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_chiss_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_chiss_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_bothan_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_twk_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_twk_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_zab_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_zab_02", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_female_bith_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_weequay_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_barada_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_arcona_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_gotal_01", 300, -1, -1, -1, 100, 6},
		{"dressed_dark_jedi_master_male_sul_01", 300, -1, -1, -1, 100, 6},
		
		-- ============================================================
		-- DRESSED DARK JEDI ELDERS (24 variants - Uncommon)
		-- ============================================================
		{"dressed_dark_jedi_elder_male_human_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_human_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_human_03", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_human_04", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_human_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_human_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_human_03", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_rodian_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_rodian_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_rodian_03", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_rodian_04", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_rodian_05", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_bothan_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_bothan_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_bothan_03", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_rodian_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_rodian_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_rodian_03", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_devorian_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_devorian_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_male_gran_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_bothan_01", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_bothan_02", 300, -1, -1, -1, 100, 10},
		{"dressed_dark_jedi_elder_female_bothan_03", 300, -1, -1, -1, 100, 10},
		
		-- ============================================================
		-- DRESSED DARK JEDI (26 variants - Common)
		-- ============================================================
		{"dressed_dark_jedi_male_human_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_human_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_human_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_human_04", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_human_05", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_human_06", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_human_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_human_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_human_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_human_04", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_twk_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_twk_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_twk_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_twk_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_twk_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_twk_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_zab_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_zab_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_zab_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_zab_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_zab_02", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_zab_03", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_male_marauder_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_marauder_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_singingmtnclan_01", 300, -1, -1, -1, 100, 12},
		{"dressed_dark_jedi_female_singingmtnclan_02", 300, -1, -1, -1, 100, 12},
		
		-- ============================================================
		-- DRESSED PADAWANS (22 variants - Very Common)
		-- ============================================================
		{"dressed_padawan_male_human_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_human_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_wke_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_wke_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_wke_03", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_wke_04", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_bothan_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_bothan_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_bothan_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_bothan_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_ith_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_ith_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_sul_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_sul_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_male_trn_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_trn_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_trn_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_ith_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_female_ith_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_wke_01", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_wke_02", 300, -1, -1, -1, 100, 15},
		{"dressed_padawan_wke_03", 300, -1, -1, -1, 100, 15}
	}
}

addSpawnGroup("global_hard", global_hard);  -- <-- FIXED: Changed to "global_hard"
