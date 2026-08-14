--[[
    Enclave Challenge Terminal
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/enclave_terminal.lua

    Radial options (LIGHT_CHALLENGE terminal):
        83 -> Train Lightsaber Mastery  -> enclave_terminal_train_light_branch(player, terminal, ghost, 1)
        84 -> Train Force Powers        -> enclave_terminal_train_light_branch(player, terminal, ghost, 2)
        85 -> Train Defence             -> enclave_terminal_train_light_branch(player, terminal, ghost, 3)
        86 -> Train Guardian Arts       -> enclave_terminal_train_light_branch(player, terminal, ghost, 4)
        82 -> Request Promotion         -> frs_request_promotion

    Radial options (DARK_CHALLENGE terminal):
        83 -> Train Lightsaber Mastery  -> enclave_terminal_train_dark_branch(player, terminal, ghost, 1)
        84 -> Train Force Powers        -> enclave_terminal_train_dark_branch(player, terminal, ghost, 2)
        85 -> Train Defence             -> enclave_terminal_train_dark_branch(player, terminal, ghost, 3)
        86 -> Train Tyrant Arts         -> enclave_terminal_train_dark_branch(player, terminal, ghost, 4)
        82 -> Request Promotion         -> frs_request_promotion

    Coded by BoosterSteel - Ghosts of the Old Republic
--]]

EnclaveTerminal = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "EnclaveTerminal",
}

registerScreenPlay("EnclaveTerminal", false)

-- ============================================================
-- HELPERS
-- ============================================================

local function rsd(pPlayer, key)
    return readScreenPlayData(pPlayer, "HolocronJedi", key)
end

local function termSay(pCreature, color, prefix, msg)
    CreatureObject(pCreature):sendSystemMessage(color .. "[" .. prefix .. "] \\#FFFFFF" .. msg)
end

local function lightSay(pCreature, msg)
    termSay(pCreature, "\\#88CCFF", "Council Elder", msg)
end

local function darkSay(pCreature, msg)
    termSay(pCreature, "\\#FF4444", "Dark Council Sovereign", msg)
end

local function countTrainedBoxes(pCreature, boxes)
    local count = 0
    for _, skill in ipairs(boxes) do
        if CreatureObject(pCreature):hasSkill(skill) then count = count + 1 end
    end
    return count
end

-- ============================================================
-- SKILL DEFINITIONS
-- ============================================================

local LIGHT_BRANCHES = {
    { name = "Lightsaber Mastery", skills = { "jedi_grand_master_lightsaber_01",   "jedi_grand_master_lightsaber_02",   "jedi_grand_master_lightsaber_03",   "jedi_grand_master_lightsaber_04"   } },
    { name = "Force Powers",       skills = { "jedi_grand_master_force_powers_01", "jedi_grand_master_force_powers_02", "jedi_grand_master_force_powers_03", "jedi_grand_master_force_powers_04" } },
    { name = "Defence",            skills = { "jedi_grand_master_defence_01",      "jedi_grand_master_defence_02",      "jedi_grand_master_defence_03",      "jedi_grand_master_defence_04"      } },
    { name = "Guardian Arts",      skills = { "jedi_grand_master_guardian_01",     "jedi_grand_master_guardian_02",     "jedi_grand_master_guardian_03",     "jedi_grand_master_guardian_04"     } },
}

local DARK_BRANCHES = {
    { name = "Lightsaber Mastery", skills = { "jedi_dark_lord_lightsaber_01",   "jedi_dark_lord_lightsaber_02",   "jedi_dark_lord_lightsaber_03",   "jedi_dark_lord_lightsaber_04"   } },
    { name = "Force Powers",       skills = { "jedi_dark_lord_force_powers_01", "jedi_dark_lord_force_powers_02", "jedi_dark_lord_force_powers_03", "jedi_dark_lord_force_powers_04" } },
    { name = "Defence",            skills = { "jedi_dark_lord_defence_01",      "jedi_dark_lord_defence_02",      "jedi_dark_lord_defence_03",      "jedi_dark_lord_defence_04"      } },
    { name = "Tyrant Arts",        skills = { "jedi_dark_lord_tyrant_01",       "jedi_dark_lord_tyrant_02",       "jedi_dark_lord_tyrant_03",       "jedi_dark_lord_tyrant_04"       } },
}

local function flatBoxes(branches)
    local t = {}
    for _, b in ipairs(branches) do
        for _, s in ipairs(b.skills) do table.insert(t, s) end
    end
    return t
end

local LIGHT_ALL_BOXES = flatBoxes(LIGHT_BRANCHES)
local DARK_ALL_BOXES  = flatBoxes(DARK_BRANCHES)

-- ============================================================
-- CORE: TRAIN ONE BOX IN A SPECIFIC BRANCH
-- ============================================================

local function trainBranch(pCreature, branches, allBoxes, branchIndex, sayFn, noviceSkill, masterSkill)
    if not CreatureObject(pCreature):hasSkill(noviceSkill) then
        sayFn(pCreature, "You have not yet earned the right to train here. Complete the Novice path first.")
        return
    end

    if CreatureObject(pCreature):hasSkill(masterSkill) then
        sayFn(pCreature, "You have already completed this path entirely.")
        return
    end

    local branch = branches[branchIndex]
    if branch == nil then
        sayFn(pCreature, "Invalid branch selection.")
        return
    end

    -- Find next unlearned skill in this branch
    local nextSkill = nil
    local nextRank  = 0
    for rank, skill in ipairs(branch.skills) do
        if not CreatureObject(pCreature):hasSkill(skill) then
            nextSkill = skill
            nextRank  = rank
            break
        end
    end

    if nextSkill == nil then
        sayFn(pCreature, branch.name .. " is already fully trained.")
        return
    end

    local success = CreatureObject(pCreature):awardSkill(nextSkill)

    if success then
        local totalTrained = countTrainedBoxes(pCreature, allBoxes)
        sayFn(pCreature, branch.name .. " rank " .. nextRank .. " trained. (" .. totalTrained .. "/16 total disciplines)")
        if totalTrained >= 16 then
            sayFn(pCreature, "All 16 disciplines mastered. Return to the Gatekeeper — the final confrontation awaits.")
        end
    else
        sayFn(pCreature, "Training failed for " .. nextSkill .. ". You may not have enough jedi_general XP.")
    end
end

-- ============================================================
-- LIGHT BRANCH ENTRY POINT
-- Called from C++ with branchIndex 1-4
-- ============================================================

function enclave_terminal_train_light_branch(pCreature, pTerminal, pGhost, branchIndex)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    if alignment == "dark" then
        lightSay(pCreature, "The light path is not yours to walk. Seek the Dark Enclave.")
        return
    end

    trainBranch(pCreature, LIGHT_BRANCHES, LIGHT_ALL_BOXES, branchIndex, lightSay,
        "jedi_grand_master_novice", "jedi_grand_master_master")
end

-- ============================================================
-- DARK BRANCH ENTRY POINT
-- Called from C++ with branchIndex 1-4
-- ============================================================

function enclave_terminal_train_dark_branch(pCreature, pTerminal, pGhost, branchIndex)
    if pCreature == nil then return end

    local alignment = rsd(pCreature, "jedi_alignment")
    if alignment == "light" then
        darkSay(pCreature, "The light path is not yours. Seek the Light Enclave.")
        return
    end

    trainBranch(pCreature, DARK_BRANCHES, DARK_ALL_BOXES, branchIndex, darkSay,
        "jedi_dark_lord_novice", "jedi_dark_lord_master")
end

-- ============================================================
-- LEGACY ENTRY POINTS (kept for any existing references)
-- ============================================================

function enclave_terminal_train_light(pCreature, pTerminal, pGhost)
    enclave_terminal_train_light_branch(pCreature, pTerminal, pGhost, 1)
end

function enclave_terminal_train_dark(pCreature, pTerminal, pGhost)
    enclave_terminal_train_dark_branch(pCreature, pTerminal, pGhost, 1)
end

-- ============================================================
-- MASTER INFO - LIGHT
-- ============================================================

function enclave_terminal_master_light(pCreature, pTerminal, pGhost)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local alignment  = rsd(pCreature, "jedi_alignment")
    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0

    if status == "master" then
        lightSay(pCreature, "You have achieved Grand Mastery. The Force flows fully through you.")
        lightSay(pCreature, "There is nothing more the enclave can offer you. You are complete.")
        return
    end

    if status == "master_novice" then
        local trained = countTrainedBoxes(pCreature, LIGHT_ALL_BOXES)
        if trained >= 16 then
            lightSay(pCreature, "All 16 disciplines mastered. Return to the Gatekeeper for the final confrontation.")
        else
            lightSay(pCreature, "You have mastered " .. trained .. "/16 disciplines. Use the training options to continue your path.")
        end
        return
    end

    if status ~= "knight" then
        lightSay(pCreature, "You must first become a Jedi Knight before seeking the Master trials.")
        return
    end

    if alignment == "dark" then
        lightSay(pCreature, "The darkness within you disqualifies you here. Seek the Dark Jedi Enclave.")
        return
    end

    local remaining = 150 - masterUsed
    if remaining > 0 then
        lightSay(pCreature, "You have studied " .. masterUsed .. "/150 holocrons toward Mastery. " .. remaining .. " more are required.")
        lightSay(pCreature, "You must also reach Rank 10 of the Jedi Council to qualify for the final trial.")
    else
        lightSay(pCreature, "You have absorbed enough holocrons. Seek the Gatekeeper for the final trial.")
    end
end

-- ============================================================
-- MASTER INFO - DARK
-- ============================================================

function enclave_terminal_master_dark(pCreature, pTerminal, pGhost)
    if pCreature == nil then return end

    local status     = rsd(pCreature, "jedi_status")
    local alignment  = rsd(pCreature, "jedi_alignment")
    local masterUsed = tonumber(rsd(pCreature, "master_holocrons_used")) or 0

    if status == "master" then
        darkSay(pCreature, "You stand at the pinnacle of the dark side. There is nothing left for me to give you.")
        darkSay(pCreature, "The galaxy is yours.")
        return
    end

    if status == "master_novice" then
        local trained = countTrainedBoxes(pCreature, DARK_ALL_BOXES)
        if trained >= 16 then
            darkSay(pCreature, "All 16 disciplines claimed. Return to the Gatekeeper. Revan Reborn waits.")
        else
            darkSay(pCreature, "You have claimed " .. trained .. "/16 disciplines. Use the training options to seize more power.")
        end
        return
    end

    if status ~= "knight" then
        darkSay(pCreature, "A Padawan dares approach me? Come back as a Knight.")
        return
    end

    if alignment ~= "dark" then
        darkSay(pCreature, "The light clings to you. Seek the Light Jedi Enclave.")
        return
    end

    local remaining = 150 - masterUsed
    if remaining > 0 then
        darkSay(pCreature, masterUsed .. "/150 holocrons consumed. " .. remaining .. " more are required.")
        darkSay(pCreature, "You must also reach Rank 10 of the Dark Council before the final trial is available.")
    else
        darkSay(pCreature, "You have consumed enough. Seek the Gatekeeper. The final trial awaits.")
    end
end

-- ============================================================
-- FRS PROMOTION
-- ============================================================

function enclave_terminal_frs_promotion(pCreature, pTerminal, pGhost)
    frs_request_promotion(pCreature, pTerminal, pGhost)
end