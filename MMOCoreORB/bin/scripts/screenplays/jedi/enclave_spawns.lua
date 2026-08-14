--[[
    Ghosts of the Old Republic - Enclave NPC Spawns
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/enclave_spawns.lua

    Spawns Knight and Master trial NPCs inside both enclaves on Yavin 4.

    TEMPLATE NAMES: spawnMobile takes the key from addCreatureTemplate(),
    NOT an IFF path. All templates used here are confirmed registered
    in this build's serverobjects/mobile system.

    rohak_village_elder   pvpBitmask=NONE, non-attackable, registered via Village FS system
    Use setCustomObjectName() to rename them in-game.
--]]

EnclaveSpawns = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "EnclaveSpawns",
}

registerScreenPlay("EnclaveSpawns", true)

-- ============================================================
-- SPAWN CONFIGURATION
-- All coords are interior cell-relative.
-- Use rohak_village_elder for all NPCs  confirmed registered,
-- pvpBitmask=NONE, non-attackable. Renamed via setCustomObjectName.
-- ============================================================

-- COORDS NOTE:
-- Light enclave teleport-in spot (forceRoom) = {0, -15.1, 24.4} cell 8525418
--   -> Light Master moved to {0, -15.1, 10.0} to avoid overlap
-- Dark enclave forcePush = {0.1, -43.4, -31.1} cell 3435634
--   -> Dark Knight already offset at x=16 so fine
-- NPCs use enclave_jedi_npc template: CONVERSABLE, no AIENABLED (stationary)

local LIGHT_KNIGHT_CONFIG = {
    zone     = "yavin4",
    template = "enclave_jedi_npc",
    name     = "Council Elder",
    x        = 8.0,
    z        = -18.9,
    y        = 20.0,
    heading  = 180,
    cellID   = 8525439,   -- Light enclave lobby
}

local DARK_KNIGHT_CONFIG = {
    zone     = "yavin4",
    template = "enclave_jedi_npc",
    name     = "Dark Arbiter",
    x        = 16.0,
    z        = -43.4,
    y        = -35.0,
    heading  = 0,
    cellID   = 3435634,   -- Dark enclave antechamber
}

local LIGHT_MASTER_CONFIG = {
    zone     = "yavin4",
    template = "enclave_jedi_npc",
    name     = "Jedi Grand Master",
    x        = 0.0,
    z        = -15.1,
    y        = 10.0,      -- Offset from forceRoom teleport dest (y=24.4) to avoid overlap
    heading  = 180,
    cellID   = 8525418,   -- Light enclave auditorium
}

local DARK_MASTER_CONFIG = {
    zone     = "yavin4",
    template = "enclave_jedi_npc",
    name     = "Dark Council Sovereign",
    x        = 0.0,
    z        = -43.4,
    y        = -31.1,
    heading  = 0,
    cellID   = 3435636,   -- Dark enclave arenahall
}

-- ============================================================
-- NPC ID TRACKING
-- ============================================================

local lightKnightID  = 0
local darkKnightID   = 0
local lightMasterID  = 0
local darkMasterID   = 0

-- ============================================================
-- STARTUP
-- ============================================================

function EnclaveSpawns:start()
    self:spawnLightKnight()
    self:spawnDarkKnight()
    self:spawnLightMaster()
    self:spawnDarkMaster()
    createEvent(300000, "EnclaveSpawns", "checkAndRespawn", nil, "")
end

-- ============================================================
-- SPAWN HELPERS
-- ============================================================

local function doSpawn(cfg)
    local pNPC = spawnMobile(cfg.zone, cfg.template, 0, cfg.x, cfg.z, cfg.y, cfg.heading, cfg.cellID)
    if pNPC == nil then
        print("EnclaveSpawns: ERROR - Failed to spawn " .. cfg.name .. " using template " .. cfg.template)
        return nil
    end
    SceneObject(pNPC):setCustomObjectName(cfg.name)
    print("EnclaveSpawns: Spawned " .. cfg.name .. " (ID: " .. tostring(SceneObject(pNPC):getObjectID()) .. ")")
    return pNPC
end

function EnclaveSpawns:spawnLightKnight()
    local pNPC = doSpawn(LIGHT_KNIGHT_CONFIG)
    if pNPC ~= nil then
        lightKnightID = SceneObject(pNPC):getObjectID()
    end
end

function EnclaveSpawns:spawnDarkKnight()
    local pNPC = doSpawn(DARK_KNIGHT_CONFIG)
    if pNPC ~= nil then
        darkKnightID = SceneObject(pNPC):getObjectID()
    end
end

function EnclaveSpawns:spawnLightMaster()
    local pNPC = doSpawn(LIGHT_MASTER_CONFIG)
    if pNPC ~= nil then
        lightMasterID = SceneObject(pNPC):getObjectID()
    end
end

function EnclaveSpawns:spawnDarkMaster()
    local pNPC = doSpawn(DARK_MASTER_CONFIG)
    if pNPC ~= nil then
        darkMasterID = SceneObject(pNPC):getObjectID()
    end
end

-- ============================================================
-- PERIODIC RESPAWN CHECK  every 5 minutes
-- ============================================================

function EnclaveSpawns:checkAndRespawn(pObj, params)
    if lightKnightID == 0 or getSceneObject(lightKnightID) == nil then
        self:spawnLightKnight()
    end
    if darkKnightID == 0 or getSceneObject(darkKnightID) == nil then
        self:spawnDarkKnight()
    end
    if lightMasterID == 0 or getSceneObject(lightMasterID) == nil then
        self:spawnLightMaster()
    end
    if darkMasterID == 0 or getSceneObject(darkMasterID) == nil then
        self:spawnDarkMaster()
    end
    createEvent(300000, "EnclaveSpawns", "checkAndRespawn", nil, "")
end