dark_trooper_inactive = Creature:new {
	objectName = "@mob/creature_names:dark_trooper",
	customName = "Dark Trooper (Inactive)",
	socialGroup = "imperial",
	faction = "imperial",
	level = 35,
	chanceHit = 0.4,
	damageMin = 305,
	damageMax = 320,
	baseXp = 3465,
	baseHAM = 9000,
	baseHAMmax = 10000,
	armor = 0,
	resists = {40,20,20,50,50,50,50,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + OVERT,
	creatureBitmask = PACK + KILLER + NOINTIMIDATE + NODOT,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.5,

	templates = {"object/mobile/dark_trooper.iff"},
	lootGroups = {
		{
			groups = {
				{group = "imperial_marshall_tier_1", chance = 10000000}
			}
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = merge(riflemanmaster, carbineermaster, brawlermaster)
}

CreatureTemplates:addCreatureTemplate(dark_trooper_inactive, "dark_trooper_inactive")
