-- Hostile, temporary Luke used only for the Dark Lord final trial.
luke_skywalker_dark_trial = Creature:new {
    customName = "Luke Skywalker",
    socialGroup = "jedi",
    faction = "",
    level = 525,
    chanceHit = 52.50,
    damageMin = 3150,
    damageMax = 5793,
    baseXp = 487358,
    baseHAM = 736750,
    baseHAMmax = 1036000,
    armor = 3,
    resists = {79,79,79,79,79,79,79,79,79},
    meatType = "", meatAmount = 0,
    hideType = "", hideAmount = 0,
    boneType = "", boneAmount = 0,
    milk = 0, tamingChance = 0, ferocity = 0,
    pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
    creatureBitmask = KILLER + STALKER,
    optionsBitmask = AIENABLED,
    diet = HERBIVORE,
    templates = {"object/mobile/dressed_luke_skywalker.iff"},
    lootGroups = {},
    weapons = {"luke_skywalker_weapons"},
    reactionStf = "@npc_reaction/slang",
    attacks = merge(lightsabermaster, forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(luke_skywalker_dark_trial, "luke_skywalker_dark_trial")
