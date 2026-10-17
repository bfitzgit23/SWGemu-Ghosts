-- Ghosts (2026-10-12): wrapper group for dangling loot reference.

collectiontierthree = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "collectiontierthree", weight = 10000000}
	}
}

addLootGroupTemplate("collectiontierthree", collectiontierthree)
