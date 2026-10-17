-- Ghosts (2026-10-12): wrapper group for dangling loot reference.

collectiontiertwo = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "collectiontiertwo", weight = 10000000}
	}
}

addLootGroupTemplate("collectiontiertwo", collectiontiertwo)
