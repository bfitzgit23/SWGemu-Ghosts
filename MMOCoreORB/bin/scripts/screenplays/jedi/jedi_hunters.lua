-- Coded by BoosterSteel 19-03-2026
--[[
    Jedi Hunter System
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/jedi_hunters.lua

    Once a player completes the Knight trial and receives FRS membership
    (force_rank_light_novice or force_rank_dark_novice), hunters will
    periodically spawn near them.

    Light Jedi Knights are hunted by Dark Jedi Assassins.
    Dark Jedi Knights are hunted by Jedi Sentinels.

    Hunters scale with FRS rank. Kill rewards 10000 gcw_skill_xp.
    Spawn interval: random 30-90 minutes.
]]

JediHunters = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "JediHunters",
}

registerScreenPlay("JediHunters", false)

-- ============================================================
-- CONSTANTS
-- ============================================================

local SPAWN_MIN_MS  = 30 * 60 * 1000   -- 30 minutes
local SPAWN_MAX_MS  = 90 * 60 * 1000   -- 90 minutes
local POLL_MS       = 10000            -- kill check interval

-- XP scales from 10000 at rank 0 to 45000 at rank 11
local function getHunterXP(rank)
    rank = math.max(0, math.min(11, rank))
    return math.floor(10000 + (rank / 11) * 35000)
end

-- Hunter templates by FRS rank tier (0=novice, 1-4=enforcer, 5-7=templar, 8-10=oppressor, 11=master)
-- Light players are hunted by Dark Jedi, Dark players hunted by Jedi
local DARK_HUNTERS = {
    -- Rank 0 (Novice)
    [0]  = { template = "dark_jedi_knight",     name = "Dark Jedi Assassin",     level = 150 },
    -- Ranks 1-4 (Enforcer tier)
    [1]  = { template = "dark_jedi_knight",     name = "Dark Jedi Enforcer",     level = 175 },
    [2]  = { template = "dark_jedi_knight",     name = "Dark Jedi Enforcer",     level = 200 },
    [3]  = { template = "dark_jedi_master",     name = "Dark Jedi Commander",    level = 225 },
    [4]  = { template = "dark_jedi_master",     name = "Dark Jedi Commander",    level = 250 },
    -- Ranks 5-7 (Templar tier)
    [5]  = { template = "dark_jedi_master",     name = "Dark Jedi Templar",      level = 280 },
    [6]  = { template = "dark_jedi_master",     name = "Dark Jedi Templar",      level = 300 },
    [7]  = { template = "dark_adept",           name = "Dark Jedi Inquisitor",   level = 330 },
    -- Ranks 8-10 (Oppressor tier)
    [8]  = { template = "dark_adept",           name = "Dark Jedi Oppressor",    level = 360 },
    [9]  = { template = "dark_adept",           name = "Dark Jedi Oppressor",    level = 390 },
    [10] = { template = "dark_adept",           name = "Dark Jedi Lord",         level = 420 },
    -- Rank 11 (Master)
    [11] = { template = "dark_adept",           name = "Dark Jedi Warlord",      level = 450 },
}

local LIGHT_HUNTERS = {
    [0]  = { template = "dark_jedi_knight",     name = "Jedi Sentinel",          level = 150 },
    [1]  = { template = "dark_jedi_knight",     name = "Jedi Sentinel",          level = 175 },
    [2]  = { template = "dark_jedi_knight",     name = "Jedi Guardian",          level = 200 },
    [3]  = { template = "dark_jedi_master",     name = "Jedi Guardian",          level = 225 },
    [4]  = { template = "dark_jedi_master",     name = "Jedi Arbiter",           level = 250 },
    [5]  = { template = "dark_jedi_master",     name = "Jedi Arbiter",           level = 280 },
    [6]  = { template = "dark_jedi_master",     name = "Jedi Watchman",          level = 300 },
    [7]  = { template = "dark_adept",           name = "Jedi Watchman",          level = 330 },
    [8]  = { template = "dark_adept",           name = "Jedi Master Hunter",     level = 360 },
    [9]  = { template = "dark_adept",           name = "Jedi Master Hunter",     level = 390 },
    [10] = { template = "dark_adept",           name = "Jedi High Sentinel",     level = 420 },
    [11] = { template = "dark_adept",           name = "Jedi Grand Sentinel",    level = 450 },
}

-- ============================================================
-- HELPERS
-- ============================================================

local function playerKey(pPlayer, suffix)
    return "JediHunter:" .. SceneObject(pPlayer):getObjectID() .. ":" .. suffix
end

local function getFrsRank(pPlayer)
    if CreatureObject(pPlayer):hasSkill("force_rank_light_master") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_master")  then return 11 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_10") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_10") then return 10 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_09") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_09") then return 9 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_08") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_08") then return 8 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_07") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_07") then return 7 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_06") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_06") then return 6 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_05") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_05") then return 5 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_04") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_04") then return 4 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_03") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_03") then return 3 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_02") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_02") then return 2 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_01") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_01") then return 1 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_novice") or
       CreatureObject(pPlayer):hasSkill("force_rank_dark_novice")  then return 0 end
    return 0
end

local function isEligible(pPlayer)
    if pPlayer == nil then return false end
    -- Check FRS novice skill OR Knight rank directly (in case FRS grant is pending)
    return CreatureObject(pPlayer):hasSkill("force_rank_light_novice") or
           CreatureObject(pPlayer):hasSkill("force_rank_dark_novice") or
           CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")
end

local function isDark(pPlayer)
    return CreatureObject(pPlayer):hasSkill("force_rank_dark_novice")
end

local function spawnNearPlayer(pPlayer, template)
    local zone = SceneObject(pPlayer):getZoneName()
    if zone == nil or zone == "" then return nil end

    local px = SceneObject(pPlayer):getWorldPositionX()
    local py = SceneObject(pPlayer):getWorldPositionY()
    local pz = SceneObject(pPlayer):getWorldPositionZ()

    local d, dd = 150, 106
    local candidates = {
        { d, 0}, {0, d}, {-d, 0}, {0, -d},
        { dd, dd}, {-dd, dd}, {dd, -dd}, {-dd, -dd},
    }

    for _, off in ipairs(candidates) do
        local pMob = spawnMobile(zone, template, 0, px + off[1], pz, py + off[2], 0, 0)
        if pMob ~= nil then return pMob end
    end
    return nil
end

-- ============================================================
-- START HUNTING A PLAYER
-- Called from jedi_trials.lua after knight rank is granted
-- ============================================================

function JediHunters:startHunting(pPlayer)
    if pPlayer == nil then return end
    if not isEligible(pPlayer) then return end

    -- Don't start if already running
    local active = readData(playerKey(pPlayer, "active"))
    if active ~= nil and active == 1 then return end

    writeData(playerKey(pPlayer, "active"), 1)
    self:scheduleNextHunter(pPlayer)

    CreatureObject(pPlayer):sendSystemMessage("\\#AAAAAA You sense a growing danger... those who oppose your path now hunt you.")
end

-- ============================================================
-- SCHEDULE NEXT SPAWN
-- ============================================================

function JediHunters:scheduleNextHunter(pPlayer)
    if pPlayer == nil then return end
    if not isEligible(pPlayer) then
        writeData(playerKey(pPlayer, "active"), 0)
        return
    end

    -- Random delay between 30-90 minutes
    local delay = SPAWN_MIN_MS + math.random(0, SPAWN_MAX_MS - SPAWN_MIN_MS)
    local mins = math.floor(delay / 60000)
    writeData(playerKey(pPlayer, "next_spawn_delay"), delay)

    createEvent(delay, "JediHunters", "spawnHunter", pPlayer, "")
end

-- ============================================================
-- SPAWN THE HUNTER
-- ============================================================

function JediHunters:spawnHunter(pPlayer, params)
    if pPlayer == nil then return end
    if not isEligible(pPlayer) then
        writeData(playerKey(pPlayer, "active"), 0)
        return
    end

    -- Don't spawn if player already has an active hunter
    local existingID = readData(playerKey(pPlayer, "hunter_id"))
    if existingID ~= nil and existingID ~= 0 then
        local pExisting = getSceneObject(existingID)
        if pExisting ~= nil and not CreatureObject(pExisting):isDead() then
            -- Hunter still alive, reschedule
            self:scheduleNextHunter(pPlayer)
            return
        end
    end

    local rank = getFrsRank(pPlayer)
    rank = math.max(0, math.min(11, rank))

    local hunterData
    if isDark(pPlayer) then
        hunterData = LIGHT_HUNTERS[rank]
    else
        hunterData = DARK_HUNTERS[rank]
    end

    local pHunter = spawnNearPlayer(pPlayer, hunterData.template)
    if pHunter == nil then
        -- Couldn't spawn, try again later
        self:scheduleNextHunter(pPlayer)
        return
    end

    SceneObject(pHunter):setCustomObjectName(hunterData.name)
    writeData(playerKey(pPlayer, "hunter_id"), SceneObject(pHunter):getObjectID())

    -- Taunt the player
    local playerName = CreatureObject(pPlayer):getFirstName()
    if isDark(pPlayer) then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[" .. hunterData.name .. "]: Your corruption ends today, " .. playerName .. ". The Order demands it.")
    else
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[" .. hunterData.name .. "]: You have chosen the wrong path, " .. playerName .. ". I am here to correct that mistake.")
    end

    -- Add waypoint
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local zone = SceneObject(pPlayer):getZoneName()
        local hx = SceneObject(pHunter):getWorldPositionX()
        local hy = SceneObject(pHunter):getWorldPositionY()
        local wpID = PlayerObject(pGhost):addWaypoint(zone, hunterData.name, "", hx, hy, WAYPOINTRED, true, true, 0)
        writeData(playerKey(pPlayer, "waypoint_id"), wpID)
    end

    -- Start kill check poll
    createEvent(POLL_MS, "JediHunters", "checkHunterKill", pPlayer, "")
end

-- ============================================================
-- KILL CHECK
-- ============================================================

function JediHunters:checkHunterKill(pPlayer, params)
    if pPlayer == nil then return end

    local hunterID = readData(playerKey(pPlayer, "hunter_id"))
    if hunterID == nil or hunterID == 0 then
        self:scheduleNextHunter(pPlayer)
        return
    end

    local pHunter = getSceneObject(hunterID)
    if pHunter == nil or CreatureObject(pHunter):isDead() then
        -- Hunter is dead
        self:onHunterKilled(pPlayer)
    else
        -- Still alive, keep polling
        createEvent(POLL_MS, "JediHunters", "checkHunterKill", pPlayer, "")
    end
end

-- ============================================================
-- HUNTER KILLED
-- ============================================================

function JediHunters:onHunterKilled(pPlayer)
    if pPlayer == nil then return end

    -- Remove waypoint
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local wpID = readData(playerKey(pPlayer, "waypoint_id"))
        if wpID ~= nil and wpID ~= 0 then
            PlayerObject(pGhost):removeWaypoint(wpID, true)
            writeData(playerKey(pPlayer, "waypoint_id"), 0)
        end
    end

    writeData(playerKey(pPlayer, "hunter_id"), 0)

    -- Award scaled gcw_skill_xp based on FRS rank
    local rank = getFrsRank(pPlayer)
    local xp = getHunterXP(rank)
    CreatureObject(pPlayer):awardExperience("gcw_skill_xp", xp)
    CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 You have defeated your hunter. The Force grows stronger in you. (+" .. xp .. " GCW Skill XP)")

    -- Schedule next hunter
    self:scheduleNextHunter(pPlayer)
end

-- ============================================================
-- STOP HUNTING (called on reset/logout cleanup)
-- ============================================================

function JediHunters:stopHunting(pPlayer)
    if pPlayer == nil then return end

    writeData(playerKey(pPlayer, "active"), 0)

    local hunterID = readData(playerKey(pPlayer, "hunter_id"))
    if hunterID ~= nil and hunterID ~= 0 then
        local pHunter = getSceneObject(hunterID)
        if pHunter ~= nil and not CreatureObject(pHunter):isDead() then
            SceneObject(pHunter):destroyObjectFromWorld()
        end
        writeData(playerKey(pPlayer, "hunter_id"), 0)
    end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local wpID = readData(playerKey(pPlayer, "waypoint_id"))
        if wpID ~= nil and wpID ~= 0 then
            PlayerObject(pGhost):removeWaypoint(wpID, true)
            writeData(playerKey(pPlayer, "waypoint_id"), 0)
        end
    end
end

-- ============================================================
-- RESUME ON LOGIN
-- ============================================================

function JediHunters:onPlayerLoggedIn(pPlayer)
    if pPlayer == nil then return end
    if not isEligible(pPlayer) then return end

    local active = readData(playerKey(pPlayer, "active"))
    if active == 1 then
        self:scheduleNextHunter(pPlayer)
    else
        self:startHunting(pPlayer)
    end

    -- Also kick off a periodic FRS rank check for imperial squad trigger
    createEvent(10000, "JediHunters", "checkImperialEligibility", pPlayer, "")
end

-- Periodic check — triggers imperial squad once player hits rank 8
function JediHunters:checkImperialEligibility(pPlayer, params)
    if pPlayer == nil then return end
    if not isEligible(pPlayer) then return end
    -- Tell the visibility hunter system to check rank
    JediVisibilityHunters:checkFrsRank(pPlayer)
    -- Re-check every 5 minutes in case they rank up mid-session
    createEvent(5 * 60 * 1000, "JediHunters", "checkImperialEligibility", pPlayer, "")
end