--[[
    Aftermath Server - Dark Jedi Enclave: Knight Trial NPC
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/dark_enclave_knight.lua

    NPC: Dark Council Arbiter (spawned inside Dark Jedi Enclave, Yavin 4)
    Uses existing in-game NPC asset: dark_jedi_master or sith_inquisitor

    Same Knight Requirements as Light side — different dialogue tone.
    Cold, contemptuous, respects only demonstrated power.

    NPC Template options (existing in-game assets):
        object/mobile/dressed_human_male_dark_jedi_master_01.iff
        object/mobile/dark_jedi_master.iff
        object/mobile/sith_inquisitor.iff
--]]

DarkEnclaveKnight = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "DarkEnclaveKnight",
}

registerScreenPlay("DarkEnclaveKnight", true)

-- ============================================================
-- CONFIGURATION (mirrors light side)
-- ============================================================

local KRAYT_PEARL_TEMPLATE    = "object/tangible/component/weapon/lightsaber/lightsaber_module_krayt_dragon_pearl.iff"
local FORCE_CRYSTAL_TEMPLATES = {
    "object/tangible/component/weapon/lightsaber/lightsaber_lance_module_force_crystal.iff",
}

local ITEMS_REQUIRED = 50

-- ============================================================
-- UTILITY (duplicated here for self-contained script)
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

local function countMasteredJediTrees(pCreature)
    local JEDI_TREE_MASTER_BOX = {
        "force_discipline_light_saber_4",
        "force_discipline_defender_4",
        "force_discipline_healing_4",
        "force_discipline_powers_4",
        "force_discipline_enhancements_4",
        "force_discipline_alteration_4",
        "force_discipline_senses_4",
        "force_discipline_combat_powers_4",
        "force_discipline_dark_side_4",
    }
    local count = 0
    for _, box in ipairs(JEDI_TREE_MASTER_BOX) do
        if CreatureObject(pCreature):hasSkill(box) then
            count = count + 1
        end
    end
    return count
end

local function isAcceptedItem(template)
    if template == KRAYT_PEARL_TEMPLATE then return true end
    for _, crystalTemplate in ipairs(FORCE_CRYSTAL_TEMPLATES) do
        if template == crystalTemplate then return true end
    end
    return false
end

local function countTurnInItems(pCreature)
    local inventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if inventory == nil then return 0 end

    local count = 0
    local invSize = SceneObject(inventory):getContainerObjectsSize()

    for i = 0, invSize - 1 do
        local pItem = SceneObject(inventory):getContainerObject(i)
        if pItem ~= nil then
            local template = SceneObject(pItem):getObjectTemplate()
            if isAcceptedItem(template) then
                count = count + 1
            end
        end
    end

    return count
end

local function consumeTurnInItems(pCreature)
    local inventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if inventory == nil then return false end

    local removed = 0
    local toRemove = {}
    local invSize = SceneObject(inventory):getContainerObjectsSize()

    for i = 0, invSize - 1 do
        if removed >= ITEMS_REQUIRED then break end
        local pItem = SceneObject(inventory):getContainerObject(i)
        if pItem ~= nil then
            local template = SceneObject(pItem):getObjectTemplate()
            if isAcceptedItem(template) then
                table.insert(toRemove, pItem)
                removed = removed + 1
            end
        end
    end

    if removed < ITEMS_REQUIRED then return false end

    for _, pItem in ipairs(toRemove) do
        SceneObject(pItem):destroyObjectFromWorld()
    end

    return true
end

local function checkAllRequirements(pCreature, pGhost)
    local status = {
        isPadawan       = getPlayerVar(pGhost, "jedi_status", "none") == "padawan",
        masteredTrees   = countMasteredJediTrees(pCreature),
        knightPoints    = getPlayerVar(pGhost, "knight_points", 0),
        fsKills         = getPlayerVar(pGhost, "knight_fs_kills", 0),
        holocronsUsed   = getPlayerVar(pGhost, "knight_holocrons_used", 0),
        itemCount       = countTurnInItems(pCreature),
        alreadyKnight   = getPlayerVar(pGhost, "jedi_status", "none") == "knight",
        alreadyMaster   = getPlayerVar(pGhost, "jedi_status", "none") == "master",
    }

    status.treesOk      = status.masteredTrees >= 3
    status.pointsOk     = status.knightPoints >= 25000
    status.killsOk      = status.fsKills >= 100
    status.holocronsOk  = status.holocronsUsed >= 20
    status.itemsOk      = status.itemCount >= ITEMS_REQUIRED

    status.allMet = status.isPadawan
                and status.treesOk
                and status.pointsOk
                and status.killsOk
                and status.holocronsOk
                and status.itemsOk

    return status
end

local function buildRequirementsReport(req)
    local lines = {}

    if not req.isPadawan then
        table.insert(lines, "  - You have not yet claimed your birthright as a Padawan. Pathetic.")
    end
    if not req.treesOk then
        table.insert(lines, "  - Mastered Force disciplines: " .. req.masteredTrees .. "/3 — Your power is insufficient.")
    end
    if not req.pointsOk then
        table.insert(lines, "  - Force attunement: " .. req.knightPoints .. "/100,000 — You lack the depth of power required.")
    end
    if not req.killsOk then
        table.insert(lines, "  - Force-sensitive adversaries destroyed: " .. req.fsKills .. "/100 — You have not proven yourself in blood.")
    end
    if not req.holocronsOk then
        table.insert(lines, "  - Holocrons consumed: " .. req.holocronsUsed .. "/20 — You have not absorbed enough of the old knowledge.")
    end
    if not req.itemsOk then
        table.insert(lines, "  - Tribute presented: " .. req.itemCount .. "/50 — You arrive before me empty-handed.")
    end

    return table.concat(lines, "\n")
end

-- ============================================================
-- CONVERSATION ENTRY POINT
-- ============================================================

function DarkEnclaveKnight:triggerConversation(pPlayer, pNPC)
    if pPlayer == nil or pNPC == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local jediStatus = getPlayerVar(pGhost, "jedi_status", "none")

    if jediStatus == "knight" or jediStatus == "master" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: You have already claimed your rank. Do not waste my time with sentimentality. Go. Grow stronger.")
        return
    end

    if jediStatus ~= "padawan" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: You have not yet awakened. You are nothing. Come back when you have at least taken the first step.")
        return
    end

    -- Store NPC ID for later use
    if pNPC ~= nil then
        setPlayerVar(pGhost, "dark_enclave_npc_id", SceneObject(pNPC):getObjectID())
    end

    self:openGreeting(pPlayer, pNPC, pGhost)
end

-- ============================================================
-- DIALOGUE SCREENS
-- ============================================================

function DarkEnclaveKnight:openGreeting(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    local greeting = ""
    if req.allMet then
        greeting = "\\#FF4444[Dark Arbiter]: So. You have actually done it.\n\nI have observed many Padawans who believed themselves ready for this moment. Most were not. They withered under the weight of what was demanded.\n\nBut you stand here. And the Dark Side does not lie about strength.\n\nSpeak your purpose. I will judge whether you are worthy of the rank you seek."
    else
        greeting = "\\#FF4444[Dark Arbiter]: You come before me unprepared.\n\nPower is not given — it is seized. It is earned through suffering, discipline, and the destruction of weakness.\n\nYou are not yet what this rank requires. But perhaps you are capable of becoming so.\n\nOr perhaps you are simply wasting my time."
    end

    CreatureObject(pPlayer):sendSystemMessage(greeting)

    if req.allMet then
        self:showReadyOptions(pPlayer, pNPC, pGhost, req)
    else
        self:showProgressOptions(pPlayer, pNPC, pGhost, req)
    end
end

-- Options when NOT ready
function DarkEnclaveKnight:showProgressOptions(pPlayer, pNPC, pGhost, req)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Path to Dark Knighthood", "State your purpose.")

    sui:addMenuItem("Tell me what I am still lacking.")
    sui:addMenuItem("What does it mean to be a Dark Jedi Knight?")
    sui:addMenuItem("I will return when I have grown stronger.")

    sui:setCallback("DarkEnclaveKnight", "onProgressChoice")
    sui:display()
end

function DarkEnclaveKnight:onProgressChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local req = checkAllRequirements(pPlayer, pGhost)

    if selectedIndex == 0 then
        local report = buildRequirementsReport(req)
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: Your deficiencies are as follows. Do not return until they are corrected.\n\n" .. report)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: A Dark Jedi Knight answers to no one but the Dark Side itself.\n\nTo reach this rank you must have crushed three Force disciplines completely within yourself — not dabbled, not sampled. Mastered.\n\nYou must have bled twenty holocrons of their secrets. You must have destroyed one hundred Force-sensitive opponents — not defeated, destroyed. There is a difference.\n\nAnd you will present fifty tributes — Krayt Dragon Pearls and Force Crystals — stripped from the galaxy by your own effort. Proof that you take what you desire.\n\nDo this. Then return.")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: Good. Knowing your limitations is at least a sign of basic intelligence. Do not mistake patience for weakness — mine or your own.")
    end
end

-- Options when ready
function DarkEnclaveKnight:showReadyOptions(pPlayer, pNPC, pGhost, req)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Dark Knight Trials", "State your purpose.")

    sui:addMenuItem("I am ready. I claim the rank of Dark Jedi Knight.")
    sui:addMenuItem("What does this rank mean for my path ahead?")
    sui:addMenuItem("I am not yet ready to commit.")

    sui:setCallback("DarkEnclaveKnight", "onReadyChoice")
    sui:display()
end

function DarkEnclaveKnight:onReadyChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        self:showFinalConfirmation(pPlayer, pNPC, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: As a Dark Jedi Knight you are no longer constrained by the hand-holding of early training.\n\nThe Dark Side will demand more of you. Greater sacrifices. Greater destruction. Greater power in return.\n\nYou will be a weapon. Not a tool — a weapon of your own making, beholden only to your own ambition and the will of the Force.\n\nThe weak will fear you. That is as it should be.")

        createEvent(1500, "DarkEnclaveKnight", "reshowReadyOptions", pPlayer, "")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: Hesitation. How disappointing.\n\nThe Dark Side does not wait for the indecisive. Return when your resolve has hardened — if it ever does.")
    end
end

function DarkEnclaveKnight:reshowReadyOptions(pPlayer, params)
    if pPlayer == nil then return end
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end
    local req = checkAllRequirements(pPlayer, pGhost)
    local npcID = getPlayerVar(pGhost, "dark_enclave_npc_id", 0)
    local pNPC = npcID ~= 0 and getSceneObject(npcID) or nil
    self:showReadyOptions(pPlayer, pNPC, pGhost, req)
end

-- Final confirmation
function DarkEnclaveKnight:showFinalConfirmation(pPlayer, pNPC, pGhost)
    local itemCount = countTurnInItems(pPlayer)

    local confirmMsg = "\\#FF4444[Dark Arbiter]: You carry " .. itemCount .. " tributes. I require fifty.\n\nThey will be taken. They will not be returned. This is the price of what you are about to become.\n\nAre you certain? Once begun, this cannot be undone."

    CreatureObject(pPlayer):sendSystemMessage(confirmMsg)

    local sui = SuiListBox.new(pPlayer, pNPC, "Claim Your Rank", "Do you present your tribute?")
    sui:addMenuItem("Yes. Take them. I claim my rank.")
    sui:addMenuItem("I need more time.")

    sui:setCallback("DarkEnclaveKnight", "onFinalConfirmation")
    sui:display()
end

function DarkEnclaveKnight:onFinalConfirmation(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        local req = checkAllRequirements(pPlayer, pGhost)

        if not req.allMet then
            CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: Your requirements are no longer met. Did you lose your nerve and drop your tribute? Come back when you are actually prepared.")
            return
        end

        local success = consumeTurnInItems(pPlayer)
        if not success then
            CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: You do not have enough tribute. Fifty. Do not return until you can count.")
            return
        end

        self:grantDarkKnighthood(pPlayer, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: More time. Of course.\n\nDo not take too long. Patience has its limits — even mine.")
    end
end

-- ============================================================
-- GRANT DARK KNIGHTHOOD
-- ============================================================

function DarkEnclaveKnight:grantDarkKnighthood(pPlayer, pGhost)
    createEvent(500, "DarkEnclaveKnight", "doKnighthoodCeremony", pPlayer, "")
end

function DarkEnclaveKnight:doKnighthoodCeremony(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FF0000 The Dark Arbiter's eyes narrow. The air in the enclave grows heavy, charged with dark energy.")
    createEvent(2500, "DarkEnclaveKnight", "ceremony_step2", pPlayer, "")
end

function DarkEnclaveKnight:ceremony_step2(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FF4444[Dark Arbiter]: The Dark Side has weighed you.\n\nIt finds you... acceptable.\n\nRise, Dark Jedi Knight. Bow to nothing. Fear nothing. Destroy everything that stands between you and greater power.")
    createEvent(3000, "DarkEnclaveKnight", "ceremony_step3", pPlayer, "")
end

function DarkEnclaveKnight:ceremony_step3(pPlayer, params)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    holocron_grant_knight(pPlayer, "dark")

    CreatureObject(pPlayer):sendSystemMessage("\\#FF0000 The Dark Side surges through you. You are a Dark Jedi Knight.")
end
