dressed_rakqua_bowman_01 = Creature:new {
	customName = "Rakqua Bowman",
	randomNameTag = true,
	socialGroup = "rakqua",
	faction = "",
	level = 200,
	chanceHit = 13.0,
	damageMin = 995,
	damageMax = 1700,
	baseXp = 18000,
	baseHAM = 130000,
	baseHAMmax = 170000,
	armor = 1,
	resists = {145,145,145,145,125,145,145,145,95},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0.0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/npe/dressed_rakqua_bowman_01.iff"},
	lootGroups = {
		{
			groups = {
				{group = "holocron_dark", chance = 400000},
				{group = "holocron_light", chance = 400000},
				{group = "crystals_premium", chance = 500000},
				{group = "crystal_kuns_blood", chance = 200000},
				{group = "color_crystals", chance = 1000000},
				{group = "armor_attachments", chance = 800000},
				{group = "clothing_attachments", chance = 800000},
				{group = "krayt_pearls", chance = 200000},
				{group = "dark_jedi_common", chance = 600000}
			},
			lootChance = 8000000
		}
	},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	attacks = merge(marksmanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(dressed_rakqua_bowman_01, "dressed_rakqua_bowman_01")
