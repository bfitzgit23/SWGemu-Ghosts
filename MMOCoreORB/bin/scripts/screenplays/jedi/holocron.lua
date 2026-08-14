--[[
    Custom Jedi Holocron Script
    Patched to hand Padawan unlock off to stock JediTrials instead of
    manually brute-forcing the entire FS skill tree.

    What this keeps:
      - 10 holocrons required for Padawan
      - False Sith / Gatekeeper trial
      - 50 holocrons for Knight
      - 100 holocrons for Master

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

registerScreenPlay("HolocronJedi", true)

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
        CreatureObject(pPlayer):setScreenPlayState(0, "HolocronKnightSkillGranted")
        CreatureObject(pPlayer):setScreenPlayState(0, "HolocronKnightGrantPending")
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

    if status == "" or status == "none" then
        local used = tonumber(readScreenPlayData(pCreature, "HolocronJedi", "holocrons_used")) or 0
        local newVal = math.min(used + 50, 10)
        writeScreenPlayData(pCreature, "HolocronJedi", "holocrons_used", tostring(newVal))
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Padawan holocrons set to " .. newVal .. "/10")

    elseif status == "padawan" then
        local used = tonumber(readScreenPlayData(pCreature, "HolocronJedi", "knight_holocrons_used")) or 0
        local newVal = math.min(used + 50, 50)
        writeScreenPlayData(pCreature, "HolocronJedi", "knight_holocrons_used", tostring(newVal))
        CreatureObject(pCreature):sendSystemMessage("\\#FFFF00[DEV] Knight holocrons set to " .. newVal .. "/50")
        if newVal >= 50 then
            createEvent(500, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        end

    elseif status == "knight" then
        local used = tonumber(readScreenPlayData(pCreature, "HolocronJedi", "master_holocrons_used")) or 0
        local newVal = math.min(used + 50, 150)
        writeScreenPlayData(pCreature, "HolocronJedi", "master_holocrons_used", tostring(newVal))
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
        CreatureObject(pSearcher):say(dialogue)
        AiAgent(pSearcher):setDefender(pTarget)
    end
end

function holocron_use_for_studies(pCreature, pTarget)
    if pCreature == nil then return end

    local status = rsd(pCreature, "jedi_status")

    if status == "" or status == "none" then
        local used = tonumber(rsd(pCreature, "holocrons_used")) or 0

        if used >= 10 then
            sendForceMessage(pCreature, "You have absorbed all you can from these teachings. Seek the Gatekeeper.")
            return
        end

        used = used + 1
        wsd(pCreature, "holocrons_used", used)
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
        local knightUsed = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0

        if knightUsed >= 50 then
            sendForceMessage(pCreature, "You have meditated upon enough holocrons. The Gatekeeper senses your growing power. Seek them out.")
            return
        end

        knightUsed = knightUsed + 1
        wsd(pCreature, "knight_holocrons_used", knightUsed)
        SceneObject(pTarget):destroyObjectFromWorld()
        sendForceMessage(pCreature, "You meditate upon the holocron. Its secrets deepen your connection to the Force. (" .. knightUsed .. "/50 holocrons absorbed)")

        if knightUsed == 50 then
            sendForceMessage(pCreature, "Your studies are complete. The Gatekeeper has more to say. Speak to them when you are ready.")


            local alignment = rsd(pCreature, "jedi_alignment")
            local pGhost = CreatureObject(pCreature):getPlayerObject()

            if alignment == "dark" then
                -- Dark alignment already chosen
                if pGhost ~= nil then
                    PlayerObject(pGhost):addWaypoint("yavin4", "Dark Jedi Enclave", "", 5079, 306, WAYPOINTYELLOW, true, true, 0)
                end
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The dark side has tested your resolve and found you worthy.\n\nThe time has come to face the trials of Dark Knighthood. Speak to the Gatekeeper again when you are ready."
                sendMail("The Force", "The Path to Dark Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            elseif alignment == "light" then
                -- Light alignment already chosen
                if pGhost ~= nil then
                    PlayerObject(pGhost):addWaypoint("yavin4", "Light Jedi Enclave", "", -5575, 4910, WAYPOINTYELLOW, true, true, 0)
                end
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The Force has tested your patience and found you worthy.\n\nThe time has come to face the trials of Knighthood. Speak to the Gatekeeper again when you are ready."
                sendMail("The Force", "The Path to Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            else
                -- No alignment chosen yet - give both waypoints and explain the choice
                if pGhost ~= nil then
                    PlayerObject(pGhost):addWaypoint("yavin4", "Light Jedi Enclave", "", -5575, 4910, WAYPOINTYELLOW, true, true, 0)
                    PlayerObject(pGhost):addWaypoint("yavin4", "Dark Jedi Enclave", "", 5079, 306, WAYPOINTYELLOW, true, true, 0)
                end
                local mailBody = "You have absorbed the wisdom of fifty holocrons. The Force has found you ready.\n\nThe time has come to face the trials of Knighthood. Speak to the Gatekeeper again when you are ready to choose your path."
                sendMail("The Force", "The Path to Knighthood", mailBody, CreatureObject(pCreature):getFirstName())
            end

            -- SUI popup notification
            createEvent(2000, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        end

    elseif status == "knight" then
        local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0

        if masterUsed >= 150 then
            sendForceMessage(pCreature, "You have absorbed all the holocron teachings you can. The Gatekeeper awaits.")
            return
        end

        masterUsed = masterUsed + 1
        wsd(pCreature, "master_holocrons_used", masterUsed)
        SceneObject(pTarget):destroyObjectFromWorld()
        sendForceMessage(pCreature, "Ancient wisdom pours into your mind. (" .. masterUsed .. "/150 holocrons absorbed)")

        if masterUsed == 150 then
            sendForceMessage(pCreature, "You have absorbed the final teachings. The Gatekeeper awaits you one last time. Seek them out.")

            local alignment = rsd(pCreature, "jedi_alignment")
            local pGhost = CreatureObject(pCreature):getPlayerObject()
            if pGhost ~= nil then
                if alignment == "dark" then
                    PlayerObject(pGhost):addWaypoint("yavin4", "Dark Jedi Enclave", "", 5079, 306, WAYPOINTYELLOW, true, true, 0)
                else
                    PlayerObject(pGhost):addWaypoint("yavin4", "Light Jedi Enclave", "", -5575, 4910, WAYPOINTYELLOW, true, true, 0)
                end
            end

            local enclaveName = (alignment == "dark") and "Dark Jedi Enclave" or "Light Jedi Enclave"
            local enclaveCoords = (alignment == "dark") and "5079, 306" or "-5575, 4910"
            local mailBody = "One hundred holocrons. You have meditated upon every fragment of ancient wisdom available to you. The Force has been your constant companion through all of it.\n\nThe time has come to face the final trials - those of the Jedi Master.\n\nSpeak to the Gatekeeper again. They will show you the way forward.\n\nFew reach this moment. Fewer still survive what comes next.\n\nMay the Force guide your final steps."
            sendMail("The Force", "The Path to Mastery", mailBody, CreatureObject(pCreature):getFirstName())

            -- SUI popup notification
            createEvent(2000, "HolocronJedi", "showMasterUnlockPopup", pCreature, "")
        end

    else
        sendForceMessage(pCreature, "You have already transcended what this holocron can teach you.")
    end
end

function holocron_speak_to_gatekeeper(pCreature, pTarget)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local knightUsed = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0

    -- Knight trial - Padawan with 50+ holocrons
    if status == "padawan" and knightUsed >= 50 then
        holocron_begin_knight_trial(pCreature, pTarget)
        return
    end

    -- Knight who has used 150 master holocrons - begin master trial phase 1
    if status == "knight" then
        local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0
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

    wsd(pCreature, "padawan_test_done", "1")

    sendForceMessage(pCreature, "The air around you grows still. A presence stirs in the Force...")
    createEvent(3000, "HolocronJedi", "gkSpeakPart2", pCreature, "")
end

function HolocronJedi:gkSpeakPart2(pCreature, params)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFFAh... so you have finally come. I have waited a long time for someone like you.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart3", pCreature, "")
end

function HolocronJedi:gkSpeakPart3(pCreature, params)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFFThe Force has been whispering your name. You stand at the threshold of something far greater than yourself.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart4", pCreature, "")
end

function HolocronJedi:gkSpeakPart4(pCreature, params)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFFBut before I can open that door... you must prove you are worthy of walking through it.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart5", pCreature, "")
end

function HolocronJedi:gkSpeakPart5(pCreature, params)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFFYour awakening has drawn a dark presence. A False Sith - one who has touched the dark side without discipline or purpose.")
    createEvent(4000, "HolocronJedi", "gkSpeakPart6", pCreature, "")
end

function HolocronJedi:gkSpeakPart6(pCreature, params)
    if pCreature == nil then return end
    CreatureObject(pCreature):sendSystemMessage("\\#AADDFF[The Gatekeeper] \\#FFFFFFFind it. Destroy it. A waypoint will mark its location. Do not return until it is done.")

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
    sui.setPrompt(name .. ", one hundred holocrons. You have absorbed every teaching available to you.\n\nThe Force has found you worthy of the final trials.\n\nSpeak to the Gatekeeper again. The last path awaits you.")
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

    local status    = rsd(pCreature, "jedi_status")
    local alignment = rsd(pCreature, "jedi_alignment")
    if status == nil then return end

    local knightUsed = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0
    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0

    -- Knight reminder: padawan who has hit 50 holocrons
    if status == "padawan" and knightUsed >= 50 then
        createEvent(5000, "HolocronJedi", "showKnightUnlockPopup", pCreature, "")
        return
    end

    -- Master reminder: knight who has hit 100 holocrons
    if status == "knight" and masterUsed >= 100 then
        createEvent(5000, "HolocronJedi", "showMasterUnlockPopup", pCreature, "")
        return
    end
end

function holocron_begin_knight_trial(pCreature, pTarget)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local knightUsed = tonumber(rsd(pCreature, "knight_holocrons_used")) or 0
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

    -- Check if trial is already running
    local id = SceneObject(pCreature):getObjectID()
    local wave = readData("LightKnightTrial:" .. id .. ":wave") or readData("DarkKnightTrial:" .. id .. ":wave")
    if wave ~= nil and wave > 0 then
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 Your trial is already underway. Seek your opponent.")
        return
    end

    -- Always show the path choice - alignment is set when the trial completes
    local sui = SuiMessageBox.new("HolocronJedi", "onPathChoice")
    sui.setTitle("Choose Your Path")
    sui.setPrompt(
        "You have absorbed " .. knightUsed .. " holocrons. The Force has judged you ready " ..
        "for the trials of Knighthood.\n\n" ..
        "Choose your path.\n\n" ..
        "The Jedi Order walks in the light. They draw strength from peace, " ..
        "knowledge and serenity.\n\n" ..
        "The Dark Jedi Order embraces passion, strength and power. " ..
        "They take what they are owed.\n\n" ..
        "Which path do you walk?"
    )
    sui.setOkButtonText("The Jedi Order")
    sui.setCancelButtonText("The Dark Jedi Order")
    sui.sendTo(pCreature)
end

function HolocronJedi:onPathChoice(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    -- eventIndex 0 = OK = Jedi Order (light)
    -- eventIndex 1 = Cancel = Dark Jedi Order (dark)
    if eventIndex == 0 then
        writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_alignment", "light")
        -- Show light trial confirmation
        local sui = SuiMessageBox.new("HolocronJedi", "onKnightTrialConfirmLight")
        sui.setTitle("Begin the Jedi Knight Trial")
        sui.setPrompt(
            "You have chosen the path of the Jedi Order.\n\n" ..
            "Four servants of the dark side will face you - each a challenge to the Jedi Code. " ..
            "Face them. Silence them. Let the Code guide your blade.\n\n" ..
            "They will come to you. Be ready.\n\n" ..
            "Are you prepared to begin?"
        )
        sui.setOkButtonText("I am ready")
        sui.setCancelButtonText("Not yet")
        sui.sendTo(pPlayer)
    else
        writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_alignment", "dark")
        -- Show dark trial confirmation
        local sui = SuiMessageBox.new("HolocronJedi", "onKnightTrialConfirmDark")
        sui.setTitle("Begin the Dark Jedi Knight Trial")
        sui.setPrompt(
            "You have chosen the path of the Dark Jedi Order.\n\n" ..
            "The dark side does not grant rank - it is taken. Four shadows will face you. " ..
            "Each embodies a truth of the Sith Code. Destroy them all.\n\n" ..
            "They will come to you. Be ready.\n\n" ..
            "Are you prepared to begin?"
        )
        sui.setOkButtonText("I am ready")
        sui.setCancelButtonText("Not yet")
        sui.sendTo(pPlayer)
    end
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

    wsd(pCreature, "jedi_status", "padawan")

    -- Grant village eligibility so awardSkill passes isVillageEligible in C++.
    -- isVillageEligible requires VILLAGE_JEDI_PROGRESSION_HAS_VILLAGE_ACCESS (4)
    -- and FS_VILLAGE_ELDER quest. Setting these screenplay states satisfies the check.
    CreatureObject(pCreature):setScreenPlayState(4, "VillageJediProgression")
    CreatureObject(pCreature):setScreenPlayState(8, "VillageJediProgression")
    CreatureObject(pCreature):setScreenPlayState(32, "VillageJediProgression")

    PlayerObject(pGhost):setJediState(1)

    if JediTrials ~= nil and JediTrials.unlockJediPadawan ~= nil then
        JediTrials:unlockJediPadawan(pCreature, true)
    else
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444[Jedi System] \\#FFFFFFJediTrials not found.")
    end
end


function holocron_grant_knight(pCreature, alignment)
    if pCreature == nil then return end

    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end

    alignment = alignment or "light"

    wsd(pCreature, "jedi_status", "knight")
    wsd(pCreature, "jedi_alignment", alignment)

    local councilType = (alignment == "dark") and 2 or 1
    writeScreenPlayData(pCreature, "JediTrials", "JediCouncil", tostring(councilType))
    CreatureObject(pCreature):setScreenPlayState(councilType, "HolocronKnightCouncil")

    -- Set pending flag — C++ fillObjectMenuResponse grants force_title_jedi_rank_03
    -- and force_rank_light/dark_novice with checkRequirements=false on next holocron interaction
    CreatureObject(pCreature):setScreenPlayState(1, "HolocronKnightGrantPending")

    -- Notify player to click holocron
    if alignment == "dark" then
        CreatureObject(pCreature):sendSystemMessage("\\#FF4444 Your trial is complete. Right-click your holocron and select any option to receive your rank.")
    else
        CreatureObject(pCreature):sendSystemMessage("\\#88CCFF Your trial is complete. Right-click your holocron and select any option to receive your rank.")
    end

    -- Poll for C++ grant completion then call unlockJediKnight for FRS/faction/jediState
    local playerID = SceneObject(pCreature):getObjectID()
    writeScreenPlayData(pCreature, "HolocronJedi", "knight_grant_playerid", tostring(playerID))
    createEvent(3000, "HolocronJedi", "pollKnightGrant", pCreature, alignment)
end

function HolocronJedi:pollKnightGrant(pPlayer, params)
    if pPlayer == nil then return end

    -- Re-resolve fresh pointer
    local playerID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "knight_grant_playerid"))
    if playerID ~= nil and playerID ~= 0 then
        local pFresh = getSceneObject(playerID)
        if pFresh ~= nil then pPlayer = pFresh end
    end

    -- Check if C++ has granted the skills
    if CreatureObject(pPlayer):getScreenPlayState("HolocronKnightSkillGranted") ~= 1 then
        -- Not yet - remind and retry
        CreatureObject(pPlayer):sendSystemMessage("\\#AAAAAA Right-click your holocron and select any option to complete your promotion.")
        createEvent(5000, "HolocronJedi", "pollKnightGrant", pPlayer, params)
        return
    end

    -- Clear flags
    CreatureObject(pPlayer):setScreenPlayState(0, "HolocronKnightSkillGranted")
    CreatureObject(pPlayer):setScreenPlayState(0, "HolocronKnightGrantPending")

    -- Now call unlockJediKnight — player already has rank_03 so addSkill is skipped
    -- This handles setFrsCouncil, setFrsRank, setJediState, faction, robe, music
    if JediTrials ~= nil and JediTrials.unlockJediKnight ~= nil then
        JediTrials:unlockJediKnight(pPlayer)
    end

    -- Start the Force affiliation hunter system
    createEvent(5000, "JediHunters", "startHunting", pPlayer, "")
    -- Start bounty hunter system if visibility already >= 75
    createEvent(5500, "JediVisibilityHunters", "checkVisibility", pPlayer, "")
end

-- ============================================================
-- MASTER TRIAL PHASE 1 — 150 Holocrons
-- ============================================================

function holocron_begin_master_trial(pCreature, pTarget)
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
        local wpID = PlayerObject(pGhost):addWaypoint(zone, "Revan", "", px + 50, py, WAYPOINTRED, true, true, 0)
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

function holocron_begin_master_trial_final(pCreature, pTarget)
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
        local wpID = PlayerObject(pGhost):addWaypoint(zone, "Revan", "", px + 50, py, WAYPOINTRED, true, true, 0)
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
        -- Phase 1 complete - set status and grant novice master skill via C++
        wsd(pPlayer, "jedi_status", "master_phase2")
        CreatureObject(pPlayer):setScreenPlayState(1, "HolocronMasterGrantPending")
        CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Revan falls. The trial is complete. Right-click your holocron to claim your title.")
    elseif phase == 3 then
        -- Final phase complete - grant full master title via C++
        wsd(pPlayer, "jedi_status", "master")
        CreatureObject(pPlayer):setScreenPlayState(1, "HolocronMasterFinalGrantPending")
        CreatureObject(pPlayer):sendSystemMessage("\\#FFD700 Revan is defeated. The title is yours. Right-click your holocron to complete your ascension.")
    end
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
    CreatureObject(pCreature):sendSystemMessage("Status: " .. (status == "" and "none" or status))
    CreatureObject(pCreature):sendSystemMessage("Padawan Holocrons: " .. (used == "" and "0" or used) .. "/10")
    CreatureObject(pCreature):sendSystemMessage("Gatekeeper Test Done: " .. (testDone == "1" and "YES" or "NO"))
    CreatureObject(pCreature):sendSystemMessage("Knight Holocrons: " .. (knightUsed == "" and "0" or knightUsed) .. "/50")
    CreatureObject(pCreature):sendSystemMessage("Master Holocrons: " .. (masterUsed == "" and "0" or masterUsed) .. "/100")
    CreatureObject(pCreature):sendSystemMessage("Alignment: " .. (alignment == "" and "none" or alignment))
    CreatureObject(pCreature):sendSystemMessage("=========================")
end