--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_yavin4_regions = {
	{"space_yavin4_1_traffic", -6798.55, 4998.69, 4760.4, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_yavin4_1_nospawn", -6798.55, 4998.69, 4760.4, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_yavin4_1_imperial", -6798.55, 4998.69, 4760.4, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_yavin4_2_traffic", -4190.56, 1539.35, 4596.82, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_yavin4_2_nospawn", -4190.56, 1539.35, 4596.82, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_yavin4_2_imperial", -4190.56, 1539.35, 4596.82, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_yavin4_3_traffic", 85.21, -342.3, -57.62, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_yavin4_3_nospawn", 85.21, -342.3, -57.62, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_yavin4_3_imperial", 85.21, -342.3, -57.62, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_yavin4_4_traffic", -5570.46, -5168, -5234.88, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_yavin4_4_nospawn", -5570.46, -5168, -5234.88, {SPHERE, 1024}, NOSPAWNAREA},
}
