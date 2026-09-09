-- Dromund Kaas (Kaas) Destroy Missions - Force-Sensitive Targets ONLY
-- High-value bounties on Dark Siders and Sith forces

kaas_destroy_missions = {
	minLevelCeiling = 80,
	
	-- High credit rewards for Force targets
	creditReward = 500000, -- 400k per mission
	
	lairSpawns = {
		-- Dark Jedi Masters (Hardest targets)
		{
			lairTemplateName = "kaas_dark_jedi_master_lair_neutral_large",
			minDifficulty = 200,
			maxDifficulty = 250,
			size = 15,
		},
		
		-- Dark Jedi Knights (Hard targets)
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair2_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair3_neutral_medium",
			minDifficulty = 150,
			maxDifficulty = 200,
			size = 20,
		},
		
		-- Dark Jedi Sentinels (Medium targets)
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_lair_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_lair2_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_imperial_lair_neutral_medium",
			minDifficulty = 120,
			maxDifficulty = 150,
			size = 20,
		},
		
		-- Force-Sensitive NPCs (Medium-Low targets)
		{
			lairTemplateName = "kaas_force_trained_archaist_lair_neutral_medium",
			minDifficulty = 100,
			maxDifficulty = 130,
			size = 25,
		},
		{
			lairTemplateName = "kaas_force_sensitive_crypt_crawler_lair_neutral_medium",
			minDifficulty = 90,
			maxDifficulty = 120,
			size = 25,
		},
		{
			lairTemplateName = "kaas_force_sensitive_renegade_lair_neutral_medium",
			minDifficulty = 90,
			maxDifficulty = 120,
			size = 25,
		},
		{
			lairTemplateName = "kaas_forsaken_force_drifter_lair_neutral_medium",
			minDifficulty = 80,
			maxDifficulty = 110,
			size = 25,
		},
		{
			lairTemplateName = "kaas_novice_force_mystic_lair_neutral_medium",
			minDifficulty = 70,
			maxDifficulty = 100,
			size = 25,
		},
		{
			lairTemplateName = "kaas_force_crystal_hunter_lair_neutral_medium",
			minDifficulty = 80,
			maxDifficulty = 110,
			size = 25,
		},
		
		-- Sith-specific targets (Very Hard)
		{
			lairTemplateName = "kaas_sith_ghost_lair_neutral_large",
			minDifficulty = 180,
			maxDifficulty = 220,
			size = 20,
		},
		{
			lairTemplateName = "kaas_insane_vitiate_cultist_lair_neutral_medium",
			minDifficulty = 140,
			maxDifficulty = 180,
			size = 25,
		},
	}
}

addDestroyMissionGroup("kaas_destroy_missions", kaas_destroy_missions);
