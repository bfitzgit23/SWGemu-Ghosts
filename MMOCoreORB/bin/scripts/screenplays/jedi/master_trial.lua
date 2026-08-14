--[[
    Ghosts of the Old Republic - Master Trial Screenplay
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/master_trial.lua

    Flow:
      1. Player reaches 150 holocrons as a Knight with FRS rank 10 (light or dark)
      2. SUI popup notifies them + in-game mail sent
      3. Player speaks to Gatekeeper NPC (radial menu "Seek the Final Trial")
      4. Epic gatekeeper dialogue delivered via system messages
      5. Revan Clone spawns 50m away and attacks
      6. If player kills Revan → granted jedi_grand_master_novice or jedi_dark_lord_novice
      7. Player trains boxes at enclave terminal (intermediate boxes only)
      8. Once at final box, player speaks to Gatekeeper again
      9. "Revan Reborn" spawns (75% stronger, double crystal loot)
      10. If player kills Revan Reborn → granted master box
      11. 5 minute despawn timer if player runs / dies
      12. 1 hour retry cooldown on failure

    FRS rank check:
      Light Jedi  = getFrsCouncilRank(1) >= 10
      Dark Jedi   = getFrsCouncilRank(2) >= 10

    Storage namespace: "HolocronJedi" (shared with existing system)

    Coded by BoosterSteel - Ghosts of the Old Republic
--]]

MasterTrial = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "MasterTrial",
}

registerScreenPlay("MasterTrial", true)

-- ============================================================
-- CONSTANTS
-- ============================================================

local MASTER_HOLOCRONS_NEEDED = 150
local FRS_RANK_NEEDED         = 10
local REVAN_DESPAWN_MS        = 300000   -- 5 minutes
local RETRY_COOLDOWN_SECS     = 3600     -- 1 hour

-- Spawn offset from player (50m north)
local SPAWN_OFFSET_X = 0
local SPAWN_OFFSET_Y = 50

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

local function gkSay(pCreature, msg)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFF" .. msg)
end

local function forceMsg(pCreature, msg)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFF" .. msg)
end

local function darkMsg(pCreature, msg)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#FF4444[The Gatekeeper] \\#FFFFFF" .. msg)
end

local function getFrsRank(pCreature, alignment)
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return 0 end
    if alignment == "dark" then
        return PlayerObject(pGhost):getFrsCouncilRank(2)
    else
        return PlayerObject(pGhost):getFrsCouncilRank(1)
    end
end

local function getAlignment(pCreature)
    -- Check FRS council membership first (most reliable)
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return rsd(pCreature, "jedi_alignment") end

    local lightRank = PlayerObject(pGhost):getFrsCouncilRank(1)
    local darkRank  = PlayerObject(pGhost):getFrsCouncilRank(2)

    if darkRank > 0 then return "dark" end
    if lightRank > 0 then return "light" end

    -- Fall back to stored alignment
    return rsd(pCreature, "jedi_alignment")
end

-- ============================================================
-- QUALIFICATION CHECK
-- Called from holocron_use_for_studies when master_holocrons_used
-- reaches MASTER_HOLOCRONS_NEEDED while player is a knight
-- ============================================================

function MasterTrial:checkQualification(pCreature)
    if pCreature == nil then return end

    local status    = rsd(pCreature, "jedi_status")
    if status ~= "knight" then return end

    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0
    if masterUsed < MASTER_HOLOCRONS_NEEDED then return end

    -- Already notified?
    if rsd(pCreature, "master_trial_notified") == "1" then return end

    local alignment = getAlignment(pCreature)
    local frsRank   = getFrsRank(pCreature, alignment)
    if frsRank < FRS_RANK_NEEDED then return end

    wsd(pCreature, "master_trial_notified", "1")
    wsd(pCreature, "jedi_alignment", alignment)

    MasterTrial:sendQualificationNotice(pCreature, alignment)
end

function MasterTrial:sendQualificationNotice(pCreature, alignment)
    if pCreature == nil then return end

    local firstName = CreatureObject(pCreature):getFirstName()
    local pGhost    = CreatureObject(pCreature):getPlayerObject()

    -- SUI Popup
    local sui = SuiMessageBox.new("MasterTrial", "onQualificationAck")
    if alignment == "dark" then
        sui.setTitle("The Dark Council Calls")
        sui.setPrompt(
            "The darkness within you has reached its fullest expression.\n\n" ..
            "You have consumed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons and risen to Rank " .. FRS_RANK_NEEDED .. " of the Dark Council.\n\n" ..
            "There is one final trial that separates a Knight from a Dark Lord.\n\n" ..
            "Seek the Gatekeeper and speak the words: 'I am ready for the final trial.'\n\n" ..
            "Do not keep the darkness waiting."
        )
        sui.setOkButtonText("I will seek him out")
    else
        sui.setTitle("The Jedi Council Speaks")
        sui.setPrompt(
            "The Force within you has reached a profound depth.\n\n" ..
            "You have absorbed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons and risen to Rank " .. FRS_RANK_NEEDED .. " of the Jedi Council.\n\n" ..
            "There is one final trial that separates a Knight from a Grand Master.\n\n" ..
            "Seek the Gatekeeper and speak the words: 'I am ready for the final trial.'\n\n" ..
            "May the Force be with you, " .. firstName .. "."
        )
        sui.setOkButtonText("I am ready")
    end
    sui.setCancelButtonText("")
    sui.sendTo(pCreature)

    -- In-game mail
    createEvent(2000, "MasterTrial", "sendQualificationMail", pCreature, alignment)
end

function MasterTrial:onQualificationAck(pPlayer, pSui, eventIndex, ...)
    -- Info only - no action needed
end

function MasterTrial:sendQualificationMail(pCreature, alignment)
    if pCreature == nil then return end
    local firstName = CreatureObject(pCreature):getFirstName()

    if alignment == "dark" then
        sendMail(
            "The Gatekeeper",
            "Your Final Trial Awaits - Dark Lord",
            "Knight " .. firstName .. ",\n\n" ..
            "The dark side has watched your ascent with great interest.\n\n" ..
            "You have consumed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons. You have clawed your way to Rank " .. FRS_RANK_NEEDED .. " of the Dark Council. " ..
            "Lesser beings would have broken. You did not.\n\n" ..
            "But knowing darkness is not the same as commanding it.\n\n" ..
            "One final test remains. A being of terrible power - a remnant of an age that should have stayed buried - " ..
            "has been called forward to judge you. His name is spoken in shadows. Those who have faced him and lived can be counted on one hand.\n\n" ..
            "Seek me out. Select 'Seek the Final Trial' from my radial menu.\n\n" ..
            "Come alone. Come prepared. Do not come afraid - the dark side has no patience for fear.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    else
        sendMail(
            "The Gatekeeper",
            "Your Final Trial Awaits - Grand Master",
            "Knight " .. firstName .. ",\n\n" ..
            "The Force has been whispering your name for some time now.\n\n" ..
            "You have absorbed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons. You have risen to Rank " .. FRS_RANK_NEEDED .. " of the Jedi Council. " ..
            "The dedication you have shown is rare. The galaxy has noticed.\n\n" ..
            "But wisdom and power are not the same thing.\n\n" ..
            "One final test remains. A being of immense power - a shadow of what the Force can produce when left unchecked - " ..
            "has been summoned to stand before you. Many have tried. Few have endured.\n\n" ..
            "Seek me out when you are ready. Select 'Seek the Final Trial' from my radial menu.\n\n" ..
            "Come prepared. Come focused. The Force will be with you - but it cannot fight for you.\n\n" ..
            "May it guide your blade.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    end
end

-- ============================================================
-- GATEKEEPER RADIAL: "Seek the Final Trial"
-- Called from gatekeeper NPC radial component
-- ============================================================

function MasterTrial:onSeekFinalTrial(pCreature, pNPC)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local alignment  = getAlignment(pCreature)
    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0
    local frsRank    = getFrsRank(pCreature, alignment)

    -- Gate checks
    if status ~= "knight" then
        gkSay(pCreature, "You are not yet a Knight. There is nothing for you here.")
        return
    end

    if masterUsed < MASTER_HOLOCRONS_NEEDED then
        local remaining = MASTER_HOLOCRONS_NEEDED - masterUsed
        if alignment == "dark" then
            darkMsg(pCreature, "You hunger for power but you have not earned the right to this trial.")
            darkMsg(pCreature, "You have consumed " .. masterUsed .. "/" .. MASTER_HOLOCRONS_NEEDED .. " holocrons. " .. remaining .. " more are required.")
        else
            gkSay(pCreature, "The Force is not ready to speak through you at this level.")
            gkSay(pCreature, "You have absorbed " .. masterUsed .. "/" .. MASTER_HOLOCRONS_NEEDED .. " holocrons. " .. remaining .. " more are required.")
        end
        return
    end

    if frsRank < FRS_RANK_NEEDED then
        local remaining = FRS_RANK_NEEDED - frsRank
        if alignment == "dark" then
            darkMsg(pCreature, "The Dark Council does not recognise you at this rank.")
            darkMsg(pCreature, "You are Rank " .. frsRank .. " of " .. FRS_RANK_NEEDED .. " required. Earn " .. remaining .. " more ranks.")
        else
            gkSay(pCreature, "The Jedi Council has not yet recognised your full standing.")
            gkSay(pCreature, "You are Rank " .. frsRank .. " of " .. FRS_RANK_NEEDED .. " required. Earn " .. remaining .. " more ranks.")
        end
        return
    end

    -- Check cooldown
    local lastFail = tonumber(rsd(pCreature, "master_trial_fail_time")) or 0
    if lastFail > 0 then
        local elapsed = os.time() - lastFail
        if elapsed < RETRY_COOLDOWN_SECS then
            local remaining = RETRY_COOLDOWN_SECS - elapsed
            local mins = math.ceil(remaining / 60)
            if alignment == "dark" then
                darkMsg(pCreature, "You failed. The dark side remembers weakness.")
                darkMsg(pCreature, "You must wait " .. mins .. " more minutes before the trial can be attempted again.")
            else
                gkSay(pCreature, "You were not ready. Rest. Reflect. The Force needs time to restore itself.")
                gkSay(pCreature, "You must wait " .. mins .. " more minutes before attempting the trial again.")
            end
            return
        else
            wsd(pCreature, "master_trial_fail_time", "0")
        end
    end

    -- Check if trial already active
    if rsd(pCreature, "master_trial_active") == "1" then
        local revanID = tonumber(rsd(pCreature, "master_revan_id")) or 0
        if revanID ~= 0 and getSceneObject(revanID) ~= nil then
            if alignment == "dark" then
                darkMsg(pCreature, "Your trial is already underway. The clone lives. Go and finish it.")
            else
                gkSay(pCreature, "Your trial is already underway. He still stands. Go and finish it.")
            end
            return
        else
            -- Revan despawned - reset
            MasterTrial:resetTrialState(pCreature)
        end
    end

    -- Begin dialogue
    MasterTrial:beginGatekeeperDialogue(pCreature, alignment)
end

-- ============================================================
-- EPIC GATEKEEPER DIALOGUE
-- ============================================================

function MasterTrial:beginGatekeeperDialogue(pCreature, alignment)
    if pCreature == nil then return end

    local firstName = CreatureObject(pCreature):getFirstName()

    if alignment == "dark" then
        darkMsg(pCreature, "...")
        createEvent(2000, "MasterTrial", "gatekeeperDialogueDark2", pCreature, "")
    else
        gkSay(pCreature, "...")
        createEvent(2000, "MasterTrial", "gatekeeperDialogueLight2", pCreature, "")
    end
end

-- LIGHT DIALOGUE CHAIN

function MasterTrial:gatekeeperDialogueLight2(pCreature, params)
    if pCreature == nil then return end
    local firstName = CreatureObject(pCreature):getFirstName()
    gkSay(pCreature, firstName .. ".")
    createEvent(2500, "MasterTrial", "gatekeeperDialogueLight3", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight3(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "I have watched many come to this place. Seekers. Dreamers. The desperate and the determined.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueLight4", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight4(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Most turned back. Some fell. A rare few endured.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueLight5", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight5(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "You have absorbed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons. You have studied the old ways until the Force itself began to speak in your sleep.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueLight6", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight6(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "You have sat in Council. You have been tested by your peers and found worthy of rank.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueLight7", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight7(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "And yet... the Force does not grant its highest rank to the learned alone.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueLight8", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight8(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "Knowledge without strength is philosophy. Strength without knowledge is destruction.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueLight9", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight9(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "A Grand Master must be both.")
    createEvent(2500, "MasterTrial", "gatekeeperDialogueLight10", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight10(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "And so I have called something ancient forward.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueLight11", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight11(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "A clone. Grown from cells taken from the greatest Force user this galaxy has ever known.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueLight12", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight12(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "He carries no memory. No mercy. Only power.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueLight13", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight13(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Defeat him... and the rank of Grand Master is yours.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueLight14", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight14(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Fail... and you will wait one hour before you may try again. He does not take prisoners.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueLight15", pCreature, "")
end

function MasterTrial:gatekeeperDialogueLight15(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The air changes. Something ancient stirs nearby.")
    createEvent(3000, "MasterTrial", "doSpawnRevan", pCreature, "light")
end

-- DARK DIALOGUE CHAIN

function MasterTrial:gatekeeperDialogueDark2(pCreature, params)
    if pCreature == nil then return end
    local firstName = CreatureObject(pCreature):getFirstName()
    darkMsg(pCreature, firstName .. ".")
    createEvent(2500, "MasterTrial", "gatekeeperDialogueDark3", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark3(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You stand before me because you have survived things that should have broken you.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueDark4", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark4(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "The dark side does not reward survivors. It rewards dominators.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueDark5", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark5(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You have consumed " .. MASTER_HOLOCRONS_NEEDED .. " holocrons. You have torn their secrets from them and made that power yours.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueDark6", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark6(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You have clawed your way through the ranks of the Dark Council, leaving the weak behind.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueDark7", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark7(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "And yet... titles are given by the living.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueDark8", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark8(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "A Dark Lord is not appointed. A Dark Lord is proven.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueDark9", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark9(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "I have called something forward for you.")
    createEvent(2500, "MasterTrial", "gatekeeperDialogueDark10", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark10(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "A clone. Engineered from the genetic material of the most dangerous Force user who ever lived.")
    createEvent(4000, "MasterTrial", "gatekeeperDialogueDark11", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark11(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "He carries no ideology. No history. Only an instinct to destroy.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueDark12", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark12(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Destroy him... and the title of Dark Lord is yours to seize.")
    createEvent(3000, "MasterTrial", "gatekeeperDialogueDark13", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark13(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Fall before him... and you will wait one hour. Weakness is not forgotten in the dark side.")
    createEvent(3500, "MasterTrial", "gatekeeperDialogueDark14", pCreature, "")
end

function MasterTrial:gatekeeperDialogueDark14(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The shadows bend. Something ancient and terrible approaches.")
    createEvent(3000, "MasterTrial", "doSpawnRevan", pCreature, "dark")
end

-- ============================================================
-- SPAWN REVAN CLONE (Trial 1)
-- ============================================================

function MasterTrial:doSpawnRevan(pCreature, alignment)
    if pCreature == nil then return end

    local zoneName = SceneObject(pCreature):getZoneName()
    local px       = SceneObject(pCreature):getWorldPositionX()
    local py       = SceneObject(pCreature):getWorldPositionY()
    local pz       = SceneObject(pCreature):getWorldPositionZ()

    local spawnX = px + SPAWN_OFFSET_X
    local spawnY = py + SPAWN_OFFSET_Y

    local pRevan = spawnMobile(zoneName, "revan_clone", 0, spawnX, pz, spawnY, 180, 0)

    if pRevan == nil then
        if alignment == "dark" then
            darkMsg(pCreature, "The summoning failed. Something disrupts this place. Return to me in a moment.")
        else
            gkSay(pCreature, "Something disrupts the summoning. The Force is unsettled here. Return to me in a moment.")
        end
        MasterTrial:resetTrialState(pCreature)
        return
    end

    local revanID = tostring(SceneObject(pRevan):getObjectID())
    wsd(pCreature, "master_trial_active",    "1")
    wsd(pCreature, "master_revan_id",        revanID)
    wsd(pCreature, "master_trial_phase",     "1")
    wsd(pCreature, "master_trial_spawn_time", tostring(os.time()))
    wsd(pCreature, "master_trial_alignment", alignment)

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost ~= nil then
        PlayerObject(pGhost):addWaypoint(zoneName, "Revan (Clone)", "", spawnX, spawnY, WAYPOINTRED, true, true, WAYPOINTQUESTTASK)
    end

    -- Make Revan attack the player
    createEvent(1000, "MasterTrial", "revanAttackPlayer", pRevan,
        tostring(SceneObject(pCreature):getObjectID()))

    -- Kill observer
    createObserver(OBJECTDESTRUCTION, "MasterTrial", "onRevanKilled", pRevan)

    -- Despawn timer
    createEvent(REVAN_DESPAWN_MS, "MasterTrial", "checkRevanDespawn", pCreature, "1")

    if alignment == "dark" then
        darkMsg(pCreature, "He is here. Prove your dominance.")
    else
        gkSay(pCreature, "He is here. May the Force flow through you.")
    end
end

function MasterTrial:revanAttackPlayer(pRevan, params)
    if pRevan == nil then return end
    local playerID = tonumber(params)
    if playerID == nil then return end
    local pTarget = getSceneObject(playerID)
    if pTarget ~= nil then
        AiAgent(pRevan):setDefender(pTarget)
    end
end

-- ============================================================
-- DESPAWN CHECK (fires after 5 minutes)
-- ============================================================

function MasterTrial:checkRevanDespawn(pCreature, phase)
    if pCreature == nil then return end

    if rsd(pCreature, "master_trial_active") ~= "1" then return end

    local revanID = tonumber(rsd(pCreature, "master_revan_id")) or 0
    if revanID == 0 then return end

    local pRevan = getSceneObject(revanID)
    if pRevan == nil then return end

    -- Revan still alive after 5 minutes - despawn and apply cooldown
    local ok, isDead = pcall(function() return CreatureObject(pRevan):isDead() end)
    if ok and isDead then return end

    SceneObject(pRevan):destroyObjectFromWorld()
    MasterTrial:onTrialFailed(pCreature, tonumber(phase) or 1)
end

-- ============================================================
-- OBSERVER: REVAN KILLED
-- ============================================================

function MasterTrial:onRevanKilled(pVictim, pAttacker)
    if pAttacker == nil then return 1 end
    if not SceneObject(pAttacker):isPlayerCreature() then return 0 end

    local pGhost = CreatureObject(pAttacker):getPlayerObject()
    if pGhost == nil then return 1 end

    if rsd(pAttacker, "master_trial_active") ~= "1" then return 1 end

    local revanID = tonumber(rsd(pAttacker, "master_revan_id")) or 0
    if revanID == 0 then return 1 end

    if pVictim ~= nil and SceneObject(pVictim):getObjectID() == revanID then
        local phase = tonumber(rsd(pAttacker, "master_trial_phase")) or 1
        if phase == 1 then
            MasterTrial:onPhaseOneComplete(pAttacker, pGhost)
        elseif phase == 2 then
            MasterTrial:onPhaseTwoComplete(pAttacker, pGhost)
        end
    end

    return 1
end

-- ============================================================
-- PHASE 1 COMPLETE - Grant novice master box
-- ============================================================

function MasterTrial:onPhaseOneComplete(pCreature, pGhost)
    if pCreature == nil or pGhost == nil then return end

    MasterTrial:resetTrialState(pCreature)

    local alignment = rsd(pCreature, "master_trial_alignment")
    if alignment == "" then alignment = getAlignment(pCreature) end

    PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)

    -- Phase 1 success dialogue
    if alignment == "dark" then
        darkMsg(pCreature, "...")
        createEvent(2000, "MasterTrial", "phaseOneSuccessDark2", pCreature, "")
    else
        gkSay(pCreature, "...")
        createEvent(2000, "MasterTrial", "phaseOneSuccessLight2", pCreature, "")
    end
end

function MasterTrial:phaseOneSuccessLight2(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "He is gone.")
    createEvent(2500, "MasterTrial", "phaseOneSuccessLight3", pCreature, "")
end

function MasterTrial:phaseOneSuccessLight3(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "You faced something that has broken others. And you endured.")
    createEvent(3500, "MasterTrial", "phaseOneSuccessLight4", pCreature, "")
end

function MasterTrial:phaseOneSuccessLight4(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The Force recognises this moment. It has been waiting for it.")
    createEvent(3000, "MasterTrial", "phaseOneSuccessLight5", pCreature, "")
end

function MasterTrial:phaseOneSuccessLight5(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "This is not your destination. This is your beginning.")
    createEvent(3000, "MasterTrial", "phaseOneSuccessLight6", pCreature, "")
end

function MasterTrial:phaseOneSuccessLight6(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Train with the enclave. Deepen your mastery. When you have walked every step of the path...")
    createEvent(3500, "MasterTrial", "phaseOneSuccessLight7", pCreature, "")
end

function MasterTrial:phaseOneSuccessLight7(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Return to me. One final confrontation awaits.")
    createEvent(3000, "MasterTrial", "doGrantNoviceMaster", pCreature, "light")
end

function MasterTrial:phaseOneSuccessDark2(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "He has fallen.")
    createEvent(2500, "MasterTrial", "phaseOneSuccessDark3", pCreature, "")
end

function MasterTrial:phaseOneSuccessDark3(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "A clone of the greatest force user who ever lived... and you dismantled him.")
    createEvent(3500, "MasterTrial", "phaseOneSuccessDark4", pCreature, "")
end

function MasterTrial:phaseOneSuccessDark4(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The dark side surges through you. It is satisfied. For now.")
    createEvent(3000, "MasterTrial", "phaseOneSuccessDark5", pCreature, "")
end

function MasterTrial:phaseOneSuccessDark5(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "But power is not a destination. It is a direction.")
    createEvent(3000, "MasterTrial", "phaseOneSuccessDark6", pCreature, "")
end

function MasterTrial:phaseOneSuccessDark6(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Train at the enclave. Forge your darkness into something unbreakable. When every skill has been claimed...")
    createEvent(3500, "MasterTrial", "phaseOneSuccessDark7", pCreature, "")
end

function MasterTrial:phaseOneSuccessDark7(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Return to me. The final confrontation will make today look like a warm-up.")
    createEvent(3000, "MasterTrial", "doGrantNoviceMaster", pCreature, "dark")
end

function MasterTrial:doGrantNoviceMaster(pCreature, alignment)
    if pCreature == nil then return end

    wsd(pCreature, "jedi_status", "master_novice")
    wsd(pCreature, "master_trial_phase1_done", "1")
    wsd(pCreature, "master_trial_notified", "0")  -- reset so phase 2 notification can fire

    if alignment == "dark" then
        awardSkill(pCreature, "jedi_dark_lord_novice")
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 The dark side acknowledges your power. You are Dark Lord Novice. Train the enclave boxes. Return to me when you are ready for the final confrontation.")
    else
        awardSkill(pCreature, "jedi_grand_master_novice")
        CreatureObject(pCreature):sendSystemMessage("\\#AADDFF The Force acknowledges your dedication. You are Grand Master Novice. Train the enclave boxes. Return to me when you are ready for the final confrontation.")
    end

    -- Send mail about next steps
    createEvent(3000, "MasterTrial", "sendPhaseOneCompleteMail", pCreature, alignment)
end

function MasterTrial:sendPhaseOneCompleteMail(pCreature, alignment)
    if pCreature == nil then return end
    local firstName = CreatureObject(pCreature):getFirstName()

    if alignment == "dark" then
        sendMail(
            "The Gatekeeper",
            "The First Trial is Complete - Dark Lord Novice",
            firstName .. ",\n\n" ..
            "You destroyed the clone. The dark side has taken note.\n\n" ..
            "You now hold the rank of Dark Lord Novice. But a novice is still a beginning.\n\n" ..
            "Seek the Dark Enclave on Yavin 4 at coordinates: 5079, 306.\n" ..
            "The terminal within will allow you to train the intermediate Dark Lord disciplines.\n\n" ..
            "Train every box. Leave nothing unlearned. When you stand at the threshold of the final rank...\n\n" ..
            "Return to me. Revan Reborn will be waiting. He will be stronger than the clone you faced today.\n\n" ..
            "Prepare accordingly.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    else
        sendMail(
            "The Gatekeeper",
            "The First Trial is Complete - Grand Master Novice",
            firstName .. ",\n\n" ..
            "You stood before the clone and did not fall. The Force is pleased.\n\n" ..
            "You now hold the rank of Grand Master Novice. The path continues.\n\n" ..
            "Seek the Jedi Enclave on Yavin 4 at coordinates: -5575, 4910.\n" ..
            "The terminal within will allow you to train the intermediate Grand Master disciplines.\n\n" ..
            "Train every box. Leave no teaching unstudied. When you stand at the threshold of the final rank...\n\n" ..
            "Return to me. Revan Reborn will be waiting. He will be far stronger than the clone you faced today.\n\n" ..
            "May the Force prepare you for what is coming.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    end
end

-- ============================================================
-- PHASE 2: FINAL TRIAL - "Seek the Final Confrontation"
-- Called when player has trained to final box and returns to gatekeeper
-- ============================================================

function MasterTrial:onSeekFinalConfrontation(pCreature, pNPC)
    if pCreature == nil then return end

    local status    = rsd(pCreature, "jedi_status")
    local alignment = getAlignment(pCreature)
    local phase1Done = rsd(pCreature, "master_trial_phase1_done")

    if phase1Done ~= "1" then
        gkSay(pCreature, "You have not yet completed the first trial. Speak to me about the final trial first.")
        return
    end

    -- Check player has trained to the final intermediate box
    -- Light: jedi_grand_master_10 | Dark: jedi_dark_lord_10
    local finalBoxSkill = (alignment == "dark") and "jedi_dark_lord_10" or "jedi_grand_master_10"
    if not CreatureObject(pCreature):hasSkill(finalBoxSkill) then
        if alignment == "dark" then
            darkMsg(pCreature, "You have not yet mastered the Dark Lord disciplines.")
            darkMsg(pCreature, "Return to the Dark Enclave and train every box. Then come back.")
        else
            gkSay(pCreature, "You have not yet mastered the Grand Master disciplines.")
            gkSay(pCreature, "Return to the enclave and train every box. Then come back.")
        end
        return
    end

    -- Check cooldown
    local lastFail = tonumber(rsd(pCreature, "master_trial2_fail_time")) or 0
    if lastFail > 0 then
        local elapsed = os.time() - lastFail
        if elapsed < RETRY_COOLDOWN_SECS then
            local remaining = RETRY_COOLDOWN_SECS - elapsed
            local mins = math.ceil(remaining / 60)
            if alignment == "dark" then
                darkMsg(pCreature, "Revan Reborn is not yet ready to face you again. " .. mins .. " minutes remain.")
            else
                gkSay(pCreature, "The Force is not yet settled. " .. mins .. " minutes remain before you may try again.")
            end
            return
        else
            wsd(pCreature, "master_trial2_fail_time", "0")
        end
    end

    -- Begin Phase 2 dialogue
    MasterTrial:beginFinalDialogue(pCreature, alignment)
end

function MasterTrial:beginFinalDialogue(pCreature, alignment)
    if pCreature == nil then return end

    if alignment == "dark" then
        darkMsg(pCreature, "So. You have returned.")
        createEvent(2500, "MasterTrial", "finalDialogueDark2", pCreature, "")
    else
        gkSay(pCreature, "You have returned.")
        createEvent(2500, "MasterTrial", "finalDialogueLight2", pCreature, "")
    end
end

-- FINAL LIGHT DIALOGUE

function MasterTrial:finalDialogueLight2(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Every discipline studied. Every teaching absorbed. Every step of the Grand Master path walked.")
    createEvent(4000, "MasterTrial", "finalDialogueLight3", pCreature, "")
end

function MasterTrial:finalDialogueLight3(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "I will not lie to you. What comes next is not the same as what you faced before.")
    createEvent(3500, "MasterTrial", "finalDialogueLight4", pCreature, "")
end

function MasterTrial:finalDialogueLight4(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Revan Reborn carries the full fury of the original. Your previous victory only awakened it.")
    createEvent(4000, "MasterTrial", "finalDialogueLight5", pCreature, "")
end

function MasterTrial:finalDialogueLight5(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The Force does not hand out its highest gifts. They are earned in fire.")
    createEvent(4000, "MasterTrial", "finalDialogueLight6", pCreature, "")
end

function MasterTrial:finalDialogueLight6(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "If you fall... you will wait. And you will try again. The Force does not abandon the worthy.")
    createEvent(3500, "MasterTrial", "finalDialogueLight7", pCreature, "")
end

function MasterTrial:finalDialogueLight7(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "But if you stand...")
    createEvent(2500, "MasterTrial", "finalDialogueLight8", pCreature, "")
end

function MasterTrial:finalDialogueLight8(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "If you stand, " .. CreatureObject(pCreature):getFirstName() .. "...")
    createEvent(3000, "MasterTrial", "finalDialogueLight9", pCreature, "")
end

function MasterTrial:finalDialogueLight9(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "The galaxy will have a new Grand Master.")
    createEvent(3000, "MasterTrial", "finalDialogueLight10", pCreature, "")
end

function MasterTrial:finalDialogueLight10(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The Force holds its breath.")
    createEvent(3000, "MasterTrial", "doSpawnRevanReborn", pCreature, "light")
end

-- FINAL DARK DIALOGUE

function MasterTrial:finalDialogueDark2(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You have trained every discipline. Claimed every power the Dark Lord path has to offer.")
    createEvent(4000, "MasterTrial", "finalDialogueDark3", pCreature, "")
end

function MasterTrial:finalDialogueDark3(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "What I am about to unleash is not the same as what you faced before.")
    createEvent(3500, "MasterTrial", "finalDialogueDark4", pCreature, "")
end

function MasterTrial:finalDialogueDark4(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Revan Reborn has been enhanced. Your victory only taught it how to kill you better.")
    createEvent(4000, "MasterTrial", "finalDialogueDark5", pCreature, "")
end

function MasterTrial:finalDialogueDark5(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The dark side does not crown the surviving. It crowns the unconquerable.")
    createEvent(4000, "MasterTrial", "finalDialogueDark6", pCreature, "")
end

function MasterTrial:finalDialogueDark6(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "If you fall... you wait. You are not above consequence.")
    createEvent(3500, "MasterTrial", "finalDialogueDark7", pCreature, "")
end

function MasterTrial:finalDialogueDark7(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "But if you destroy him...")
    createEvent(2500, "MasterTrial", "finalDialogueDark8", pCreature, "")
end

function MasterTrial:finalDialogueDark8(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "If you stand over his corpse...")
    createEvent(3000, "MasterTrial", "finalDialogueDark9", pCreature, "")
end

function MasterTrial:finalDialogueDark9(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "The title of Dark Lord is yours. And no one will dare dispute it.")
    createEvent(3000, "MasterTrial", "finalDialogueDark10", pCreature, "")
end

function MasterTrial:finalDialogueDark10(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The shadows converge.")
    createEvent(3000, "MasterTrial", "doSpawnRevanReborn", pCreature, "dark")
end

-- ============================================================
-- SPAWN REVAN REBORN (Phase 2 - 75% stronger, double crystal loot)
-- ============================================================

function MasterTrial:doSpawnRevanReborn(pCreature, alignment)
    if pCreature == nil then return end

    local zoneName = SceneObject(pCreature):getZoneName()
    local px       = SceneObject(pCreature):getWorldPositionX()
    local py       = SceneObject(pCreature):getWorldPositionY()
    local pz       = SceneObject(pCreature):getWorldPositionZ()

    local spawnX = px + SPAWN_OFFSET_X
    local spawnY = py + SPAWN_OFFSET_Y

    local pRevan = spawnMobile(zoneName, "revan_reborn", 0, spawnX, pz, spawnY, 180, 0)

    if pRevan == nil then
        if alignment == "dark" then
            darkMsg(pCreature, "The summoning was disrupted. Return to me in a moment.")
        else
            gkSay(pCreature, "Something disrupts the summoning. Return to me in a moment.")
        end
        return
    end

    local revanID = tostring(SceneObject(pRevan):getObjectID())
    wsd(pCreature, "master_trial_active",    "1")
    wsd(pCreature, "master_revan_id",        revanID)
    wsd(pCreature, "master_trial_phase",     "2")
    wsd(pCreature, "master_trial_spawn_time", tostring(os.time()))
    wsd(pCreature, "master_trial_alignment", alignment)

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost ~= nil then
        PlayerObject(pGhost):addWaypoint(zoneName, "Revan (Reborn)", "", spawnX, spawnY, WAYPOINTRED, true, true, WAYPOINTQUESTTASK)
    end

    createEvent(1000, "MasterTrial", "revanAttackPlayer", pRevan,
        tostring(SceneObject(pCreature):getObjectID()))

    createObserver(OBJECTDESTRUCTION, "MasterTrial", "onRevanKilled", pRevan)

    createEvent(REVAN_DESPAWN_MS, "MasterTrial", "checkRevanDespawn", pCreature, "2")

    if alignment == "dark" then
        darkMsg(pCreature, "Revan Reborn is here. Prove your absolute dominance.")
    else
        gkSay(pCreature, "Revan Reborn is here. Call upon everything the Force has given you.")
    end
end

-- ============================================================
-- PHASE 2 COMPLETE - Grant Master box
-- ============================================================

function MasterTrial:onPhaseTwoComplete(pCreature, pGhost)
    if pCreature == nil or pGhost == nil then return end

    MasterTrial:resetTrialState(pCreature)

    local alignment = rsd(pCreature, "master_trial_alignment")
    if alignment == "" then alignment = getAlignment(pCreature) end

    PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)

    wsd(pCreature, "jedi_status", "master")
    wsd(pCreature, "master_trial_phase1_done", "0")

    if alignment == "dark" then
        createEvent(1000,  "MasterTrial", "finalSuccessDark1",  pCreature, "")
    else
        createEvent(1000,  "MasterTrial", "finalSuccessLight1", pCreature, "")
    end
end

-- LIGHT VICTORY

function MasterTrial:finalSuccessLight1(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "Silence.")
    createEvent(3000, "MasterTrial", "finalSuccessLight2", pCreature, "")
end

function MasterTrial:finalSuccessLight2(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "He is gone. Truly gone.")
    createEvent(3000, "MasterTrial", "finalSuccessLight3", pCreature, "")
end

function MasterTrial:finalSuccessLight3(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "In all the years I have stood in this place... very few have ever made it this far.")
    createEvent(4000, "MasterTrial", "finalSuccessLight4", pCreature, "")
end

function MasterTrial:finalSuccessLight4(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The Force does not speak in words. But today, it is deafening.")
    createEvent(4000, "MasterTrial", "finalSuccessLight5", pCreature, "")
end

function MasterTrial:finalSuccessLight5(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "You are no longer a Knight in search of purpose.")
    createEvent(3000, "MasterTrial", "finalSuccessLight6", pCreature, "")
end

function MasterTrial:finalSuccessLight6(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "You are no longer a student waiting for permission to act.")
    createEvent(3000, "MasterTrial", "finalSuccessLight7", pCreature, "")
end

function MasterTrial:finalSuccessLight7(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Rise.")
    createEvent(3500, "MasterTrial", "finalSuccessLight8", pCreature, "")
end

function MasterTrial:finalSuccessLight8(pCreature, params)
    if pCreature == nil then return end
    gkSay(pCreature, "Grand Master.")
    createEvent(4000, "MasterTrial", "doGrantMasterBox", pCreature, "light")
end

-- DARK VICTORY

function MasterTrial:finalSuccessDark1(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The darkness surges.")
    createEvent(3000, "MasterTrial", "finalSuccessDark2", pCreature, "")
end

function MasterTrial:finalSuccessDark2(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Revan Reborn lies at your feet.")
    createEvent(3000, "MasterTrial", "finalSuccessDark3", pCreature, "")
end

function MasterTrial:finalSuccessDark3(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "In all the time I have stood in this place... I have seen very few capable of what you just did.")
    createEvent(4000, "MasterTrial", "finalSuccessDark4", pCreature, "")
end

function MasterTrial:finalSuccessDark4(pCreature, params)
    if pCreature == nil then return end
    forceMsg(pCreature, "The dark side does not applaud. But it bows.")
    createEvent(4000, "MasterTrial", "finalSuccessDark5", pCreature, "")
end

function MasterTrial:finalSuccessDark5(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You are no longer a Knight hungry for power.")
    createEvent(3000, "MasterTrial", "finalSuccessDark6", pCreature, "")
end

function MasterTrial:finalSuccessDark6(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "You are no longer a student waiting to be unleashed.")
    createEvent(3000, "MasterTrial", "finalSuccessDark7", pCreature, "")
end

function MasterTrial:finalSuccessDark7(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Kneel to nothing.")
    createEvent(3500, "MasterTrial", "finalSuccessDark8", pCreature, "")
end

function MasterTrial:finalSuccessDark8(pCreature, params)
    if pCreature == nil then return end
    darkMsg(pCreature, "Dark Lord.")
    createEvent(4000, "MasterTrial", "doGrantMasterBox", pCreature, "dark")
end

-- ============================================================
-- GRANT MASTER BOX
-- ============================================================

function MasterTrial:doGrantMasterBox(pCreature, alignment)
    if pCreature == nil then return end

    if alignment == "dark" then
        awardSkill(pCreature, "jedi_dark_lord_master")
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 You are Dark Lord Master. The galaxy will know your name.")
    else
        awardSkill(pCreature, "jedi_grand_master_master")
        CreatureObject(pCreature):sendSystemMessage("\\#AADDFF You are Grand Master. The Force is with you. It has always been with you.")
    end

    -- Send completion mail
    createEvent(3000, "MasterTrial", "sendMasterCompleteMail", pCreature, alignment)
end

function MasterTrial:sendMasterCompleteMail(pCreature, alignment)
    if pCreature == nil then return end
    local firstName = CreatureObject(pCreature):getFirstName()

    if alignment == "dark" then
        sendMail(
            "The Gatekeeper",
            "Dark Lord Master - The Path is Complete",
            firstName .. ",\n\n" ..
            "It is done.\n\n" ..
            "You destroyed Revan Reborn. You have claimed what no one could take from you.\n\n" ..
            "The title of Dark Lord Master belongs to you. Not because it was given. Because you seized it.\n\n" ..
            "There are no more trials. No more gates. No more tests.\n\n" ..
            "The galaxy is yours to dominate.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    else
        sendMail(
            "The Gatekeeper",
            "Grand Master - The Path is Complete",
            firstName .. ",\n\n" ..
            "It is done.\n\n" ..
            "You stood before Revan Reborn and did not fall. The Force has spoken.\n\n" ..
            "The title of Grand Master belongs to you. Carry it with wisdom.\n\n" ..
            "There are no more trials. No more gates. No more tests.\n\n" ..
            "The galaxy needs what you have become.\n\n" ..
            "May the Force be with you. Always.\n\n" ..
            "- The Gatekeeper",
            firstName
        )
    end
end

-- ============================================================
-- TRIAL FAILED (death / despawn / ran away)
-- ============================================================

function MasterTrial:onTrialFailed(pCreature, phase)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "master_trial_alignment")
    local pGhost    = CreatureObject(pCreature):getPlayerObject()

    if pGhost ~= nil then
        PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTQUESTTASK)
    end

    MasterTrial:resetTrialState(pCreature)

    if phase == 2 then
        wsd(pCreature, "master_trial2_fail_time", tostring(os.time()))
    else
        wsd(pCreature, "master_trial_fail_time", tostring(os.time()))
    end

    if alignment == "dark" then
        darkMsg(pCreature, "You have failed. The dark side does not forgive weakness easily.")
        darkMsg(pCreature, "Return in one hour and try again. Use the time wisely.")
    else
        gkSay(pCreature, "You were not ready. There is no shame in this - only a lesson.")
        gkSay(pCreature, "Return in one hour. The Force will be waiting.")
    end
end

-- ============================================================
-- RESET TRIAL STATE
-- ============================================================

function MasterTrial:resetTrialState(pCreature)
    if pCreature == nil then return end
    wsd(pCreature, "master_trial_active",    "0")
    wsd(pCreature, "master_revan_id",        "0")
    wsd(pCreature, "master_trial_phase",     "0")
    wsd(pCreature, "master_trial_spawn_time", "0")
end
