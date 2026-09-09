color_crystals = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "force_color_crystal",          weight = 9900000},  -- 99% plain
		{groupTemplate = "color_crystals_dot_chance",   weight = 100000},   --  1% -> sub-group
	}
}

addLootGroupTemplate("color_crystals", color_crystals)
