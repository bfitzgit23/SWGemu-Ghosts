chandriltech_contractor = Creature:new {
	objectName = "@mob/creature_names:commoner",
	customName = "ChandrilTech Contractor",
	socialGroup = "townsperson",
	faction = "",
	level = 10,
	chanceHit = 0.1,
	damageMin = 10,
	damageMax = 20,
	baseXp = 200,
	baseHAM = 3000,
	baseHAMmax = 4000,
	armor = 0,
	resists = {10,10,10,10,10,10,10,-1,-1},
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

	templates = {"object/mobile/dressed_mand_bunker_technician.iff"},
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

CreatureTemplates:addCreatureTemplate(chandriltech_contractor, "chandriltech_contractor")
