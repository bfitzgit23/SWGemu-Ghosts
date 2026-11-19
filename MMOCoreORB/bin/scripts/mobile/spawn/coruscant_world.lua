-- Coruscant Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- The underworld levels: thugs, criminals, Black Sun, brigands and dark adepts.

coruscant_world = {
	lairSpawns = {
		{
			lairTemplateName = "global_thug_neutral_none",
			spawnLimit = -1,
			minDifficulty = 20,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "global_criminal_neutral_none",
			spawnLimit = -1,
			minDifficulty = 20,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "global_black_sun_neutral_none",
			spawnLimit = -1,
			minDifficulty = 30,
			maxDifficulty = 55,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_bandit_pack_neutral_none",
			spawnLimit = -1,
			minDifficulty = 20,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_brigand_squad_neutral_none",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 50,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_outlaw_neutral_none",
			spawnLimit = -1,
			minDifficulty = 20,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "global_dark_adept_neutral_none",
			spawnLimit = -1,
			minDifficulty = 35,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "global_dark_jedi_knight_neutral_none",
			spawnLimit = -1,
			minDifficulty = 40,
			maxDifficulty = 60,
			numberToSpawn = 0,
			weighting = 8,
			size = 20
		},
	},
}

addSpawnGroup("coruscant_world", coruscant_world);
