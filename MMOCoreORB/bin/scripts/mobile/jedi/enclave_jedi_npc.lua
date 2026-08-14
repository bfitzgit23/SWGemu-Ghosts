--[[
    Ghosts of the Old Republic - Enclave Jedi NPC Template
    Location: MMOCoreORB/bin/scripts/mobile/jedi/enclave_jedi_npc.lua

    Used for Council Elder, Dark Arbiter, Jedi Grand Master, Dark Council Sovereign.
    - CONVERSABLE: shows talk cursor, allows radial menu interaction
    - No AIENABLED: fully stationary, no pathfinding, no ramp-running
    - pvpBitmask = NONE: non-attackable
    - IFF: shared_dressed_fs_village_oldman.iff (confirmed working in this build)
--]]

enclave_jedi_npc = Creature:new {
    customName          = "Jedi",
    socialGroup         = "neutral",
    faction             = "",
    level               = 1,
    chanceHit           = 0.0,
    damageMin           = 0,
    damageMax           = 0,
    baseXp              = 0,
    baseHAM             = 1000,
    baseHAMmax          = 1000,
    pvpBitmask          = NONE,
    creatureBitmask     = NONE,
    optionsBitmask      = CONVERSABLE,   -- Talk cursor, no AI movement
    templates           = { "object/mobile/dressed_fs_village_elder.iff" },
    attacks             = {},
}

CreatureTemplates:addCreatureTemplate(enclave_jedi_npc, "enclave_jedi_npc")