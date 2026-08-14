-- Knight Trial Guardian — Wave 4
-- Template key: trial_guardian_wave4
-- Name set at spawn time via setCustomObjectName()
-- Light names: Wave1=Sith Acolyte, Wave2=Sith Marauder, Wave3=Sith Lord, Wave4=Sith Champion
-- Dark names:  Wave1=Shadow Initiate, Wave2=Shadow Warrior, Wave3=Shadow Lord, Wave4=Shadow Champion
-- Coded by BoosterSteel 19-03-2026

trial_guardian_wave4 = Creature:new {
	objectName = "@mob/creature_names:dark_adept",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "",
	faction = "",
	level = 413,
	chanceHit = 55.0,
	damageMin = 2800,
	damageMax = 4400,
	baseXp = 14500,
	baseHAM = 170000,
	baseHAMmax = 193000,
	armor = 3,
	resists = {66,66,66,66,66,66,66,66,56},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	templates = {"dark_jedi"},
	lootGroups = {
		{
			groups = {
				{group = "holocron_dark", chance = 2000000},
				{group = "holocron_light", chance = 2000000},
				{group = "power_crystals", chance = 2000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
			},
			lootChance = 10000000
		},
	},
	weapons = {"dark_jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster, forcewielder, forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(trial_guardian_wave4, "trial_guardian_wave4")
