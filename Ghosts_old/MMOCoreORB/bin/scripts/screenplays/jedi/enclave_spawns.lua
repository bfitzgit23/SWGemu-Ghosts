--[[
    Aftermath Server - Enclave NPC Spawns
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/enclave_spawns.lua

    Spawns the Knight trial NPCs inside both enclaves on Yavin 4.
    Called once at server startup via screenplays.lua.

    Enclave coordinates sourced from the existing FRS enclave
    structures on Yavin 4 — these are the stock SWG enclave buildings.

    LIGHT JEDI ENCLAVE  (Yavin 4)
        Approximate exterior coords: -5575, 4303
        The NPC is placed just inside the main hall entrance.

    DARK JEDI ENCLAVE   (Yavin 4)
        Approximate exterior coords: 5108, 3455
        The NPC is placed just inside the main hall entrance.

    IMPORTANT: The exact X/Z/Y coords inside the building cells
    may need tweaking. Use /getpos in-game on your admin character
    to get precise interior coords, then update the values below.
    Cell IDs are 0 for outdoors, or the building cell poid for interiors.
--]]

EnclaveSpawns = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "EnclaveSpawns",
}

registerScreenPlay("EnclaveSpawns", true)

-- ============================================================
-- SPAWN CONFIGURATION
-- ============================================================

-- Light Jedi Enclave Knight NPC
-- Cell: lobby (8525439) — just inside the main entrance hall
local LIGHT_NPC_CONFIG = {
    zone        = "yavin4",
    template    = "dressed_dark_jedi_elder_male_human_01",
    name        = "Council Elder",
    x           = 8.0,
    z           = -18.9,
    y           = 20.0,
    heading     = 180,
    cellID      = 8525439,
}

-- Dark Jedi Enclave Knight NPC
-- Cell: antechamber (3435634) — just inside the main entrance
local DARK_NPC_CONFIG = {
    zone        = "yavin4",
    template    = "dressed_dark_jedi_male_human_06",
    name        = "Dark Arbiter",
    x           = 16.0,
    z           = -43.4,
    y           = -35.0,
    heading     = 0,
    cellID      = 3435634,
}

-- Light Jedi Enclave Master NPC
-- Cell: auditorium (8525418) — the arena room deeper inside
local LIGHT_MASTER_NPC_CONFIG = {
    zone        = "yavin4",
    template    = "dressed_padawan_male_human_01",
    name        = "Jedi Grand Master",
    x           = 0.0,
    z           = -15.1,
    y           = 24.4,
    heading     = 180,
    cellID      = 8525418,
}

-- Dark Jedi Enclave Master NPC
-- Cell: arenahall (3435636) — the arena room deeper inside
local DARK_MASTER_NPC_CONFIG = {
    zone        = "yavin4",
    template    = "dressed_dark_jedi_male_human_06",
    name        = "Dark Council Sovereign",
    x           = 0.0,
    z           = -43.4,
    y           = -31.1,
    heading     = 0,
    cellID      = 3435636,
}

-- ============================================================
-- STORED NPC OBJECT IDS
-- Used to check if NPCs are still alive and respawn if needed
-- ============================================================

local lightNpcID       = 0
local darkNpcID        = 0
local lightMasterNpcID = 0
local darkMasterNpcID  = 0

-- ============================================================
-- STARTUP SPAWN
-- Called once when screenplays load at server start
-- ============================================================

function EnclaveSpawns:start()
    self:spawnLightNPC()
    self:spawnDarkNPC()
    self:spawnLightMasterNPC()
    self:spawnDarkMasterNPC()

    createEvent(300000, "EnclaveSpawns", "checkAndRespawn", nil, "")
end

-- ============================================================
-- SPAWN LIGHT ENCLAVE NPC
-- ============================================================

function EnclaveSpawns:spawnLightNPC()
    local cfg = LIGHT_NPC_CONFIG

    local pNPC = spawnMobile(cfg.zone, cfg.template, 0, cfg.x, cfg.z, cfg.y, cfg.heading, cfg.cellID)

    if pNPC == nil then
        print("EnclaveSpawns: ERROR — Failed to spawn Light Enclave NPC on " .. cfg.zone)
        return
    end

    SceneObject(pNPC):setCustomObjectName(cfg.name)
    CreatureObject(pNPC):setConversationTemplate("LightEnclaveKnight")

    lightNpcID = SceneObject(pNPC):getObjectID()
    print("EnclaveSpawns: Council Elder spawned (ID: " .. lightNpcID .. ")")
end

-- ============================================================
-- SPAWN DARK ENCLAVE KNIGHT NPC
-- ============================================================

function EnclaveSpawns:spawnDarkNPC()
    local cfg = DARK_NPC_CONFIG

    local pNPC = spawnMobile(cfg.zone, cfg.template, 0, cfg.x, cfg.z, cfg.y, cfg.heading, cfg.cellID)

    if pNPC == nil then
        print("EnclaveSpawns: ERROR — Failed to spawn Dark Enclave NPC on " .. cfg.zone)
        return
    end

    SceneObject(pNPC):setCustomObjectName(cfg.name)
    CreatureObject(pNPC):setConversationTemplate("DarkEnclaveKnight")

    darkNpcID = SceneObject(pNPC):getObjectID()
    print("EnclaveSpawns: Dark Arbiter spawned (ID: " .. darkNpcID .. ")")
end

-- ============================================================
-- SPAWN LIGHT MASTER NPC
-- ============================================================

function EnclaveSpawns:spawnLightMasterNPC()
    local cfg = LIGHT_MASTER_NPC_CONFIG

    local pNPC = spawnMobile(cfg.zone, cfg.template, 0, cfg.x, cfg.z, cfg.y, cfg.heading, cfg.cellID)

    if pNPC == nil then
        print("EnclaveSpawns: ERROR — Failed to spawn Light Master NPC on " .. cfg.zone)
        return
    end

    SceneObject(pNPC):setCustomObjectName(cfg.name)
    CreatureObject(pNPC):setConversationTemplate("LightEnclaveMaster")

    lightMasterNpcID = SceneObject(pNPC):getObjectID()
    print("EnclaveSpawns: Jedi Grand Master spawned (ID: " .. lightMasterNpcID .. ")")
end

-- ============================================================
-- SPAWN DARK MASTER NPC
-- ============================================================

function EnclaveSpawns:spawnDarkMasterNPC()
    local cfg = DARK_MASTER_NPC_CONFIG

    local pNPC = spawnMobile(cfg.zone, cfg.template, 0, cfg.x, cfg.z, cfg.y, cfg.heading, cfg.cellID)

    if pNPC == nil then
        print("EnclaveSpawns: ERROR — Failed to spawn Dark Master NPC on " .. cfg.zone)
        return
    end

    SceneObject(pNPC):setCustomObjectName(cfg.name)
    CreatureObject(pNPC):setConversationTemplate("DarkEnclaveMaster")

    darkMasterNpcID = SceneObject(pNPC):getObjectID()
    print("EnclaveSpawns: Dark Council Sovereign spawned (ID: " .. darkMasterNpcID .. ")")
end

-- ============================================================
-- PERIODIC RESPAWN CHECK — every 5 minutes
-- ============================================================

function EnclaveSpawns:checkAndRespawn(pObj, params)
    if lightNpcID == 0 or getSceneObject(lightNpcID) == nil then
        print("EnclaveSpawns: Light Knight NPC missing — respawning.")
        self:spawnLightNPC()
    end

    if darkNpcID == 0 or getSceneObject(darkNpcID) == nil then
        print("EnclaveSpawns: Dark Knight NPC missing — respawning.")
        self:spawnDarkNPC()
    end

    if lightMasterNpcID == 0 or getSceneObject(lightMasterNpcID) == nil then
        print("EnclaveSpawns: Light Master NPC missing — respawning.")
        self:spawnLightMasterNPC()
    end

    if darkMasterNpcID == 0 or getSceneObject(darkMasterNpcID) == nil then
        print("EnclaveSpawns: Dark Master NPC missing — respawning.")
        self:spawnDarkMasterNPC()
    end

    createEvent(300000, "EnclaveSpawns", "checkAndRespawn", nil, "")
end
