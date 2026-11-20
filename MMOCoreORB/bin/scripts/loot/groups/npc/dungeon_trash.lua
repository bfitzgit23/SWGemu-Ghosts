-- Ghosts: self-contained dungeon trash/rare groups.
-- Only references groups that are actually registered by loot/groups.lua
-- (trash_common/trash_rare in groups/boss_dungeon are never included).

dungeon_trash = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "junk", weight = 1758242},
		{groupTemplate = "clothing_attachments", weight = 824176},
		{groupTemplate = "armor_attachments", weight = 824176},
		{groupTemplate = "collectiontiertwo", weight = 769231},
		{groupTemplate = "power_crystals", weight = 384615},
		{groupTemplate = "krayt_pearls", weight = 219780},
		{groupTemplate = "ls_gen5_group", weight = 21978}
	}
}

addLootGroupTemplate("dungeon_trash", dungeon_trash)

dungeon_trash_rare = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "clothing_attachments", weight = 1318681},
		{groupTemplate = "armor_attachments", weight = 1318681},
		{groupTemplate = "krayt_pearls", weight = 879121},
		{groupTemplate = "power_crystals", weight = 879121},
		{groupTemplate = "collectiontiertwo", weight = 769231},
		{groupTemplate = "ls_gen5_group", weight = 32967}
	}
}

addLootGroupTemplate("dungeon_trash_rare", dungeon_trash_rare)
