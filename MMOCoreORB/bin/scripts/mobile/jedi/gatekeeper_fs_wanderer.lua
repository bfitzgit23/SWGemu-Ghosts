-- Temporary final-Padawan Gatekeeper. These are standard Force-sensitive
-- village appearances already used successfully by current server mobiles.
gatekeeper_fs_wanderer = Creature:new {
    customName = "The Gatekeeper",
    socialGroup = "neutral",
    faction = "",
    level = 1,
    chanceHit = 0,
    damageMin = 0,
    damageMax = 0,
    baseXp = 0,
    baseHAM = 1000,
    baseHAMmax = 1000,
    armor = 0,
    resists = {0, 0, 0, 0, 0, 0, 0, 0, -1},
    meatType = "", meatAmount = 0, hideType = "", hideAmount = 0,
    boneType = "", boneAmount = 0, milk = 0, tamingChance = 0,
    ferocity = 0,
    pvpBitmask = NONE,
    creatureBitmask = NONE,
    optionsBitmask = CONVERSABLE,
    diet = HERBIVORE,
    templates = {
        "object/mobile/dressed_fs_village_oldman.iff",
        "object/mobile/dressed_fs_village_elder.iff",
        "object/mobile/dressed_fs_trainer.iff",
        "object/mobile/dressed_fs_village_intro_woman.iff",
        "object/mobile/dressed_fs_village_quharek.iff"
    },
    lootGroups = {},
    weapons = {},
    conversationTemplate = "GatekeeperTrialConvoTemplate",
    attacks = {}
}

CreatureTemplates:addCreatureTemplate(gatekeeper_fs_wanderer, "gatekeeper_fs_wanderer")
