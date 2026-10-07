--[[ Space Region Definitions - ship spawn areas around each space station.
     Generated from space_manager.lua station data. ]]

require("scripts.managers.space.regions.regions")

space_tatooine_regions = {
	{"space_tatooine_1_traffic", 2311.89, -5872.72, 1865.29, {CUBOID, 6144, 6144, 6144}, SPAWNAREA, {"corellia_traffic"}, 100},
	{"space_tatooine_1_nospawn", 2311.89, -5872.72, 1865.29, {SPHERE, 1024}, NOSPAWNAREA},
}
