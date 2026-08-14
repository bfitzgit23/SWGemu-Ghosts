--[[
    Aftermath Server - Light Jedi Enclave: Jedi Master Trial NPC
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/light_enclave_master.lua

    NPC: Jedi Grand Master (separate NPC from the Knight trial Council Elder)
    Placed deeper inside the Light Jedi Enclave on Yavin 4.

    Alignment strict — only Light-aligned Knights may complete this trial.
    A Dark-aligned Knight who wanders in is turned away.

    Master Requirements:
        - jedi_status == "knight"
        - jedi_alignment == "light"
        - 100 holocrons consumed (master_holocrons_used >= 100)
        - 2500 FS NPC kills (master_fs_kills >= 2500)
        - 2x frn_all_holocron_cube
        - 2x frn_all_holocron_dode
        - 2x frn_all_holocron_triangle

    NPC Template (existing asset):
        dressed_human_male_jedi_master_01  (or similar robed master)
--]]

LightEnclaveMaster = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "LightEnclaveMaster",
}

registerScreenPlay("LightEnclaveMaster", true)

-- ============================================================
-- CONFIGURATION
-- ============================================================

local HOLOCRON_CUBE_TEMPLATE     = "object/tangible/furniture/all/frn_all_holocron_cube.iff"
local HOLOCRON_DODE_TEMPLATE     = "object/tangible/furniture/all/frn_all_holocron_dode.iff"
local HOLOCRON_TRIANGLE_TEMPLATE = "object/tangible/furniture/all/frn_all_holocron_triangle.iff"

local REQUIRED_ITEMS = {
    { template = HOLOCRON_CUBE_TEMPLATE,     count = 2, name = "Ancient Jedaii Holocron Cube" },
    { template = HOLOCRON_DODE_TEMPLATE,     count = 2, name = "Ancient Jedaii Holocron Dodecahedron" },
    { template = HOLOCRON_TRIANGLE_TEMPLATE, count = 2, name = "Ancient Jedaii Holocron Triangle" },
}

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

-- Count how many of a specific template exist in player inventory
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

-- Remove exactly `needed` items of a template from inventory
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

-- Full requirements check
local function checkAllRequirements(pCreature, pGhost)
    local req = {
        isKnight    = getPlayerVar(pGhost, "jedi_status", "none") == "knight",
        isLight     = getPlayerVar(pGhost, "jedi_alignment", "none") == "light",
        holocrons   = getPlayerVar(pGhost, "master_holocrons_used", 0),
        fsKills     = getPlayerVar(pGhost, "master_fs_kills", 0),
    }

    -- Count each required item type
    req.cubeCount     = countItemInInventory(pCreature, HOLOCRON_CUBE_TEMPLATE)
    req.dodeCount     = countItemInInventory(pCreature, HOLOCRON_DODE_TEMPLATE)
    req.triangleCount = countItemInInventory(pCreature, HOLOCRON_TRIANGLE_TEMPLATE)

    req.holocronsOk = req.holocrons >= MASTER_HOLOCRONS_REQUIRED
    req.killsOk     = req.fsKills >= MASTER_FS_KILLS_REQUIRED
    req.cubeOk      = req.cubeCount >= 2
    req.dodeOk      = req.dodeCount >= 2
    req.triangleOk  = req.triangleCount >= 2

    req.allMet = req.isKnight
             and req.isLight
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
        table.insert(lines, "  - You have not yet achieved the rank of Jedi Knight.")
    end
    if not req.holocronsOk then
        table.insert(lines, "  - Holocrons studied: " .. req.holocrons .. "/" .. MASTER_HOLOCRONS_REQUIRED)
    end
    if not req.killsOk then
        table.insert(lines, "  - Force-sensitive adversaries defeated: " .. req.fsKills .. "/" .. MASTER_FS_KILLS_REQUIRED)
    end
    if not req.cubeOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Cubes: " .. req.cubeCount .. "/2")
    end
    if not req.dodeOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Dodecahedra: " .. req.dodeCount .. "/2")
    end
    if not req.triangleOk then
        table.insert(lines, "  - Ancient Jedaii Holocron Triangles: " .. req.triangleCount .. "/2")
    end

    return table.concat(lines, "\n")
end

-- ============================================================
-- CONVERSATION ENTRY POINT
-- ============================================================

function LightEnclaveMaster:triggerConversation(pPlayer, pNPC)
    if pPlayer == nil or pNPC == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local jediStatus    = getPlayerVar(pGhost, "jedi_status", "none")
    local jediAlignment = getPlayerVar(pGhost, "jedi_alignment", "none")

    -- Already a Master
    if jediStatus == "master" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: You have already attained Mastery. The Force flows through you fully. There is nothing more I can bestow upon you.")
        return
    end

    -- Not yet a Knight
    if jediStatus ~= "knight" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: I sense great potential within you... but you have not yet proven yourself as a Knight. Return when you have walked that path.")
        return
    end

    -- Wrong alignment — Dark Knight wandered into Light enclave
    if jediAlignment ~= "light" then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: I feel the darkness within you. This enclave is not your path. Seek your own kind.")
        return
    end

    -- Store NPC ID for re-use in delayed callbacks
    setPlayerVar(pGhost, "light_master_npc_id", SceneObject(pNPC):getObjectID())

    self:openGreeting(pPlayer, pNPC, pGhost)
end

-- ============================================================
-- DIALOGUE
-- ============================================================

function LightEnclaveMaster:openGreeting(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    local greeting = ""
    if req.allMet then
        greeting = "\\#FFFFFF[Jedi Grand Master]: I have meditated upon this moment for some time.\n\nYou stand before me as a Jedi Knight who has walked the full length of their path. The Force has spoken your name in my meditations more than once.\n\nWhat you seek now is not rank. It is not title. It is the complete surrender of self to the will of the Force.\n\nAre you ready to lay down the last of what you are... and become what the Force needs you to be?"
    else
        greeting = "\\#FFFFFF[Jedi Grand Master]: You have come far, Knight. Further than most who have stood where you stand.\n\nBut I sense incompleteness. The trials of Mastery are unlike anything you have faced.\n\nThere are still things the Force requires of you before you may stand in that light."
    end

    CreatureObject(pPlayer):sendSystemMessage(greeting)

    if req.allMet then
        self:showReadyOptions(pPlayer, pNPC, pGhost)
    else
        self:showProgressOptions(pPlayer, pNPC, pGhost, req)
    end
end

function LightEnclaveMaster:showProgressOptions(pPlayer, pNPC, pGhost, req)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Path to Mastery", "What would you ask of me?")

    sui:addMenuItem("Show me what the Force still requires of me.")
    sui:addMenuItem("What does it mean to be a Jedi Master?")
    sui:addMenuItem("I will return when I am ready.")

    sui:setCallback("LightEnclaveMaster", "onProgressChoice")
    sui:display()
end

function LightEnclaveMaster:onProgressChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    local req = checkAllRequirements(pPlayer, pGhost)

    if selectedIndex == 0 then
        local report = buildRequirementsReport(req)
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: The Force has not yet released you from your trials, Knight.\n\n" .. report .. "\n\nEvery one of these is a test of something deeper than skill. Do not rush them.")

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: A Jedi Master does not simply know more than a Knight.\n\nA Master has been broken and rebuilt by the Force. They have faced the full weight of the dark side — not once but countless times — and chosen the light every single time, not out of rule or obligation, but because they understand, truly understand, why it matters.\n\nYou must have studied one hundred holocrons. You must have faced and defeated two thousand five hundred Force-sensitive adversaries — not as a warrior seeking victory, but as a Jedi ensuring balance.\n\nAnd you must bring six relics of the ancient Jedaii Order — Cubes, Dodecahedra, and Triangles — proof that you have reached into the deepest history of our tradition and drawn something back.\n\nThis is not a rank you claim. It is one the Force grants.")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: Go in peace, Knight. The Force will tell you when the time is right.")
    end
end

function LightEnclaveMaster:showReadyOptions(pPlayer, pNPC, pGhost)
    local sui = SuiListBox.new(pPlayer, pNPC, "The Mastery Trials", "What would you ask of me?")

    sui:addMenuItem("I am ready. I surrender myself to the will of the Force.")
    sui:addMenuItem("I need to understand what I am about to undertake.")
    sui:addMenuItem("I need more time to reflect.")

    sui:setCallback("LightEnclaveMaster", "onReadyChoice")
    sui:display()
end

function LightEnclaveMaster:onReadyChoice(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        self:showFinalConfirmation(pPlayer, pNPC, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: What you are about to do cannot be undone.\n\nThe six ancient Jedaii relics you carry will be offered to the Force itself — not to me, not to the Order, but to the living will of the Force that binds all things.\n\nIn return, the Force will open itself to you completely. You will feel things no Knight can feel. Carry burdens no Knight is asked to carry.\n\nThis is not an honour. It is a calling. Make certain you have heard it clearly.")

        createEvent(1500, "LightEnclaveMaster", "reshowReadyOptions", pPlayer, "")

    elseif selectedIndex == 2 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: Wisdom knows the difference between patience and hesitation. Take the time you need. I will be here.")
    end
end

function LightEnclaveMaster:reshowReadyOptions(pPlayer, params)
    if pPlayer == nil then return end
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end
    local npcID = getPlayerVar(pGhost, "light_master_npc_id", 0)
    local pNPC = npcID ~= 0 and getSceneObject(npcID) or nil
    self:showReadyOptions(pPlayer, pNPC, pGhost)
end

function LightEnclaveMaster:showFinalConfirmation(pPlayer, pNPC, pGhost)
    local req = checkAllRequirements(pPlayer, pGhost)

    local itemSummary = "Ancient Jedaii Holocron Cubes: " .. req.cubeCount .. "/2\n"
                     .. "Ancient Jedaii Holocron Dodecahedra: " .. req.dodeCount .. "/2\n"
                     .. "Ancient Jedaii Holocron Triangles: " .. req.triangleCount .. "/2"

    CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: You carry the relics the Force requires.\n\n" .. itemSummary .. "\n\nThey will be offered and cannot be returned. Once you begin, there is no stepping back from this threshold.\n\nDo you offer them freely?")

    local sui = SuiListBox.new(pPlayer, pNPC, "The Final Offering", "Do you offer the relics freely?")
    sui:addMenuItem("Yes. I offer them freely and without reservation.")
    sui:addMenuItem("Not yet. I need more time.")

    sui:setCallback("LightEnclaveMaster", "onFinalConfirmation")
    sui:display()
end

function LightEnclaveMaster:onFinalConfirmation(pPlayer, pNPC, selectedIndex)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    if selectedIndex == 0 then
        local req = checkAllRequirements(pPlayer, pGhost)

        if not req.allMet then
            CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: Something has changed. You no longer carry what is required, or your trials are incomplete. Gather what is needed and return.")
            return
        end

        -- Consume all 6 relics
        local cubeOk     = consumeItems(pPlayer, HOLOCRON_CUBE_TEMPLATE, 2)
        local dodeOk     = consumeItems(pPlayer, HOLOCRON_DODE_TEMPLATE, 2)
        local triangleOk = consumeItems(pPlayer, HOLOCRON_TRIANGLE_TEMPLATE, 2)

        if not (cubeOk and dodeOk and triangleOk) then
            CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: Something is missing. Ensure you carry two of each ancient relic before proceeding.")
            return
        end

        self:grantMastery(pPlayer, pGhost)

    elseif selectedIndex == 1 then
        CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: The Force is patient. Return when you are certain.")
    end
end

-- ============================================================
-- GRANT MASTERY — staged ceremony
-- ============================================================

function LightEnclaveMaster:grantMastery(pPlayer, pGhost)
    createEvent(500, "LightEnclaveMaster", "ceremony_step1", pPlayer, "")
end

function LightEnclaveMaster:ceremony_step1(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF The Grand Master closes his eyes. The air around you stills completely. You feel the Force itself turn its full attention toward this moment.")
    createEvent(3000, "LightEnclaveMaster", "ceremony_step2", pPlayer, "")
end

function LightEnclaveMaster:ceremony_step2(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF A warmth unlike anything you have ever felt flows through you — not heat, but presence. Ancient, vast, and utterly still.")
    createEvent(3000, "LightEnclaveMaster", "ceremony_step3", pPlayer, "")
end

function LightEnclaveMaster:ceremony_step3(pPlayer, params)
    if pPlayer == nil then return end
    CreatureObject(pPlayer):sendSystemMessage("\\#FFFFFF[Jedi Grand Master]: The Force has accepted your offering.\n\nAll that you were ends here. All that you are called to be begins now.\n\nRise... Jedi Master. May the Force be with you. Always.")
    createEvent(3000, "LightEnclaveMaster", "ceremony_step4", pPlayer, "")
end

function LightEnclaveMaster:ceremony_step4(pPlayer, params)
    if pPlayer == nil then return end

    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost == nil then return end

    -- Grant Master status via holocron.lua
    holocron_grant_master(pPlayer)

    -- Play the Jedi theme as a final flourish
    local pmm = PlayMusicMessage("sound/music_become_light_jedi.snd")
    PlayerObject(pGhost):sendMessage(pmm)

    CreatureObject(pPlayer):sendSystemMessage("\\#FFFF00 The Force flows through you completely. You are a Jedi Master.")
end
