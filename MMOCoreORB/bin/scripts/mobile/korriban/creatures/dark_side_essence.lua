dark_side_essence = Creature:new {
	objectName = "",
	customName = "Dark Side Essence",
	socialGroup = "sith",
	faction = "",
	level = 280,
	chanceHit = 30.0,
	damageMin = 1870,
	damageMax = 3500,
	baseXp = 26000,
	baseHAM = 280000,
	baseHAMmax = 350000,
	armor = 2,
	resists = {185,185,185,185,185,185,185,185,135},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.2,  -- Slightly larger

	templates = {"object/mobile/ep3/shared_sith_hologram.iff"},
	lootGroups = {
		{
			groups = {
				{group = "holocron_dark", chance = 6000000},
				{group = "holocron_light", chance = 4000000},
			},
			lootChance = 6000000
		},
		{
			groups = {
				{group = "crystals_premium", chance = 10000000},
			},
			lootChance = 7500000
		},
		{
			groups = {
				{group = "crystal_kuns_blood", chance = 10000000},
			},
			lootChance = 2500000
		},
		{
			groups = {
				{group = "color_crystals", chance = 10000000},
			},
			lootChance = 8000000
		},
		{
			groups = {
				{group = "tierone", chance = 3000000},
				{group = "tiertwo", chance = 4000000},
				{group = "tierthree", chance = 3000000},
			},
			lootChance = 8000000
		},
		{
			groups = {
				{group = "armor_attachments", chance = 5000000},
				{group = "clothing_attachments", chance = 5000000},
			},
			lootChance = 6000000
		},
		{
			groups = {
				{group = "dark_jedi_common", chance = 10000000},
			},
			lootChance = 5000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = merge(forcepowermaster,fencermid,swordsmanmid)
}

CreatureTemplates:addCreatureTemplate(dark_side_essence, "dark_side_essence")
