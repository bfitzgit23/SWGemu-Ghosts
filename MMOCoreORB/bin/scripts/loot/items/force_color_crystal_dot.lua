-- DOT variant of the standard force color crystal.
-- Rolls a random color AND a random DOT type/stats.
-- dotType:      1=Poison, 2=Disease, 3=Fire, 4=Bleeding
-- dotAttribute: 0=Health, 1=Action, 2=Mind (mapped to HAM pools 0/3/6 in LightsaberCrystalComponentImplementation)

force_color_crystal_dot = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"color",         0,     11, 0},  -- random color (0-11)
		{"dotType",       1,      4, 0},  -- 1=Poison 2=Disease 3=Fire 4=Bleeding
		{"dotAttribute",  0,      2, 0},  -- 0=Health 1=Action 2=Mind
		{"dotStrength",   1500, 3000, 0}, -- damage per tick
		{"dotDuration",   800,  1600, 0}, -- duration in seconds
		{"dotPotency",    40,     85, 0}, -- chance to apply (%)
		{"dotUses",       9000, 95000, 0},-- charges before DOT depletes
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_color_crystal_dot", force_color_crystal_dot)