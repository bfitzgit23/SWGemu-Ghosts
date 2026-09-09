--[[
    Ghosts of the Old Republic - Gatekeeper Conversation & Padawan Final Test
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/gatekeeper_conversation.lua

    The Gatekeeper NPC delivers dialogue as coloured system messages.
    Players can also right-click the Gatekeeper at any time and ask
    "What must I do?" to get context-aware instructions.

    CONFIRMED BROKEN in this Core3 build - DO NOT USE:
        CreatureObject():say()         -- nil method crash
        CreatureObject():doAnimation() -- nil method crash

    All NPC speech uses sendSystemMessage on the player only.

    Storage: ALL flags via writeScreenPlayData(pCreature, "HolocronJedi", key, value)
--]]
-- Coded by BoosterSteel 19-03-2026

GatekeeperConversation = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "GatekeeperConversation",
}

-- Event-driven conversation logic; it has no startup work.
registerScreenPlay("GatekeeperConversation", false)

-- ============================================================
-- HELPERS
-- ============================================================

local function rsd(pCreature, key)
    local v = readScreenPlayData(pCreature, "HolocronJedi", key)
    if v == nil or v == "" then return "" end
    return v
end

local function wsd(pCreature, key, value)
    writeScreenPlayData(pCreature, "HolocronJedi", key, tostring(value))
end

local function getOrSpawnGatekeeper(pCreature)
    if pCreature == nil then return nil end

    local gatekeeperID = tonumber(rsd(pCreature, "gatekeeper_ghost_id")) or 0
    local pGatekeeper = gatekeeperID > 0 and getSceneObject(gatekeeperID) or nil
    if pGatekeeper ~= nil and SceneObject(pGatekeeper):getZoneName() == SceneObject(pCreature):getZoneName() and
            SceneObject(pCreature):isInRangeWithObject(pGatekeeper, 30) then
        return pGatekeeper
    end

    if pGatekeeper ~= nil then
        SceneObject(pGatekeeper):destroyObjectFromWorld()
        SceneObject(pGatekeeper):destroyObjectFromDatabase(true)
    end
    wsd(pCreature, "gatekeeper_ghost_id", "0")

    local zone = SceneObject(pCreature):getZoneName()
    if zone == nil or zone == "" then return nil end

    local cellID = CreatureObject(pCreature):getParentID()
    local x, y, z
    if cellID ~= 0 then
        x = SceneObject(pCreature):getPositionX() + 2
        y = SceneObject(pCreature):getPositionY() + 1
        z = SceneObject(pCreature):getPositionZ()
    else
        x = SceneObject(pCreature):getWorldPositionX() + 3
        y = SceneObject(pCreature):getWorldPositionY() + 2
        z = getWorldFloor(x, y, zone)
    end

    local gatekeeperTemplate = "gatekeeper_fs_wanderer"
    pGatekeeper = spawnMobile(zone, gatekeeperTemplate, 0, x, z, y, 180, cellID)
    if pGatekeeper == nil then return nil end

    CreatureObject(pGatekeeper):setPvpStatusBitmask(0)
    CreatureObject(pGatekeeper):clearOptionBit(AIENABLED)
    AiAgent(pGatekeeper):addObjectFlag(AI_STATIC)
    wsd(pCreature, "gatekeeper_ghost_id", SceneObject(pGatekeeper):getObjectID())
    wsd(pCreature, "gatekeeper_mobile_template", gatekeeperTemplate)
    createEvent(300000, "GatekeeperConversation", "despawnGatekeeper", pCreature, "")
    return pGatekeeper
end

function GatekeeperConversation:despawnGatekeeperNow(pCreature)
    if pCreature == nil then return end
    local gatekeeperID = tonumber(rsd(pCreature, "gatekeeper_ghost_id")) or 0
    local pGatekeeper = gatekeeperID > 0 and getSceneObject(gatekeeperID) or nil
    if pGatekeeper ~= nil then
        SceneObject(pGatekeeper):destroyObjectFromWorld()
        SceneObject(pGatekeeper):destroyObjectFromDatabase(true)
    end
    wsd(pCreature, "gatekeeper_ghost_id", "0")
    wsd(pCreature, "gatekeeper_mobile_template", "")
end

function GatekeeperConversation:summonForTrial(pCreature)
    if pCreature == nil then return nil end
    local pGatekeeper = getOrSpawnGatekeeper(pCreature)
    if pGatekeeper == nil then
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFFThe presence cannot take form here. Move to a clear area and use the holocron again.")
        return nil
    end

    spatialChat(pGatekeeper, "You there. Your studies have drawn my attention. Speak with me when you are ready.")
    return pGatekeeper
end

function gatekeeperSpatialSay(pCreature, msg)
    if pCreature == nil then return end
    local pGatekeeper = getOrSpawnGatekeeper(pCreature)
    if pGatekeeper ~= nil then
        spatialChat(pGatekeeper, msg)
    else
        CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFF" .. msg)
    end
end

local function gkSay(pCreature, msg)
    gatekeeperSpatialSay(pCreature, msg)
end

local function forceMsg(pCreature, msg)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFF" .. msg)
end

-- The Gatekeeper is a dedicated temporary Force Ghost. It is reused for the
-- whole dialogue chain and removed after five minutes of inactivity.

function GatekeeperConversation:despawnGatekeeper(pCreature, params)
    self:despawnGatekeeperNow(pCreature)
end

-- ============================================================
-- CONTEXT-AWARE INSTRUCTIONS
-- ============================================================

function GatekeeperConversation:giveInstructions(pCreature)
    if pCreature == nil then return end

    local status        = rsd(pCreature, "jedi_status")
    local testActive    = rsd(pCreature, "padawan_test_active")
    local mobSpawned    = rsd(pCreature, "padawan_mob_spawned")
    local testDone      = rsd(pCreature, "padawan_test_done")
    local used          = tonumber(rsd(pCreature, "holocrons_used")) or 0
    local knightUsed    = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0
    local alignment     = rsd(pCreature, "jedi_alignment")

    if status == "master" then
        gkSay(pCreature, "You have walked the full path. There is nothing more I can show you, Master.")
        return
    end

    if status == "knight" then
        if alignment == "dark" then
            gkSay(pCreature, "Your hunger for power is legendary. The Dark Enclave on Yavin 4 holds the final secrets.")
            gkSay(pCreature, "You have consumed " .. knightUsed .. " holocrons toward Mastery. The dark side demands more.")
            gkSay(pCreature, "Travel to Yavin 4. The Dark Enclave is located at coordinates: 5079, 306.")
        else
            gkSay(pCreature, "You carry the title of Knight well. But the Force has more to teach you.")
            gkSay(pCreature, "You have consumed " .. knightUsed .. " holocrons toward Mastery. Keep going.")
            gkSay(pCreature, "When you are ready, seek the Light Enclave on Yavin 4 at coordinates: -5575, 4910.")
        end
        return
    end

    if status == "padawan" then
        if alignment == "dark" then
            gkSay(pCreature, "You are a Padawan of the dark path. The Sith ways await deeper study.")
            gkSay(pCreature, "Travel to Yavin 4 and seek the Dark Jedi Enclave at coordinates: 5079, 306.")
            gkSay(pCreature, "There you will find a Dark Arbiter who will guide your next steps.")
        else
            gkSay(pCreature, "You have earned the rank of Padawan. The Force grows stronger in you each day.")
            gkSay(pCreature, "Travel to Yavin 4 and seek the Jedi Enclave at coordinates: -5575, 4910.")
            gkSay(pCreature, "A Council Elder awaits you there. They will reveal what the next step requires.")
        end
        return
    end

    if testActive == "1" and mobSpawned == "1" then
        local mobID = tonumber(rsd(pCreature, "trial_djk_id")) or 0
        local pMob = mobID ~= 0 and getSceneObject(mobID) or nil
        if pMob ~= nil then
            gkSay(pCreature, "Your trial is not yet complete. The False Sith still lives.")
            gkSay(pCreature, "Find it and destroy it. Your waypoint marks the location. Do not return until it is done.")
        else
            gkSay(pCreature, "I feel... the dark presence has faded. You have done it.")
            local pGhost = CreatureObject(pCreature):getPlayerObject()
            if pGhost ~= nil then
                self:trialSuccess(pCreature, pGhost)
            end
        end
        return
    end

    if testDone == "1" then
        gkSay(pCreature, "Your trial was set in motion but something has gone wrong. Speak to me again - I will reset and try once more.")
        wsd(pCreature, "padawan_test_done", "0")
        wsd(pCreature, "padawan_mob_spawned", "0")
        wsd(pCreature, "padawan_test_active", "0")
        return
    end

    if used < 10 then
        gkSay(pCreature, "You are not yet ready to face your trial.")
        gkSay(pCreature, "You must study " .. (10 - used) .. " more holocron" .. (10 - used == 1 and "" or "s") .. " before I can set your trial in motion.")
        gkSay(pCreature, "Seek holocrons in the world. Meditate on them. Use them through your radial menu. Return to me when you have studied ten.")
    else
        gkSay(pCreature, "You have studied enough to be ready. The Force stirs within you.")
        gkSay(pCreature, "Your trial is to face and destroy a dark presence I will summon. It will not be easy.")
        gkSay(pCreature, "I am ready to begin your trial. Use your holocron radial menu and speak to me through it to start.")
    end
end

-- ============================================================
-- RADIAL MENU HANDLER
-- ============================================================

function GatekeeperConversation:onAskInstructions(pCreature, pNPC)
    if pCreature == nil then return end
    self:giveInstructions(pCreature)
end

-- ============================================================
-- RESUME ON LOGIN
-- ============================================================

function GatekeeperConversation:onPlayerLoggedIn(pCreature)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    local testActive = rsd(pCreature, "padawan_test_active")
    if testActive ~= "1" then return end

    local mobID = tonumber(rsd(pCreature, "trial_djk_id")) or 0
    if mobID == 0 then
        self:cleanupTrialAttempt(pCreature)
        forceMsg(pCreature, "Your interrupted final trial has been cleared. Use a holocron to summon the Gatekeeper when you are ready to try again.")
        return
    end

    local pMob = getSceneObject(mobID)
    if pMob == nil then
        self:cleanupTrialAttempt(pCreature)
        forceMsg(pCreature, "Your interrupted final trial has been cleared. Use a holocron to summon the Gatekeeper when you are ready to try again.")
    else
        gkSay(pCreature, "Welcome back. Your trial is not yet complete.")
        self:giveInstructions(pCreature)
        createEvent(5000, "GatekeeperConversation", "checkTrialComplete", pCreature, "")
    end
end

function GatekeeperConversation:cleanupTrialAttempt(pCreature)
    if pCreature == nil then return end
    local mobID = tonumber(rsd(pCreature, "trial_djk_id")) or 0
    local pMob = mobID > 0 and getSceneObject(mobID) or nil
    if pMob ~= nil then
        SceneObject(pMob):destroyObjectFromWorld()
        SceneObject(pMob):destroyObjectFromDatabase(true)
    end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost ~= nil then
        PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)
    end

    wsd(pCreature, "padawan_test_active", "0")
    wsd(pCreature, "padawan_mob_spawned", "0")
    wsd(pCreature, "trial_djk_id", "0")
    wsd(pCreature, "trial_spawn_time", "0")
    wsd(pCreature, "trial_start_x", "0")
    wsd(pCreature, "trial_start_y", "0")
end

function GatekeeperConversation:onPlayerLoggedOut(pCreature)
    if pCreature == nil then return end
    self:despawnGatekeeperNow(pCreature)
    if rsd(pCreature, "padawan_test_active") == "1" then
        self:cleanupTrialAttempt(pCreature)
        -- Preserve eligibility while requiring a deliberate fresh attempt.
        wsd(pCreature, "padawan_test_done", "0")
    end
end

-- Dialogue chain handled in holocron.lua (HolocronJedi:gkSpeakPart2-6)
-- GatekeeperConversation:spawnTrialMob is called at the end of that chain

-- ============================================================
-- SPAWN THE FALSE SITH
-- ============================================================

function GatekeeperConversation:spawnTrialMob(pCreature, params)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    if rsd(pCreature, "padawan_mob_spawned") == "1" then
        gkSay(pCreature, "Your trial opponent already awaits. Follow your waypoint.")
        return
    end

    local zoneName = SceneObject(pCreature):getZoneName()
    if zoneName == nil or zoneName == "" then
        forceMsg(pCreature, "Could not determine your location. Try again in a moment.")
        return
    end

    local px = SceneObject(pCreature):getWorldPositionX()
    local py = SceneObject(pCreature):getWorldPositionY()
    local pz = SceneObject(pCreature):getWorldPositionZ()

    local d, dd = 200, 141
    local candidates = {
        { d,  0}, {0,  d}, {-d,  0}, {0, -d},
        { dd, dd}, {-dd, dd}, {dd, -dd}, {-dd, -dd},
    }

    local pFalseSith, spawnX, spawnY = nil, nil, nil

    for _, off in ipairs(candidates) do
        local tx, ty = px + off[1], py + off[2]
        local pTest = spawnMobile(zoneName, "the_false_sith", 0, tx, pz, ty, 0, 0)
        if pTest ~= nil then
            pFalseSith, spawnX, spawnY = pTest, tx, ty
            break
        end
    end

    if pFalseSith == nil then
        spawnX, spawnY = px + 15, py + 15
        pFalseSith = spawnMobile(zoneName, "the_false_sith", 0, spawnX, pz, spawnY, 0, 0)
    end

    if pFalseSith == nil then
        gkSay(pCreature, "Something disturbs the trial grounds. The dark presence eludes my call. Return to me in a moment and we will try again.")
        wsd(pCreature, "padawan_test_done",   "0")
        wsd(pCreature, "padawan_mob_spawned", "0")
        wsd(pCreature, "padawan_test_active", "0")
        return
    end

    local mobID = tostring(SceneObject(pFalseSith):getObjectID())
    wsd(pCreature, "trial_djk_id",        mobID)
    wsd(pCreature, "padawan_mob_spawned", "1")
    wsd(pCreature, "padawan_test_active", "1")
    wsd(pCreature, "trial_spawn_time",    tostring(os.time()))
    wsd(pCreature, "trial_start_x",       tostring(px))
    wsd(pCreature, "trial_start_y",       tostring(py))

    PlayerObject(pGhost):addWaypoint(zoneName, "The False Sith", "", spawnX, 0, spawnY, WAYPOINT_RED, true, true, WAYPOINTQUESTTASK)

    createObserver(OBJECTDESTRUCTION, "GatekeeperConversation", "onFalseSithKilled", pFalseSith)

    forceMsg(pCreature, "You sense a dark presence. It is close. Your waypoint marks its location.")

    createEvent(5000, "GatekeeperConversation", "checkTrialComplete", pCreature, "")
end

-- ============================================================
-- OBSERVER: FALSE SITH KILLED
-- ============================================================

function GatekeeperConversation:onFalseSithKilled(pVictim, pAttacker)
    if pAttacker == nil then return 1 end
    if not SceneObject(pAttacker):isPlayerCreature() then return 0 end

    local pGhost = CreatureObject(pAttacker):getPlayerObject()
    if pGhost == nil then return 1 end

    local testActive = rsd(pAttacker, "padawan_test_active")
    if testActive ~= "1" then return 1 end

    local mobID = tonumber(rsd(pAttacker, "trial_djk_id")) or 0
    if mobID == 0 then return 1 end

    if pVictim ~= nil and SceneObject(pVictim):getObjectID() == mobID then
        self:trialSuccess(pAttacker, pGhost)
    end

    return 1
end

-- ============================================================
-- POLL: CHECK TRIAL COMPLETE
-- ============================================================

function GatekeeperConversation:checkTrialComplete(pCreature, params)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    if rsd(pCreature, "padawan_test_active") ~= "1" then return end

    local okPlayerDead, playerDead = pcall(function() return CreatureObject(pCreature):isDead() end)
    if okPlayerDead and playerDead then
        self:cleanupTrialAttempt(pCreature)
        wsd(pCreature, "padawan_test_done", "0")
        return
    end

    local mobID = tonumber(rsd(pCreature, "trial_djk_id")) or 0
    if mobID == 0 then return end

    local pMob = getSceneObject(mobID)
    local isDead = false

    if pMob == nil then
        isDead = true
    else
        if SceneObject(pMob):getZoneName() ~= SceneObject(pCreature):getZoneName() or
                not SceneObject(pCreature):isInRangeWithObject(pMob, 600) then
            self:cleanupTrialAttempt(pCreature)
            wsd(pCreature, "padawan_test_done", "0")
            forceMsg(pCreature, "You have left the final trial behind. Use a holocron when you are ready to attempt it again.")
            return
        end
        local ok, dead = pcall(function() return CreatureObject(pMob):isDead() end)
        local ok2, incap = pcall(function() return CreatureObject(pMob):isIncapacitated() end)
        if (ok and dead) or (ok2 and incap) then
            isDead = true
        end
    end

    if isDead then
        self:trialSuccess(pCreature, pGhost)
    else
        createEvent(5000, "GatekeeperConversation", "checkTrialComplete", pCreature, "")
    end
end

-- ============================================================
-- TRIAL SUCCESS
-- ============================================================

function GatekeeperConversation:trialSuccess(pCreature, pGhost)
    if pCreature == nil or pGhost == nil then return end

    wsd(pCreature, "padawan_test_active", "0")
    wsd(pCreature, "trial_djk_id",        "0")
    wsd(pCreature, "trial_spawn_time",    "0")
    wsd(pCreature, "trial_start_x",       "0")
    wsd(pCreature, "trial_start_y",       "0")
    wsd(pCreature, "padawan_mob_spawned", "0")

    PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)

    forceMsg(pCreature, "The Gatekeeper's final words return to you: the Force surged through you in that moment.")
    createEvent(2500, "GatekeeperConversation", "trialSuccessPart2", pCreature, "")
end

function GatekeeperConversation:trialSuccessPart2(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "You did not hesitate. You did not fail. The path ahead is yours now.")
    createEvent(3000, "GatekeeperConversation", "trialSuccessPart3", pCreature, "")
end

function GatekeeperConversation:trialSuccessPart3(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "Step forward... Padawan.")
    createEvent(2500, "GatekeeperConversation", "doGrantPadawan", pCreature, "")
end

function GatekeeperConversation:doGrantPadawan(pCreature, params)
    if pCreature == nil then return end
    holocron_grant_padawan(pCreature)
    createEvent(4000, "GatekeeperConversation", "sendPostGrantInstructions", pCreature, "")
end

function GatekeeperConversation:sendPostGrantInstructions(pCreature, params)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    local firstName = CreatureObject(pCreature):getFirstName()

    if alignment == "dark" then
        forceMsg(pCreature, "You are now a Padawan of the dark path. Seek the Dark Jedi Enclave on Yavin 4 at coordinates: 5079, 306.")
        forceMsg(pCreature, "A Dark Arbiter waits there. They will guide your next steps toward Knighthood.")
        sendMail("The Gatekeeper", "Padawan of Darkness - Your Path Forward",
            "Padawan,\n\n" ..
            "The trial is complete. The dark side recognized your strength and you did not flinch.\n\n" ..
            "You now carry the title of Padawan. But the path is far from over.\n\n" ..
            "Travel to Yavin 4 and seek the Dark Jedi Enclave at coordinates:\n" ..
            "  /waypoint yavin4 5079 306\n\n" ..
            "A Dark Arbiter waits within. They will assess your readiness and reveal what is required to claim the rank of Knight.\n\n" ..
            "The dark side rewards the strong. Do not keep them waiting.\n\n" ..
            "- The Gatekeeper",
            firstName)
    else
        forceMsg(pCreature, "You are now a Padawan. Seek the Jedi Enclave on Yavin 4 at coordinates: -5575, 4910.")
        forceMsg(pCreature, "A Council Elder waits there. They will reveal what the path to Knighthood requires.")
        sendMail("The Gatekeeper", "Padawan - Your Path Forward",
            "Padawan,\n\n" ..
            "The trial is complete. You faced the darkness and prevailed. The Force speaks clearly of your potential.\n\n" ..
            "You now carry the title of Padawan. But the path is far from over.\n\n" ..
            "Travel to Yavin 4 and seek the Jedi Enclave at coordinates:\n" ..
            "  /waypoint yavin4 -5575 4910\n\n" ..
            "A Council Elder waits within. They will assess your readiness and reveal what is required to walk the path of the Knight.\n\n" ..
            "May the Force be with you.\n\n" ..
            "- The Gatekeeper",
            firstName)
    end
end
