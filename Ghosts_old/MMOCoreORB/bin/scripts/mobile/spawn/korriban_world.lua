-- Korriban Spawn Groups - NO SITH CREATURES, DOUBLE SPAWNS!

korriban_world = {
	lairSpawns = {
		{
			lairTemplateName = "korriban_terentatek_lair",
			spawnLimit = -1,
			minDifficulty = 180,
			maxDifficulty = 220,
			numberToSpawn = 30,  -- DOUBLED from 15
			weighting = 20,  -- DOUBLED from 10
			size = 25,
		},
		{
			lairTemplateName = "korriban_hssiss_lair",
			spawnLimit = -1,
			minDifficulty = 150,
			maxDifficulty = 180,
			numberToSpawn = 30,  -- DOUBLED from 15
			weighting = 30,  -- DOUBLED from 15
			size = 25,
		},
		{
			lairTemplateName = "korriban_tukata_lair",
			spawnLimit = -1,
			minDifficulty = 120,
			maxDifficulty = 150,
			numberToSpawn = 30,  -- DOUBLED from 15
			weighting = 50,  -- DOUBLED from 25
			size = 25,
		},
		{
			lairTemplateName = "korriban_shyrack_lair",
			spawnLimit = -1,
			minDifficulty = 80,
			maxDifficulty = 110,
			numberToSpawn = 30,  -- DOUBLED from 15
			weighting = 60,  -- DOUBLED from 30
			size = 25,
		},
		{
			lairTemplateName = "korriban_klor_slug_lair",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 90,
			numberToSpawn = 30,  -- DOUBLED from 15
			weighting = 50,  -- DOUBLED from 25
			size = 25,
		},
	},
	
	mobile = {
		-- ============================================================
		-- APEX PREDATORS (DOUBLED!)
		-- ============================================================
		{"terentatek", 300, -1, -1, -1, 100, 20},  -- DOUBLED from 10
		{"terentatek", 300, -1, -1, -1, 100, 20},  -- Extra!
		{"mutant_rancor", 300, -1, -1, -1, 100, 16},  -- DOUBLED from 8
		{"mutant_rancor", 300, -1, -1, -1, 100, 16},  -- Extra!
		{"mutant_acklay", 300, -1, -1, -1, 100, 16},  -- DOUBLED from 8
		{"mutant_acklay", 300, -1, -1, -1, 100, 16},  -- Extra!
		
		-- ============================================================
		-- DANGEROUS CREATURES (DOUBLED!)
		-- ============================================================
		{"hssiss", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"hssiss", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"tukata", 300, -1, -1, -1, 100, 60},  -- DOUBLED from 30
		{"tukata", 300, -1, -1, -1, 100, 60},  -- Extra!
		{"shyrack", 300, -1, -1, -1, 100, 50},  -- DOUBLED from 25
		{"shyrack", 300, -1, -1, -1, 100, 50},  -- Extra!
		{"klor_slug", 300, -1, -1, -1, 100, 50},  -- DOUBLED from 25
		{"klor_slug", 300, -1, -1, -1, 100, 50},  -- Extra!
		
		-- ============================================================
		-- MUTANT CREATURES (DOUBLED!)
		-- ============================================================
		{"feral_mutant_gackle_stalker", 300, -1, -1, -1, 100, 30},  -- DOUBLED from 15
		{"feral_mutant_gackle_stalker", 300, -1, -1, -1, 100, 30},  -- Extra!
		{"giant_mutant_bark_mite", 300, -1, -1, -1, 100, 30},  -- DOUBLED from 15
		{"giant_mutant_bark_mite", 300, -1, -1, -1, 100, 30},  -- Extra!
		{"mutant_bark_mite_queen", 300, -1, -1, -1, 100, 20},  -- DOUBLED from 10
		{"mutant_bark_mite_queen", 300, -1, -1, -1, 100, 20},  -- Extra!
		{"mutant_bark_mite_soldier", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"mutant_bark_mite_soldier", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"mutant_bark_mite_worker", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"mutant_bark_mite_worker", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"mutant_bark_mite_hatchling", 300, -1, -1, -1, 100, 50},  -- DOUBLED from 25
		{"mutant_bark_mite_hatchling", 300, -1, -1, -1, 100, 50},  -- Extra!
		{"mutant_hermit_spider", 300, -1, -1, -1, 100, 30},  -- DOUBLED from 15
		{"mutant_hermit_spider", 300, -1, -1, -1, 100, 30},  -- Extra!
		{"mutant_baz_nitch", 300, -1, -1, -1, 100, 30},  -- DOUBLED from 15
		{"mutant_baz_nitch", 300, -1, -1, -1, 100, 30},  -- Extra!
		{"mutant_womp_rat", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"mutant_womp_rat", 300, -1, -1, -1, 100, 40},  -- Extra!
		
		-- ============================================================
		-- FORCE BEINGS (QUADRUPLED - Extra spawns!)
		-- ============================================================
		{"dark_jedi_master", 300, -1, -1, -1, 100, 24},  -- DOUBLED from 12
		{"dark_jedi_master", 300, -1, -1, -1, 100, 24},
		{"dark_jedi_master", 300, -1, -1, -1, 100, 24},  -- Extra!
		{"dark_jedi_master", 300, -1, -1, -1, 100, 24},  -- Extra!
		
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 36},  -- DOUBLED from 18
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 36},
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 36},  -- Extra!
		{"dark_jedi_knight", 300, -1, -1, -1, 100, 36},  -- Extra!
		
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 36},  -- DOUBLED from 18
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 36},
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 36},  -- Extra!
		{"dark_jedi_sentinel", 300, -1, -1, -1, 100, 36},  -- Extra!
		
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 30},  -- DOUBLED from 15
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 30},
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 30},  -- Extra!
		{"dark_jedi_sentinel_imperial", 300, -1, -1, -1, 100, 30},  -- Extra!
		
		{"force_trained_archaist", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"force_trained_archaist", 300, -1, -1, -1, 100, 40},
		{"force_trained_archaist", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"force_trained_archaist", 300, -1, -1, -1, 100, 40},  -- Extra!
		
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 44},  -- DOUBLED from 22
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 44},
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 44},  -- Extra!
		{"force_sensitive_crypt_crawler", 300, -1, -1, -1, 100, 44},  -- Extra!
		
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 40},
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"force_sensitive_renegade", 300, -1, -1, -1, 100, 40},  -- Extra!
		
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 40},  -- DOUBLED from 20
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 40},
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 40},  -- Extra!
		{"forsaken_force_drifter", 300, -1, -1, -1, 100, 40},  -- Extra!
		
		{"novice_force_mystic", 300, -1, -1, -1, 100, 44},  -- DOUBLED from 22
		{"novice_force_mystic", 300, -1, -1, -1, 100, 44},
		{"novice_force_mystic", 300, -1, -1, -1, 100, 44},  -- Extra!
		{"novice_force_mystic", 300, -1, -1, -1, 100, 44},  -- Extra!
		
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 36},  -- DOUBLED from 18
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 36},
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 36},  -- Extra!
		{"force_crystal_hunter", 300, -1, -1, -1, 100, 36},  -- Extra!
	},
}

addSpawnGroup("korriban_world", korriban_world);
