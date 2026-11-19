-- Kashyyyk Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- The Wookiee homeworld fauna: webweavers, bolotaurs, moufs, urnsoris, wallugas,
-- varactyls and minstyngars, plus the dark side presence in the deep woods.

kashyyyk_world = {
	lairSpawns = {
		{
			lairTemplateName = "kash_webweavers",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "kash_bolotaurs",
			spawnLimit = -1,
			minDifficulty = 35,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 18,
			size = 20
		},
		{
			lairTemplateName = "kash_moufs",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "kash_urnsoris",
			spawnLimit = -1,
			minDifficulty = 32,
			maxDifficulty = 52,
			numberToSpawn = 0,
			weighting = 18,
			size = 20
		},
		{
			lairTemplateName = "kash_wallugas",
			spawnLimit = -1,
			minDifficulty = 35,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 18,
			size = 20
		},
		{
			lairTemplateName = "kash_varactyls",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 18,
			size = 20
		},
		{
			lairTemplateName = "kash_minstyngars",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_knight_neutral_none",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
	},
}

addSpawnGroup("kashyyyk_world", kashyyyk_world);
