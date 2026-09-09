chandrila_park_ranger = Creature:new {
	customName = "a Chandrila Park Ranger",
	socialGroup = "townsperson",
	faction = "rebel",
	level = 15,
	chanceHit = 0.2,
	damageMin = 15,
	damageMax = 40,
	baseXp = 200,
	baseHAM = 3500,
	baseHAMmax = 4500,
	armor = 2,
	resists = {10,10,10,10,10,10,10,10,10},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_rebel_guard_human_male_01.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(chandrila_park_ranger, "chandrila_park_ranger")

