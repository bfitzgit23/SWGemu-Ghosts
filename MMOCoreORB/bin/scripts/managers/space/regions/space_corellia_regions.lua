--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_corellia_regions = {
	{"space_corellia_1_traffic", -7132.79, 2340.4, 2013.98, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_corellia_1_nospawn", -7132.79, 2340.4, 2013.98, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_corellia_1_rebel", -7132.79, 2340.4, 2013.98, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"rebel_easy"}, 100},
	{"space_corellia_2_traffic", -6345.5, -5274.5, -3957.25, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_corellia_2_nospawn", -6345.5, -5274.5, -3957.25, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_corellia_3_traffic", -1463.42, 318.86, -1012.24, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_corellia_3_nospawn", -1463.42, 318.86, -1012.24, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_corellia_3_rebel", -1463.42, 318.86, -1012.24, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"rebel_easy"}, 100},
	{"space_corellia_4_traffic", 6519.75, -5373.75, -2600.25, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_corellia_4_nospawn", 6519.75, -5373.75, -2600.25, {SPHERE, 1024}, NOSPAWNAREA},
}
