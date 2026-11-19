-- Geonosis Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- Droid foundries and the clone/Geonosian ground war.

geonosis_world = {
	lairSpawns = {
		{
			lairTemplateName = "geonosis_spider_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "geonosis_spider_droid_brown_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "geonosis_sbd2_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_sbd4_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 50,
			maxDifficulty = 70,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_sbd6_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_security3_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_security5_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 50,
			maxDifficulty = 70,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_hellfire_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 55,
			maxDifficulty = 75,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "geonosis_pit_droid_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_elite_geonosian_warrior_neutral",
			spawnLimit = -1,
			minDifficulty = 50,
			maxDifficulty = 70,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_imperial_clone_neutral",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 12,
			size = 20
		},
		{
			lairTemplateName = "geonosis_sentry_droid_none",
			spawnLimit = -1,
			minDifficulty = 45,
			maxDifficulty = 65,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
	},
}

addSpawnGroup("geonosis_world", geonosis_world);
