-- Mustafar Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- Native lava creatures plus the dark side presence around the Mensix and HK camps.

mustafar_world = {
	lairSpawns = {
		{
			lairTemplateName = "must_lava_fleas",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 25,
			size = 20
		},
		{
			lairTemplateName = "must_tulrus",
			spawnLimit = -1,
			minDifficulty = 50,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "must_xandanks",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "must_jundaks",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "must_tanrays",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "must_blistmoks",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_knight_neutral_none",
			spawnLimit = -1,
			minDifficulty = 60,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_master_lair_neutral_large",
			spawnLimit = -1,
			minDifficulty = 70,
			maxDifficulty = 85,
			numberToSpawn = 0,
			weighting = 5,
			size = 20
		},
	},
}

addSpawnGroup("mustafar_world", mustafar_world);
