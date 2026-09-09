--[[
    Aftermath Server - Gatekeeper Conversation & Padawan Final Test
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/gatekeeper_conversation.lua

    No ConversationTemplate used — pure screenplay logic only.

    Flow:
    1. holocron.lua calls beginConversation via createEvent after Old Man spawns
    2. beginConversation sends NPC dialogue as system messages and triggers spawn
    3. The False Sith spawns 1500m away with a red waypoint
    4. Poll checks every 5s for mob death
    5. On death -> holocron_grant_padawan fires
--]]

GatekeeperConversation = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "GatekeeperConversation",
}

registerScreenPlay("GatekeeperConversation", true)

-- ============================================================
-- UTILITY
-- ============================================================

local function getPlayerVar(pCreature, varName, default)
    if pCreature == nil then return default end
    local val = readScreenPlayData(pCreature, "HolocronJedi", varName)
    if val == nil or val == "" then return default end
    return tonumber(val) or val
end

local function setPlayerVar(pCreature, varName, value)
    if pCreature == nil then return end
    writeScreenPlayData(pCreature, "HolocronJedi", varName, tostring(value))
end

local function sendForceMessage(pCreature, msg)
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFF" .. msg)
end



-- ============================================================
-- BEGIN CONVERSATION
-- Called via createEvent from holocron.lua
-- pNPC = Old Man, params = stringified player object ID
-- ============================================================

function GatekeeperConversation:beginConversation(pNPC, params)
    if pNPC == nil then return end

    local playerID = tonumber(params)
    if playerID == nil then return end

    local pCreature = getSceneObject(playerID)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    -- Stop following and face the player
    CreatureObject(pNPC):clearFollowObject()
    CreatureObject(pNPC):faceObject(pCreature)

    -- Check not already in trial
    local testActive = getPlayerVar(pCreature, "padawan_test_active", 0)
    if testActive == 1 then
        local pGK = getSceneObject(getPlayerVar(pCreature, "gatekeeper_id", 0))
        npcSay(pGK, "Your trial is already underway. Follow your waypoint and face what awaits you.")
        return
    end

    -- Store Gatekeeper ID
    setPlayerVar(pCreature, "gatekeeper_id", SceneObject(pNPC):getObjectID())

    -- Send dialogue then trigger spawn after short delay
    npcSay(pNPC, "Ah... so you have finally come. I have waited a long time for someone like you. The Force has been whispering your name.")
    createEvent(3000, "GatekeeperConversation", "sendDialoguePart2", pCreature, tostring(SceneObject(pNPC):getObjectID()))
end

function GatekeeperConversation:sendDialoguePart2(pCreature, params)
    if pCreature == nil then return end
    local npcID = tonumber(params)
    local pNPC = npcID ~= nil and getSceneObject(npcID) or nil

    npcSay(pNPC, "I stand between what you are and what you could become. But first... you must prove yourself worthy.")
    createEvent(4000, "GatekeeperConversation", "sendDialoguePart3", pCreature, params)
end

function GatekeeperConversation:sendDialoguePart3(pCreature, params)
    if pCreature == nil then return end
    local npcID = tonumber(params)
    local pNPC = npcID ~= nil and getSceneObject(npcID) or nil

    npcSay(pNPC, "A dark presence has been drawn to your awakening. It waits for you nearby. Seek it out and destroy it. Only then will the Force accept you.")
    createEvent(3000, "GatekeeperConversation", "spawnTrialMob", pCreature, params)
end

-- ============================================================
-- SPAWN THE FALSE SITH 1500m AWAY
-- ============================================================

function GatekeeperConversation:spawnTrialMob(pCreature, params)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    -- Prevent double spawn
    local alreadySpawned = getPlayerVar(pCreature, "padawan_mob_spawned", 0)
    if alreadySpawned == 1 then
        local pGK2 = getSceneObject(getPlayerVar(pCreature, "gatekeeper_id", 0))
        npcSay(pGK2, "Your trial opponent already awaits. Follow your waypoint.")
        return
    end

    local pZone = CreatureObject(pCreature):getZone()
    if pZone == nil then return end

    local zoneName = SceneObject(pZone):getZoneName()
    local playerX = CreatureObject(pCreature):getPositionX()
    local playerY = CreatureObject(pCreature):getPositionY()
    local playerZ = CreatureObject(pCreature):getPositionZ()

    -- Spawn 1500m away on X axis
    local spawnX = playerX + 1500
    local spawnY = playerY
    local spawnZ = playerZ

    local pFalseSith = spawnMobile(zoneName, "the_false_sith", 0, spawnX, spawnZ, spawnY, 0, 0)

    if pFalseSith == nil then
        local pGK3 = getSceneObject(getPlayerVar(pCreature, "gatekeeper_id", 0))
        npcSay(pGK3, "Something disturbs the trial grounds. Try again in a moment.")
        setPlayerVar(pCreature, "padawan_mob_spawned", 0)
        return
    end

    -- Store mob ID for death tracking
    setPlayerVar(pCreature, "trial_djk_id", SceneObject(pFalseSith):getObjectID())
    setPlayerVar(pCreature, "padawan_mob_spawned", 1)
    setPlayerVar(pCreature, "padawan_test_active", 1)

    -- Drop a red waypoint to the spawn location
    local pGhostObj = CreatureObject(pCreature):getPlayerObject()
    if pGhostObj ~= nil then
        PlayerObject(pGhostObj):addWaypoint(zoneName, "The False Sith", "", spawnX, spawnY, WAYPOINTRED, true, true, WAYPOINTQUESTTASK)
    end

    local pGK4 = getSceneObject(getPlayerVar(pCreature, "gatekeeper_id", 0))
    npcSay(pGK4, "It is done. A waypoint marks the location. Go. Do not fail.")
    sendForceMessage(pCreature, "You sense a dark presence 1500 metres away. The trial has begun.")

    -- Start polling for death
    createEvent(5000, "GatekeeperConversation", "checkTrialComplete", pCreature, "")
end

-- ============================================================
-- POLL: CHECK IF TRIAL COMPLETE (every 5s)
-- ============================================================

function GatekeeperConversation:checkTrialComplete(pCreature, params)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    local testActive = getPlayerVar(pCreature, "padawan_test_active", 0)
    if testActive ~= 1 then return end

    local mobID = getPlayerVar(pCreature, "trial_djk_id", 0)

    if mobID ~= 0 then
        local pMob = getSceneObject(mobID)
        if pMob == nil then
            -- Mob gone = dead
            self:trialSuccess(pCreature, pGhost)
        else
            createEvent(5000, "GatekeeperConversation", "checkTrialComplete", pCreature, "")
        end
    end
end

-- ============================================================
-- TRIAL SUCCESS
-- ============================================================

function GatekeeperConversation:trialSuccess(pCreature, pGhost)
    if pCreature == nil or pGhost == nil then return end

    setPlayerVar(pCreature, "padawan_test_active", 0)
    setPlayerVar(pCreature, "trial_djk_id", 0)

    -- Remove the quest waypoint
    PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)

    local gatekeeperID = getPlayerVar(pCreature, "gatekeeper_id", 0)
    local pGatekeeper = gatekeeperID ~= 0 and getSceneObject(gatekeeperID) or nil

    if pGatekeeper ~= nil then
        CreatureObject(pGatekeeper):say("I felt it fall. The Force surged through you in that moment. You have proven yourself. Step forward... Padawan.")
        createEvent(8000, "GatekeeperConversation", "despawnGatekeeper", pGatekeeper, "")
    else
        sendForceMessage(pCreature, "A distant voice echoes in your mind: 'You have proven yourself. Welcome... Padawan.'")
    end

    -- Grant Padawan status
    holocron_grant_padawan(pCreature)
end

-- ============================================================
-- DESPAWN GATEKEEPER
-- ============================================================

function GatekeeperConversation:despawnGatekeeper(pNPC, params)
    if pNPC == nil then return end
    CreatureObject(pNPC):doAnimation("salute")
    createEvent(2000, "GatekeeperConversation", "doFinalDespawn", pNPC, "")
end

function GatekeeperConversation:doFinalDespawn(pNPC, params)
    if pNPC == nil then return end
    SceneObject(pNPC):destroyObjectFromWorld()
end
