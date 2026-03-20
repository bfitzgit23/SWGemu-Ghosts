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

kaas_regions = {
	-- No-spawn zones (cities, shrines, etc.)
	{"mysterious_shrine",-6374,6400,{CIRCLE,30},NOSPAWNAREA + NOBUILDZONEAREA},
	{"northern_islands_1",-70,6370,{CIRCLE,100},NOSPAWNAREA + NOBUILDZONEAREA},
	{"eastern_islands_1",2850,3890,{CIRCLE,200},NOSPAWNAREA + NOBUILDZONEAREA},
	{"eastern_islands_2",3342,2634,{CIRCLE,500},NOSPAWNAREA + NOBUILDZONEAREA},
	{"swamp_general_1",6017,-1141,{CIRCLE,400},NOSPAWNAREA + NOBUILDZONEAREA},
	{"a_rebel_outpost",-6131,2705,{CIRCLE,700},NOSPAWNAREA + NOBUILDZONEAREA},
	{"mysterious_shrine_2",-4495,-7535,{CIRCLE,30},NOSPAWNAREA + NOBUILDZONEAREA},
	
	-- World spawner - covers entire planet
	{"world_spawner",0,0,{CIRCLE,-1},SPAWNAREA + WORLDSPAWNAREA,{"kaas_world", "global_hard"},2048},
}

kaas_static_spawns = {
	{"imperial_recruiter",60,-5106,80,-2286,0,0, "neutral", "", ""},
	{"rebel_recruiter",60,2835,126,3881,90,0, "neutral", "", ""},
}

kaas_badges = {

}