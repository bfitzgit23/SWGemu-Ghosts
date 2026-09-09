dressed_rakqua_witch_02 = Creature:new {
	customName = "Rakqua Witch",
	randomNameTag = true,
	socialGroup = "rakqua",
	faction = "",
	level = 200,
	chanceHit = 12.0,
	damageMin = 945,
	damageMax = 1600,
	baseXp = 18000,
	baseHAM = 120000,
	baseHAMmax = 160000,
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

	templates = {"object/mobile/npe/dressed_rakqua_witch_02.iff"},
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
	attacks = merge(forcepowermaster,fencermid,swordsmanmid)
}

CreatureTemplates:addCreatureTemplate(dressed_rakqua_witch_02, "dressed_rakqua_witch_02")
