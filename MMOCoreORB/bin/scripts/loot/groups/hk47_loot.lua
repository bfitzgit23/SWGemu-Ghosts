-- HK-47 Pet Deed Loot Group

hk47_loot = {
	description = "HK-47 Pet Deed",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "hk47_deed", weight = 10000000},
	},
}

addLootGroupTemplate("hk47_loot", hk47_loot)
