-- Knight Trial Guardian — Wave 1
-- Template key: trial_guardian_wave1
-- Name set at spawn time via setCustomObjectName()
-- Light names: Wave1=Sith Acolyte, Wave2=Sith Marauder, Wave3=Sith Lord, Wave4=Sith Champion
-- Dark names:  Wave1=Shadow Initiate, Wave2=Shadow Warrior, Wave3=Shadow Lord, Wave4=Shadow Champion
-- Coded by BoosterSteel 19-03-2026

trial_guardian_wave1 = Creature:new {
	objectName = "@mob/creature_names:dark_adept",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	socialGroup = "",
	faction = "",
	level = 188,
	chanceHit = 25.0,
	damageMin = 1200,
	damageMax = 2000,
	baseXp = 6600,
	baseHAM = 78000,
	baseHAMmax = 88000,
	armor = 3,
	resists = {30,30,30,30,30,30,30,30,20},
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
	lootGroups = {},
	weapons = {"dark_jedi_weapons_gen4"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster, forcewielder)
}

CreatureTemplates:addCreatureTemplate(trial_guardian_wave1, "trial_guardian_wave1")
