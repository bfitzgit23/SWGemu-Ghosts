death_watch_blastromech = Creature:new {
	objectName = "@mob/creature_names:blastromech",
	socialGroup = "death_watch",
	faction = "",
	level = 180,
	chanceHit = 0.75,
	damageMin = 520,
	damageMax = 750,
	baseXp = 7668,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {145,165,200,160,200,125,140,175,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/blastromech.iff"},
	lootGroups = {
		{
			groups = {
					{group = "death_watch_bunker_commoners", chance = 625000}, -- 6.25%
					{group = "death_watch_bunker_lieutenants", chance = 625000}, -- 6.25%
					{group = "pistols", chance = 833333}, -- 8.33%
					{group = "rifles", chance = 833333}, -- 8.33%
					{group = "carbines", chance = 833333}, -- 8.33%
					{group = "wearables_uncommon", chance = 3250001}, -- 32.50%
					{group = "clothing_attachments", chance = 1500000}, -- 15.00%
					{group = "armor_attachments", chance = 1500000}, -- 15.00%
			}
		},
	},
	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_astromech_ranged.iff",
	defaultAttack = "attack",
}

CreatureTemplates:addCreatureTemplate(death_watch_blastromech, "death_watch_blastromech")
