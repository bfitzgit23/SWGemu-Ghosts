--[[ 
    Aftermath Server - Custom Jedi Holocron Script
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/holocron.lua

    NOTE: Radial menu is handled entirely in C++ via HolocronMenuComponent.cpp
    This script only handles the LOGIC called from those radial selections.

    C++ calls these two global functions directly:
        holocron_use_for_studies(pCreature, pTarget, pGhost)
        holocron_speak_to_gatekeeper(pCreature, pTarget, pGhost)

    Other scripts call:
        holocron_award_points(pCreature, points, source)
        holocron_on_fs_kill(pCreature, pVictim)

    Player flags stored via PlayerObject screenplayState:
        "jedi_points"           - current accumulated points (Padawan path)
        "jedi_threshold_hit"    - 1 if player has hit the 15,000 point threshold
        "jedi_status"           - "none" / "padawan" / "knight" / "master"
        "knight_points"         - points accumulated post-padawan
        "knight_fs_kills"       - FS NPC kill counter
        "knight_holocrons_used" - holocrons consumed toward Knight unlock (need 20)
        "padawan_test_done"     - 1 if Old Man test has been initiated
        "padawan_mob_spawned"   - 1 if Dark Jedi Knight test mob is spawned
--]]

-- ============================================================
-- CONFIGURATION
-- ============================================================

-- Padawan thresholds — fixed values, no random
local PADAWAN_THRESHOLD = 15000
local HOLOCRON_POINTS_PADAWAN = 1000

-- Knight requirements
local KNIGHT_POINT_THRESHOLD = 25000
local KNIGHT_FS_KILLS_REQUIRED = 100
local KNIGHT_HOLOCRONS_REQUIRED = 20

-- Master requirements  
local MASTER_HOLOCRONS_REQUIRED = 100
local MASTER_FS_KILLS_REQUIRED = 2500

-- Force sensitive Jedi skill trees required for Knight unlock
-- Player must have mastered 3 of these trees
local JEDI_SKILL_TREES = {
    "force_discipline_light_saber",
    "force_discipline_defender",
    "force_discipline_healing",
    "force_discipline_powers",
    "force_discipline_enhancements",
    "force_discipline_alteration",
    "force_discipline_senses",
    "force_discipline_combat_powers",
    "force_discipline_dark_side",
}

-- Master box skill name per tree (the final box = mastered)
local JEDI_TREE_MASTER_BOX = {
    force_discipline_light_saber   = "force_discipline_light_saber_4",
    force_discipline_defender      = "force_discipline_defender_4",
    force_discipline_healing       = "force_discipline_healing_4",
    force_discipline_powers        = "force_discipline_powers_4",
    force_discipline_enhancements  = "force_discipline_enhancements_4",
    force_discipline_alteration    = "force_discipline_alteration_4",
    force_discipline_senses        = "force_discipline_senses_4",
    force_discipline_combat_powers = "force_discipline_combat_powers_4",
    force_discipline_dark_side     = "force_discipline_dark_side_4",
}

-- Dark Jedi Knight test mob template (spawned for Padawan final test)
-- Uses existing in-game Dark Jedi Knight NPC asset
local DARK_JEDI_KNIGHT_TEMPLATE = "object/mobile/dark_jedi_knight.iff"

-- Old Man NPC template (uses existing in-game hermit/old man asset)
local OLD_MAN_TEMPLATE = "object/mobile/old_man.iff"

-- Atmospheric messages sent to player as they accumulate points
-- Sent at increasing point thresholds as a % of their target
local ATMOSPHERIC_MESSAGES_PADAWAN = {
    [10]  = "You feel a strange warmth in your chest, as though something stirs within you.",
    [25]  = "Dreams of distant stars and ancient voices have begun to trouble your sleep.",
    [40]  = "The world seems different lately. Sharper. As if you are noticing things others cannot.",
    [55]  = "A strange energy courses through you at times. You cannot explain it.",
    [70]  = "You sense a presence at the edge of your awareness. Patient. Waiting.",
    [85]  = "The feeling grows stronger every day. Something is drawing you toward a greater destiny.",
    [95]  = "You feel as though you stand on the precipice of something vast and unknowable.",
}

local ATMOSPHERIC_MESSAGES_KNIGHT = {
    [10]  = "The Force whispers of greater trials ahead. Your training is not yet complete.",
    [25]  = "You sense the weight of the Force pressing upon you, testing your resolve.",
    [40]  = "Ancient knowledge stirs within you. The path to true mastery becomes clearer.",
    [55]  = "Your connection to the Force deepens. You feel its currents like never before.",
    [70]  = "The Force reveals glimpses of what you could become. The trials draw near.",
    [85]  = "You can feel the eyes of the Force upon you, measuring your worth.",
    [95]  = "The time is almost upon you. The enclave calls to your spirit.",
}

-- ============================================================
-- UTILITY FUNCTIONS
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

local function getJediStatus(pCreature)
    return getPlayerVar(pCreature, "jedi_status", "none")
end

local function hasSkill(pCreature, skillName)
    return CreatureObject(pCreature):hasSkill(skillName)
end

-- Count how many Jedi trees the player has mastered (box 4)
local function countMasteredJediTrees(pCreature)
    local count = 0
    for tree, masterBox in pairs(JEDI_TREE_MASTER_BOX) do
        if hasSkill(pCreature, masterBox) then
            count = count + 1
        end
    end
    return count
end

-- Send a Force message to the player
local function sendForceMessage(pCreature, msg)
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFF" .. msg)
end

-- Check and fire atmospheric messages based on point progress
local function checkAtmosphericMessages(pCreature, currentPoints, threshold, messageTable)
    local pct = math.floor((currentPoints / threshold) * 100)
    local lastMsgPct = getPlayerVar(pCreature, "last_atm_msg_pct", 0)
    
    for pctTrigger, msg in pairs(messageTable) do
        if pct >= pctTrigger and lastMsgPct < pctTrigger then
            sendForceMessage(pCreature, msg)
            setPlayerVar(pCreature, "last_atm_msg_pct", pctTrigger)
            break
        end
    end
end

-- ============================================================
-- USE FOR STUDIES
-- Earns points, consumes holocron, fires atmospheric messages
-- ============================================================

function holocron_use_for_studies(pCreature, pTarget, pGhost)
    local jediStatus = getJediStatus(pCreature)
    
    -- ---- PADAWAN PATH ----
    if jediStatus == "none" then
        local thresholdHit = getPlayerVar(pCreature, "jedi_threshold_hit", 0)
        
        if thresholdHit == 1 then
            sendForceMessage(pCreature, "You have already absorbed all you can from these teachings. Seek the Gatekeeper.")
            return
        end
        
        -- Add points
        local currentPoints = getPlayerVar(pCreature, "jedi_points", 0)
        currentPoints = currentPoints + HOLOCRON_POINTS_PADAWAN
        setPlayerVar(pCreature, "jedi_points", currentPoints)
        
        sendForceMessage(pCreature, "You study the holocron carefully. Ancient knowledge flows through you.")
        
        -- Destroy holocron
        SceneObject(pTarget):destroyObjectFromWorld()
        
        -- Check threshold
        if currentPoints >= PADAWAN_THRESHOLD then
            setPlayerVar(pCreature, "jedi_threshold_hit", 1)
            setPlayerVar(pCreature, "last_atm_msg_pct", 0)
            sendForceMessage(pCreature, "Something profound shifts within you. You have absorbed all you can from these teachings for now. Seek further knowledge... speak to the Gatekeeper.")
        else
            checkAtmosphericMessages(pCreature, currentPoints, PADAWAN_THRESHOLD, ATMOSPHERIC_MESSAGES_PADAWAN)
        end
        
    -- ---- KNIGHT PATH ----
    elseif jediStatus == "padawan" then
        local masteredTrees = countMasteredJediTrees(pCreature)
        
        if masteredTrees < 3 then
            sendForceMessage(pCreature, "You sense that you are not yet ready. Master more of the Force disciplines before seeking further advancement.")
            return
        end
        
        -- Check knight holocron count
        local knightHolocrons = getPlayerVar(pCreature, "knight_holocrons_used", 0)
        
        if knightHolocrons >= KNIGHT_HOLOCRONS_REQUIRED then
            sendForceMessage(pCreature, "You have meditated upon enough holocrons. Travel to your enclave to complete the trials.")
            return
        end
        
        knightHolocrons = knightHolocrons + 1
        setPlayerVar(pCreature, "knight_holocrons_used", knightHolocrons)
        
        -- Also accumulate knight points
        local knightPoints = getPlayerVar(pCreature, "knight_points", 0)
        knightPoints = knightPoints + HOLOCRON_POINTS_PADAWAN
        setPlayerVar(pCreature, "knight_points", knightPoints)
        
        sendForceMessage(pCreature, "You meditate upon the holocron. Its secrets deepen your connection to the Force. (" .. knightHolocrons .. "/" .. KNIGHT_HOLOCRONS_REQUIRED .. " holocrons absorbed)")
        
        -- Destroy holocron
        SceneObject(pTarget):destroyObjectFromWorld()
        
        -- Check knight threshold hit
        local threshold = KNIGHT_POINT_THRESHOLD
        if knightPoints >= threshold then
            local knightFsKills = getPlayerVar(pCreature, "knight_fs_kills", 0)
            if knightFsKills >= KNIGHT_FS_KILLS_REQUIRED and knightHolocrons >= KNIGHT_HOLOCRONS_REQUIRED then
                sendForceMessage(pCreature, "You feel the Force surging through you. You are ready for the Knight trials. Travel to your enclave.")
                setPlayerVar(pCreature, "knight_ready", 1)
            else
                checkAtmosphericMessages(pCreature, knightPoints, threshold, ATMOSPHERIC_MESSAGES_KNIGHT)
            end
        else
            checkAtmosphericMessages(pCreature, knightPoints, threshold, ATMOSPHERIC_MESSAGES_KNIGHT)
        end
        
    -- ---- MASTER PATH ----
    elseif jediStatus == "knight" then
        local masterHolocrons = getPlayerVar(pCreature, "master_holocrons_used", 0)
        
        if masterHolocrons >= MASTER_HOLOCRONS_REQUIRED then
            sendForceMessage(pCreature, "You have absorbed all the holocron teachings you can. The final trials await.")
            return
        end
        
        masterHolocrons = masterHolocrons + 1
        setPlayerVar(pCreature, "master_holocrons_used", masterHolocrons)
        
        sendForceMessage(pCreature, "Ancient wisdom pours into your mind. The path to Mastery becomes clearer. (" .. masterHolocrons .. "/" .. MASTER_HOLOCRONS_REQUIRED .. " holocrons absorbed)")
        
        SceneObject(pTarget):destroyObjectFromWorld()
        
        -- Check if all master conditions met
        local masterFsKills = getPlayerVar(pCreature, "master_fs_kills", 0)
        if masterHolocrons >= MASTER_HOLOCRONS_REQUIRED and masterFsKills >= MASTER_FS_KILLS_REQUIRED then
            sendForceMessage(pCreature, "You have proven yourself worthy. The power of a Master courses through you. Travel to your enclave to claim your destiny.")
            setPlayerVar(pCreature, "master_ready", 1)
        end
        
    else
        -- Already Master/Dark Lord or unrecognised state
        sendForceMessage(pCreature, "You have already transcended what this holocron can teach you.")
    end
end

-- ============================================================
-- SPEAK TO THE GATEKEEPER
-- Spawns Old Man NPC near the player to begin Padawan final test
-- ============================================================

function holocron_speak_to_gatekeeper(pCreature, pTarget, pGhost)
    local jediStatus = getJediStatus(pCreature)
    
    if jediStatus ~= "none" then
        sendForceMessage(pCreature, "You have already passed beyond this threshold.")
        return
    end
    
    local thresholdHit = getPlayerVar(pCreature, "jedi_threshold_hit", 0)
    if thresholdHit ~= 1 then
        -- Shouldn't be reachable via menu, but safety check
        sendForceMessage(pCreature, "You do not yet feel ready to meet the Gatekeeper.")
        return
    end
    
    local testDone = getPlayerVar(pCreature, "padawan_test_done", 0)
    if testDone == 1 then
        sendForceMessage(pCreature, "The Gatekeeper has already set your trial in motion. Complete your task.")
        return
    end
    
    -- Get player position for NPC spawn
    local pZone = CreatureObject(pCreature):getZone()
    if pZone == nil then
        CreatureObject(pCreature):sendSystemMessage("An error occurred. Please try again.")
        return
    end
    
    local x = CreatureObject(pCreature):getPositionX()
    local z = CreatureObject(pCreature):getPositionZ()
    local y = CreatureObject(pCreature):getPositionY()
    local zoneName = SceneObject(pZone):getZoneName()
    
    -- Spawn Old Man a few metres in front of player
    local spawnX = x + 3
    local spawnY = y
    local spawnZ = z
    
    local pOldMan = spawnMobile(zoneName, OLD_MAN_TEMPLATE, 0, spawnX, spawnZ, spawnY, 180, 0)
    
    if pOldMan == nil then
        CreatureObject(pCreature):sendSystemMessage("The Gatekeeper could not be reached. Try again in a moment.")
        return
    end
    
    -- Name the NPC
    SceneObject(pOldMan):setCustomObjectName("The Gatekeeper")
    
    -- Consume the holocron used to summon him
    SceneObject(pTarget):destroyObjectFromWorld()
    
    -- Mark test as initiated
    setPlayerVar(pCreature, "padawan_test_done", 1)
    
    -- Store Old Man object ID so conversation system can link back to player
    -- The conversation handler will take over from here
    setPlayerVar(pCreature, "gatekeeper_id", SceneObject(pOldMan):getObjectID())
    
    -- Trigger the Old Man to walk to player and initiate conversation
    -- The conversation screenplay will handle dialogue and Dark Jedi Knight spawn
    CreatureObject(pOldMan):setFollowObject(pCreature)
    
    sendForceMessage(pCreature, "The air shimmers. A weathered figure emerges from the shadows and approaches you...")
    
    -- Start the gatekeeper conversation via screenplay
    -- (see gatekeeper_conversation.lua)
    createEvent(2000, "gatekeeper_conversation", "beginConversation", pOldMan, tostring(SceneObject(pCreature):getObjectID()))
end

-- ============================================================
-- POINT AWARD FUNCTION
-- Called from other scripts (crafting, combat, etc.)
-- Usage: holocron_award_points(pCreature, points, source)
-- ============================================================

function holocron_award_points(pCreature, points, source)
    if pCreature == nil then return end
    
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    local jediStatus = getJediStatus(pCreature)
    
    -- ---- PADAWAN POINTS ----
    if jediStatus == "none" then
        local thresholdHit = getPlayerVar(pCreature, "jedi_threshold_hit", 0)
        if thresholdHit == 1 then return end -- already hit, no more needed
        
        local currentPoints = getPlayerVar(pCreature, "jedi_points", 0)
        currentPoints = currentPoints + points
        setPlayerVar(pCreature, "jedi_points", currentPoints)
        
        if currentPoints >= PADAWAN_THRESHOLD then
            setPlayerVar(pCreature, "jedi_threshold_hit", 1)
            setPlayerVar(pCreature, "last_atm_msg_pct", 0)
            sendForceMessage(pCreature, "Something profound shifts within you. You have absorbed all you can from these teachings for now. Seek further knowledge... speak to the Gatekeeper.")
        else
            checkAtmosphericMessages(pCreature, currentPoints, PADAWAN_THRESHOLD, ATMOSPHERIC_MESSAGES_PADAWAN)
        end
        
    -- ---- KNIGHT POINTS ----
    elseif jediStatus == "padawan" then
        local masteredTrees = countMasteredJediTrees(pCreature)
        if masteredTrees < 3 then return end -- not yet eligible
        
        local knightPoints = getPlayerVar(pCreature, "knight_points", 0)
        knightPoints = knightPoints + points
        setPlayerVar(pCreature, "knight_points", knightPoints)
        
        checkAtmosphericMessages(pCreature, knightPoints, KNIGHT_POINT_THRESHOLD, ATMOSPHERIC_MESSAGES_KNIGHT)
        
    -- ---- MASTER POINTS (FS kill tracking handled separately) ----
    elseif jediStatus == "knight" then
        -- Points don't matter as much for master, FS kills do
        -- But we still track for atmospheric messages
        local masterPoints = getPlayerVar(pCreature, "master_points", 0)
        masterPoints = masterPoints + points
        setPlayerVar(pCreature, "master_points", masterPoints)
    end
end

-- ============================================================
-- FS NPC KILL TRACKER
-- Called from creature death handlers
-- Usage: holocron_on_fs_kill(pCreature, pVictim)
-- ============================================================

function holocron_on_fs_kill(pCreature, pVictim)
    if pCreature == nil or pVictim == nil then return end
    
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    local jediStatus = getJediStatus(pCreature)
    
    if jediStatus == "padawan" then
        -- Knight path kill counter
        local masteredTrees = countMasteredJediTrees(pCreature)
        if masteredTrees < 3 then return end
        
        local kills = getPlayerVar(pCreature, "knight_fs_kills", 0)
        kills = kills + 1
        setPlayerVar(pCreature, "knight_fs_kills", kills)
        
        -- Milestone messages
        if kills == 50 then
            sendForceMessage(pCreature, "You have defeated " .. kills .. " Force-sensitive adversaries. Your power grows.")
        elseif kills == KNIGHT_FS_KILLS_REQUIRED then
            sendForceMessage(pCreature, "You have proven yourself in combat. You have defeated " .. kills .. " Force-sensitive foes.")
        end
        
        -- Check full Knight readiness
        local knightPoints = getPlayerVar(pCreature, "knight_points", 0)
        local knightHolocrons = getPlayerVar(pCreature, "knight_holocrons_used", 0)
        if knightPoints >= KNIGHT_POINT_THRESHOLD and knightHolocrons >= KNIGHT_HOLOCRONS_REQUIRED and kills >= KNIGHT_FS_KILLS_REQUIRED then
            local alreadyNotified = getPlayerVar(pCreature, "knight_ready", 0)
            if alreadyNotified ~= 1 then
                sendForceMessage(pCreature, "You feel the Force surging through you. You are ready for the Knight trials. Travel to your enclave.")
                setPlayerVar(pCreature, "knight_ready", 1)
            end
        end
        
    elseif jediStatus == "knight" then
        -- Master path kill counter
        local kills = getPlayerVar(pCreature, "master_fs_kills", 0)
        kills = kills + 1
        setPlayerVar(pCreature, "master_fs_kills", kills)
        
        -- Milestone messages every 500 kills
        if kills % 500 == 0 then
            sendForceMessage(pCreature, "You have vanquished " .. kills .. " Force-sensitive enemies. The path to Mastery is paved with their defeat. (" .. kills .. "/" .. MASTER_FS_KILLS_REQUIRED .. ")")
        elseif kills == MASTER_FS_KILLS_REQUIRED then
            sendForceMessage(pCreature, "You have proven your dominance over " .. kills .. " Force-sensitive adversaries. Check your master requirements.")
        end
        
        -- Check full Master readiness
        local masterHolocrons = getPlayerVar(pCreature, "master_holocrons_used", 0)
        if masterHolocrons >= MASTER_HOLOCRONS_REQUIRED and kills >= MASTER_FS_KILLS_REQUIRED then
            local alreadyNotified = getPlayerVar(pCreature, "master_ready", 0)
            if alreadyNotified ~= 1 then
                sendForceMessage(pCreature, "You have proven yourself worthy of the highest teachings. Travel to your enclave to claim your destiny.")
                setPlayerVar(pCreature, "master_ready", 1)
            end
        end
    end
end

-- ============================================================
-- GRANT PADAWAN STATUS
-- Called after Old Man test is completed
-- ============================================================

local FS_SKILL_POOL = {
    "force_sensitive_combat_prowess_novice",
    "force_sensitive_combat_prowess_master",
    "force_sensitive_combat_prowess_ranged_accuracy_01",
    "force_sensitive_combat_prowess_ranged_accuracy_02",
    "force_sensitive_combat_prowess_ranged_accuracy_03",
    "force_sensitive_combat_prowess_ranged_accuracy_04",
    "force_sensitive_combat_prowess_ranged_speed_01",
    "force_sensitive_combat_prowess_ranged_speed_02",
    "force_sensitive_combat_prowess_ranged_speed_03",
    "force_sensitive_combat_prowess_ranged_speed_04",
    "force_sensitive_combat_prowess_melee_accuracy_01",
    "force_sensitive_combat_prowess_melee_accuracy_02",
    "force_sensitive_combat_prowess_melee_accuracy_03",
    "force_sensitive_combat_prowess_melee_accuracy_04",
    "force_sensitive_combat_prowess_melee_speed_01",
    "force_sensitive_combat_prowess_melee_speed_02",
    "force_sensitive_combat_prowess_melee_speed_03",
    "force_sensitive_combat_prowess_melee_speed_04",
    "force_sensitive_enhanced_reflexes_novice",
    "force_sensitive_enhanced_reflexes_master",
    "force_sensitive_enhanced_reflexes_ranged_defense_01",
    "force_sensitive_enhanced_reflexes_ranged_defense_02",
    "force_sensitive_enhanced_reflexes_ranged_defense_03",
    "force_sensitive_enhanced_reflexes_ranged_defense_04",
    "force_sensitive_enhanced_reflexes_melee_defense_01",
    "force_sensitive_enhanced_reflexes_melee_defense_02",
    "force_sensitive_enhanced_reflexes_melee_defense_03",
    "force_sensitive_enhanced_reflexes_melee_defense_04",
    "force_sensitive_enhanced_reflexes_vehicle_control_01",
    "force_sensitive_enhanced_reflexes_vehicle_control_02",
    "force_sensitive_enhanced_reflexes_vehicle_control_03",
    "force_sensitive_enhanced_reflexes_vehicle_control_04",
    "force_sensitive_enhanced_reflexes_survival_01",
    "force_sensitive_enhanced_reflexes_survival_02",
    "force_sensitive_enhanced_reflexes_survival_03",
    "force_sensitive_enhanced_reflexes_survival_04",
    "force_sensitive_crafting_mastery_novice",
    "force_sensitive_crafting_mastery_master",
    "force_sensitive_crafting_mastery_experimentation_01",
    "force_sensitive_crafting_mastery_experimentation_02",
    "force_sensitive_crafting_mastery_experimentation_03",
    "force_sensitive_crafting_mastery_experimentation_04",
    "force_sensitive_crafting_mastery_assembly_01",
    "force_sensitive_crafting_mastery_assembly_02",
    "force_sensitive_crafting_mastery_assembly_03",
    "force_sensitive_crafting_mastery_assembly_04",
    "force_sensitive_crafting_mastery_repair_01",
    "force_sensitive_crafting_mastery_repair_02",
    "force_sensitive_crafting_mastery_repair_03",
    "force_sensitive_crafting_mastery_repair_04",
    "force_sensitive_crafting_mastery_technique_01",
    "force_sensitive_crafting_mastery_technique_02",
    "force_sensitive_crafting_mastery_technique_03",
    "force_sensitive_crafting_mastery_technique_04",
    "force_sensitive_heightened_senses_novice",
    "force_sensitive_heightened_senses_master",
    "force_sensitive_heightened_senses_healing_01",
    "force_sensitive_heightened_senses_healing_02",
    "force_sensitive_heightened_senses_healing_03",
    "force_sensitive_heightened_senses_healing_04",
    "force_sensitive_heightened_senses_surveying_01",
    "force_sensitive_heightened_senses_surveying_02",
    "force_sensitive_heightened_senses_surveying_03",
    "force_sensitive_heightened_senses_surveying_04",
    "force_sensitive_heightened_senses_persuasion_01",
    "force_sensitive_heightened_senses_persuasion_02",
    "force_sensitive_heightened_senses_persuasion_03",
    "force_sensitive_heightened_senses_persuasion_04",
    "force_sensitive_heightened_senses_luck_01",
    "force_sensitive_heightened_senses_luck_02",
    "force_sensitive_heightened_senses_luck_03",
    "force_sensitive_heightened_senses_luck_04",
}

function holocron_grant_padawan(pCreature)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    setPlayerVar(pCreature, "jedi_status", "padawan")
    setPlayerVar(pCreature, "last_atm_msg_pct", 0)

    -- Grant title skills — exact order from jedi_trials.lua
    if not CreatureObject(pCreature):hasSkill("force_title_jedi_rank_01") then
        awardSkill(pCreature, "force_title_jedi_rank_01")
    end
    awardSkill(pCreature, "force_title_jedi_rank_02")
    writeScreenPlayData(pCreature, "PadawanTrials", "completedTrials", 1)

    -- Play unlock effects before setJediState — exact order from jedi_trials.lua
    CreatureObject(pCreature):playEffect("clienteffect/trap_electric_01.cef", "")
    CreatureObject(pCreature):playMusicMessage("sound/music_become_jedi.snd")

    -- Set Jedi state AFTER skills — makes Force Progression tree visible
    PlayerObject(pGhost):setJediState(2)

    -- Give padawan robe
    local pInventory = SceneObject(pCreature):getSlottedObject("inventory")
    if pInventory == nil or SceneObject(pInventory):isContainerFullRecursive() then
        CreatureObject(pCreature):sendSystemMessage("@jedi_spam:inventory_full_jedi_robe")
    else
        local pInv2 = CreatureObject(pCreature):getSlottedObject("inventory")
        giveItem(pInv2, "object/tangible/wearables/robe/robe_jedi_padawan.iff", -1)
    end

    -- Send welcome mail
    sendMail("system", "@jedi_spam:welcome_subject", "@jedi_spam:welcome_body", CreatureObject(pCreature):getFirstName())

    -- Grant all Force Sensitive skills from the pool
    for i = 1, #FS_SKILL_POOL do
        if not CreatureObject(pCreature):hasSkill(FS_SKILL_POOL[i]) then
            awardSkill(pCreature, FS_SKILL_POOL[i])
        end
    end
end

function holocron_grant_knight(pCreature, alignment)
    -- alignment: "light" or "dark"
    if pCreature == nil then return end
    
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    setPlayerVar(pCreature, "jedi_status", "knight")
    setPlayerVar(pCreature, "jedi_alignment", alignment)
    setPlayerVar(pCreature, "last_atm_msg_pct", 0)
    
    if alignment == "light" then
        CreatureObject(pCreature):sendSystemMessage("\\#88CCFF You have proven yourself worthy. The Jedi Council recognises you as a Jedi Knight. May the Force be with you.")
    else
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 Your power is undeniable. The Dark Side welcomes you as a Dark Jedi Knight. Embrace your destiny.")
    end
end

-- ============================================================
-- GRANT MASTER STATUS
-- Called from enclave NPC after Master trial completion
-- ============================================================

function holocron_grant_master(pCreature)
    if pCreature == nil then return end
    
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    local alignment = getPlayerVar(pCreature, "jedi_alignment", "light")
    setPlayerVar(pCreature, "jedi_status", "master")
    
    if alignment == "light" then
        CreatureObject(pCreature):sendSystemMessage("\\#FFFFFF The Force flows through you in its fullness. You are a Jedi Master. The galaxy looks to you for guidance.")
    else
        CreatureObject(pCreature):sendSystemMessage("\\#AA00AA Your dominion over the Dark Side is complete. You are a Dark Lord. Bow to no one.")
    end
end

-- ============================================================
-- DEBUG / ADMIN QUERY
-- Usage: /checkjedi <playerName>  (called from admin command)
-- ============================================================

function holocron_debug_status(pCreature)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    local status        = getJediStatus(pCreature)
    local points        = getPlayerVar(pCreature, "jedi_points", 0)
    local threshHit     = getPlayerVar(pCreature, "jedi_threshold_hit", 0)
    local kPoints       = getPlayerVar(pCreature, "knight_points", 0)
    local kKills        = getPlayerVar(pCreature, "knight_fs_kills", 0)
    local kHolocrons    = getPlayerVar(pCreature, "knight_holocrons_used", 0)
    local mHolocrons    = getPlayerVar(pCreature, "master_holocrons_used", 0)
    local mKills        = getPlayerVar(pCreature, "master_fs_kills", 0)
    local masteredTrees = countMasteredJediTrees(pCreature)
    
    CreatureObject(pCreature):sendSystemMessage("=== JEDI STATUS DEBUG ===")
    CreatureObject(pCreature):sendSystemMessage("Status: " .. status)
    CreatureObject(pCreature):sendSystemMessage("Padawan Points: " .. points .. " / " .. PADAWAN_THRESHOLD .. (threshHit == 1 and " [HIT]" or ""))
    CreatureObject(pCreature):sendSystemMessage("Mastered Jedi Trees: " .. masteredTrees .. "/3")
    CreatureObject(pCreature):sendSystemMessage("Knight Points: " .. kPoints .. " / " .. KNIGHT_POINT_THRESHOLD)
    CreatureObject(pCreature):sendSystemMessage("Knight FS Kills: " .. kKills .. " / " .. KNIGHT_FS_KILLS_REQUIRED)
    CreatureObject(pCreature):sendSystemMessage("Knight Holocrons: " .. kHolocrons .. " / " .. KNIGHT_HOLOCRONS_REQUIRED)
    CreatureObject(pCreature):sendSystemMessage("Master Holocrons: " .. mHolocrons .. " / " .. MASTER_HOLOCRONS_REQUIRED)
    CreatureObject(pCreature):sendSystemMessage("Master FS Kills: " .. mKills .. " / " .. MASTER_FS_KILLS_REQUIRED)
    CreatureObject(pCreature):sendSystemMessage("=========================")
end
