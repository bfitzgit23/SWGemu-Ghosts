chandrila_park_ranger = Creature:new {
	objectName = "@mob/creature_names:commoner",
	customName = "Chandrila Park Ranger",
	socialGroup = "townsperson",
	faction = "",
	level = 15,
	chanceHit = 0.1,
	damageMin = 15,
	damageMax = 30,
	baseXp = 300,
	baseHAM = 4000,
	baseHAMmax = 5000,
	armor = 0,
	resists = {15,15,15,15,15,15,15,-1,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.0,

	templates = {"object/mobile/dressed_imperial_major_m.iff"},
	lootGroups = {
		{
			groups = {
				{group = "trash_common", chance = 10000000}
			}
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(chandrila_park_ranger, "chandrila_park_ranger")
