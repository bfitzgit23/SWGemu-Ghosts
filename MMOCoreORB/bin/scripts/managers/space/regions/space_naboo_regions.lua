--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_naboo_regions = {
	{"space_naboo_1_traffic", 3511.83, 1774.71, 944.36, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"naboo_traffic"}, 100},
	{"space_naboo_1_nospawn", 3511.83, 1774.71, 944.36, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_naboo_1_imperial", 3511.83, 1774.71, 944.36, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_naboo_2_traffic", -2491.26, 905.49, -6460.67, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"naboo_traffic"}, 100},
	{"space_naboo_2_nospawn", -2491.26, 905.49, -6460.67, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_naboo_3_traffic", 6226.22, -4450.57, 484.75, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"naboo_traffic"}, 100},
	{"space_naboo_3_nospawn", 6226.22, -4450.57, 484.75, {SPHERE, 1024}, NOSPAWNAREA},
}
