--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_lok_regions = {
	{"space_lok_1_traffic", -1798.64, 2649.25, 400.89, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_lok_1_nospawn", -1798.64, 2649.25, 400.89, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_lok_1_imperial", -1798.64, 2649.25, 400.89, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_lok_2_traffic", -6235.21, -5341.59, 113.86, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_lok_2_nospawn", -6235.21, -5341.59, 113.86, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_lok_3_traffic", 1799.13, -2458.57, -3680.29, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_lok_3_nospawn", 1799.13, -2458.57, -3680.29, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_lok_3_rebel", 1799.13, -2458.57, -3680.29, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"rebel_easy"}, 100},
}
