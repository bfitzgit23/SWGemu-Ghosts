dressed_rakqua_warrior_02 = Creature:new {
	customName = "Rakqua Warrior",
	randomNameTag = true,
	socialGroup = "rakqua",
	faction = "",
	level = 200,
	chanceHit = 14.0,
	damageMin = 1045,
	damageMax = 1800,
	baseXp = 18500,
	baseHAM = 140000,
	baseHAMmax = 180000,
	armor = 2,
	resists = {155,155,155,155,135,155,155,155,105},
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

	templates = {"object/mobile/npe/dressed_rakqua_warrior_02.iff"},
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
	weapons = {"dark_jedi_weapons_gen3"},
	conversationTemplate = "",
	attacks = merge(fencermid,swordsmanmid,tkamid,pikemanmaster,brawlermaster)
}

CreatureTemplates:addCreatureTemplate(dressed_rakqua_warrior_02, "dressed_rakqua_warrior_02")
