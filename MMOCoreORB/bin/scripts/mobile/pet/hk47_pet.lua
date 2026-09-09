hk47_pet = Creature:new {
	customName = "HK-47",
	socialGroup = "",
	faction = "",
	level = 10,
	mobType = MOB_DROID,
	chanceHit = 0.45,
	damageMin = 180,
	damageMax = 240,
	baseXp = 0,
	baseHAM = 5000,
	baseHAMmax = 5500,
	armor = 1,
	resists = {25,25,25,25,25,25,25,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = HERD,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/som/shared_hk47.iff"
	},
	lootGroups = {},
	defaultAttack = "attack",
	primaryWeapon = "droid_probot_ranged",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",
}

CreatureTemplates:addCreatureTemplate(hk47_pet, "hk47_pet")
