--[[
    Aftermath Server - Dark Jedi Enclave: Dark Lord Trial NPC
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/dark_enclave_master.lua

    NPC: Dark Council Sovereign (separate from Knight trial Dark Arbiter)
    Placed deeper inside the Dark Jedi Enclave on Yavin 4.

    Alignment strict — only Dark-aligned Knights may complete this trial.
    A Light Knight who enters is turned away with contempt.

    Master Requirements:
        - jedi_status == "knight"
        - jedi_alignment == "dark"
        - 100 holocrons consumed (master_holocrons_used >= 100)
        - 2500 FS NPC kills (master_fs_kills >= 2500)
        - 2x frn_all_holocron_cube
        - 2x frn_all_holocron_dode
        - 2x frn_all_holocron_triangle

    NPC Template (existing asset):
        dressed_human_male_dark_jedi_master_01  (or sith_inquisitor)
--]]

DarkEnclaveMaster = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "DarkEnclaveMaster",
}

registerScreenPlay("DarkEnclaveMaster", true)

-- ============================================================
-- CONFIGURATION
-- ============================================================

local HOLOCRON_CUBE_TEMPLATE     = "object/tangible/furniture/all/frn_all_holocron_cube.iff"
local HOLOCRON_DODE_TEMPLATE     = "object/tangible/furniture/all/frn_all_holocron_dode.iff"
local HOLOCRON_TRIANGLE_TEMPLATE = "object/tangible/furniture/all/frn_all_holocron_triangle.iff"

local MASTER_HOLOCRONS_REQUIRED = 100
local MASTER_FS_KILLS_REQUIRED  = 2500

-- ============================================================
-- UTILITY
-- ============================================================

local function getPlayerVar(pGhost, varName, default)
    if pGhost == nil then return default end
    local val = PlayerObject(pGhost):getScreenPlayState(varName)
    if val == nil or val == "" then return default end
    return tonumber(val) or val
end

local function setPlayerVar(pGhost, varName, value)
    if pGhost == nil then return end
    PlayerObject(pGhost):setScreenPlayState(varName, tostring(value))
end

local function countItemInInventory(pCreature, template)
    local inventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if inventory == nil then return 0 end

    local count = 0
    local invSize = SceneObject(inventory):getContainerObjectsSize()

    for i = 0, invSize - 1 do
        local pItem = SceneObject(inventory):getContainerObject(i)
        if pItem ~= nil then
            if SceneObject(pItem):getObjectTemplate() == template then
                count = count + 1
            end
        end
    end

    return count
end

local function consumeItems(pCreature, template, needed)
    local inventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if inventory == nil then return false end

    local toRemove = {}
    local invSize = SceneObject(inventory):getContainerObjectsSize()

    for i = 0, invSize - 1 do
        if #toRemove >= needed then break end
        local pItem = SceneObject(inventory):getContainerObject(i)
        if pItem ~= nil then
            if SceneObject(pItem):getObjectTemplate() == template then
                table.insert(toRemove, pItem)
            end
        end
    end

    if #toRemove < needed then return false end

    for _, pItem in ipairs(toRemove) do
        SceneObject(pItem):destroyObjectFromWorld()
    end

    return true
end

local function checkAllRequirements(pCreature, pGhost)
    local req = {
        isKnight  = getPlayerVar(pGhost, "jedi_status", "none") == "knight",
        isDark    = getPlayerVar(pGhost, "jedi_alignment", "none") == "dark",
        holocrons = getPlayerVar(pGhost, "master_holocrons_used", 0),
        fsKills   = getPlayerVar(pGhost, "master_fs_kills", 0),
    }

    req.cubeCount     = countItemInInventory(pCreature, HOLOCRON_CUBE_TEMPLATE)
    req.dodeCount     = countItemInInventory(pCreature, HOLOCRON_DODE_TEMPLATE)
    req.triangleCount = countItemInInventory(pCreature, HOLOCRON_TRIANGLE_TEMPLATE)

    req.holocronsOk = req.holocrons >= MASTER_HOLOCRONS_REQUIRED
    req.killsOk     = req.fsKills >= MASTER_FS_KILLS_REQUIRED
    req.cubeOk      = req.cubeCount >= 2
    req.dodeOk      = req.dodeCount >= 2
    req.triangleOk  = req.triangleCount >= 2

    req.allMet = req.isKnight
             and req.isDark
             and req.holocronsOk
             and req.killsOk
             and req.cubeOk
             and req.dodeOk
             and req.triangleOk

    return req
end

local function buildRequirementsReport(req)
    local lines = {}

    if not req.isKnight then
        table.insert(lines, "  - You have not achieved the rank of Dark Jedi Knight. You are nothing yet.")
    end
    if not req.holocronsOk then
        table.insert(lines, "  - Holocrons consumed: " .. req.holocrons .. "/" .. MASTER_HOLOCRONS_REQUIRED .. " — Your knowledge is shallow.")
    end
    if not req.killsOk then
        table.insert(lines, "  - Force-sensitive enemies destroyed: " .. req.fsKills .. "/" .. MASTER_FS_KILLS_REQUIRED .. " — Your hands are not yet sufficiently bloodied.")
    end
    if not req.cubeOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Cubes: " .. req.cubeCount .. "/2 — Missing.")
    end
    if not req.dodeOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Dodecahedra: " .. req.dodeCount .. "/2 — Missing.")
    end
    if not req.triangleOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Triangles: " .. req.triangleCount .. "/2 — Missing.")
    end

    return table.concat(lines, "\n")
end

-- ============================================================
-- CONVERSATION ENTRY POINT
-- ============================================================

function DarkEnclaveMaster:triggerConversation(pPlayer, pNPC)
    if pPlayer == nil or pNPC == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local jediStatus    = getPlayerVar(pGhost, "jedi_status", "none")
    local jediAlignment = getPlayerVar(pGhost, "jedi_alignment", "none")

    -- Already a Master
    if jediStatus == "master" then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: You have already claimed everything this path offers. Do not come to me seeking validation. Go. Dominate.")
        return
    end

    -- Not yet a Knight
    if jediStatus ~= "knight" then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: A Knight has not yet been made of you. You are beneath this conversation. Leave.")
        return
    end

    -- Wrong alignment — Light Knight entered Dark enclave
    if jediAlignment ~= "dark" then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: The light clings to you like a disease. You do not belong here. Get out before I lose my patience.")
        return
    end

    setPlayerVar(pGhost, "dark_master_npc_id", SceneObject(pNPC):getObjectID())

    self:openGreeting(pPlayer, pNPC, pGhost)
end

-- ============================================================
-- DIALOGUE
-- ============================================================

function DarkEnclaveMaster:openGreeting(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    local greeting = ""
    if req.allMet then
        greeting = "\\#AA00AA[Dark Council Sovereign]: So you have actually arrived.\n\nMost who begin this path consume themselves long before reaching this chamber. The Dark Side is not generous — it takes everything and offers power only to those who can bear the weight of it.\n\nYou are still standing. That alone is notable.\n\nBut standing is not enough. Tell me — what do you want from the darkness? And do you have the strength to take it?"
    else
        greeting = "\\#AA00AA[Dark Council Sovereign]: You come before me incomplete.\n\nThe Dark Side does not elevate the unfinished. It devours them.\n\nYou have not yet done what is required. Return when you have. Or do not return at all — that would also be an answer."
    end

    CreatureObject(pPlayer):sendSystemMessage(greeting)

    if req.allMet then
        self:showReadyOptions(pPlayer, pNPC, pGhost)
    else
        self:showProgressOptions(pPlayer, pNPC, pGhost, req)
    end
end

function DarkEnclaveMaster:showProgressOptions(pPlayer, pNPC, pGhost, req)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Path to Dark Lordship", "State your purpose.")

    sui:addMenuItem("Tell me what I still lack.")
    sui:addMenuItem("What does it mean to be a Dark Lord?")
    sui:addMenuItem("I will return stronger.")

    sui:setCallback("DarkEnclaveMaster", "onProgressChoice")
    sui:display()
end

function DarkEnclaveMaster:onProgressChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local req = checkAllRequirements(pPlayer, pGhost)

    if selectedIndex == 0 then
        local report = buildRequirementsReport(req)
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Your deficiencies. Memorise them.\n\n" .. report .. "\n\nEvery one of these represents a failure of will or effort. Correct them.")

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: A Dark Lord does not serve the Dark Side. The Dark Lord IS the Dark Side — its instrument, its voice, its hand in the galaxy.\n\nTo reach this you must have consumed one hundred holocrons completely. Not studied — consumed. Bled them of everything.\n\nYou must have destroyed two thousand five hundred Force-sensitive enemies. Not defeated. Destroyed. There is a distinction and the Dark Side knows it.\n\nAnd you must bring six ancient Jedaii relics — Cubes, Dodecahedra, Triangles — torn from the oldest chapters of Force history. The Dark Side demands proof that you have reached into the past and seized something from it.\n\nThis title is not given. It is taken. Everything in this path is taken.\n\nAre you capable of taking it?")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Good. At least you know your own limitations. Most never reach even that level of self-awareness.")
    end
end

function DarkEnclaveMaster:showReadyOptions(pPlayer, pNPC, pGhost)
    local sui = SuiListBox.new(pPlayer, pNPC, "Claim the Dark Lordship", "State your purpose.")

    sui:addMenuItem("I want the power. I am ready to claim it.")
    sui:addMenuItem("Tell me what this will cost me.")
    sui:addMenuItem("I am not yet ready.")

    sui:setCallback("DarkEnclaveMaster", "onReadyChoice")
    sui:display()
end

function DarkEnclaveMaster:onReadyChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        self:showFinalConfirmation(pPlayer, pNPC, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Cost.\n\nAn interesting word. The Dark Side does not deal in costs — it deals in transformations.\n\nThe six Jedaii relics you carry will be consumed by the Dark Side entirely. Not taken by me — consumed by the darkness itself as proof of your worthiness.\n\nWhat you receive in return cannot be measured in credits or power alone. You will be changed at a level that cannot be undone.\n\nIf that concerns you, you were never worthy of this to begin with.")

        createEvent(1500, "DarkEnclaveMaster", "reshowReadyOptions", pPlayer, "")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Then leave. Do not waste what little patience I possess.")
    end
end

function DarkEnclaveMaster:reshowReadyOptions(pPlayer, params)
    if pPlayer == nil then return end
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end
    local npcID = getPlayerVar(pGhost, "dark_master_npc_id", 0)
    local pNPC = npcID ~= 0 and getSceneObject(npcID) or nil
    self:showReadyOptions(pPlayer, pNPC, pGhost)
end

function DarkEnclaveMaster:showFinalConfirmation(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    local itemSummary = "Ancient Jedaii Holocron Cubes: " .. req.cubeCount .. "/2\n"
                     .. "Ancient Jedaii Holocron Dodecahedra: " .. req.dodeCount .. "/2\n"
                     .. "Ancient Jedaii Holocron Triangles: " .. req.triangleCount .. "/2"

    CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: You carry what is required.\n\n" .. itemSummary .. "\n\nThey will be taken by the Dark Side and nothing will remain of them. This is permanent and absolute.\n\nDo you surrender them?")

    local sui = SuiListBox.new(pPlayer, pNPC, "Final Surrender", "Do you surrender the relics to the Dark Side?")
    sui:addMenuItem("Yes. Take them. Give me what I have earned.")
    sui:addMenuItem("Not yet.")

    sui:setCallback("DarkEnclaveMaster", "onFinalConfirmation")
    sui:display()
end

function DarkEnclaveMaster:onFinalConfirmation(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        local req = checkAllRequirements(pPlayer, pGhost)

        if not req.allMet then
            CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Your requirements are no longer met. Did you lose your nerve and discard your relics? Come back when you are actually prepared — and do not waste my time again.")
            return
        end

        local cubeOk     = consumeItems(pPlayer, HOLOCRON_CUBE_TEMPLATE, 2)
        local dodeOk     = consumeItems(pPlayer, HOLOCRON_DODE_TEMPLATE, 2)
        local triangleOk = consumeItems(pPlayer, HOLOCRON_TRIANGLE_TEMPLATE, 2)

        if not (cubeOk and dodeOk and triangleOk) then
            CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: You are missing relics. Two Cubes. Two Dodecahedra. Two Triangles. Do not return until you can count.")
            return
        end

        self:grantDarkLordship(pPlayer, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: Hesitation. The one weakness the Dark Side has no tolerance for. Do not make a habit of it.")
    end
end

-- ============================================================
-- GRANT DARK LORDSHIP — staged ceremony
-- ============================================================

function DarkEnclaveMaster:grantDarkLordship(pPlayer, pGhost)
    createEvent(500, "DarkEnclaveMaster", "ceremony_step1", pPlayer, "")
end

function DarkEnclaveMaster:ceremony_step1(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#660000 The Sovereign's eyes go cold and distant. The shadows in the enclave deepen unnaturally. The air itself seems to recoil.")
    createEvent(3000, "DarkEnclaveMaster", "ceremony_step2", pPlayer, "")
end

function DarkEnclaveMaster:ceremony_step2(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#AA0000 The Dark Side surges through the chamber. You feel it pressing against every part of you — not warmly, but with absolute authority. Testing. Measuring. Deciding.")
    createEvent(3000, "DarkEnclaveMaster", "ceremony_step3", pPlayer, "")
end

function DarkEnclaveMaster:ceremony_step3(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#AA00AA[Dark Council Sovereign]: The Dark Side has measured you.\n\nIt is... satisfied.\n\nRise, Dark Lord. The darkness is yours now. All of it. Do not squander what it has cost you to reach this moment.")
    createEvent(3000, "DarkEnclaveMaster", "ceremony_step4", pPlayer, "")
end

function DarkEnclaveMaster:ceremony_step4(pPlayer, params)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    -- Grant Master status via holocron.lua
    holocron_grant_master(pPlayer)

    -- Dark side music sting
    local pmm = PlayMusicMessage("sound/music_become_dark_jedi.snd")
    PlayerObject(pGhost):sendMessage(pmm)

    CreatureObject(pPlayer):sendSystemMessage("\\#FF0000 The Dark Side flows through you completely. You are a Dark Lord.")
end
