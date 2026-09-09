mutated_rancor_sith = Creature:new {
	objectName = "",
	customName = "Mutated Sith Rancor",
	socialGroup = "sith",
	faction = "",
	level = 260,
	chanceHit = 28.0,
	damageMin = 1770,
	damageMax = 3350,
	baseXp = 24000,
	baseHAM = 360000,
	baseHAMmax = 440000,
	armor = 2,
	resists = {180,180,180,180,180,180,180,180,130},
	meatType = "meat_carnivore",
	meatAmount = 900,
	hideType = "hide_bristley",
	hideAmount = 850,
	boneType = "bone_mammal",
	boneAmount = 800,
	milk = 0,
	tamingChance = 0,
	ferocity = 25,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.0,  -- Normal size

	templates = {"object/mobile/beast_master/shared_bm_mutated_rancor_sith.iff"},
	lootGroups = {
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
		},
		{
			groups = {
				{group = "holocron_dark", chance = 5000000},
				{group = "holocron_light", chance = 5000000},
			},
			lootChance = 4000000
		},
		{
			groups = {
				{group = "crystals_premium", chance = 10000000},
			},
			lootChance = 6500000
		},
		{
			groups = {
				{group = "crystal_kuns_blood", chance = 10000000},
			},
			lootChance = 1500000
		},
		{
			groups = {
				{group = "tierone", chance = 4000000},
				{group = "tiertwo", chance = 4000000},
				{group = "tierthree", chance = 2000000},
			},
			lootChance = 7500000
		},
		{
			groups = {
				{group = "krayt_pearls", chance = 10000000},
			},
			lootChance = 1500000
		},
		{
			groups = {
				{group = "armor_attachments", chance = 5000000},
				{group = "clothing_attachments", chance = 5000000},
			},
			lootChance = 5500000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
		{"creatureareacombo","stateAccuracyBonus=80"},
		{"creatureareaknockdown","stateAccuracyBonus=80"},
		{"knockdownattack","KnockdownChance=50"},
		{"dizzyattack","DizzyChance=50"},
		{"stunattack","StunChance=50"}
	}
}

CreatureTemplates:addCreatureTemplate(mutated_rancor_sith, "mutated_rancor_sith")
