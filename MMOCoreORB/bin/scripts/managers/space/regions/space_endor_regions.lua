--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_endor_regions = {
	{"space_endor_1_traffic", 5773.37, -6359.57, 6976.04, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_endor_1_nospawn", 5773.37, -6359.57, 6976.04, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_endor_1_imperial", 5773.37, -6359.57, 6976.04, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_endor_2_traffic", 6200, 5000, 6000, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_endor_2_nospawn", 6200, 5000, 6000, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_endor_2_imperial", 6200, 5000, 6000, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_endor_3_traffic", -5716.48, 7198.22, 2009.09, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_endor_3_nospawn", -5716.48, 7198.22, 2009.09, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_endor_3_imperial", -5716.48, 7198.22, 2009.09, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_endor_4_traffic", -5268.23, -1500.23, 5209.39, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_endor_4_nospawn", -5268.23, -1500.23, 5209.39, {SPHERE, 1024}, NOSPAWNAREA},
}
