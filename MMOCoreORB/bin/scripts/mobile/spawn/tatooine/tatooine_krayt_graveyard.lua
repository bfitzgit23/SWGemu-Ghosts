-- Ghosts (2026-10-15): krayt dragon lairs for the Krayt Graveyard.
-- The graveyard regions (7451/4510 and the 6560/4096-7488/4608 rectangle) were
-- named/no-build areas with no spawn group, so the only krayt lairs that could
-- appear there came from the planet-wide "tatooine_world" pool, which gives the
-- graveyard no density of its own. Tuned after the north-east "hard krayt" area.

tatooine_krayt_graveyard = {
	lairSpawns = {
		{
			lairTemplateName = "tatooine_canyon_krayt_dragon_pack_neutral_none",
			spawnLimit = 6,
			minDifficulty = 122,
			maxDifficulty = 276,
			numberToSpawn = 0,
			weighting = 30,
			size = 35
		},
		{
			lairTemplateName = "tatooine_canyon_krayt_dragon_lair_neutral_large",
			spawnLimit = 6,
			minDifficulty = 122,
			maxDifficulty = 276,
			numberToSpawn = 0,
			weighting = 25,
			size = 35
		},
		{
			lairTemplateName = "tatooine_giant_canyon_krayt_dragon_pack_neutral_none",
			spawnLimit = 4,
			minDifficulty = 275,
			maxDifficulty = 304,
			numberToSpawn = 0,
			weighting = 20,
			size = 35
		},
		{
			lairTemplateName = "tatooine_giant_canyon_krayt_dragon_lair_neutral_large",
			spawnLimit = 4,
			minDifficulty = 275,
			maxDifficulty = 304,
			numberToSpawn = 0,
			weighting = 15,
			size = 35
		},
		{
			lairTemplateName = "tatooine_krayt_dragon_grand_neutral_none",
			spawnLimit = 2,
			minDifficulty = 320,
			maxDifficulty = 350,
			numberToSpawn = 0,
			weighting = 5,
			size = 35
		},
		{
			lairTemplateName = "tatooine_krayt_dragon_ancient_neutral_none",
			spawnLimit = 2,
			minDifficulty = 320,
			maxDifficulty = 350,
			numberToSpawn = 0,
			weighting = 5,
			size = 35
		},
	}
}

addSpawnGroup("tatooine_krayt_graveyard", tatooine_krayt_graveyard);
