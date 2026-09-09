--[[
    Custom Jedi Holocron Script
    Patched to hand Padawan unlock off to stock JediTrials instead of
    manually brute-forcing the entire FS skill tree.

    What this keeps:
      - 10 holocrons required for Padawan
      - False Sith / Gatekeeper trial
      - 50 Padawan-stage holocron studies for Knight
      - 150 Knight-stage holocron studies for Master-Novice eligibility

    What this changes:
      - Padawan completion now calls the stock SWGEmu JediTrials unlock path
      - No more manual 72-skill grant loop in holocron_grant_padawan()
--]]
-- Coded by BoosterSteel 19-03-2026


local function rsd(pCreature, key)
    local v = readScreenPlayData(pCreature, "HolocronJedi", key)
    if v == nil or v == "" then return "" end
    return v
end

local function wsd(pCreature, key, value)
    writeScreenPlayData(pCreature, "HolocronJedi", key, tostring(value))
end

local function sendForceMessage(pCreature, msg)
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFF" .. msg)
end

local POINTS_PER_HOLOCRON = 1000
local JEDI_STAGE_DELAY_SECONDS = 7 * 24 * 60 * 60
local JEDI_DISCOVERY_SKILL_BOXES = 36
local JEDI_DISCOVERY_HOLOCRON = "object/tangible/jedi/no_drop_jedi_holocron_light.iff"
local DISCOVERY_RECEIVED = "received"
local DISCOVERY_ACTIVATED = "activated"
local DISCOVERY_UNLOCKED = "studies_unlocked"
local PADAWAN_STUDIES_NEEDED = 10
local KNIGHT_STUDIES_NEEDED = 50
local MASTER_STUDIES_NEEDED = 150

-- Each rank has its own counter.  The one-time migration converts saves made
-- by the short-lived cumulative implementation without making players repeat
-- studies already completed during their current rank.
local function getTotalStudies(pCreature)
    local status = rsd(pCreature, "jedi_status")
    if rsd(pCreature, "stage_counter_migrated") ~= "1" then
        local cumulative = tonumber(rsd(pCreature, "holocron_studies_total"))
        if cumulative ~= nil then
            if status == "padawan" then
                wsd(pCreature, "knight_holocrons_used", math.max(0, cumulative - PADAWAN_STUDIES_NEEDED))
            elseif status == "knight" then
                wsd(pCreature, "master_holocrons_used", math.max(0, cumulative - KNIGHT_STUDIES_NEEDED))
            end
        end
        wsd(pCreature, "stage_counter_migrated", "1")
        wsd(pCreature, "holocron_studies_total", "")
    end

    if status == "padawan" then
        return tonumber(rsd(pCreature, "knight_holocrons_used")) or 0
    elseif status == "knight" then
        return tonumber(rsd(pCreature, "master_holocrons_used")) or 0
    end
    return tonumber(rsd(pCreature, "holocrons_used")) or 0
end

local function setTotalStudies(pCreature, total)
    total = math.max(0, tonumber(total) or 0)
    local status = rsd(pCreature, "jedi_status")
    if status == "padawan" then
        wsd(pCreature, "knight_holocrons_used", total)
    elseif status == "knight" then
        wsd(pCreature, "master_holocrons_used", total)
    else
        wsd(pCreature, "holocrons_used", total)
    end
end

local function ensureForceSensitiveSchematics(pCreature)
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    -- These are the two schematics granted by the Force-sensitive stage.
    -- Padawan must not receive any Generation One lightsaber schematics.
    PlayerObject(pGhost):addRewardedSchematic(
        "object/draft_schematic/weapon/lightsaber/lightsaber_training.iff", 2, -1, true)
    PlayerObject(pGhost):addRewardedSchematic(
        "object/draft_schematic/weapon/lightsaber/lightsaber_refined_crystal_pack.iff", 2, -1, true)
end

local function replaceEnclaveWaypoint(pCreature, alignment)
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    local oldID = tonumber(rsd(pCreature, "jedi_enclave_waypoint_id")) or 0
    if oldID > 0 then PlayerObject(pGhost):removeWaypoint(oldID, true) end
    local dark = alignment == "dark"
    local wpID = PlayerObject(pGhost):addWaypoint("yavin4",
        dark and "Dark Jedi Enclave" or "Light Jedi Enclave", "",
        dark and 5079 or -5575, 0, dark and 306 or 4910,
        WAYPOINTYELLOW, true, true, WAYPOINTQUESTTASK)
    wsd(pCreature, "jedi_enclave_waypoint_id", wpID or 0)
end

local function formatTrainingTime(remaining)
    remaining = math.max(0, math.ceil(tonumber(remaining) or 0))

    local days = math.floor(remaining / 86400)
    remaining = remaining % 86400
    local hours = math.floor(remaining / 3600)
    remaining = remaining % 3600
    local minutes = math.ceil(remaining / 60)

    if minutes == 60 then
        minutes = 0
        hours = hours + 1
    end
    if hours == 24 then
        hours = 0
        days = days + 1
    end

    return days .. " day(s), " .. hours .. " hour(s), and " .. minutes .. " minute(s)"
end

local function inventoryContainsTemplate(pCreature, templatePath)
    local pInventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if pInventory == nil then return false end

    local count = SceneObject(pInventory):getContainerObjectsSize()
    for i = 0, count - 1 do
        local pItem = SceneObject(pInventory):getContainerObject(i)
        if pItem ~= nil and SceneObject(pItem):getTemplateObjectPath() == templatePath then
            return true
        end
    end
    return false
end

local function hasAnySkill(pCreature, skills)
    for _, skillName in ipairs(skills) do
        if CreatureObject(pCreature):hasSkill(skillName) then return true end
    end
    return false
end

local function getDiscoveryProfession(pCreature)
    -- The order is intentional and makes hybrid characters deterministic.
    if hasAnySkill(pCreature, {
        "combat_medic_novice", "science_doctor_novice", "science_combatmedic_novice"
    }) then return "medic" end

    if hasAnySkill(pCreature, {
        "social_entertainer_novice", "social_dancer_novice", "social_musician_novice",
        "social_imagedesigner_novice"
    }) then return "entertainer" end

    if hasAnySkill(pCreature, {
        "crafting_artisan_novice", "crafting_weaponsmith_novice", "crafting_armorsmith_novice",
        "crafting_droidengineer_novice", "crafting_architect_novice", "crafting_chef_novice",
        "crafting_tailor_novice", "crafting_shipwright_novice"
    }) then return "artisan" end

    if hasAnySkill(pCreature, {
        "outdoors_scout_novice", "outdoors_ranger_novice", "outdoors_creaturehandler_novice"
    }) then return "scout" end

    return "combat"
end


local function showDiscoveryPopup(pPlayer)
    if pPlayer == nil then return end

    local category = getDiscoveryProfession(pPlayer)
    local messages = {
        entertainer = "You finish your performance and begin gathering your things when something unusual catches your eye among the evening's tips.\n\nIt isn't a credit chip.\n\nA small, unfamiliar object rests among your belongings, its surface strangely smooth and cold beneath your fingers.\n\nYou cannot remember seeing anyone leave it there.\n\nFor the briefest moment, you could swear something moved within it... a faint pulse of light that disappears almost as soon as you notice it.\n\nSomeone tipped you something far stranger than credits.",
        artisan = "While sorting through your materials, you notice something that doesn't belong.\n\nAt first you mistake it for an unusual piece of raw material, but the object is unlike anything recorded by your tools.\n\nIts surface is impossibly smooth, yet your instruments cannot identify its composition.\n\nWhen you pick it up, a faint light flickers somewhere deep inside.\n\nYou don't remember gathering it.\n\nWhatever it is, this is no ordinary resource.",
        medic = "While reorganising your medical supplies, your hand brushes against something that should not be there.\n\nHidden beneath the familiar instruments and medicine packs is a small object you have never seen before.\n\nIt is cool to the touch and bears markings you don't recognise.\n\nFor a moment, a faint light stirs beneath its surface.\n\nYou have no memory of placing it in your medical bag.\n\nWhatever this object is, it certainly isn't medical equipment.",
        scout = "While checking your equipment after another journey through the wilderness, you notice something caught among your gathered supplies.\n\nAt first you assume it is a stone or fragment collected while harvesting.\n\nIt isn't.\n\nThe small object is unnaturally smooth, untouched by dirt or weather, and marked with patterns you have never seen before.\n\nAs you brush the dust away, a faint light moves beneath its surface.\n\nFor all your experience tracking the things others overlook, you cannot explain where this came from.\n\nPerhaps this time, something was waiting to be found.",
        combat = "After the fighting is over, you begin checking your equipment and sorting through what was recovered from the battlefield.\n\nAmong the debris is something you don't recognise.\n\nA small object rests in your hand, untouched by the violence around it.\n\nThere are no maker's marks. No obvious controls. Nothing to suggest what purpose it serves.\n\nThen, for just an instant, light flickers from somewhere within.\n\nYou don't remember picking it up.\n\nYet somehow, it feels as though you were meant to find it."
    }

    local sui = SuiMessageBox.new("HolocronJedi", "emptyCallback")
    sui.setTitle("A Strange Discovery")
    sui.setPrompt(messages[category])
    sui.setOkButtonText("Examine it later")
    sui.setCancelButtonText("Close")
    sui.sendTo(pPlayer)
end

function holocron_progression_timer_ready(pCreature, timestampKey, stageName)
    if pCreature == nil then return false end

    if rsd(pCreature, "progression_timer_bypass_pending") == "1" then
        -- A bypass authorizes exactly one progression gate. Consume it here
        -- so an administrator must explicitly authorize every later stage.
        wsd(pCreature, "progression_timer_bypass_pending", "0")
        sendForceMessage(pCreature, "The administrator timer bypass has been consumed for this progression stage.")
        return true
    end

    local unlockedAt = tonumber(rsd(pCreature, timestampKey)) or 0
    if unlockedAt <= 0 then
        -- Existing characters predate the timer data. Start their seven-day
        -- clock the first time they attempt the next progression stage.
        unlockedAt = os.time()
        wsd(pCreature, timestampKey, unlockedAt)
    end

    local remaining = JEDI_STAGE_DELAY_SECONDS - (os.time() - unlockedAt)
    if remaining <= 0 then return true end

    sendForceMessage(pCreature, stageName .. " is not yet available. You must wait " ..
        formatTrainingTime(remaining) .. ".")
    return false
end

-- Shows the remaining training time without consuming an administrator
-- bypass. Returns true while the player must continue waiting.
function holocron_progression_training_notice(pCreature, timestampKey, stageName)
    if pCreature == nil then return false end

    if rsd(pCreature, "progression_timer_bypass_pending") == "1" then
        sendForceMessage(pCreature, "An administrator has authorized your next timed progression stage. Speak to the Gatekeeper when your studies are complete.")
        return false
    end

    local unlockedAt = tonumber(rsd(pCreature, timestampKey)) or 0
    if unlockedAt <= 0 then
        unlockedAt = os.time()
        wsd(pCreature, timestampKey, unlockedAt)
    end

    local remaining = JEDI_STAGE_DELAY_SECONDS - (os.time() - unlockedAt)
    if remaining <= 0 then
        sendForceMessage(pCreature, "Your seven-day training period for " .. stageName .. " is complete. Speak to the Gatekeeper when your studies are complete.")
        return false
    end

    sendForceMessage(pCreature, "You may continue studying holocrons, but you cannot begin " .. stageName ..
        " for another " .. formatTrainingTime(remaining) .. ".")
    return true
end

function holocron_award_points(pCreature, points, source)
    if pCreature == nil or points == nil or points <= 0 then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    local current = tonumber(readScreenPlayData(pCreature, "HolocronJedi", "jedi_points")) or 0
    local newTotal = current + points
    writeScreenPlayData(pCreature, "HolocronJedi", "jedi_points", tostring(newTotal))

    if math.floor(newTotal / 500) > math.floor(current / 500) then
        sendForceMessage(pCreature, "The Force stirs within you. (" .. newTotal .. " Force Points accumulated)")
    end
end

function holocron_on_fs_kill(pKiller, pVictim)
    if pKiller == nil then return end
    local bonus = 150
    holocron_award_points(pKiller, bonus, "fs_kill")
    sendForceMessage(pKiller, "You have bested a Force-sensitive opponent. The Force grows stronger in you.")
end

HolocronJedi = ScreenPlay:new {
    numberOfActs = 1,
}

-- Invoked by holocron observers/radials; it has no startup work.
registerScreenPlay("HolocronJedi", false)

function HolocronJedi:showDiscoveryPopup(pPlayer, params)
    if pPlayer == nil then return end
    -- Skill acquisition can fire several eligibility callbacks in the same
    -- frame. Only the first queued event may create a discovery window.
    if rsd(pPlayer, "jedi_discovery_popup_shown") == "1" then return end
    wsd(pPlayer, "jedi_discovery_popup_scheduled", "0")
    wsd(pPlayer, "jedi_discovery_popup_shown", "1")
    showDiscoveryPopup(pPlayer)
end

function HolocronJedi:onSkillLearned(pPlayer, skillName)
    self:checkDiscoveryEligibility(pPlayer)
end

function HolocronJedi:checkDiscoveryEligibility(pPlayer)
    if pPlayer == nil then return end
    if rsd(pPlayer, "jedi_holocron_studies_unlocked") == "1" then
        wsd(pPlayer, "jedi_discovery_state", DISCOVERY_UNLOCKED)
        return
    end

    local state = rsd(pPlayer, "jedi_discovery_state")
    if state == DISCOVERY_ACTIVATED then
        -- The item has already been consumed. Recreate only the encounter.
        createEvent(1000, "HolocronJedi", "beginDiscoveryEncounter", pPlayer, "")
        return
    end

    if state == DISCOVERY_RECEIVED or rsd(pPlayer, "jedi_holocron_discovery_occurred") == "1" then
        -- Compatibility for characters awarded by the earlier implementation.
        wsd(pPlayer, "jedi_discovery_state", DISCOVERY_RECEIVED)
        if inventoryContainsTemplate(pPlayer, JEDI_DISCOVERY_HOLOCRON) then
            if rsd(pPlayer, "jedi_discovery_popup_shown") ~= "1" and
                    rsd(pPlayer, "jedi_discovery_popup_scheduled") ~= "1" then
                -- Persist the scheduling guard before creating the delayed
                -- event so simultaneous skill callbacks cannot queue copies.
                wsd(pPlayer, "jedi_discovery_popup_scheduled", "1")
                createEvent(250, "HolocronJedi", "showDiscoveryPopup", pPlayer, "")
            end
            return
        end
        -- Restore a missing unactivated personal item, but never award a
        -- second copy while one exists.
    end

    local learned = CreatureObject(pPlayer):getLearnedProfessionSkillBoxCount()
    if learned < JEDI_DISCOVERY_SKILL_BOXES then return end

    local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
    if pInventory == nil or SceneObject(pInventory):isContainerFullRecursive() then
        sendForceMessage(pPlayer, "You sense that something is trying to reach you, but your inventory is full.")
        return
    end

    local pHolocron = nil
    if not inventoryContainsTemplate(pPlayer, JEDI_DISCOVERY_HOLOCRON) then
        pHolocron = giveItem(pInventory, JEDI_DISCOVERY_HOLOCRON, -1, true)
        if pHolocron == nil then
            sendForceMessage(pPlayer, "A strange presence brushes your thoughts. Make room in your inventory and log in again.")
            return
        end
    end

    wsd(pPlayer, "jedi_holocron_discovery_occurred", "1")
    wsd(pPlayer, "jedi_discovery_state", DISCOVERY_RECEIVED)
    if rsd(pPlayer, "jedi_discovery_popup_shown") ~= "1" and
            rsd(pPlayer, "jedi_discovery_popup_scheduled") ~= "1" then
        wsd(pPlayer, "jedi_discovery_popup_scheduled", "1")
        createEvent(250, "HolocronJedi", "showDiscoveryPopup", pPlayer, "")
    end
end

function HolocronJedi:beginDiscoveryEncounter(pPlayer, params)
    if pPlayer == nil or rsd(pPlayer, "jedi_holocron_studies_unlocked") == "1" then return end
    if rsd(pPlayer, "jedi_discovery_state") ~= DISCOVERY_ACTIVATED then return end

    local existingID = tonumber(rsd(pPlayer, "discovery_npc_id")) or 0
    local pExisting = existingID > 0 and getSceneObject(existingID) or nil
    if pExisting ~= nil and SceneObject(pExisting):getCustomObjectName() == "A Wandering Scholar" and
            SceneObject(pExisting):getZoneName() == SceneObject(pPlayer):getZoneName() and
            SceneObject(pPlayer):isInRangeWithObject(pExisting, 30) then
        spatialChat(pExisting, "You still have questions. Speak with me when you are ready.")
        return
    end

    if pExisting ~= nil then
        SceneObject(pExisting):destroyObjectFromWorld()
        SceneObject(pExisting):destroyObjectFromDatabase(true)
    end

    -- Runtime scene IDs can become stale after a restart.  Never let an old
    -- saved ID prevent the encounter from being created again.
    wsd(pPlayer, "discovery_npc_id", "0")

    local zone = SceneObject(pPlayer):getZoneName()
    if zone == nil or zone == "" then return end

    local cellID = CreatureObject(pPlayer):getParentID()
    local x
    local y
    local z

    if cellID ~= 0 then
        -- spawnMobile uses cell-local coordinates for an indoor spawn.
        x = SceneObject(pPlayer):getPositionX() + 2
        y = SceneObject(pPlayer):getPositionY() + 1
        z = SceneObject(pPlayer):getPositionZ()
    else
        x = SceneObject(pPlayer):getWorldPositionX() + 3
        y = SceneObject(pPlayer):getWorldPositionY() + 2
        z = getWorldFloor(x, y, zone)
    end

    local pNpc = spawnMobile(zone, "holocron_discovery_scholar", 0, x, z, y, 180, cellID)
    if pNpc == nil then
        sendForceMessage(pPlayer, "The presence fades before revealing itself. Log out and return to resume the encounter.")
        return
    end

    SceneObject(pNpc):setCustomObjectName("A Wandering Scholar")
	CreatureObject(pNpc):setPvpStatusBitmask(0)
	CreatureObject(pNpc):clearOptionBit(AIENABLED)
	AiAgent(pNpc):addObjectFlag(AI_STATIC)
    wsd(pPlayer, "discovery_npc_id", SceneObject(pNpc):getObjectID())
    spatialChat(pNpc, "You there. Yes, you. That object you're carrying... where did you find it?")
    createEvent(300000, "HolocronJedi", "despawnDiscoveryNpc", pPlayer, "")
end

function HolocronJedi:despawnDiscoveryNpc(pPlayer, params)
    if pPlayer == nil then return end
    local npcID = tonumber(rsd(pPlayer, "discovery_npc_id")) or 0
    local pNpc = npcID > 0 and getSceneObject(npcID) or nil
    if pNpc ~= nil then
        SceneObject(pNpc):destroyObjectFromWorld()
        SceneObject(pNpc):destroyObjectFromDatabase(true)
    end
    wsd(pPlayer, "discovery_npc_id", "0")
end

function HolocronJedi:bypassProgressionTimers(pCreature)
    if pCreature == nil then return end
    if rsd(pCreature, "progression_timer_bypass_pending") == "1" then
        sendForceMessage(pCreature, "This character already has one pending timer bypass. It cannot be stacked.")
        return
    end

    wsd(pCreature, "progression_timer_bypass_pending", "1")
    sendForceMessage(pCreature, "One Jedi progression waiting period may now be bypassed. This authorization is consumed at the next timed stage.")
end

-- ============================================================
-- FIRST HOLOCRON PICKUP — One-time lore SUI
-- Fires via onPickUp observer registered on the holocron object.
-- Screenplay state "HolocronFirstSeen" tracks whether the player
-- has already seen the popup so it only ever shows once.
-- ============================================================

function HolocronJedi:onPickUp(pPlayer, pHolocron)
    if pPlayer == nil then return end

    -- Only fire once per player lifetime
    if CreatureObject(pPlayer):getScreenPlayState("HolocronFirstSeen") == 1 then return end
    CreatureObject(pPlayer):setScreenPlayState(1, "HolocronFirstSeen")

    -- Delay slightly so the item is fully in inventory before the SUI fires
    createEvent(1500, "HolocronJedi", "showFirstHolocronSUI", pPlayer, "")
end

function HolocronJedi:showFirstHolocronSUI(pPlayer, params)
    if pPlayer == nil then return end

    local name = CreatureObject(pPlayer):getFirstName()

    local sui = SuiMessageBox.new("HolocronJedi", "emptyCallback")
    sui.setTitle("A Voice in the Force")
    sui.setPrompt(
        name .. "...\n\n" ..
        "You feel it before you see it - a warmth that does not come from the sun. " ..
        "A presence, ancient and vast, pressing gently at the edges of your mind.\n\n" ..
        "The object in your hands hums with a faint resonance, as though it recognises you. " ..
        "As though it has been waiting.\n\n" ..
        "A voice - not quite sound, not quite thought - drifts through the stillness.\n\n" ..
        "\\#AADDFF\"There is more to you than you know. Study this. Listen. The Force does not whisper to those it does not intend to guide.\"\n\n" ..
        "\\#FFFFFFThe feeling fades. But something has shifted. Right-click the holocron and select Study to begin."
    )
    sui.setOkButtonText("I understand")
    sui.setCancelButtonText("Close")
    sui.sendTo(pPlayer)
end

function HolocronJedi:finishKnightGrant(pPlayer, params)
    if pPlayer == nil then return end
    -- Knight unlock now completes directly in Lua via JediTrials:unlockJediKnight.
    -- This callback is left as a safe no-op for compatibility with any old queued events.
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") then
        return
    end
end

function HolocronJedi:emptyCallback(pPlayer, pSui, eventIndex, ...)
    -- intentionally empty - used for info-only SUI popups
end

function holocron_dev_start_hunters(pCreature, pTarget)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Starting Jedi hunter system...")
    JediHunters:startHunting(pCreature)
end

function holocron_dev_start_bh_hunters(pCreature, pTarget)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Starting bounty hunter system...")
    JediVisibilityHunters:startBountyHunting(pCreature)
end

function holocron_dev_stop_hunters(pCreature, pTarget)
    if pCreature == nil then return end
    JediHunters:stopHunting(pCreature)
    JediVisibilityHunters:stopBountyHunting(pCreature)
    CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] All hunters stopped.")
end

function holocron_dev_add_50_holocrons(pCreature, pTarget)
    if pCreature == nil then return end

    local status = readScreenPlayData(pCreature, "HolocronJedi", "jedi_status")
    if status == nil then status = "" end
    local total = getTotalStudies(pCreature)

    if status == "" or status == "none" then
        local newVal = math.min(total + 50, PADAWAN_STUDIES_NEEDED)
        setTotalStudies(pCreature, newVal)
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Padawan holocrons set to " .. newVal .. "/10")

    elseif status == "padawan" then
        local newVal = math.min(total + 50, KNIGHT_STUDIES_NEEDED)
        setTotalStudies(pCreature, newVal)
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Knight holocrons set to " .. newVal .. "/50")
        if newVal >= 50 then
            createEvent(500, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        end

    elseif status == "knight" then
        local newVal = math.min(total + 50, MASTER_STUDIES_NEEDED)
        setTotalStudies(pCreature, newVal)
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Master holocrons set to " .. newVal .. "/150")
        if newVal >= 150 then
            createEvent(500, "HolocronJedi", "showMasterUnlockPopup", pCreature, "")
        end

    else
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Status is '" .. status .. "' - no holocron counter to advance.")
    end
end

function HolocronJedi:searcherAttack(pSearcher, params)
    if pSearcher == nil then return end
    local sep = string.find(params, "|")
    if sep == nil then return end
    local playerID = tonumber(string.sub(params, 1, sep - 1))
    local dialogue = string.sub(params, sep + 1)
    local pTarget = getSceneObject(playerID)
    if pTarget ~= nil then
        -- CreatureObject:say was removed from the current Lua API.
        spatialChat(pSearcher, dialogue)
        AiAgent(pSearcher):setDefender(pTarget)
    end
end

function holocron_use_for_studies(pCreature, pTarget)
    if pCreature == nil then return end

    local status = rsd(pCreature, "jedi_status")
    local totalStudies = getTotalStudies(pCreature)

    if status == "" or status == "none" then
        local used = totalStudies

        if used >= 10 then
            sendForceMessage(pCreature, "You have absorbed all you can from these teachings. Seek the Gatekeeper.")
            return
        end

        used = used + 1
        setTotalStudies(pCreature, used)
        SceneObject(pTarget):destroyObjectFromWorld()

        local searcherLines = {
            [1]  = "My master requires that artifact! Hand it over or die!",
            [2]  = "You dabble with forces you do not understand. Surrender the holocron!",
            [3]  = "The dark side stirs within you... my master has taken notice.",
            [4]  = "You grow bolder. My master grows impatient. This ends now!",
            [5]  = "I can feel the Force awakening in you. That makes you dangerous - and dead.",
            [6]  = "Half way there, fool. You will never reach the Gatekeeper.",
            [7]  = "My master says you are closer than any before you. He also says you must be destroyed.",
            [8]  = "You persist. Impressive. Futile, but impressive.",
            [9]  = "One more and you reach him. I cannot allow that!",
            [10] = "You have done it... but my master sends one final hunter. Do not think you are safe yet.",
        }

        if used < 10 then
            sendForceMessage(pCreature, "You study the holocron carefully. Ancient knowledge flows through you. (" .. used .. "/10)")
            if used == 3 then
                sendForceMessage(pCreature, "Dreams of distant stars and ancient voices have begun to trouble your sleep.")
            elseif used == 6 then
                sendForceMessage(pCreature, "A strange energy courses through you. You cannot explain it.")
            elseif used == 9 then
                sendForceMessage(pCreature, "You feel as though you stand on the precipice of something vast and unknowable.")
            end
        else
            sendForceMessage(pCreature, "You study the holocron carefully. Ancient knowledge flows through you. (10/10)")
            sendForceMessage(pCreature, "Something profound shifts within you. You have absorbed all you can for now. Seek the Gatekeeper.")
        end

        local zoneName = SceneObject(pCreature):getZoneName()
        if zoneName ~= nil and zoneName ~= "" then
            local px = SceneObject(pCreature):getWorldPositionX()
            local py = SceneObject(pCreature):getWorldPositionY()
            local dialogue = searcherLines[used] or "You will not reach the Gatekeeper!"

            local sx = px + 20
            local sy = py
            local sz = SceneObject(pCreature):getWorldPositionZ()

            local pSearcher = spawnMobile(zoneName, "force_trained_archaist", 0, sx, sz, sy, 180, 0)
            if pSearcher ~= nil then
                SceneObject(pSearcher):setCustomObjectName("Dark Side Artifact Searcher")
                createEvent(1500, "HolocronJedi", "searcherAttack", pSearcher,
                    tostring(SceneObject(pCreature):getObjectID()) .. "|" .. dialogue)
            end
        end

    elseif status == "padawan" then
        local knightUsed = totalStudies

        if knightUsed >= 50 then
            sendForceMessage(pCreature, "You have meditated upon enough holocrons. The Gatekeeper senses your growing power. Seek them out.")
            return
        end

        knightUsed = knightUsed + 1
        setTotalStudies(pCreature, knightUsed)
        SceneObject(pTarget):destroyObjectFromWorld()
        sendForceMessage(pCreature, "You meditate upon the holocron. Its secrets deepen your connection to the Force. (" .. knightUsed .. "/50 holocrons absorbed)")

        if knightUsed == 50 then
            sendForceMessage(pCreature, "Your studies are complete. The Gatekeeper has more to say. Speak to them when you are ready.")


            local alignment = rsd(pCreature, "jedi_alignment")
            if alignment == "dark" then
                replaceEnclaveWaypoint(pCreature, "dark")
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The dark side has tested your resolve and found you worthy.\n\nThe time has come to face the trials of Dark Knighthood. Speak to the Gatekeeper again when you are ready."
                sendMail("The Force", "The Path to Dark Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            elseif alignment == "light" then
                -- Light alignment already chosen
                replaceEnclaveWaypoint(pCreature, "light")
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The Force has tested your patience and found you worthy.\n\nThe time has come to face the trials of Knighthood. Speak to the Gatekeeper again when you are ready."
                sendMail("The Force", "The Path to Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            else
                -- The Gatekeeper's moral assessment chooses one path later.
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The Force has found you ready.\n\nThe time has come to face the trials of Knighthood. Speak to the Gatekeeper again when you are ready to choose your path."
                sendMail("The Force", "The Path to Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            end

            -- SUI popup notification
            createEvent(2000, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        end

    elseif status == "knight" then
        local masterUsed = totalStudies

        if masterUsed >= 150 then
            sendForceMessage(pCreature, "You have absorbed all the holocron teachings you can. The Gatekeeper awaits.")
            return
        end

        masterUsed = masterUsed + 1
        setTotalStudies(pCreature, masterUsed)
        SceneObject(pTarget):destroyObjectFromWorld()
        sendForceMessage(pCreature, "Ancient wisdom pours into your mind. (" .. masterUsed .. "/150 holocrons absorbed)")

        if masterUsed == 150 then
            sendForceMessage(pCreature, "You have absorbed the final teachings. The Gatekeeper awaits you one last time. Seek them out.")

            local alignment = rsd(pCreature, "jedi_alignment")
            replaceEnclaveWaypoint(pCreature, alignment)

            local enclaveName = (alignment == "dark") and "Dark Jedi Enclave" or "Light Jedi Enclave"
            local enclaveCoords = (alignment == "dark") and "5079, 306" or "-5575, 4910"
            local mailBody = "One hundred and fifty holocrons. You have meditated upon every fragment of ancient wisdom available to you. The Force has been your constant companion through all of it.\n\nThe time has come to face the final trials - those of the Jedi Master.\n\nSpeak to the Gatekeeper again. They will show you the way forward.\n\nFew reach this moment. Fewer still survive what comes next.\n\nMay the Force guide your final steps."
            sendMail("The Force", "The Path to Mastery", mailBody, CreatureObject(pCreature):getFirstName())

            -- SUI popup notification
            createEvent(2000, "HolocronJedi", "showMasterUnlockPopup", pCreature, "")
        end

    else
        sendForceMessage(pCreature, "You have already transcended what this holocron can teach you.")
    end
end

-- Single entry point used by the active Jedi manager when a player selects
-- Use on a holocron. Before a stage threshold it consumes/studies the item;
-- at the threshold it contacts the Gatekeeper without consuming another one.
function holocron_use_custom(pCreature, pTarget)
    if pCreature == nil or pTarget == nil then return end

    local templatePath = SceneObject(pTarget):getTemplateObjectPath()
    if templatePath == JEDI_DISCOVERY_HOLOCRON then
        if rsd(pCreature, "jedi_holocron_studies_unlocked") == "1" then
            sendForceMessage(pCreature, "This damaged holocron has already revealed the path it held for you.")
            return
        end

        if rsd(pCreature, "jedi_discovery_state") == DISCOVERY_ACTIVATED then
            sendForceMessage(pCreature, "The damaged holocron has already awakened. The nearby presence can still be found.")
            HolocronJedi:beginDiscoveryEncounter(pCreature, "")
            return
        end

        local pInventory = CreatureObject(pCreature):getSlottedObject("inventory")
        if pInventory == nil or SceneObject(pTarget):getParentID() ~= SceneObject(pInventory):getObjectID() then
            sendForceMessage(pCreature, "You must carry the strange object in your inventory before attempting to activate it.")
            return
        end

        if rsd(pCreature, "jedi_discovery_state") ~= DISCOVERY_RECEIVED then
            sendForceMessage(pCreature, "The strange object remains silent.")
            return
        end

        -- Persist activation before consuming the one-time item. If the
        -- process stops after this write, login recovery recreates the NPC.
        wsd(pCreature, "jedi_discovery_state", DISCOVERY_ACTIVATED)
        wsd(pCreature, "jedi_holocron_discovery_activated", "1")

        CreatureObject(pCreature):sendSystemMessage("You turn the strange object slowly in your hands.\n\nFor several moments, nothing happens. Then the object responds. Lines of pale light race across its surface, forming patterns you cannot understand. A low vibration passes through your hands.\n\nAnd then you hear something. Not a voice. Not quite. More like a whisper remembered from a dream.\n\nSomewhere nearby... you suddenly feel that you are no longer alone.")

        SceneObject(pTarget):destroyObjectFromWorld()
        SceneObject(pTarget):destroyObjectFromDatabase(true)
        createEvent(750, "HolocronJedi", "beginDiscoveryEncounter", pCreature, "")
        return
    end

    if rsd(pCreature, "jedi_holocron_studies_unlocked") ~= "1" then
        CreatureObject(pCreature):sendSystemMessage("You examine the ancient device.\n\nIts markings are unfamiliar, and whatever purpose it once served remains hidden from you.\n\nFor a moment you think you feel something stirring beneath its surface...\n\nThen it is silent.")
        return
    end

    local status = rsd(pCreature, "jedi_status")
    local shouldContactGatekeeper = false
    local trainingPeriodActive = false

    if status == "" or status == "none" then
        shouldContactGatekeeper = getTotalStudies(pCreature) >= PADAWAN_STUDIES_NEEDED
    elseif status == "padawan" then
        trainingPeriodActive = holocron_progression_training_notice(
            pCreature, "padawan_unlocked_at", "the Jedi Knight Trials")
        shouldContactGatekeeper = getTotalStudies(pCreature) >= KNIGHT_STUDIES_NEEDED
    elseif status == "knight" then
        trainingPeriodActive = holocron_progression_training_notice(
            pCreature, "knight_unlocked_at", "the Grand Jedi Master or Dark Jedi Lord trials")
        shouldContactGatekeeper = getTotalStudies(pCreature) >= MASTER_STUDIES_NEEDED
    elseif status == "master_novice" or status == "master_phase2" then
        trainingPeriodActive = holocron_progression_training_notice(
            pCreature, "master_novice_unlocked_at", "the final Grand Jedi Master or Dark Jedi Lord trial")
        shouldContactGatekeeper = (status == "master_phase2")
    elseif status == "master" then
        shouldContactGatekeeper = true
    end

    if shouldContactGatekeeper and not trainingPeriodActive then
        holocron_speak_to_gatekeeper(pCreature, pTarget)
    else
        holocron_use_for_studies(pCreature, pTarget)
    end
end

function holocron_speak_to_gatekeeper(pCreature, pTarget)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local knightUsed = getTotalStudies(pCreature)

    -- Knight trial - Padawan with 50+ holocrons
    if status == "padawan" and knightUsed >= 50 then
        holocron_begin_knight_trial(pCreature, pTarget)
        return
    end

    -- Knight who has used 150 master holocrons - begin master trial phase 1
    if status == "knight" then
        local masterUsed = getTotalStudies(pCreature)
        if masterUsed >= 150 then
            holocron_begin_master_trial(pCreature, pTarget)
            return
        else
            sendForceMessage(pCreature, "You have more to learn. Meditate upon holocrons. (" .. masterUsed .. "/150 absorbed)")
            return
        end
    end

    -- Master who has trained the full tree - begin master trial phase 3
    if status == "master_phase2" then
        -- Player must have trained through box 10 of their master tree
        local hasFullTree = CreatureObject(pCreature):hasSkill("jedi_grand_master_10") or
                            CreatureObject(pCreature):hasSkill("jedi_dark_lord_10")
        if hasFullTree then
            holocron_begin_master_trial_final(pCreature, pTarget)
        else
            sendForceMessage(pCreature, "You must first train all ten ranks of your Master discipline at the enclave before facing this trial.")
        end
        return
    end

    -- Already a full master
    if status == "master" then
        sendForceMessage(pCreature, "You have already transcended what this holocron can teach you.")
        return
    end

    local used = tonumber(rsd(pCreature, "holocrons_used")) or 0
    if used < 10 then
        sendForceMessage(pCreature, "You do not yet feel ready to meet the Gatekeeper. Study more holocrons. (" .. used .. "/10)")
        return
    end

    local testDone = rsd(pCreature, "padawan_test_done")
    if testDone == "1" then
        local testActive = rsd(pCreature, "padawan_test_active")
        local mobID = tonumber(rsd(pCreature, "trial_djk_id")) or 0
        local mobAlive = mobID ~= 0 and getSceneObject(mobID) ~= nil

        if testActive == "1" and mobAlive then
            sendForceMessage(pCreature, "Your trial is already underway. Find and destroy the false one.")
            return
        elseif testActive == "1" and not mobAlive then
            local pGhost = CreatureObject(pCreature):getPlayerObject()
            if pGhost ~= nil then
                GatekeeperConversation:trialSuccess(pCreature, pGhost)
            end
            return
        else
            wsd(pCreature, "padawan_test_done", "0")
            wsd(pCreature, "padawan_mob_spawned", "0")
        end
    end

    wsd(pCreature, "gatekeeper_conversation_ready", "padawan_trial")

    local pGatekeeper = GatekeeperConversation:summonForTrial(pCreature)
    if pGatekeeper == nil then
        wsd(pCreature, "gatekeeper_conversation_ready", "")
        return
    end

    sendForceMessage(pCreature, "The air around you grows still. The Gatekeeper has appeared nearby. Speak with the apparition to continue your path.")
end

function HolocronJedi:gkSpeakPart2(pCreature, params)
    if pCreature == nil then return end
    gatekeeperSpatialSay(pCreature, "You have listened to the voices of those who came before you.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart3", pCreature, "")
end

function HolocronJedi:gkSpeakPart3(pCreature, params)
    if pCreature == nil then return end
    gatekeeperSpatialSay(pCreature, "You have gathered knowledge... but knowledge alone does not make one worthy of the Force.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart4", pCreature, "")
end

function HolocronJedi:gkSpeakPart4(pCreature, params)
    if pCreature == nil then return end
    gatekeeperSpatialSay(pCreature, "Until now, you have been a seeker. That must change.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart5", pCreature, "")
end

function HolocronJedi:gkSpeakPart5(pCreature, params)
    if pCreature == nil then return end
    gatekeeperSpatialSay(pCreature, "Remember this... the Force will not measure the strength of your weapon. It will measure you.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart6", pCreature, "")
end

function HolocronJedi:gkSpeakPart6(pCreature, params)
    if pCreature == nil then return end
    gatekeeperSpatialSay(pCreature, "Very well. Face the dark presence that has answered your awakening. Your waypoint will reveal where it waits.")

    local firstName = CreatureObject(pCreature):getFirstName()
    sendMail("The Gatekeeper", "Your Trial Awaits",
        "Seeker,\n\n" ..
        "You have studied enough. The Force stirs within you - but knowledge alone does not make a Jedi.\n\n" ..
        "A dark presence has been drawn to your awakening. This False Sith waits nearby. A waypoint has been placed in your datapad marking its location.\n\n" ..
        "Find it. Destroy it. Only then will you have proven yourself worthy of the title of Padawan.\n\n" ..
        "Do not hesitate. Do not fail.\n\n" ..
        "- The Gatekeeper",
        firstName)

    createEvent(2000, "GatekeeperConversation", "spawnTrialMob", pCreature, "")
end


-- ============================================================
-- KNIGHT UNLOCK POPUP
-- ============================================================

function HolocronJedi:showKnightUnlockPopup(pCreature, params)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    local name = CreatureObject(pCreature):getFirstName()

    local sui = SuiMessageBox.new("HolocronJedi", "emptyCallback")
    sui.setTitle("The Gatekeeper Stirs")
    sui.setPrompt(name .. ", you have absorbed the wisdom of fifty holocrons.\n\nThe Force has judged you ready for the trials of Knighthood.\n\nSpeak to the Gatekeeper again. A new path awaits you.")
    sui.setOkButtonText("Understood")
    sui.setCancelButtonText("Close")
    sui.sendTo(pCreature)
end

-- ============================================================
-- MASTER UNLOCK POPUP
-- ============================================================

function HolocronJedi:showMasterUnlockPopup(pCreature, params)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    local name = CreatureObject(pCreature):getFirstName()

    local sui = SuiMessageBox.new("HolocronJedi", "emptyCallback")
    sui.setTitle("The Gatekeeper Stirs")
    sui.setPrompt(name .. ", one hundred and fifty holocrons. You have absorbed every teaching available to you.\n\nThe Force has found you worthy of the final trials.\n\nSpeak to the Gatekeeper again. The last path awaits you.")
    sui.setOkButtonText("Understood")
    sui.setCancelButtonText("Close")
    sui.sendTo(pCreature)
end

-- ============================================================
-- LOGIN REMINDER
-- Shows popup if player has unlocked knight or master trials
-- but hasn't completed them yet.
-- Called from JediTrials:onPlayerLoggedIn via jedi_trials.lua
-- ============================================================

function HolocronJedi:onPlayerLoggedIn(pCreature)
    if pCreature == nil then return end

    -- Delayed events do not survive a disconnect. Release a stale scheduling
    -- guard so login recovery can deliver the one popup if it never appeared.
    if rsd(pCreature, "jedi_discovery_popup_shown") ~= "1" then
        wsd(pCreature, "jedi_discovery_popup_scheduled", "0")
    end
    self:checkDiscoveryEligibility(pCreature)
    -- Run the one-time cumulative-to-stage counter migration.
    getTotalStudies(pCreature)

    local status    = rsd(pCreature, "jedi_status")
    local alignment = rsd(pCreature, "jedi_alignment")
    if status == nil then return end

    if CreatureObject(pCreature):hasSkill("force_title_jedi_novice") or
            CreatureObject(pCreature):hasSkill("force_title_jedi_rank_01") or
            CreatureObject(pCreature):hasSkill("force_title_jedi_rank_02") then
        ensureForceSensitiveSchematics(pCreature)
    end

    if status == "padawan" or status == "knight" then
        replaceEnclaveWaypoint(pCreature, alignment)
    end

    local knightUsed = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0
    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0

    -- Knight reminder: padawan who has hit 50 holocrons
    if status == "padawan" and knightUsed >= 50 then
        createEvent(5000, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        return
    end

    -- Advanced-path reminder: knight who has hit the 150-study milestone.
    if status == "knight" and masterUsed >= 150 then
        createEvent(5000, "HolocronJedi", "showMasterUnlockPopup", pCreature, "")
        return
    end
end

function holocron_begin_knight_trial(pCreature, pTarget)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local knightUsed = getTotalStudies(pCreature)
    local alignment  = rsd(pCreature, "jedi_alignment")

    -- Eligibility checks
    if status ~= "padawan" then
        if status == "knight" or status == "master" then
            CreatureObject(pCreature):sendSystemMessage("\\#88CCFF You have already achieved the rank of Knight. There is nothing more the trial can offer you.")
        else
            CreatureObject(pCreature):sendSystemMessage("\\#888888 You must first become a Jedi Padawan before seeking the trials of Knighthood.")
        end
        return
    end

    if knightUsed < 50 then
        CreatureObject(pCreature):sendSystemMessage("\\#888888 You have studied " .. knightUsed .. "/50 holocrons. " .. (50 - knightUsed) .. " more are required before you may attempt the trial.")
        return
    end

    if not holocron_progression_timer_ready(pCreature, "padawan_unlocked_at", "The Knight trials") then
        return
    end

    -- Check if trial is already running
    local id = SceneObject(pCreature):getObjectID()
    local wave = readData("LightKnightTrial:" .. id .. ":wave") or readData("DarkKnightTrial:" .. id .. ":wave")
    if wave ~= nil and wave > 0 then
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 Your trial is already underway. Seek your opponent.")
        return
    end

    if rsd(pCreature, "jedi_alignment_locked") == "1" then
        local locked = rsd(pCreature, "jedi_alignment")
        if locked == "light" or locked == "dark" then
            replaceEnclaveWaypoint(pCreature, locked)
            local sui = SuiMessageBox.new("HolocronJedi", locked == "light" and "onKnightTrialConfirmLight" or "onKnightTrialConfirmDark")
            sui.setTitle(locked == "light" and "Begin the Jedi Knight Trial" or "Begin the Dark Jedi Knight Trial")
            sui.setPrompt("Your path is already chosen. Four opponents await. Are you prepared to begin?")
            sui.setOkButtonText("I am ready")
            sui.setCancelButtonText("Not yet")
            sui.sendTo(pCreature)
            return
        end
    end

    wsd(pCreature, "knight_moral_score", "0")
    wsd(pCreature, "knight_moral_question", "1")
    HolocronJedi:showKnightMoralQuestion(pCreature, 1)
end

local KNIGHT_MORAL_QUESTIONS = {
    {"A defeated enemy lies helpless before you. What decides their fate?", "Mercy. Justice must never become vengeance.", "Power. An enemy spared may rise against me."},
    {"A settlement refuses your protection and insults your order. How do you answer?", "I protect them anyway; service is not payment for praise.", "I leave them to learn the price of defiance."},
    {"Forbidden knowledge promises the strength to save someone you love. What do you do?", "Refuse it. Fear cannot be allowed to choose my path.", "Claim it. Power is a tool, and I will decide how it is used."},
    {"Your closest ally betrays you but later asks forgiveness. What matters most?", "Truth, accountability, and the possibility of redemption.", "The betrayal. Trust broken must be answered with strength."}
}

function HolocronJedi:showKnightMoralQuestion(pPlayer, question)
    local q = KNIGHT_MORAL_QUESTIONS[question]
    if pPlayer == nil or q == nil then return end
    local sui = SuiMessageBox.new("HolocronJedi", "onKnightMoralAnswer")
    sui.setTitle("The Gatekeeper's Question " .. question .. " of 4")
    sui.setPrompt(q[1])
    sui.setOkButtonText(q[2])
    sui.setCancelButtonText(q[3])
    sui.sendTo(pPlayer)
end

function HolocronJedi:onKnightMoralAnswer(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    local score = tonumber(rsd(pPlayer, "knight_moral_score")) or 0
    score = score + (eventIndex == 0 and 1 or -1)
    local question = (tonumber(rsd(pPlayer, "knight_moral_question")) or 1) + 1
    wsd(pPlayer, "knight_moral_score", score)
    wsd(pPlayer, "knight_moral_question", question)
    if question <= 4 then
        self:showKnightMoralQuestion(pPlayer, question)
    elseif score == 0 then
        local sui = SuiMessageBox.new("HolocronJedi", "onKnightTieBreaker")
        sui.setTitle("The Gatekeeper's Final Question")
        sui.setPrompt("When peace and personal power cannot coexist, which do you surrender?")
        sui.setOkButtonText("I surrender power")
        sui.setCancelButtonText("I surrender peace")
        sui.sendTo(pPlayer)
    else
        self:showKnightPathConfirmation(pPlayer, score > 0 and "light" or "dark")
    end
end

function HolocronJedi:onKnightTieBreaker(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    self:showKnightPathConfirmation(pPlayer, eventIndex == 0 and "light" or "dark")
end

function HolocronJedi:showKnightPathConfirmation(pPlayer, alignment)
    wsd(pPlayer, "knight_alignment_candidate", alignment)
    local light = alignment == "light"
    local sui = SuiMessageBox.new("HolocronJedi", "onKnightPathConfirmation")
    sui.setTitle(light and "The Path of Light" or "The Path of Darkness")
    sui.setPrompt(light and
        "Your answers reveal patience, mercy, and service. The Gatekeeper sees the path of the Jedi before you. Once accepted, this choice is permanent. Do you accept it?" or
        "Your answers reveal passion, dominance, and an unwillingness to surrender power. The Gatekeeper sees the dark path before you. Once accepted, this choice is permanent. Do you accept it?")
    sui.setOkButtonText("Accept this path")
    sui.setCancelButtonText("Reconsider my answers")
    sui.sendTo(pPlayer)
end

function HolocronJedi:onKnightPathConfirmation(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex ~= 0 then
        wsd(pPlayer, "knight_moral_score", "0")
        wsd(pPlayer, "knight_moral_question", "1")
        self:showKnightMoralQuestion(pPlayer, 1)
        return
    end
    local alignment = rsd(pPlayer, "knight_alignment_candidate")
    if alignment ~= "light" and alignment ~= "dark" then return end
    wsd(pPlayer, "jedi_alignment", alignment)
    wsd(pPlayer, "jedi_alignment_locked", "1")
    replaceEnclaveWaypoint(pPlayer, alignment)
    local sui = SuiMessageBox.new("HolocronJedi", alignment == "light" and "onKnightTrialConfirmLight" or "onKnightTrialConfirmDark")
    sui.setTitle(alignment == "light" and "Begin the Jedi Knight Trial" or "Begin the Dark Jedi Knight Trial")
    sui.setPrompt((alignment == "light" and
        "The Gatekeeper inclines his head. 'Then walk in the light, and let each choice prove your answer.'" or
        "The Gatekeeper's image darkens. 'Then claim your path. Let no weakness survive your trial.'") ..
        "\n\nFour opponents will come for you. Are you prepared to begin?")
    sui.setOkButtonText("I am ready")
    sui.setCancelButtonText("Not yet")
    sui.sendTo(pPlayer)
end

function HolocronJedi:onKnightTrialConfirmLight(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex == 1 then return end -- Cancel
    LightEnclaveKnight:onTrialAccept(pPlayer)
end

function HolocronJedi:onKnightTrialConfirmDark(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex == 1 then return end -- Cancel
    DarkEnclaveKnight:onTrialAccept(pPlayer)
end

function holocron_grant_padawan(pCreature)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    -- ============================================================
    -- Ghosts custom Jedi unlock
    --
    -- The holocron/gatekeeper path replaces the normal Village
    -- progression, so grant the Force Sensitive foundation directly.
    -- ============================================================

    -- Root Force Sensitive skill.
    if not CreatureObject(pCreature):hasSkill("force_title_jedi_novice") then
        awardSkill(pCreature, "force_title_jedi_novice", true)
    end

    -- Mark every Village Force Sensitive branch as unlocked.
    local fsBranches = {
        "force_sensitive_combat_prowess_melee_accuracy",
        "force_sensitive_combat_prowess_melee_speed",
        "force_sensitive_combat_prowess_ranged_accuracy",
        "force_sensitive_combat_prowess_ranged_speed",

        "force_sensitive_crafting_mastery_assembly",
        "force_sensitive_crafting_mastery_experimentation",
        "force_sensitive_crafting_mastery_repair",
        "force_sensitive_crafting_mastery_technique",

        "force_sensitive_enhanced_reflexes_melee_defense",
        "force_sensitive_enhanced_reflexes_ranged_defense",
        "force_sensitive_enhanced_reflexes_survival",
        "force_sensitive_enhanced_reflexes_vehicle_control",

        "force_sensitive_heightened_senses_healing",
        "force_sensitive_heightened_senses_luck",
        "force_sensitive_heightened_senses_persuasion",
        "force_sensitive_heightened_senses_surveying"
    }

    for i = 1, #fsBranches do
        CreatureObject(pCreature):setScreenPlayState(
            2,
            "VillageUnlockScreenPlay:" .. fsBranches[i]
        )
    end

    -- Grant every Force Sensitive profession tree.
    -- awardSkill(..., true) bypasses the normal Village requirements.
    local fsSkills = {
        "force_sensitive_combat_prowess_novice",

        "force_sensitive_combat_prowess_melee_accuracy_01",
        "force_sensitive_combat_prowess_melee_accuracy_02",
        "force_sensitive_combat_prowess_melee_accuracy_03",
        "force_sensitive_combat_prowess_melee_accuracy_04",

        "force_sensitive_combat_prowess_melee_speed_01",
        "force_sensitive_combat_prowess_melee_speed_02",
        "force_sensitive_combat_prowess_melee_speed_03",
        "force_sensitive_combat_prowess_melee_speed_04",

        "force_sensitive_combat_prowess_ranged_accuracy_01",
        "force_sensitive_combat_prowess_ranged_accuracy_02",
        "force_sensitive_combat_prowess_ranged_accuracy_03",
        "force_sensitive_combat_prowess_ranged_accuracy_04",

        "force_sensitive_combat_prowess_ranged_speed_01",
        "force_sensitive_combat_prowess_ranged_speed_02",
        "force_sensitive_combat_prowess_ranged_speed_03",
        "force_sensitive_combat_prowess_ranged_speed_04",

        "force_sensitive_combat_prowess_master",

        "force_sensitive_crafting_mastery_novice",

        "force_sensitive_crafting_mastery_assembly_01",
        "force_sensitive_crafting_mastery_assembly_02",
        "force_sensitive_crafting_mastery_assembly_03",
        "force_sensitive_crafting_mastery_assembly_04",

        "force_sensitive_crafting_mastery_experimentation_01",
        "force_sensitive_crafting_mastery_experimentation_02",
        "force_sensitive_crafting_mastery_experimentation_03",
        "force_sensitive_crafting_mastery_experimentation_04",

        "force_sensitive_crafting_mastery_repair_01",
        "force_sensitive_crafting_mastery_repair_02",
        "force_sensitive_crafting_mastery_repair_03",
        "force_sensitive_crafting_mastery_repair_04",

        "force_sensitive_crafting_mastery_technique_01",
        "force_sensitive_crafting_mastery_technique_02",
        "force_sensitive_crafting_mastery_technique_03",
        "force_sensitive_crafting_mastery_technique_04",

        "force_sensitive_crafting_mastery_master",

        "force_sensitive_enhanced_reflexes_novice",

        "force_sensitive_enhanced_reflexes_melee_defense_01",
        "force_sensitive_enhanced_reflexes_melee_defense_02",
        "force_sensitive_enhanced_reflexes_melee_defense_03",
        "force_sensitive_enhanced_reflexes_melee_defense_04",

        "force_sensitive_enhanced_reflexes_ranged_defense_01",
        "force_sensitive_enhanced_reflexes_ranged_defense_02",
        "force_sensitive_enhanced_reflexes_ranged_defense_03",
        "force_sensitive_enhanced_reflexes_ranged_defense_04",

        "force_sensitive_enhanced_reflexes_survival_01",
        "force_sensitive_enhanced_reflexes_survival_02",
        "force_sensitive_enhanced_reflexes_survival_03",
        "force_sensitive_enhanced_reflexes_survival_04",

        "force_sensitive_enhanced_reflexes_vehicle_control_01",
        "force_sensitive_enhanced_reflexes_vehicle_control_02",
        "force_sensitive_enhanced_reflexes_vehicle_control_03",
        "force_sensitive_enhanced_reflexes_vehicle_control_04",

        "force_sensitive_enhanced_reflexes_master",

        "force_sensitive_heightened_senses_novice",

        "force_sensitive_heightened_senses_healing_01",
        "force_sensitive_heightened_senses_healing_02",
        "force_sensitive_heightened_senses_healing_03",
        "force_sensitive_heightened_senses_healing_04",

        "force_sensitive_heightened_senses_luck_01",
        "force_sensitive_heightened_senses_luck_02",
        "force_sensitive_heightened_senses_luck_03",
        "force_sensitive_heightened_senses_luck_04",

        "force_sensitive_heightened_senses_persuasion_01",
        "force_sensitive_heightened_senses_persuasion_02",
        "force_sensitive_heightened_senses_persuasion_03",
        "force_sensitive_heightened_senses_persuasion_04",

        "force_sensitive_heightened_senses_surveying_01",
        "force_sensitive_heightened_senses_surveying_02",
        "force_sensitive_heightened_senses_surveying_03",
        "force_sensitive_heightened_senses_surveying_04",

        "force_sensitive_heightened_senses_master"
    }

    for i = 1, #fsSkills do
        if not CreatureObject(pCreature):hasSkill(fsSkills[i]) then
            awardSkill(pCreature, fsSkills[i], true)
        end
    end

    -- Required for the Force progression tree to display correctly.
    CreatureObject(pCreature):setScreenPlayState(
        32,
        "VillageJediProgression"
    )

    -- Set our custom progression state.
    wsd(pCreature, "jedi_status", "padawan")
    wsd(pCreature, "padawan_unlocked_at", os.time())
    wsd(pCreature, "holocrons_used", "0")
    wsd(pCreature, "knight_holocrons_used", "0")
    wsd(pCreature, "stage_counter_migrated", "1")
    wsd(pCreature, "holocron_studies_total", "")

    PlayerObject(pGhost):setJediState(1)

    -- Finish the standard Core3 Padawan setup, but bypass the normal
    -- Village requirements for the Jedi title ranks.
    if JediTrials ~= nil and JediTrials.unlockJediPadawan ~= nil then
        JediTrials:unlockJediPadawan(pCreature, true, true)
    else
        CreatureObject(pCreature):sendSystemMessage(
            "\\#FF4444[Jedi System] \\#FFFFFFJediTrials not found."
        )
        return
    end

    ensureForceSensitiveSchematics(pCreature)

    replaceEnclaveWaypoint(pCreature, rsd(pCreature, "jedi_alignment"))

    CreatureObject(pCreature):sendSystemMessage(
        "\\#AADDFF[Jedi System] \\#FFFFFFYour connection to the Force has awakened. You are now a Jedi Padawan."
    )

    local firstName = CreatureObject(pCreature):getFirstName()
    sendMail(
        "The Force",
        "Jedi Progression - The Padawan Path",
        firstName .. ",\n\n" ..
        "The path of the Jedi cannot be rushed.\n\n" ..
        "You have become a Jedi Padawan. You must now complete seven days of training before you may undertake your Jedi Knight Trials.\n\n" ..
        "This waiting period represents the time required for you to grow, train, and deepen your connection to the Force.\n\n" ..
        "May the Force guide your path.",
        firstName
    )
end

function holocron_grant_knight(pCreature, alignment)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    alignment = alignment or "light"

    wsd(pCreature, "jedi_status", "knight")
    wsd(pCreature, "jedi_alignment", alignment)
    wsd(pCreature, "knight_unlocked_at", os.time())
    wsd(pCreature, "knight_holocrons_used", "0")
    wsd(pCreature, "master_holocrons_used", "0")
    wsd(pCreature, "holocron_studies_total", "")

    local councilType = (alignment == "dark") and 2 or 1
    writeScreenPlayData(pCreature, "JediTrials", "JediCouncil", tostring(councilType))
    CreatureObject(pCreature):setScreenPlayState(councilType, "HolocronKnightCouncil")

    -- Ghosts Jedi progression:
    -- Grant Knight and FRS skills directly from Lua.
    -- Third argument true bypasses normal skill requirements.
    if not CreatureObject(pCreature):hasSkill("force_title_jedi_rank_03") then
        awardSkill(pCreature, "force_title_jedi_rank_03", true)
    end

    if alignment == "dark" then
        if not CreatureObject(pCreature):hasSkill("force_rank_dark") then
            awardSkill(pCreature, "force_rank_dark", true)
        end

        if not CreatureObject(pCreature):hasSkill("force_rank_dark_novice") then
            awardSkill(pCreature, "force_rank_dark_novice", true)
        end
    else
        if not CreatureObject(pCreature):hasSkill("force_rank_light") then
            awardSkill(pCreature, "force_rank_light", true)
        end

        if not CreatureObject(pCreature):hasSkill("force_rank_light_novice") then
            awardSkill(pCreature, "force_rank_light_novice", true)
        end
    end

    -- Finish normal Core3 Knight setup:
    -- FRS council/rank, Jedi state, faction, robe, music, etc.
    if JediTrials ~= nil and JediTrials.unlockJediKnight ~= nil then
        JediTrials:unlockJediKnight(pCreature)
    else
        CreatureObject(pCreature):sendSystemMessage(
            "\\#FF4444[Jedi System] \\#FFFFFFJediTrials.unlockJediKnight not found."
        )
        return
    end

    -- Start Jedi hunter systems.
    createEvent(5000, "JediHunters", "startHunting", pCreature, "")
    createEvent(5500, "JediVisibilityHunters", "checkVisibility", pCreature, "")

    if alignment == "dark" then
        CreatureObject(pCreature):sendSystemMessage(
            "\\#FF4444[Jedi System] \\#FFFFFFYou have been recognized as a Dark Jedi Knight."
        )
    else
        CreatureObject(pCreature):sendSystemMessage(
            "\\#88CCFF[Jedi System] \\#FFFFFFYou have been recognized as a Jedi Knight."
        )
    end

    local firstName = CreatureObject(pCreature):getFirstName()
    local nextRank = (alignment == "dark") and "Dark Jedi Lord" or "Grand Jedi Master"
    sendMail(
        "The Force",
        "Jedi Progression - The Knight's Path",
        firstName .. ",\n\n" ..
        "The path of the Jedi cannot be rushed.\n\n" ..
        "You have become a Jedi Knight. You must now complete a further seven days of training before you may undertake the trials to become " .. nextRank .. ".\n\n" ..
        "Use this time to train, grow, and master your connection to the Force.\n\n" ..
        "May the Force guide your path.",
        firstName
    )
end

-- ============================================================
-- MASTER TRIAL PHASE 1 — 150 Holocrons
-- ============================================================

function holocron_begin_master_trial_legacy(pCreature, pTarget)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    local name = CreatureObject(pCreature):getFirstName()
    local dark = (alignment == "dark")

    -- Gatekeeper dialogue SUI
    local title = dark and "The Path of the Dark Lord" or "The Path of the Grand Master"
    local prompt
    if dark then
        prompt = name .. ", you have come far. Further than most dare.\n\nThe dark side has tested you. The Force itself has bent to your will.\n\nBut there is one final measure of your power. One who stood where you stand and chose a different path.\n\nA shadow of Revan stirs nearby. A memory of what could have been.\n\nProve you are worthy of the title of Dark Jedi Lord. Destroy it."
    else
        prompt = name .. ", you have walked a long road.\n\nThe Force has guided you, tested you, and found you worthy at every turn.\n\nBut the title of Grand Master is not given. It is earned.\n\nAn echo of Revan has manifested nearby. A remnant of the past.\n\nFace it. Defeat it. Prove you are worthy of the Force."
    end

    local sui = SuiMessageBox.new("HolocronJedi", "onMasterTrial1Confirm")
    sui.setTitle(title)
    sui.setPrompt(prompt)
    sui.setOkButtonText("I am ready")
    sui.setCancelButtonText("Not yet")
    sui.sendTo(pCreature)
end

function HolocronJedi:onMasterTrial1Confirm(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex == 1 then return end -- cancelled

    -- Spawn Revan Clone 50m away
    local zone = SceneObject(pPlayer):getZoneName()
    local px = SceneObject(pPlayer):getWorldPositionX()
    local py = SceneObject(pPlayer):getWorldPositionY()
    local pz = SceneObject(pPlayer):getWorldPositionZ()

    local alignment = rsd(pPlayer, "jedi_alignment")
    local phase1Template = (alignment == "dark") and "revan_dark_lord_novice" or "revan_grand_master_novice"
    local pRevan = spawnMobile(zone, phase1Template, 0, px + 50, pz, py, 0, 0)
    if pRevan == nil then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 The trial could not begin. Please try again.")
        return
    end

    if alignment == "dark" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Revan - Dark Lord Novice]: Your ambition reeks of desperation. I have seen this darkness before. In myself.")
    else
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Revan - Grand Master Novice]: You walk the light. As I once did. But the Force does not grant titles. It demands proof.")
    end

    -- Add red waypoint
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local wpID = PlayerObject(pGhost):addWaypoint(zone, "Revan", "", px + 50, 0, py, WAYPOINTRED, true, true, 0)
        writeScreenPlayData(pPlayer, "HolocronJedi", "revan_wp_id", tostring(wpID))
    end

    writeScreenPlayData(pPlayer, "HolocronJedi", "revan_id", tostring(SceneObject(pRevan):getObjectID()))
    writeScreenPlayData(pPlayer, "HolocronJedi", "master_trial_phase", "1")

    -- Start kill poll
    createEvent(5000, "HolocronJedi", "pollRevanKill", pPlayer, "")
end

-- ============================================================
-- MASTER TRIAL PHASE 3 — Final Trial (after training master tree)
-- ============================================================

function holocron_begin_master_trial_final_legacy(pCreature, pTarget)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    local name = CreatureObject(pCreature):getFirstName()
    local dark = (alignment == "dark")

    local title = dark and "The Final Test" or "The Final Test"
    local prompt
    if dark then
        prompt = name .. ", you have mastered the dark arts.\n\nBut Revan returns. Stronger now. A true echo of his full power.\n\nThe Dark Council does not grant the title of Dark Jedi Lord lightly.\n\nDestroy him. Completely. Then it is yours."
    else
        prompt = name .. ", you have trained to the peak of the Jedi arts.\n\nRevan appears once more. This time at full strength.\n\nThe Council does not grant the title of Grand Master without this final proof.\n\nFace him. Defeat him. The Force is with you."
    end

    local sui = SuiMessageBox.new("HolocronJedi", "onMasterTrialFinalConfirm")
    sui.setTitle(title)
    sui.setPrompt(prompt)
    sui.setOkButtonText("I am ready")
    sui.setCancelButtonText("Not yet")
    sui.sendTo(pCreature)
end

function HolocronJedi:onMasterTrialFinalConfirm(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex == 1 then return end

    local zone = SceneObject(pPlayer):getZoneName()
    local px = SceneObject(pPlayer):getWorldPositionX()
    local py = SceneObject(pPlayer):getWorldPositionY()
    local pz = SceneObject(pPlayer):getWorldPositionZ()

    local alignment = rsd(pPlayer, "jedi_alignment")
    local finalTemplate = (alignment == "dark") and "revan_dark_lord" or "revan_grand_master"
    local pRevan = spawnMobile(zone, finalTemplate, 0, px + 50, pz, py, 0, 0)
    if pRevan == nil then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 The trial could not begin. Please try again.")
        return
    end

    if alignment == "dark" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Revan - Dark Jedi Lord]: This ends now. One of us walks away from this. It will not be you.")
    else
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Revan - Grand Jedi Master]: I have faced greater Jedi than you. But the Force has spoken. Let us finish this.")
    end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local wpID = PlayerObject(pGhost):addWaypoint(zone, "Revan", "", px + 50, 0, py, WAYPOINTRED, true, true, 0)
        writeScreenPlayData(pPlayer, "HolocronJedi", "revan_wp_id", tostring(wpID))
    end

    writeScreenPlayData(pPlayer, "HolocronJedi", "revan_id", tostring(SceneObject(pRevan):getObjectID()))
    writeScreenPlayData(pPlayer, "HolocronJedi", "master_trial_phase", "3")

    createEvent(5000, "HolocronJedi", "pollRevanKill", pPlayer, "")
end

-- ============================================================
-- REVAN KILL POLL
-- ============================================================

function HolocronJedi:pollRevanKill(pPlayer, params)
    if pPlayer == nil then return end

    local revanID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "revan_id")) or 0
    if revanID == 0 then return end

    local pRevan = getSceneObject(revanID)
    if pRevan ~= nil and not CreatureObject(pRevan):isDead() then
        -- Still alive, keep polling
        createEvent(5000, "HolocronJedi", "pollRevanKill", pPlayer, "")
        return
    end

    -- Revan is dead — remove waypoint
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    local wpID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "revan_wp_id")) or 0
    if pGhost ~= nil and wpID ~= 0 then
        PlayerObject(pGhost):removeWaypoint(wpID, true)
    end
    writeScreenPlayData(pPlayer, "HolocronJedi", "revan_wp_id", "0")
    writeScreenPlayData(pPlayer, "HolocronJedi", "revan_id", "0")

    local phase = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "master_trial_phase")) or 0

    if phase == 1 then
        -- Phase 1 complete - update status; Lua Master Trial handles the rank grant
        wsd(pPlayer, "jedi_status", "master_phase2")
        CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Revan falls. The first Master trial is complete.")
    elseif phase == 3 then
        -- Final phase complete - update status; Lua Master Trial handles the rank grant
        wsd(pPlayer, "jedi_status", "master")
        CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Revan is defeated. Your final Master trial is complete.")
    end
end

-- Sole active Master-trial entry points. The legacy callbacks above are kept
-- under explicit names only for save/event compatibility and are never used
-- by new progression.
function holocron_begin_master_trial(pCreature, pTarget)
    if pCreature == nil or MasterTrial == nil then return end
    MasterTrial:onSeekFinalTrial(pCreature, pTarget)
end

function holocron_begin_master_trial_final(pCreature, pTarget)
    if pCreature == nil or MasterTrial == nil then return end
    MasterTrial:onSeekFinalConfrontation(pCreature, pTarget)
end

function holocron_grant_master(pCreature)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    wsd(pCreature, "jedi_status", "master")

    if alignment == "dark" then
        CreatureObject(pCreature):sendSystemMessage("\\#AA00AA Your dominion over the Dark Side is complete. You are a Dark Lord. Bow to no one.")
    else
        CreatureObject(pCreature):sendSystemMessage("\\#FFFFFF The Force flows through you in its fullness. You are a Jedi Master. The galaxy looks to you for guidance.")
    end
end

function holocron_reset_progress(pCreature, pTarget)
    if pCreature == nil then return end

    writeScreenPlayData(pCreature, "HolocronJedi", "jedi_status", "")
    writeScreenPlayData(pCreature, "HolocronJedi", "holocrons_used", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "padawan_test_done", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "padawan_test_active", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "padawan_mob_spawned", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "trial_djk_id", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "trial_spawn_time", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "trial_start_x", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "trial_start_y", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "gatekeeper_id", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "knight_holocrons_used", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "master_holocrons_used", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "jedi_alignment", "")
    writeScreenPlayData(pCreature, "HolocronJedi", "jedi_alignment_locked", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "holocron_studies_total", "0")
    writeScreenPlayData(pCreature, "HolocronJedi", "jedi_enclave_waypoint_id", "0")

    local pGhostObj = CreatureObject(pCreature):getPlayerObject()
    if pGhostObj ~= nil then
        PlayerObject(pGhostObj):removeWaypointBySpecialType(WAYPOINTQUESTTASK)
    end

    CreatureObject(pCreature):sendSystemMessage("\\#FF4444[Jedi System] \\#FFFFFFYour Force progression has been reset.")
end

function holocron_debug_status(pCreature)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local used       = rsd(pCreature, "holocrons_used")
    local testDone   = rsd(pCreature, "padawan_test_done")
    local knightUsed = rsd(pCreature, "knight_holocrons_used")
    local masterUsed = rsd(pCreature, "master_holocrons_used")
    local alignment  = rsd(pCreature, "jedi_alignment")

    CreatureObject(pCreature):sendSystemMessage("=== JEDI STATUS DEBUG ===")
    CreatureObject(pCreature):sendSystemMessage("Current Stage Holocron Studies: " .. getTotalStudies(pCreature))
    CreatureObject(pCreature):sendSystemMessage("Status: " .. (status == "" and "none" or status))
    CreatureObject(pCreature):sendSystemMessage("Padawan Holocrons: " .. (used == "" and "0" or used) .. "/10")
    CreatureObject(pCreature):sendSystemMessage("Gatekeeper Test Done: " .. (testDone == "1" and "YES" or "NO"))
    CreatureObject(pCreature):sendSystemMessage("Knight Holocrons: " .. (knightUsed == "" and "0" or knightUsed) .. "/50")
    CreatureObject(pCreature):sendSystemMessage("Master Holocrons: " .. (masterUsed == "" and "0" or masterUsed) .. "/150")
    CreatureObject(pCreature):sendSystemMessage("Alignment: " .. (alignment == "" and "none" or alignment))
    CreatureObject(pCreature):sendSystemMessage("=========================")
end
