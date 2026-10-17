-- Ghosts (2026-10-12): wrapper group for dangling loot reference.

revan_robe = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "revan_robe", weight = 10000000}
	}
}

addLootGroupTemplate("revan_robe", revan_robe)
