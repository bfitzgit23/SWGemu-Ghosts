dressed_rakqua_overlord = Creature:new {
	customName = "Rakqua Overlord",
	randomNameTag = false,
	socialGroup = "rakqua",
	faction = "",
	level = 200,
	chanceHit = 15.0,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19000,
	baseHAM = 150000,
	baseHAMmax = 200000,
	armor = 2,
	resists = {165,165,165,165,145,165,165,165,115},
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

	templates = {"object/mobile/npe/dressed_rakqua_overlord.iff"},
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
	weapons = {"dark_jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = merge(fencermid,swordsmanmid,tkamid,pikemanmaster,brawlermaster,forcewielder)
}

CreatureTemplates:addCreatureTemplate(dressed_rakqua_overlord, "dressed_rakqua_overlord")
