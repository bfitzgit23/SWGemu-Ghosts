-- Korriban Destroy Missions - Force-Sensitive Targets ONLY
-- High-value bounties on Dark Siders

korriban_destroy_missions = {
	minLevelCeiling = 80,
	
	-- High credit rewards for Force targets
	creditReward = 500000, -- 400k per mission
	
	lairSpawns = {
		-- Dark Jedi Masters (Hardest targets)
		{
			lairTemplateName = "korriban_dark_jedi_master_lair_neutral_large",
			minDifficulty = 200,
			maxDifficulty = 250,
			size = 15,
		},
		
		-- Dark Jedi Knights (Hard targets)
		{
			lairTemplateName = "korriban_dark_jedi_knight_lair_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		{
			lairTemplateName = "korriban_dark_jedi_knight_lair2_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		{
			lairTemplateName = "korriban_dark_jedi_knight_lair3_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		
		-- Dark Jedi Sentinels (Medium targets)
		{
			lairTemplateName = "korriban_dark_jedi_sentinel_lair_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		{
			lairTemplateName = "korriban_dark_jedi_sentinel_lair2_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		{
			lairTemplateName = "korriban_dark_jedi_sentinel_imperial_lair_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		
		-- Force-Sensitive NPCs (Medium-Low targets)
		{
			lairTemplateName = "korriban_force_trained_archaist_lair_neutral_medium",
			minDifficulty = 100,
			maxDifficulty = 130,
			size = 25,
		},
		{
			lairTemplateName = "korriban_force_sensitive_crypt_crawler_lair_neutral_medium",
			minDifficulty = 90,
			maxDifficulty = 120,
			size = 25,
		},
		{
			lairTemplateName = "korriban_force_sensitive_renegade_lair_neutral_medium",
			minDifficulty = 90,
			maxDifficulty = 120,
			size = 25,
		},
		{
			lairTemplateName = "korriban_forsaken_force_drifter_lair_neutral_medium",
			minDifficulty = 80,
			maxDifficulty = 110,
			size = 25,
		},
		{
			lairTemplateName = "korriban_novice_force_mystic_lair_neutral_medium",
			minDifficulty = 70,
			maxDifficulty = 100,
			size = 25,
		},
		{
			lairTemplateName = "korriban_force_crystal_hunter_lair_neutral_medium",
			minDifficulty = 80,
			maxDifficulty = 110,
			size = 25,
		},
	}
}

addDestroyMissionGroup("korriban_destroy_missions", korriban_destroy_missions);