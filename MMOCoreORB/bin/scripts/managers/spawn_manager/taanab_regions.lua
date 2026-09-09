require("scripts.managers.spawn_manager.regions")

taanab_regions = {
	{"pandath", 2000, 5400, {CIRCLE, 300}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"starhunterstation", 3763, -5425, {CIRCLE, 300}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"taanab_world"}, 2048},
	{"taanabhexfarms", -3000, -105, {CIRCLE, 300}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"taanabgreatherd", 5537, -4958, {CIRCLE, 300}, NOWORLDSPAWNAREA + NOBUILDZONEAREA + SPAWNAREA, {"taanab_nerfherd"}, 1024},
	{"downedship", 3293, -1324, {CIRCLE, 150}, NOBUILDZONEAREA},
	{"taanabcanyonlands", -2590, 3705, {CIRCLE, 50}, NOBUILDZONEAREA},
	{"taanabmine", -2609, -1305, {CIRCLE, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"taanabcave", -850, 7200, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
}
