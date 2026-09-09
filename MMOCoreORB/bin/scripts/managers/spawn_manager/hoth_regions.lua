require("scripts.managers.spawn_manager.regions")

hoth_regions = {
	{"echobase", -5100, 5100, {CIRCLE, 2000}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"starport", 0, -2000, {CIRCLE, 400}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"hoth_world", "global_hard"}, 1024},
}
