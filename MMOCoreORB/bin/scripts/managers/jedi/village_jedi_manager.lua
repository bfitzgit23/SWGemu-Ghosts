JediManager = require("managers.jedi.jedi_manager")
local Logger = require("utils.logger")
local QuestManager = require("managers.quest.quest_manager")

jediManagerName = "VillageJediManager"

NOTINABUILDING = 0

NUMBEROFTREESTOMASTER = 6

local TRAINING_SABER = "object/weapon/melee/sword/crafted_saber/sword_lightsaber_training.iff"
local POLEARM_STARTER_PREFIX = "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm"

-- Staff Jedi request inbox. Add more character first names if needed.
local JEDI_REQUEST_RECIPIENTS = { "Xixx" }
local JEDI_REQUEST_COOLDOWN = 24 * 60 * 60

VillageJediManager = JediManager:new {
	screenplayName = jediManagerName,
	jediManagerName = jediManagerName,
	jediProgressionType = VILLAGEJEDIPROGRESSION,
	startingEvent = nil,
}


-- Ghosts: replace the client's double-bladed Jedi starter with the intended
-- training lightsaber. The polearm needs cert_polearmlightsaber, which a new
-- combat_jedi_novice does not have, so it cannot be used to attack.
function VillageJediManager:onPlayerCreated(pCreature)
	if (pCreature == nil) then
		return
	end

	local pPlayer = CreatureObject(pCreature)
	local isJediStarter = pPlayer:hasSkill("combat_jedi_novice")
		or pPlayer:hasSkill("force_rank_gray_novice")

	if (not isJediStarter) then
		return
	end

	local pInventory = pPlayer:getSlottedObject("inventory")
	if (pInventory == nil) then
		return
	end

	local hasTrainingSaber = false
	local itemCount = SceneObject(pInventory):getContainerObjectsSize()

	for i = itemCount - 1, 0, -1 do
		local pItem = SceneObject(pInventory):getContainerObject(i)
		if (pItem ~= nil) then
			local templatePath = SceneObject(pItem):getTemplateObjectPath()

			if (templatePath == TRAINING_SABER) then
				hasTrainingSaber = true
			elseif (templatePath ~= nil and string.find(templatePath, POLEARM_STARTER_PREFIX, 1, true) ~= nil) then
				SceneObject(pItem):destroyObjectFromWorld()
				SceneObject(pItem):destroyObjectFromDatabase(true)
			end
		end
	end

	if (not hasTrainingSaber) then
		giveItem(pInventory, TRAINING_SABER, -1)
	end
end

-- Handling of the useItem event.
-- @param pSceneObject pointer to the item object.
-- @param itemType the type of item that is used.
-- @param pPlayer pointer to the creature object that used the item.
function VillageJediManager:useItem(pSceneObject, itemType, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	Logger:log("useItem called with item type " .. itemType, LT_INFO)
	if itemType == ITEMHOLOCRON then
		-- Ghosts uses an earned holocron progression in place of the stock
		-- Village holocron response. Fall back safely if its screenplay failed
		-- to load so a startup problem does not make holocrons unusable.
		if holocron_use_custom ~= nil then
			holocron_use_custom(pPlayer, pSceneObject)
		else
			VillageJediManagerHolocron.useHolocron(pSceneObject, pPlayer)
		end
	end
	if itemType == ITEMWAYPOINTDATAPAD then
		SithShadowEncounter:useWaypointDatapad(pSceneObject, pPlayer)
	end
	if itemType == ITEMTHEATERDATAPAD then
		SithShadowIntroTheater:useTheaterDatapad(pSceneObject, pPlayer)
	end
end

-- Handling of the checkForceStatus command.
-- @param pPlayer pointer to the creature object of the player who performed the command
function VillageJediManager:checkForceStatusCommand(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- Already on a Force path: keep the normal status readout.
	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") or CreatureObject(pPlayer):hasSkill("combat_jedi_novice")) then
		Glowing:checkForceStatusCommand(pPlayer)
		return
	end

	local lastRequest = tonumber(readScreenPlayData(pPlayer, "JediRequest", "sent_at")) or 0

	if (lastRequest > 0 and (os.time() - lastRequest) < JEDI_REQUEST_COOLDOWN) then
		CreatureObject(pPlayer):sendSystemMessage("Your Jedi training request is already with the staff. Please wait for a reply.")
		return
	end

	local sui = SuiMessageBox.new("VillageJediManager", "onJediRequestResponse")
	sui.setTitle("Jedi Training Request")
	sui.setPrompt("The Force moves around you. Would you like to ask the staff to grant you Jedi training?")
	sui.setOkButtonText("Request Jedi Training")
	sui.setCancelButtonText("Not now")
	sui.sendTo(pPlayer)
end

-- Handling of the requestJediTraining command.
-- @param pPlayer pointer to the creature object of the player who performed the command
function VillageJediManager:requestJediTrainingCommand(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)

	-- Already on a Force path, so there is nothing to request.
	if (creature:hasSkill("force_title_jedi_novice") or creature:hasSkill("combat_jedi_novice")) then
		creature:sendSystemMessage("You are already on a Force path.")
		return
	end

	self:submitJediRequest(pPlayer)
end

function VillageJediManager:onJediRequestResponse(pPlayer, pSui, eventIndex, ...)
	if (pPlayer == nil) then
		return
	end

	if (eventIndex == 1) then
		return
	end

	self:submitJediRequest(pPlayer)
end

function VillageJediManager:submitJediRequest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local lastRequest = tonumber(readScreenPlayData(pPlayer, "JediRequest", "sent_at")) or 0

	if (lastRequest > 0 and (os.time() - lastRequest) < JEDI_REQUEST_COOLDOWN) then
		CreatureObject(pPlayer):sendSystemMessage("Your Jedi training request is already with the staff. Please wait for a reply.")
		return
	end

	local firstName = CreatureObject(pPlayer):getFirstName()
	local displayName = SceneObject(pPlayer):getDisplayedName()

	if (displayName == nil or displayName == "") then
		displayName = firstName
	end

	local planet = SceneObject(pPlayer):getZoneName()
	local timestamp = os.date("!%Y-%m-%d %H:%M UTC", os.time())

	writeScreenPlayData(pPlayer, "JediRequest", "sent_at", tostring(os.time()))

	for i = 1, #JEDI_REQUEST_RECIPIENTS do
		sendMail(
			"The Force",
			"Jedi Training Request - " .. displayName,
			"Character: " .. displayName .. "\n" ..
			"Planet: " .. planet .. "\n" ..
			"Requested: " .. timestamp .. "\n\n" ..
			"Grant with: @grantPadawanTrialsEligibility full " .. displayName .. "\n" ..
			"(Put dark before the name for a Dark Jedi.)",
			JEDI_REQUEST_RECIPIENTS[i]
		)
	end

	CreatureObject(pPlayer):sendSystemMessage("Your Jedi training request has been sent to the staff. You will be contacted in-game.")
end

-- Handling of the onPlayerLoggedIn event. The progression of the player will be checked and observers will be registered.
-- @param pPlayer pointer to the creature object of the player who logged in.
function VillageJediManager:onPlayerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- VILLAGE UNLOCK CHAIN DISABLED (Ghosts): the stock badge->glowing->intro
	-- chain is the vanilla village unlock method and must not run. Jedi unlock
	-- is holocron-driven only. Village access for force-path players is granted
	-- by the Ghosts block below, independent of this chain.
	-- Glowing:onPlayerLoggedIn(pPlayer)

	-- Ghosts: village ACCESS for force-path players (holocron jedi or grey jedi).
	-- The pre-CU client gates the Aurilia mist wall on the vanilla village-intro
	-- state, which our holocron unlock path never grants.  Grant the same access
	-- markers the vanilla intro grants (access flag, completed intro quest,
	-- jediState >= 1).  This grants ACCESS only -- jedi unlock itself remains
	-- holocron-driven.
	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") or CreatureObject(pPlayer):hasSkill("combat_jedi_novice")) then
		if (not VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_HAS_VILLAGE_ACCESS)) then
			VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_HAS_VILLAGE_ACCESS)
		end

		if (not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)) then
			if (not QuestManager.hasActiveQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)) then
				QuestManager.activateQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)
			end
			QuestManager.completeQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)
		end

		local pGhostForce = CreatureObject(pPlayer):getPlayerObject()
		if (pGhostForce ~= nil and PlayerObject(pGhostForce):getJediState() < 1) then
			PlayerObject(pGhostForce):setJediState(1)
		end
	end

	-- Village unlock is disabled (Ghosts): eligibility grants ACCESS only.
	-- Never award the Jedi novice title from village state.

	-- VILLAGE UNLOCK CHAIN DISABLED (Ghosts): never resume the intro unlock chain.
	-- if (FsIntro:isOnIntro(pPlayer)) then
	-- 	FsIntro:onLoggedIn(pPlayer)
	-- end

	-- Village unlock chain disabled (Ghosts): do not resume the Old Man outro.

	FsPhase1:onLoggedIn(pPlayer)
	FsPhase2:onLoggedIn(pPlayer)
	FsPhase3:onLoggedIn(pPlayer)
	FsPhase4:onLoggedIn(pPlayer)

	if (not VillageCommunityCrafting:isOnActiveCrafterList(pPlayer)) then
		VillageCommunityCrafting:removeSchematics(pPlayer, 2)
		VillageCommunityCrafting:removeSchematics(pPlayer, 3)
	end

	JediTrials:onPlayerLoggedIn(pPlayer)

	-- Resume any interrupted Ghosts holocron or Gatekeeper trial state.
	if HolocronJedi ~= nil and HolocronJedi.onPlayerLoggedIn ~= nil then
		HolocronJedi:onPlayerLoggedIn(pPlayer)
	end

	if GatekeeperConversation ~= nil and GatekeeperConversation.onPlayerLoggedIn ~= nil then
		GatekeeperConversation:onPlayerLoggedIn(pPlayer)
	end
end

function VillageJediManager:onPlayerLoggedOut(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- VILLAGE UNLOCK CHAIN DISABLED (Ghosts).
	-- if (FsIntro:isOnIntro(pPlayer)) then
	-- 	FsIntro:onLoggedOut(pPlayer)
	-- end

	-- Village unlock chain disabled (Ghosts): do not resume the Old Man outro.

	FsPhase1:onLoggedOut(pPlayer)
	FsPhase2:onLoggedOut(pPlayer)
	FsPhase3:onLoggedOut(pPlayer)

	if GatekeeperConversation ~= nil and GatekeeperConversation.onPlayerLoggedOut ~= nil then
		GatekeeperConversation:onPlayerLoggedOut(pPlayer)
	end
end

--Check for force skill prerequisites
--Check for force skill prerequisites
-- Ghosts: FS skills and Jedi title skills are freely learnable; holocron/grey-jedi
-- eligibility is enforced upstream. Village access is no longer required.
function VillageJediManager:canLearnSkill(pPlayer, skillName)
	if skillName == "force_title_jedi_rank_03" and not CreatureObject(pPlayer):villageKnightPrereqsMet("") then
		return false
	end

	return true
end

--Check to ensure force skill prerequisites are maintained
function VillageJediManager:canSurrenderSkill(pPlayer, skillName)
	-- Ghosts admin: one-shot Bennji Jedi skill reset bypass.
	if (readScreenPlayData(pPlayer, "ResetBennjiJedi", "allow") == "1") then
		return true
	end


	if skillName == "force_title_jedi_novice" and CreatureObject(pPlayer):getForceSensitiveSkillCount(true) > 0 then
		return false
	end

	if string.find(skillName, "force_sensitive_") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and CreatureObject(pPlayer):getForceSensitiveSkillCount(false) <= 12 then
		return false
	end

	local isJediTreeSkill = string.find(skillName, "force_discipline_") ~= nil
		or string.find(skillName, "jedi_padawan_") ~= nil
		or string.find(skillName, "jedi_light_side_") ~= nil
		or string.find(skillName, "jedi_dark_side_") ~= nil

	if isJediTreeSkill and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and not CreatureObject(pPlayer):villageKnightPrereqsMet(skillName) then
		return false
	end

	return true
end

-- Handling of the onFSTreesCompleted event.
-- @param pPlayer pointer to the creature object of the player
function VillageJediManager:onFSTreeCompleted(pPlayer, branch)
	if (VillageJediManagerCommon.isHolocronJedi(pPlayer)) then
		return
	end
	if (pPlayer == nil) then
		return
	end

	if (QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.OLD_MAN_FINAL) or VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_COMPLETED_VILLAGE) or VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_DEFEATED_MELLIACHAE)) then
		return
	end

	-- Village unlock chain disabled (Ghosts): never start the Old Man unlock.
end

function VillageJediManager:onSkillRevoked(pPlayer, pSkill)
	if (pPlayer == nil) then
		return
	end

	if (JediTrials:isOnPadawanTrials(pPlayer) or JediTrials:isOnKnightTrials(pPlayer)) then
		JediTrials:droppedSkillDuringTrials(pPlayer, pSkill)
	end
end

registerScreenPlay("VillageJediManager", true)

return VillageJediManager
