acklay_sith = Creature:new {
	objectName = "",
	customName = "Sith Acklay",
	socialGroup = "sith",
	faction = "",
	level = 240,
	chanceHit = 26.0,
	damageMin = 1670,
	damageMax = 3050,
	baseXp = 22000,
	baseHAM = 320000,
	baseHAMmax = 390000,
	armor = 2,
	resists = {170,170,170,170,170,170,170,170,120},
	meatType = "meat_carnivore",
	meatAmount = 750,
	hideType = "hide_scaley",
	hideAmount = 700,
	boneType = "bone_mammal",
	boneAmount = 650,
	milk = 0,
	tamingChance = 0,
	ferocity = 20,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.0,  -- Normal size

	templates = {"object/mobile/beast_master/shared_bm_acklay_sith.iff"},
	lootGroups = {
	},
		{
			groups = {
				{group = "tierone", chance = 1500000},
				{group = "tiertwo", chance = 3500000},
				{group = "tierthree", chance = 2500000},
				{group = "tierdiamond", chance = 2500000},
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "tierone", chance = 1500000},
				{group = "tiertwo", chance = 3500000},
				{group = "tierthree", chance = 2500000},
				{group = "tierdiamond", chance = 2500000},
			},
			lootChance = 10000000
		}
		{
			groups = {
				{group = "holocron_dark", chance = 5000000},
				{group = "holocron_light", chance = 5000000},
			},
			lootChance = 3500000
		},
	
		{
			groups = {
				{group = "crystal_kuns_blood", chance = 10000000},
			},
			lootChance = 1200000
		},
		{
			groups = {
				{group = "tierone", chance = 4000000},
				{group = "tiertwo", chance = 4000000},
				{group = "tierthree", chance = 2000000},
			},
			lootChance = 7000000
		},
		{
			groups = {
				{group = "krayt_pearls", chance = 10000000},
			},
			lootChance = 1200000
		},
		{
			groups = {
				{group = "armor_attachments", chance = 5000000},
				{group = "clothing_attachments", chance = 5000000},
			},
			lootChance = 5000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
		{"creatureareacombo","stateAccuracyBonus=75"},
		{"creatureareaknockdown","stateAccuracyBonus=75"},
		{"knockdownattack","KnockdownChance=45"},
		{"blindattack","BlindChance=45"}
	}
}

CreatureTemplates:addCreatureTemplate(acklay_sith, "acklay_sith")
