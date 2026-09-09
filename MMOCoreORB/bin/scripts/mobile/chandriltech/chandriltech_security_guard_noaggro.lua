chandriltech_security_guard_noaggro = Creature:new {
	objectName = "@mob/creature_names:stormtrooper",
	customName = "ChandrilTech Security Guard",
	socialGroup = "mercenary",
	faction = "",
	level = 30,
	chanceHit = 0.4,
	damageMin = 200,
	damageMax = 300,
	baseXp = 2500,
	baseHAM = 8000,
	baseHAMmax = 10000,
	armor = 0,
	resists = {30,20,20,40,40,40,40,-1,-1},
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

	templates = {"object/mobile/dressed_stormtrooper_m.iff"},
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

CreatureTemplates:addCreatureTemplate(chandriltech_security_guard_noaggro, "chandriltech_security_guard_noaggro")
