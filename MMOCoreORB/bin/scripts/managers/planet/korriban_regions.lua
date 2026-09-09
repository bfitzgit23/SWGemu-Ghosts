require("scripts.managers.planet.regions")

korriban_regions = {
	{"dreshdae_valley", 1060, -5332, {CIRCLE, 400}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"valley_of_the_dark_lords", -1346, -830, {CIRCLE, 1000}, NOBUILDZONEAREA},
	{"shyrack_cave", 457, -235, {CIRCLE, 250}, NOBUILDZONEAREA},
	{"archaeological_outpost", -1712, -679, {CIRCLE, 200}, NOBUILDZONEAREA + NOSPAWNAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global_hard"}, 2048},
}
