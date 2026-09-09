-- Secondary color-crystal roll: 75% plain, 25% DOT crystal.
color_crystals_dot_chance = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "force_color_crystal", weight = 7500000},
		{itemTemplate = "force_color_crystal_dot", weight = 2500000},
	}
}

addLootGroupTemplate("color_crystals_dot_chance", color_crystals_dot_chance)
