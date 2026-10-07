--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_dathomir_regions = {
	{"space_dathomir_1_traffic", 4842.19, -5316.32, -4222.79, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_dathomir_1_nospawn", 4842.19, -5316.32, -4222.79, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_dathomir_1_imperial", 4842.19, -5316.32, -4222.79, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_dathomir_2_traffic", 6092.23, 6223.58, -6731.9, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_dathomir_2_nospawn", 6092.23, 6223.58, -6731.9, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_dathomir_2_imperial", 6092.23, 6223.58, -6731.9, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"imperial_easy"}, 100},
	{"space_dathomir_3_traffic", 4000, 200, -4700, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_dathomir_3_nospawn", 4000, 200, -4700, {SPHERE, 1024}, NOSPAWNAREA},
	{"space_dathomir_4_traffic", -7078.75, 2879, -4293.75, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_dathomir_4_nospawn", -7078.75, 2879, -4293.75, {SPHERE, 1024}, NOSPAWNAREA},
}
