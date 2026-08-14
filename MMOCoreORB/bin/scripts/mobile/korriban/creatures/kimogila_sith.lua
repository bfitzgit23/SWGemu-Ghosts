kimogila_sith = Creature:new {
	objectName = "",
	customName = "Sith Dragon",
	socialGroup = "sith",
	faction = "",
	level = 250,
	chanceHit = 28.0,
	damageMin = 1770,
	damageMax = 3250,
	baseXp = 24000,
	baseHAM = 350000,
	baseHAMmax = 420000,
	armor = 2,
	resists = {175,175,175,175,175,175,175,175,125},
	meatType = "meat_carnivore",
	meatAmount = 850,
	hideType = "hide_leathery",
	hideAmount = 800,
	boneType = "bone_mammal",
	boneAmount = 750,
	milk = 0,
	tamingChance = 0,
	ferocity = 25,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.0,  -- Normal size

	templates = {"object/mobile/shared_kimogila_sith.iff"},
	lootGroups = {
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
			lootChance = 6000000
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
			lootChance = 7000000
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
			lootChance = 5000000
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {
		{"creatureareacombo","stateAccuracyBonus=80"},
		{"creatureareaknockdown","stateAccuracyBonus=80"},
		{"knockdownattack","KnockdownChance=50"},
		{"stunattack","StunChance=50"}
	}
}

CreatureTemplates:addCreatureTemplate(kimogila_sith, "kimogila_sith")
