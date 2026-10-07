boss_common = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "vehicledeedsnormal", weight = 1111111},
		{groupTemplate = "goggles_all", weight = 1111111},
		{groupTemplate = "capes", weight = 1111112},  
		{itemTemplate = "krayt_pearls", weight = 1111111},      
		{itemTemplate = "power_crystals", weight = 1111111},      
		{groupTemplate = "color_crystals", weight = 1111111}, 
		{groupTemplate = "nonjedi_jewelry", weight = 1111111},      
		{itemTemplate = "clothing_attachments", weight = 1111111},
		{itemTemplate = "armor_attachments", weight = 1111111},
		{groupTemplate = "ls_gen5_group", weight = 150000},
		{groupTemplate = "jedi_comp_group", weight = 100000}   
		
	}
}

addLootGroupTemplate("boss_common", boss_common)