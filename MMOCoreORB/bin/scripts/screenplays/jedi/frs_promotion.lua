-- Coded by BoosterSteel 19-03-2026
--[[
    FRS Promotion System
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/frs_promotion.lua

    Replaces the vanilla vote-based FRS promotion system with a direct
    XP-gated promotion at the enclave terminals.

    Players select "Request Promotion" at their enclave terminal.
    If they have enough gcw_skill_xp for the next rank they are promoted
    immediately. No votes, no petitions, no council cap checks.

    XP requirements match frs_manager.lua lightRankingData/darkRankingData:
        Rank 0  (Novice)   -> Rank 1:   5,000 XP
        Rank 1  -> Rank 2:  15,000 XP
        Rank 2  -> Rank 3:  25,000 XP
        Rank 3  -> Rank 4:  35,000 XP
        Rank 4  -> Rank 5:  50,000 XP
        Rank 5  -> Rank 6:  70,000 XP
        Rank 6  -> Rank 7:  90,000 XP
        Rank 7  -> Rank 8: 130,000 XP
        Rank 8  -> Rank 9: 180,000 XP
        Rank 9  -> Rank 10: 250,000 XP
        Rank 10 -> Rank 11: 400,000 XP
]]

FrsPromotion = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "FrsPromotion",
}

registerScreenPlay("FrsPromotion", false)

-- ============================================================
-- RANK DATA
-- ============================================================

-- { requiredXP, lightSkill, darkSkill, lightRobe, darkRobe, lightTitle, darkTitle }
-- XP values taken directly from skills.iff XP_COST column
local RANK_DATA = {
    [1]  = { xp = 10000,  lightSkill = "force_rank_light_rank_01", darkSkill = "force_rank_dark_rank_01",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s02.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s02.iff",
             lightTitle = "Sentinel I",       darkTitle = "Sith Disciple I" },
    [2]  = { xp = 125000, lightSkill = "force_rank_light_rank_02", darkSkill = "force_rank_dark_rank_02",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s02.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s02.iff",
             lightTitle = "Sentinel II",      darkTitle = "Sith Disciple II" },
    [3]  = { xp = 175000, lightSkill = "force_rank_light_rank_03", darkSkill = "force_rank_dark_rank_03",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s02.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s02.iff",
             lightTitle = "Sentinel III",     darkTitle = "Sith Disciple III" },
    [4]  = { xp = 200000, lightSkill = "force_rank_light_rank_04", darkSkill = "force_rank_dark_rank_04",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s02.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s02.iff",
             lightTitle = "Sentinel IV",      darkTitle = "Sith Disciple IV" },
    [5]  = { xp = 200000, lightSkill = "force_rank_light_rank_05", darkSkill = "force_rank_dark_rank_05",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s03.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s03.iff",
             lightTitle = "Jedi Guardian",    darkTitle = "Sith Warrior" },
    [6]  = { xp = 225000, lightSkill = "force_rank_light_rank_06", darkSkill = "force_rank_dark_rank_06",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s03.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s03.iff",
             lightTitle = "Jedi Weaponmaster", darkTitle = "Sith Juggernaut" },
    [7]  = { xp = 225000, lightSkill = "force_rank_light_rank_07", darkSkill = "force_rank_dark_rank_07",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s03.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s03.iff",
             lightTitle = "Jedi Ace",         darkTitle = "Sith Destroyer" },
    [8]  = { xp = 250000, lightSkill = "force_rank_light_rank_08", darkSkill = "force_rank_dark_rank_08",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s04.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s04.iff",
             lightTitle = "Jedi Crusader",    darkTitle = "Sith Inquisitor" },
    [9]  = { xp = 275000, lightSkill = "force_rank_light_rank_09", darkSkill = "force_rank_dark_rank_09",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s04.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s04.iff",
             lightTitle = "Jedi Champion",    darkTitle = "Sith Champion" },
    [10] = { xp = 325000, lightSkill = "force_rank_light_rank_10", darkSkill = "force_rank_dark_rank_10",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s05.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s05.iff",
             lightTitle = "Jedi Master",      darkTitle = "Sith Lord" },
    [11] = { xp = 500000, lightSkill = "force_rank_light_master",  darkSkill = "force_rank_dark_master",
             lightRobe = "object/tangible/wearables/robe/robe_jedi_light_s05.iff",
             darkRobe  = "object/tangible/wearables/robe/robe_jedi_dark_s05.iff",
             lightTitle = "Jedi Grand Master", darkTitle = "Sith Dark Lord" },
}

-- ============================================================
-- HELPERS
-- ============================================================

-- Get FRS rank by checking which rank skill the player has
local function getFrsRank(pPlayer)
    -- Check from highest to lowest
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

-- Get council from JediTrials screenplay data (set during knight unlock)
local function getFrsCouncil(pPlayer)
    local council = tonumber(readScreenPlayData(pPlayer, "JediTrials", "JediCouncil"))
    if council ~= nil then return council end
    -- Fallback: check skills directly
    if CreatureObject(pPlayer):hasSkill("force_rank_dark_novice") then return 2 end
    if CreatureObject(pPlayer):hasSkill("force_rank_light_novice") then return 1 end
    return 0
end

-- Get gcw_skill_xp from player experience
local function getGcwSkillXp(pPlayer)
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return 0 end
    return PlayerObject(pGhost):getExperience("gcw_skill_xp") or 0
end

local function isDark(pPlayer)
    return getFrsCouncil(pPlayer) == 2
end

-- ============================================================
-- MAIN ENTRY — called from enclave terminal
-- ============================================================

function frs_request_promotion(pCreature, pTerminal, pGhost)
    if pCreature == nil then return end

    local rank = getFrsRank(pCreature)

    -- Not in FRS
    if rank < 0 or not (CreatureObject(pCreature):hasSkill("force_rank_light_novice") or
                        CreatureObject(pCreature):hasSkill("force_rank_dark_novice")) then
        CreatureObject(pCreature):sendSystemMessage("You are not yet a member of a Force council. Complete the Knight trials first.")
        return
    end

    -- Already at max rank
    if rank >= 11 then
        if isDark(pCreature) then
            CreatureObject(pCreature):sendSystemMessage("\\\\#FF4444 You have reached the pinnacle of the Dark Council. There are no further ranks.")
        else
            CreatureObject(pCreature):sendSystemMessage("\\\\#88CCFF You stand at the pinnacle of the Jedi Council. There are no further ranks.")
        end
        return
    end

    local nextRank = rank + 1
    local data = RANK_DATA[nextRank]
    local xp = getGcwSkillXp(pCreature)
    local dark = isDark(pCreature)
    local title = dark and data.darkTitle or data.lightTitle
    local name = CreatureObject(pCreature):getFirstName()

    if xp < data.xp then
        -- Not enough XP
        local needed = data.xp - xp
        if dark then
            CreatureObject(pCreature):sendSystemMessage("\\\\#FF4444 You are not yet worthy of the rank of " .. title .. ". You need " .. needed .. " more GCW Skill XP.")
        else
            CreatureObject(pCreature):sendSystemMessage("\\\\#88CCFF The Council has reviewed your deeds. You need " .. needed .. " more GCW Skill XP to reach the rank of " .. title .. ".")
        end
        return
    end

    -- Eligible - show confirmation SUI
    writeScreenPlayData(pCreature, "FrsPromotion", "pending_rank", tostring(nextRank))

    local sui = SuiMessageBox.new("FrsPromotion", "onPromotionConfirm")
    if dark then
        sui.setTitle("Dark Council Promotion")
        sui.setPrompt(name .. ", your deeds have been measured.\\n\\nYou have earned " .. xp .. " GCW Skill XP.\\n\\nThe Dark Council grants you the rank of:\\n\\n" .. title .. "\\n\\nDo you accept this promotion?")
        sui.setOkButtonText("I accept")
        sui.setCancelButtonText("Not yet")
    else
        sui.setTitle("Jedi Council Promotion")
        sui.setPrompt(name .. ", the Council has deliberated.\\n\\nYou have earned " .. xp .. " GCW Skill XP.\\n\\nIt is the Council's decision to grant you the rank of:\\n\\n" .. title .. "\\n\\nMay the Force be with you.")
        sui.setOkButtonText("I accept")
        sui.setCancelButtonText("Not yet")
    end
    sui.sendTo(pCreature)
end

-- ============================================================
-- PROMOTION CONFIRMED
-- ============================================================

function FrsPromotion:onPromotionConfirm(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    if eventIndex == 1 then return end -- cancelled

    local nextRank = tonumber(readScreenPlayData(pPlayer, "FrsPromotion", "pending_rank"))
    if nextRank == nil or nextRank < 1 or nextRank > 11 then return end

    local data = RANK_DATA[nextRank]
    local dark = isDark(pPlayer)
    local skill = dark and data.darkSkill or data.lightSkill
    local robe  = dark and data.darkRobe  or data.lightRobe
    local title = dark and data.darkTitle or data.lightTitle
    local name  = CreatureObject(pPlayer):getFirstName()

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    -- Grant the rank skill
    if not CreatureObject(pPlayer):hasSkill(skill) then
        awardSkill(pPlayer, skill)
    end

    -- Update FRS rank
    PlayerObject(pGhost):setFrsRank(nextRank)

    -- Give rank robe
    local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
    if pInventory ~= nil and not SceneObject(pInventory):isContainerFullRecursive() then
        giveItem(pInventory, robe, -1)
    end

    -- Play music and send congratulations
    if dark then
        CreatureObject(pPlayer):playMusicMessage("sound/music_themequest_victory_imperial.snd")
        CreatureObject(pPlayer):sendSystemMessage("\\\\#FF4444 The Dark Council recognises your power. You are now " .. title .. ", " .. name .. ". Serve the darkness well.")
    else
        CreatureObject(pPlayer):playMusicMessage("sound/music_themequest_victory_rebel.snd")
        CreatureObject(pPlayer):sendSystemMessage("\\\\#88CCFF The Jedi Council is honoured to grant you the rank of " .. title .. ", " .. name .. ". May the Force guide your path.")
    end

    -- Check if imperial squad should now start hunting (rank 8+)
    if nextRank >= 8 then
        createEvent(2000, "JediVisibilityHunters", "checkFrsRank", pPlayer, "")
    end

    writeScreenPlayData(pPlayer, "FrsPromotion", "pending_rank", "0")
end


-- ============================================================
-- MASTER DISCIPLINE TRAINER
-- Called from EnclaveTerminalMenuComponent selectedID 83
-- Grants the next untrained GJM or DJL box using jedi_general XP
-- ============================================================

-- { xpCost, lightSkill, darkSkill, lightTitle, darkTitle }
local MASTER_RANK_DATA = {
    [1]  = { xp = 750000,   lightSkill = "jedi_grand_master_1",  darkSkill = "jedi_dark_lord_1",  lightTitle = "Grand Master I",   darkTitle = "Dark Lord I"   },
    [2]  = { xp = 1000000,  lightSkill = "jedi_grand_master_2",  darkSkill = "jedi_dark_lord_2",  lightTitle = "Grand Master II",  darkTitle = "Dark Lord II"  },
    [3]  = { xp = 1500000,  lightSkill = "jedi_grand_master_3",  darkSkill = "jedi_dark_lord_3",  lightTitle = "Grand Master III", darkTitle = "Dark Lord III" },
    [4]  = { xp = 1000000,  lightSkill = "jedi_grand_master_4",  darkSkill = "jedi_dark_lord_4",  lightTitle = "Grand Master IV",  darkTitle = "Dark Lord IV"  },
    [5]  = { xp = 1000000,  lightSkill = "jedi_grand_master_5",  darkSkill = "jedi_dark_lord_5",  lightTitle = "Grand Master V",   darkTitle = "Dark Lord V"   },
    [6]  = { xp = 1000000,  lightSkill = "jedi_grand_master_6",  darkSkill = "jedi_dark_lord_6",  lightTitle = "Grand Master VI",  darkTitle = "Dark Lord VI"  },
    [7]  = { xp = 1000000,  lightSkill = "jedi_grand_master_7",  darkSkill = "jedi_dark_lord_7",  lightTitle = "Grand Master VII", darkTitle = "Dark Lord VII" },
    [8]  = { xp = 1000000,  lightSkill = "jedi_grand_master_8",  darkSkill = "jedi_dark_lord_8",  lightTitle = "Grand Master VIII",darkTitle = "Dark Lord VIII"},
    [9]  = { xp = 1000000,  lightSkill = "jedi_grand_master_9",  darkSkill = "jedi_dark_lord_9",  lightTitle = "Grand Master IX",  darkTitle = "Dark Lord IX"  },
    [10] = { xp = 1000000,  lightSkill = "jedi_grand_master_10", darkSkill = "jedi_dark_lord_10", lightTitle = "Grand Master X",   darkTitle = "Dark Lord X"   },
}

function frs_train_master(pPlayer, pTerminal, pGhost)
    if pPlayer == nil or pGhost == nil then return end

    local name      = CreatureObject(pPlayer):getFirstName()
    local alignment = readScreenPlayData(pPlayer, "HolocronJedi", "jedi_alignment")
    local status    = readScreenPlayData(pPlayer, "HolocronJedi", "jedi_status")
    local dark      = (alignment == "dark")

    if status ~= "master_phase2" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 You must first complete the initial Master trial before training these disciplines.")
        return
    end

    -- Find next untrained box
    local nextBox = nil
    local nextData = nil
    for i = 1, 10 do
        local data = MASTER_RANK_DATA[i]
        local skill = dark and data.darkSkill or data.lightSkill
        if not CreatureObject(pPlayer):hasSkill(skill) then
            nextBox = i
            nextData = data
            break
        end
    end

    if nextBox == nil then
        -- All 10 trained - check if final trial is available
        if dark then
            CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 You have trained all Dark Lord disciplines. Return to your holocron and speak to the Gatekeeper to face the Final Trial.")
        else
            CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF You have trained all Grand Master disciplines. Return to your holocron and speak to the Gatekeeper to face the Final Trial.")
        end
        return
    end

    local skill     = dark and nextData.darkSkill  or nextData.lightSkill
    local title     = dark and nextData.darkTitle  or nextData.lightTitle
    local xpCost    = nextData.xp

    -- Grant skill directly - XP cost enforced by skills.iff prerequisites
    if not CreatureObject(pPlayer):hasSkill(skill) then
        awardSkill(pPlayer, skill)
    end

    if dark then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 You have seized the discipline of " .. title .. ", " .. name .. ". The dark side grows stronger in you.")
    else
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF You have mastered the discipline of " .. title .. ", " .. name .. ". The Force flows through you.")
    end

    -- If box 10 just trained, tell them to seek the gatekeeper
    if nextBox == 10 then
        if dark then
            CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 All Dark Lord disciplines seized. Your holocron awaits. Speak to the Gatekeeper to face the Final Trial.")
        else
            CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF All Grand Master disciplines mastered. Your holocron awaits. Speak to the Gatekeeper to face the Final Trial.")
        end
    end
end