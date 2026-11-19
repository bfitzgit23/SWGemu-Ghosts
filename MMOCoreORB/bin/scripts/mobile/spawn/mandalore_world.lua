-- Mandalore Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- Death Watch, clan hunters, narglatch prides and rancor guardians.

mandalore_world = {
	lairSpawns = {
		{
			lairTemplateName = "mandalore_deathwatch_sbd_lair",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "naboo_narglatch_pride_neutral_medium",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "narglatch_swamp",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "dathomir_ancient_bull_rancor_lair_neutral_large",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 8,
			size = 20
		},
		{
			lairTemplateName = "bantha_wasteland",
			spawnLimit = -1,
			minDifficulty = 35,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_knight_neutral_none",
			spawnLimit = -1,
			minDifficulty = 50,
			maxDifficulty = 70,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "global_dark_adept_neutral_none",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
	},
}

addSpawnGroup("mandalore_world", mandalore_world);
