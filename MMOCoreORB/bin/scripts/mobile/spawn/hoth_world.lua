-- Hoth Spawn Groups
--
-- Ghosts 2026-11-19: these planets shipped with a `mobile = { ... }` table,
-- which the spawn engine never reads (SpawnGroup only loads `lairSpawns`),
-- so they spawned nothing at all. Rewritten as lair spawn groups.
-- Ice plain packs, the wampa caves, and the Imperial/Rebel snow camps.

hoth_world = {
	lairSpawns = {
		{
			lairTemplateName = "hoth_taun_taun_lair",
			spawnLimit = -1,
			minDifficulty = 12,
			maxDifficulty = 30,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "hoth_tauntaun_pack",
			spawnLimit = -1,
			minDifficulty = 10,
			maxDifficulty = 25,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "hoth_wampa_lair",
			spawnLimit = -1,
			minDifficulty = 20,
			maxDifficulty = 40,
			numberToSpawn = 0,
			weighting = 20,
			size = 20
		},
		{
			lairTemplateName = "hoth_wampa_pack",
			spawnLimit = -1,
			minDifficulty = 18,
			maxDifficulty = 35,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "hoth_mynock_pack",
			spawnLimit = -1,
			minDifficulty = 12,
			maxDifficulty = 28,
			numberToSpawn = 0,
			weighting = 15,
			size = 20
		},
		{
			lairTemplateName = "hoth_snowtrooper_camp",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
		{
			lairTemplateName = "hoth_rebel_camp",
			spawnLimit = -1,
			minDifficulty = 25,
			maxDifficulty = 45,
			numberToSpawn = 0,
			weighting = 10,
			size = 20
		},
	},
}

addSpawnGroup("hoth_world", hoth_world);
