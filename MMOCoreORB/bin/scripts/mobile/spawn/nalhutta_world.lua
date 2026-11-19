-- Nal Hutta Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- Hutta wildlife, Gamorrean muscle and the criminal crews of the swamps.

nalhutta_world = {
	lairSpawns = {
		{
			lairTemplateName = "nalhutta_chemilizard_pack",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "nalhutta_dragonsnake_pack",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "nalhutta_xuuva_pack",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "hutt_thug",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_criminal_neutral_none",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_black_sun_neutral_none",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
	},
}

addSpawnGroup("nalhutta_world", nalhutta_world);
