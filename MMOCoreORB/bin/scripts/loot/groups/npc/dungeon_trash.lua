-- Ghosts: self-contained dungeon trash/rare groups.
-- Only references groups that are actually registered by loot/groups.lua
-- (trash_common/trash_rare in groups/boss_dungeon are never included).

dungeon_trash = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "junk", weight = 3200000},
		{groupTemplate = "clothing_attachments", weight = 1500000},
		{groupTemplate = "armor_attachments", weight = 1500000},
		{groupTemplate = "collectiontiertwo", weight = 1400000},
		{groupTemplate = "power_crystals", weight = 700000},
		{groupTemplate = "krayt_pearls", weight = 400000},
		{groupTemplate = "ls_gen5_group", weight = 40000}
	}
}

addLootGroupTemplate("dungeon_trash", dungeon_trash)

dungeon_trash_rare = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "clothing_attachments", weight = 2400000},
		{groupTemplate = "armor_attachments", weight = 2400000},
		{groupTemplate = "krayt_pearls", weight = 1600000},
		{groupTemplate = "power_crystals", weight = 1600000},
		{groupTemplate = "collectiontiertwo", weight = 1400000},
		{groupTemplate = "ls_gen5_group", weight = 60000}
	}
}

addLootGroupTemplate("dungeon_trash_rare", dungeon_trash_rare)
