-- Coded by BoosterSteel 19-03-2026
--[[
    Jedi Visibility Hunter System
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/jedi_visibility_hunters.lua

    SYSTEM 1 - Bounty Hunters (visibility >= 75):
      A bounty hunter spawns near any Jedi with 75+ visibility.
      Checked every 30-90 minutes randomly.
      Awards gcw_skill_xp on kill.

    SYSTEM 2 - Imperial Squad (FRS rank >= 8):
      Darth Vader + 1 Shadow Guard + 5 Dark Troopers spawn as a squad.
      Spawn interval: every 2 hours.
      50,000 gcw_skill_xp split across all mobs (Vader=20k, Guard=10k, Troopers=4k each)
]]

JediVisibilityHunters = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "JediVisibilityHunters",
}

registerScreenPlay("JediVisibilityHunters", false)

-- ============================================================
-- CONSTANTS
-- ============================================================

local VISIBILITY_THRESHOLD  = 75
local BH_SPAWN_MIN_MS       = 5 * 60 * 1000     -- 5 minutes (TESTING - change back to 30 * 60 * 1000)
local BH_SPAWN_MAX_MS       = 5 * 60 * 1000     -- 5 minutes (TESTING - change back to 90 * 60 * 1000)
local BH_XP                 = 5000
local IMPERIAL_INTERVAL_MS  = 2 * 60 * 60 * 1000 -- 2 hours
local IMPERIAL_MIN_RANK     = 8
local VADER_XP              = 20000
local SHADOW_GUARD_XP       = 10000
local DARK_TROOPER_XP       = 4000  -- x5 = 20000, total = 50000
local POLL_MS               = 10000

-- ============================================================
-- HELPERS
-- ============================================================

local function playerKey(pPlayer, prefix, suffix)
    return prefix .. ":" .. SceneObject(pPlayer):getObjectID() .. ":" .. suffix
end

local function bhKey(pPlayer, suffix)
    return playerKey(pPlayer, "BHHunter", suffix)
end

local function impKey(pPlayer, suffix)
    return playerKey(pPlayer, "ImpSquad", suffix)
end

local function getVisibility(pPlayer)
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return 0 end
    return PlayerObject(pGhost):getVisibility()
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
    return -1
end

local function isJedi(pPlayer)
    return CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01") or
           CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") or
           CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")
end

local function spawnNearPlayer(pPlayer, template)
    local zone = SceneObject(pPlayer):getZoneName()
    if zone == nil or zone == "" then return nil end
    local px = SceneObject(pPlayer):getWorldPositionX()
    local py = SceneObject(pPlayer):getWorldPositionY()
    local pz = SceneObject(pPlayer):getWorldPositionZ()
    -- Spawn at 25m in 8 directions
    local d, dd = 25, 18
    local candidates = {
        {d,0},{0,d},{-d,0},{0,-d},
        {dd,dd},{-dd,dd},{dd,-dd},{-dd,-dd},
    }
    for _, off in ipairs(candidates) do
        local pMob = spawnMobile(zone, template, 0, px+off[1], pz, py+off[2], 0, 0)
        if pMob ~= nil then return pMob end
    end
    return nil
end

local function addHunterWaypoint(pPlayer, pMob, name)
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return 0 end
    local zone = SceneObject(pPlayer):getZoneName()
    local mx = SceneObject(pMob):getWorldPositionX()
    local my = SceneObject(pMob):getWorldPositionY()
    return PlayerObject(pGhost):addWaypoint(zone, name, "", mx, my, WAYPOINTRED, true, true, 0)
end

local function removeWaypoint(pPlayer, wpID)
    if wpID == nil or wpID == 0 then return end
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        PlayerObject(pGhost):removeWaypoint(wpID, true)
    end
end

-- ============================================================
-- SYSTEM 1 — BOUNTY HUNTER (visibility >= 75)
-- ============================================================

function JediVisibilityHunters:startBountyHunting(pPlayer)
    if pPlayer == nil then return end
    if not isJedi(pPlayer) then return end
    if readData(bhKey(pPlayer, "active")) == 1 then return end

    writeData(bhKey(pPlayer, "active"), 1)
    self:scheduleBountyHunter(pPlayer)
    CreatureObject(pPlayer):sendSystemMessage("\\#FF8C00 Word of your power has reached the bounty hunter boards. Watch your back.")
end

function JediVisibilityHunters:scheduleBountyHunter(pPlayer)
    if pPlayer == nil then return end
    if not isJedi(pPlayer) then
        writeData(bhKey(pPlayer, "active"), 0)
        return
    end
    local delay = BH_SPAWN_MIN_MS + math.random(0, BH_SPAWN_MAX_MS - BH_SPAWN_MIN_MS)
    createEvent(delay, "JediVisibilityHunters", "spawnBountyHunter", pPlayer, "")
end

function JediVisibilityHunters:spawnBountyHunter(pPlayer, params)
    if pPlayer == nil then return end

    -- Only spawn if visibility is still 75+
    if getVisibility(pPlayer) < VISIBILITY_THRESHOLD then
        self:scheduleBountyHunter(pPlayer)
        return
    end

    -- Don't spawn if one is already active
    local existingID = readData(bhKey(pPlayer, "hunter_id"))
    if existingID ~= nil and existingID ~= 0 then
        local pEx = getSceneObject(existingID)
        if pEx ~= nil and not CreatureObject(pEx):isDead() then
            self:scheduleBountyHunter(pPlayer)
            return
        end
    end

    local pHunter = spawnNearPlayer(pPlayer, "jedi_bounty_hunter")
    if pHunter == nil then
        self:scheduleBountyHunter(pPlayer)
        return
    end

    local playerName = CreatureObject(pPlayer):getFirstName()
    SceneObject(pHunter):setCustomObjectName("Bounty Hunter")
    writeData(bhKey(pPlayer, "hunter_id"), SceneObject(pHunter):getObjectID())

    local wpID = addHunterWaypoint(pPlayer, pHunter, "Bounty Hunter")
    writeData(bhKey(pPlayer, "waypoint_id"), wpID)

    CreatureObject(pPlayer):sendSystemMessage("\\#FF8C00[Bounty Hunter]: " .. playerName .. ". The guild posted your bounty this morning. Biggest payday I have seen in years. Nothing personal.")
    -- Attack taunt after 4 seconds
    createEvent(4000, "JediVisibilityHunters", "bhAttackTaunt", pPlayer, "")

    createEvent(POLL_MS, "JediVisibilityHunters", "checkBHKill", pPlayer, "")
end

function JediVisibilityHunters:checkBHKill(pPlayer, params)
    if pPlayer == nil then return end
    local hunterID = readData(bhKey(pPlayer, "hunter_id"))
    if hunterID == nil or hunterID == 0 then
        self:scheduleBountyHunter(pPlayer)
        return
    end
    local pHunter = getSceneObject(hunterID)
    if pHunter == nil or CreatureObject(pHunter):isDead() then
        self:onBHKilled(pPlayer)
    else
        createEvent(POLL_MS, "JediVisibilityHunters", "checkBHKill", pPlayer, "")
    end
end

function JediVisibilityHunters:onBHKilled(pPlayer)
    if pPlayer == nil then return end
    removeWaypoint(pPlayer, readData(bhKey(pPlayer, "waypoint_id")))
    writeData(bhKey(pPlayer, "waypoint_id"), 0)
    writeData(bhKey(pPlayer, "hunter_id"), 0)
    CreatureObject(pPlayer):awardExperience("gcw_skill_xp", BH_XP)
    CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 The bounty hunter is dead. The contract is void. For now. (+" .. BH_XP .. " GCW Skill XP)")
    self:scheduleBountyHunter(pPlayer)
end

-- ============================================================
-- STOP BOUNTY HUNTING
-- ============================================================

function JediVisibilityHunters:stopBountyHunting(pPlayer)
    if pPlayer == nil then return end
    writeData(bhKey(pPlayer, "active"), 0)
    local hunterID = readData(bhKey(pPlayer, "hunter_id"))
    if hunterID ~= nil and hunterID ~= 0 then
        local pHunter = getSceneObject(hunterID)
        if pHunter ~= nil and not CreatureObject(pHunter):isDead() then
            SceneObject(pHunter):destroyObjectFromWorld()
        end
        writeData(bhKey(pPlayer, "hunter_id"), 0)
    end
    removeWaypoint(pPlayer, readData(bhKey(pPlayer, "waypoint_id")))
    writeData(bhKey(pPlayer, "waypoint_id"), 0)
end

-- ============================================================
-- SYSTEM 2 — IMPERIAL SQUAD (FRS rank >= 8)
-- ============================================================

function JediVisibilityHunters:startImperialHunting(pPlayer)
    if pPlayer == nil then return end
    if getFrsRank(pPlayer) < IMPERIAL_MIN_RANK then return end
    if readData(impKey(pPlayer, "active")) == 1 then return end

    writeData(impKey(pPlayer, "active"), 1)
    self:scheduleImperialSquad(pPlayer)
    CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 Your power has drawn the attention of the Empire itself. Darth Vader has been dispatched.")
end

function JediVisibilityHunters:scheduleImperialSquad(pPlayer)
    if pPlayer == nil then return end
    if getFrsRank(pPlayer) < IMPERIAL_MIN_RANK then
        writeData(impKey(pPlayer, "active"), 0)
        return
    end
    createEvent(IMPERIAL_INTERVAL_MS, "JediVisibilityHunters", "spawnImperialSquad", pPlayer, "")
end

function JediVisibilityHunters:spawnImperialSquad(pPlayer, params)
    if pPlayer == nil then return end
    if getFrsRank(pPlayer) < IMPERIAL_MIN_RANK then
        writeData(impKey(pPlayer, "active"), 0)
        return
    end

    -- Don't spawn if squad still active
    local vaderID = readData(impKey(pPlayer, "vader_id"))
    if vaderID ~= nil and vaderID ~= 0 then
        local pVader = getSceneObject(vaderID)
        if pVader ~= nil and not CreatureObject(pVader):isDead() then
            self:scheduleImperialSquad(pPlayer)
            return
        end
    end

    local playerName = CreatureObject(pPlayer):getFirstName()

    -- Spawn Darth Vader
    local pVader = spawnNearPlayer(pPlayer, "imperial_darth_vader")
    if pVader == nil then
        self:scheduleImperialSquad(pPlayer)
        return
    end
    writeData(impKey(pPlayer, "vader_id"), SceneObject(pVader):getObjectID())
    local vaderWP = addHunterWaypoint(pPlayer, pVader, "Darth Vader")
    writeData(impKey(pPlayer, "vader_wp"), vaderWP)

    -- Spawn Shadow Guard
    local pGuard = spawnNearPlayer(pPlayer, "imperial_black_stormtrooper")
    if pGuard ~= nil then
        writeData(impKey(pPlayer, "guard_id"), SceneObject(pGuard):getObjectID())
    end

    -- Spawn 5 Dark Troopers
    for i = 1, 5 do
        local pTrooper = spawnNearPlayer(pPlayer, "imperial_dark_trooper")
        if pTrooper ~= nil then
            writeData(impKey(pPlayer, "trooper_id_" .. i), SceneObject(pTrooper):getObjectID())
        end
    end

    -- Vader spawn dialogue
    CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Darth Vader]: I find your lack of surrender disturbing.")
    createEvent(4000, "JediVisibilityHunters", "vaderAttackTaunt", pPlayer, "")

    -- Start kill tracking
    writeData(impKey(pPlayer, "kills"), 0)
    writeData(impKey(pPlayer, "total"), 7)  -- Vader + Guard + 5 Troopers
    createEvent(POLL_MS, "JediVisibilityHunters", "checkImperialKills", pPlayer, "")
end

function JediVisibilityHunters:bhAttackTaunt(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FF8C00[Bounty Hunter]: Don't make this harder than it needs to be. The guild wants you dead, not inconvenienced.")
end

function JediVisibilityHunters:vaderAttackTaunt(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Darth Vader]: You should not have come back.")
end

function JediVisibilityHunters:checkImperialKills(pPlayer, params)
    if pPlayer == nil then return end

    local kills = 0
    local total = readData(impKey(pPlayer, "total")) or 7

    -- Check Vader
    local vaderID = readData(impKey(pPlayer, "vader_id"))
    local vaderDead = false
    if vaderID ~= nil and vaderID ~= 0 then
        local pVader = getSceneObject(vaderID)
        if pVader == nil or CreatureObject(pVader):isDead() then
            vaderDead = true
            kills = kills + 1
            -- Award Vader XP if not already awarded
            if readData(impKey(pPlayer, "vader_xp_given")) ~= 1 then
                writeData(impKey(pPlayer, "vader_xp_given"), 1)
                removeWaypoint(pPlayer, readData(impKey(pPlayer, "vader_wp")))
                writeData(impKey(pPlayer, "vader_wp"), 0)
                CreatureObject(pPlayer):awardExperience("gcw_skill_xp", VADER_XP)
                CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Darth Vader has fallen! (+" .. VADER_XP .. " GCW Skill XP)")
            end
        end
    end

    -- Check Shadow Guard
    local guardID = readData(impKey(pPlayer, "guard_id"))
    if guardID ~= nil and guardID ~= 0 then
        local pGuard = getSceneObject(guardID)
        if pGuard == nil or CreatureObject(pGuard):isDead() then
            kills = kills + 1
            if readData(impKey(pPlayer, "guard_xp_given")) ~= 1 then
                writeData(impKey(pPlayer, "guard_xp_given"), 1)
                CreatureObject(pPlayer):awardExperience("gcw_skill_xp", SHADOW_GUARD_XP)
                CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Imperial Shadow Guard destroyed. (+" .. SHADOW_GUARD_XP .. " GCW Skill XP)")
            end
        end
    end

    -- Check Dark Troopers
    for i = 1, 5 do
        local trooperID = readData(impKey(pPlayer, "trooper_id_" .. i))
        if trooperID ~= nil and trooperID ~= 0 then
            local pTrooper = getSceneObject(trooperID)
            if pTrooper == nil or CreatureObject(pTrooper):isDead() then
                kills = kills + 1
                if readData(impKey(pPlayer, "trooper_xp_" .. i)) ~= 1 then
                    writeData(impKey(pPlayer, "trooper_xp_" .. i), 1)
                    CreatureObject(pPlayer):awardExperience("gcw_skill_xp", DARK_TROOPER_XP)
                    CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Dark Trooper destroyed. (+" .. DARK_TROOPER_XP .. " GCW Skill XP)")
                end
            end
        end
    end

    if kills >= total then
        self:onImperialSquadDefeated(pPlayer)
    else
        createEvent(POLL_MS, "JediVisibilityHunters", "checkImperialKills", pPlayer, "")
    end
end

function JediVisibilityHunters:onImperialSquadDefeated(pPlayer)
    if pPlayer == nil then return end

    -- Clear all tracking data
    for i = 1, 5 do
        writeData(impKey(pPlayer, "trooper_id_" .. i), 0)
        writeData(impKey(pPlayer, "trooper_xp_" .. i), 0)
    end
    writeData(impKey(pPlayer, "vader_id"), 0)
    writeData(impKey(pPlayer, "vader_xp_given"), 0)
    writeData(impKey(pPlayer, "guard_id"), 0)
    writeData(impKey(pPlayer, "guard_xp_given"), 0)
    writeData(impKey(pPlayer, "kills"), 0)

    CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 The Imperial squad has been destroyed. The Empire does not forget. They will return.")
    self:scheduleImperialSquad(pPlayer)
end

-- ============================================================
-- LOGIN RESUME
-- ============================================================

function JediVisibilityHunters:onPlayerLoggedIn(pPlayer)
    if pPlayer == nil then return end

    -- Resume bounty hunter system if visibility >= 75
    if isJedi(pPlayer) and getVisibility(pPlayer) >= VISIBILITY_THRESHOLD then
        if readData(bhKey(pPlayer, "active")) == 1 then
            self:scheduleBountyHunter(pPlayer)
        else
            self:startBountyHunting(pPlayer)
        end
    end

    -- Resume imperial squad system if rank >= 8
    if getFrsRank(pPlayer) >= IMPERIAL_MIN_RANK then
        if readData(impKey(pPlayer, "active")) == 1 then
            self:scheduleImperialSquad(pPlayer)
        else
            self:startImperialHunting(pPlayer)
        end
    end
end

-- ============================================================
-- VISIBILITY CHECK HOOK
-- Called from jedi_point_sources.lua or jedi_trials.lua
-- when visibility changes
-- ============================================================

function JediVisibilityHunters:checkVisibility(pPlayer)
    if pPlayer == nil then return end
    if not isJedi(pPlayer) then return end

    local vis = getVisibility(pPlayer)
    if vis >= VISIBILITY_THRESHOLD then
        if readData(bhKey(pPlayer, "active")) ~= 1 then
            self:startBountyHunting(pPlayer)
        end
    end
end

-- Called when player reaches FRS rank 8
function JediVisibilityHunters:checkFrsRank(pPlayer)
    if pPlayer == nil then return end
    if getFrsRank(pPlayer) >= IMPERIAL_MIN_RANK then
        if readData(impKey(pPlayer, "active")) ~= 1 then
            self:startImperialHunting(pPlayer)
        end
    end
end