-- Dromund Kaas Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- The Dark Jedi and Force cult lairs that already exist for the planet.

kaas_world = {
	lairSpawns = {
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 80,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair2_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 80,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_knight_lair3_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 80,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_master_lair_neutral_large",
			spawnLimit = -1,
			minDifficulty = 70,
			maxDifficulty = 85,
			numberToSpawn = 0,
			weighting = 8,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 78,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_lair2_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 78,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_dark_jedi_sentinel_imperial_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 78,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "kaas_force_crystal_hunter_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_force_sensitive_crypt_crawler_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_force_sensitive_renegade_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_force_trained_archaist_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_forsaken_force_drifter_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_insane_vitiate_cultist_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_novice_force_mystic_lair_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "kaas_sith_ghost_lair_neutral_large",
			spawnLimit = -1,
			minDifficulty = 65,
			maxDifficulty = 85,
			numberToSpawn = 0,
			weighting = 8,
			size = 20
		},
	},
}

addSpawnGroup("kaas_world", kaas_world);
