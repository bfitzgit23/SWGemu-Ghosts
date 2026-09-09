dengar = Creature:new {
	objectName = "@mob/creature_names:dengar",
	customName = "Dengar",
	socialGroup = "mercenary",
	faction = "",
	level = 45,
	chanceHit = 0.5,
	damageMin = 400,
	damageMax = 600,
	baseXp = 5000,
	baseHAM = 15000,
	baseHAMmax = 20000,
	armor = 1,
	resists = {50,50,50,50,50,50,50,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.0,

	templates = {"object/mobile/dressed_stormtrooper_m.iff"},
	lootGroups = {
		{
			groups = {
				{group = "boss_common", chance = 10000000}
			},
			lootChance = 5000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = merge(riflemanmaster, carbineermaster, brawlermaster)
}

CreatureTemplates:addCreatureTemplate(dengar, "dengar")
