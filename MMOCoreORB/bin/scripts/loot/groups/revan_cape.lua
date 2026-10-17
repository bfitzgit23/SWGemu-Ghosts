-- Ghosts (2026-10-12): wrapper group for dangling loot reference.

revan_cape = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "revan_cape", weight = 10000000}
	}
}

addLootGroupTemplate("revan_cape", revan_cape)
