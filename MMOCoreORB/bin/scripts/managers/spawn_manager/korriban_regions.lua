-- Planet Region Definitions
-- This file has been generated with the SWGEmu World Spawner Tool.
--
-- {"regionName", xCenter, yCenter, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {CIRCLE, radius}
--   - Rectangle: {RECTANGLE, x2, y2}
--   - Ring: {RING, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.

require("scripts.managers.spawn_manager.regions")

korriban_regions = {
	-- No-spawn zones (cities, caves, sacred areas)
	{"dreshdae_valley", 1060, -5332, {CIRCLE, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"valley_of_the_dark_lords", -1346, -830, {CIRCLE, 100}, NOBUILDZONEAREA},
	{"shyrack_cave", 457, -235, {CIRCLE, 250}, NOBUILDZONEAREA},
	{"archaeological_outpost", -1712, -679, {CIRCLE, 100}, NOBUILDZONEAREA + NOSPAWNAREA},
	
	-- World spawner - covers entire planet
	-- World spawners (split into several circles to increase local density)
	{"world_spawner_center", 0, 0, {CIRCLE, 7000}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global"}, 2048},
	{"world_spawner_ne", 4500, 4500, {CIRCLE, 4500}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global"}, 1024},
	{"world_spawner_nw", -4500, 4500, {CIRCLE, 4500}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global"}, 1024},
	{"world_spawner_se", 4500, -4500, {CIRCLE, 4500}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global"}, 1024},
	{"world_spawner_sw", -4500, -4500, {CIRCLE, 4500}, SPAWNAREA + WORLDSPAWNAREA, {"korriban_world", "global"}, 1024},
}

korriban_static_spawns = {

}

korriban_badges = {

}
