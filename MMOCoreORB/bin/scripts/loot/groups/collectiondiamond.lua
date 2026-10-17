-- Ghosts (2026-10-12): wrapper group for dangling loot reference.

collectiondiamond = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "collectiondiamond", weight = 10000000}
	}
}

addLootGroupTemplate("collectiondiamond", collectiondiamond)
