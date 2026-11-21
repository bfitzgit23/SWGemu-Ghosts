boss_common = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "mustafar_glowing_elite", weight = 500000},
		{groupTemplate = "vehicledeedsnormal", weight = 1029816},
		{groupTemplate = "goggles_all", weight = 1029810},
		{groupTemplate = "capes", weight = 1029809},  
		{itemTemplate = "krayt_pearls", weight = 1029810},      
		{itemTemplate = "power_crystals", weight = 1029810},      
		{groupTemplate = "color_crystals", weight = 1029810}, 
		{groupTemplate = "nonjedi_jewelry", weight = 1029810},      
		{itemTemplate = "clothing_attachments", weight = 1029810},
		{itemTemplate = "armor_attachments", weight = 1029810},
		{groupTemplate = "ls_gen5_group", weight = 139023},
		{groupTemplate = "jedi_comp_group", weight = 92682}   
		
	}
}

addLootGroupTemplate("boss_common", boss_common)