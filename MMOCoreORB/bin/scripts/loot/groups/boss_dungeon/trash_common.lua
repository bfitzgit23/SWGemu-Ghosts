trash_common = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "junk", weight = 5000000},      
		{itemTemplate = "collectiontierone", weight = 2000000},
		{itemTemplate = "clothing_attachments", weight = 1500000},
		{itemTemplate = "armor_attachments", weight = 1500000},
		{groupTemplate = "ls_gen5_group", weight = 50000},
		{groupTemplate = "jedi_comp_group", weight = 30000}
	}
}

addLootGroupTemplate("trash_common", trash_common)