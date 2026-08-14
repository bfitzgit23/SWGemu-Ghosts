sith_dragon = Creature:new {
	objectName = "",
	customName = "<< Sith Dragon >>",
	socialGroup = "sith",
	faction = "",
	level = 320,
	chanceHit = 35.0,
	damageMin = 2270,
	damageMax = 4500,
	baseXp = 30000,
	baseHAM = 450000,
	baseHAMmax = 550000,
	armor = 3,
	resists = {195,195,195,195,195,195,195,195,145},
	meatType = "meat_carnivore",
	meatAmount = 1000,
	hideType = "hide_leathery",
	hideAmount = 1000,
	boneType = "bone_mammal",
	boneAmount = 1000,
	milk = 0,
	tamingChance = 0,
	ferocity = 30,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 2.0,  -- 2x bigger!

	templates = {"object/mobile/shared_kimogila_sith.iff"},
	lootGroups = {
		{
			groups = {
				{group = "krayt_pearls_flawless", chance = 10000000},
			},
			lootChance = 3000000
		},
		{
			groups = {
				{group = "vehicledeedsrare", chance = 10000000},
			},
			lootChance = 150000
		},
		{
			groups = {
				{group = "holocron_dark", chance = 5000000},
				{group = "holocron_light", chance = 5000000},
			},
			lootChance = 5000000
		},
		{
			groups = {
				{group = "crystals_premium", chance = 10000000},
			},
			lootChance = 8000000
		},
		{
			groups = {
				{group = "crystal_kuns_blood", chance = 10000000},
			},
			lootChance = 2000000
		},
		{
			groups = {
				{group = "tierone", chance = 3000000},
				{group = "tiertwo", chance = 4000000},
				{group = "tierthree", chance = 2000000},
				{group = "tierdiamond", chance = 1000000},
			},
			lootChance = 9000000
		},
		{
			groups = {
				{group = "armor_attachments", chance = 5000000},
				{group = "clothing_attachments", chance = 5000000},
			},
			lootChance = 7000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
		{"creatureareacombo","stateAccuracyBonus=100"},
		{"creatureareaknockdown","stateAccuracyBonus=100"},
		{"knockdownattack","KnockdownChance=70"},
		{"dizzyattack","DizzyChance=70"},
		{"stunattack","StunChance=70"}
	}
}

CreatureTemplates:addCreatureTemplate(sith_dragon, "sith_dragon")
