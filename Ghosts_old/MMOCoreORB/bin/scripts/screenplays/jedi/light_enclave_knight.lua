--[[
    Aftermath Server - Light Jedi Enclave: Knight Trial NPC
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/light_enclave_knight.lua

    NPC: Jedi Council Elder (spawned inside Light Jedi Enclave, Yavin 4)
    Uses existing in-game NPC asset: jedi_knight_human_male or jedi_master

    Knight Requirements checked here:
        - Padawan status
        - 3 mastered Jedi/FS skill trees
        - 100,000 knight points
        - 100 FS NPC kills
        - 20 holocrons consumed
        - 50 Krayt Dragon Pearls + Force Crystals (any combo, total = 50)

    Spawn this NPC in the Light Jedi Enclave on Yavin 4 via a spawn region
    or directly via screenplays/jedi/enclave_spawns.lua (created separately)

    NPC Template options (existing in-game assets, no custom models needed):
        object/mobile/dressed_human_male_jedi_council_01.iff
        object/mobile/dressed_human_male_jedi_master_01.iff
        object/mobile/jedi_knight_human_male.iff
--]]

LightEnclaveKnight = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "LightEnclaveKnight",
}

registerScreenPlay("LightEnclaveKnight", true)

-- ============================================================
-- CONFIGURATION
-- ============================================================

-- Item templates accepted as turn-ins
local KRAYT_PEARL_TEMPLATE    = "object/tangible/component/weapon/lightsaber/lightsaber_module_krayt_dragon_pearl.iff"
local FORCE_CRYSTAL_TEMPLATES = {
    "object/tangible/component/weapon/lightsaber/lightsaber_lance_module_force_crystal.iff",
}

local ITEMS_REQUIRED = 50

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

-- Check if an item template matches an accepted turn-in item
local function isAcceptedItem(template)
    if template == KRAYT_PEARL_TEMPLATE then return true end
    for _, crystalTemplate in ipairs(FORCE_CRYSTAL_TEMPLATES) do
        if template == crystalTemplate then return true end
    end
    return false
end

-- Count accepted items in player inventory
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

-- Remove exactly ITEMS_REQUIRED accepted items from inventory
local function consumeTurnInItems(pCreature)
    local inventory = CreatureObject(pCreature):getSlottedObject("inventory")
    if inventory == nil then return false end

    local removed = 0
    local invSize = SceneObject(inventory):getContainerObjectsSize()

    -- Build list first to avoid iterator issues during removal
    local toRemove = {}
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

    -- Now destroy them
    for _, pItem in ipairs(toRemove) do
        SceneObject(pItem):destroyObjectFromWorld()
    end

    return true
end

-- Full requirements check — returns status table
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

-- Build a status string listing what is missing
local function buildRequirementsReport(req)
    local lines = {}

    if not req.isPadawan then
        table.insert(lines, "  - You have not yet awakened to the Force as a Padawan.")
    end
    if not req.treesOk then
        table.insert(lines, "  - Mastered Force disciplines: " .. req.masteredTrees .. "/3")
    end
    if not req.pointsOk then
        table.insert(lines, "  - Force attunement: " .. req.knightPoints .. "/100,000")
    end
    if not req.killsOk then
        table.insert(lines, "  - Force-sensitive adversaries defeated: " .. req.fsKills .. "/100")
    end
    if not req.holocronsOk then
        table.insert(lines, "  - Holocrons studied: " .. req.holocronsUsed .. "/20")
    end
    if not req.itemsOk then
        table.insert(lines, "  - Krayt Pearls / Force Crystals presented: " .. req.itemCount .. "/50")
    end

    return table.concat(lines, "\n")
end

-- ============================================================
-- CONVERSATION ENTRY POINT
-- Called when player activates the NPC via radial menu
-- ============================================================

function LightEnclaveKnight:triggerConversation(pPlayer, pNPC)
    if pPlayer == nil or pNPC == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local jediStatus = getPlayerVar(pGhost, "jedi_status", "none")

    -- Already Knight or Master
    if jediStatus == "knight" or jediStatus == "master" then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: You have already walked the path of the Knight. The Force is strong within you. Go in peace.")
        return
    end

    -- Not yet Padawan
    if jediStatus ~= "padawan" then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: I sense much potential in you... but you have not yet awakened to the Force. Return when you have found your path.")
        return
    end

    -- Begin full dialogue
    self:openGreeting(pPlayer, pNPC, pGhost)
end

-- ============================================================
-- DIALOGUE SCREENS
-- ============================================================

function LightEnclaveKnight:openGreeting(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    -- Build the opening line based on how close they are
    local greeting = ""
    if req.allMet then
        greeting = "\\#88CCFF[Council Elder]: I have watched your progress from afar, Padawan. The Force speaks clearly of your journey.\n\nYou stand before me now not as a student... but as one who is ready to be tested for the rank of Jedi Knight.\n\nAre you prepared to present yourself for judgement?"
    else
        greeting = "\\#88CCFF[Council Elder]: Welcome to the enclave, Padawan. I sense great determination within you.\n\nThe path to Knighthood is long. You have come far, but the trials are not yet complete.\n\nWould you like to know where you stand?"
    end

    CreatureObject(pPlayer):sendSystemMessage(greeting)

    -- Present options based on readiness
    if req.allMet then
        self:showReadyOptions(pPlayer, pNPC, pGhost, req)
    else
        self:showProgressOptions(pPlayer, pNPC, pGhost, req)
    end
end

-- Options when player is NOT yet ready
function LightEnclaveKnight:showProgressOptions(pPlayer, pNPC, pGhost, req)
    -- SWGemu SUI list box for dialogue choices
    local sui = SuiListBox.new(pPlayer, pNPC, "The Path to Knighthood", "What would you ask of me?")

    sui:addMenuItem("Show me what I still need to accomplish.")
    sui:addMenuItem("Tell me about the trials of Knighthood.")
    sui:addMenuItem("I will return when I am ready.")

    sui:setCallback("LightEnclaveKnight", "onProgressChoice")
    sui:display()
end

function LightEnclaveKnight:onProgressChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local req = checkAllRequirements(pPlayer, pGhost)

    if selectedIndex == 0 then
        -- Show requirements status
        local report = buildRequirementsReport(req)
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Your current standing before the Council:\n\n" .. report .. "\n\nContinue your training. The Force will guide you.")

    elseif selectedIndex == 1 then
        -- Lore about the trials
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: The road to Knighthood has never been taken lightly.\n\nYou must deepen your mastery of the Force disciplines — three trees must be fully realised within you.\n\nYou must have studied twenty holocrons, absorbing the wisdom of those who came before.\n\nYou must have faced one hundred Force-sensitive adversaries and proven that you can stand against the darkness.\n\nAnd you must present fifty offerings — Krayt Dragon Pearls and Force Crystals — symbols of perseverance, focus, and sacrifice.\n\nOnly when all of these are met may you stand before the Council.")

    elseif selectedIndex == 2 then
        -- Farewell
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Go well, Padawan. The Force walks with you.")
    end
end

-- Options when player IS ready
function LightEnclaveKnight:showReadyOptions(pPlayer, pNPC, pGhost, req)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Knight Trials", "What would you ask of me?")

    sui:addMenuItem("I am ready. I wish to be judged for Knighthood.")
    sui:addMenuItem("Tell me what becoming a Jedi Knight means.")
    sui:addMenuItem("I need a moment. I will return shortly.")

    sui:setCallback("LightEnclaveKnight", "onReadyChoice")
    sui:display()
end

function LightEnclaveKnight:onReadyChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        -- Begin the final trial confirmation
        self:showFinalConfirmation(pPlayer, pNPC, pGhost)

    elseif selectedIndex == 1 then
        -- Lore about what Knight means
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: A Jedi Knight is no longer a student. You stand on your own — guided by the Force, not by a Master's hand.\n\nWith that freedom comes responsibility. You will be a beacon to others. A protector of the innocent. A servant of the light.\n\nThe darkness will test you in ways your training never could. But the Force does not abandon those who walk with sincerity and courage.\n\nAre you prepared for that burden?")

        createEvent(1500, "LightEnclaveKnight", "reshowReadyOptions", pPlayer, "")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Take all the time you need. I will be here when you are ready.")
    end
end

function LightEnclaveKnight:reshowReadyOptions(pPlayer, params)
    if pPlayer == nil then return end
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end
    local req = checkAllRequirements(pPlayer, pGhost)
    -- Find NPC — stored when conversation began
    local npcID = getPlayerVar(pGhost, "light_enclave_npc_id", 0)
    local pNPC = npcID ~= 0 and getSceneObject(npcID) or nil
    self:showReadyOptions(pPlayer, pNPC, pGhost, req)
end

-- Final confirmation before consuming items and granting Knight
function LightEnclaveKnight:showFinalConfirmation(pPlayer, pNPC, pGhost)
    local itemCount = countTurnInItems(pPlayer)

    local confirmMsg = "\\#88CCFF[Council Elder]: Before I can elevate you to the rank of Jedi Knight, I must receive your offerings.\n\nYou carry " .. itemCount .. " Krayt Dragon Pearls and Force Crystals. I require fifty.\n\nThese will be taken from you as proof of your dedication. They cannot be returned.\n\nDo you wish to proceed?"

    CreatureObject(pPlayer):sendSystemMessage(confirmMsg)

    local sui = SuiListBox.new(pPlayer, pNPC, "Final Offering", "Will you present your offerings?")
    sui:addMenuItem("Yes. I present my offerings and accept the trials.")
    sui:addMenuItem("Not yet. I wish to reconsider.")

    sui:setCallback("LightEnclaveKnight", "onFinalConfirmation")
    sui:display()
end

function LightEnclaveKnight:onFinalConfirmation(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        -- Final check — re-verify everything hasn't changed
        local req = checkAllRequirements(pPlayer, pGhost)

        if not req.allMet then
            -- Something changed (items removed, etc.)
            CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Something has changed. You no longer meet all the requirements. Gather what is needed and return.")
            return
        end

        -- Consume the items
        local success = consumeTurnInItems(pPlayer)
        if not success then
            CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: I could not find enough offerings in your possession. Please ensure you carry fifty Krayt Dragon Pearls or Force Crystals.")
            return
        end

        -- Grant Knight status
        self:grantKnighthood(pPlayer, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Take your time. Knighthood is not granted to the impatient — nor should it be sought without full commitment.")
    end
end

-- ============================================================
-- GRANT KNIGHTHOOD
-- ============================================================

function LightEnclaveKnight:grantKnighthood(pPlayer, pGhost)
    -- Brief dramatic pause before the ceremony message
    createEvent(500, "LightEnclaveKnight", "doKnighthoodCeremony", pPlayer, "")
end

function LightEnclaveKnight:doKnighthoodCeremony(pPlayer, params)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    -- Ceremony message sequence
    CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF The Council Elder closes his eyes. A deep silence falls over the enclave.")

    createEvent(2500, "LightEnclaveKnight", "ceremony_step2", pPlayer, "")
end

function LightEnclaveKnight:ceremony_step2(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: By the will of the Force, and in the name of the Jedi Order...\n\nI name you Jedi Knight.\n\nRise, and carry the light with you always.")
    createEvent(3000, "LightEnclaveKnight", "ceremony_step3", pPlayer, "")
end

function LightEnclaveKnight:ceremony_step3(pPlayer, params)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    -- Call the grant function from holocron.lua
    holocron_grant_knight(pPlayer, "light")

    CreatureObject(pPlayer):sendSystemMessage("\\#FFFF00 The Force surges through you. You are a Jedi Knight.")
end
