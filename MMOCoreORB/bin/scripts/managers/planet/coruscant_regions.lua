-- Coruscant region definitions
--
-- Ghosts 2026-11-19: this file was empty, so the planet had zero regions and the
-- world spawner never ran - no NPCs, no creatures anywhere. The starports keep a
-- no-spawn bubble, everything else is underworld spawning.

require("scripts.managers.planet.regions")

coruscant_regions = {
	{"collective_commerce_starport", -1851, -175, {CIRCLE, 250}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"monument_square_starport", 1538, 779, {CIRCLE, 250}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"entertainment_district_starport", 2248, -4546, {CIRCLE, 250}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"coruscant_world", "global"}, 2048},
}
