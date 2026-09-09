JediManager = require("managers.jedi.jedi_manager")
local Logger = require("utils.logger")
local QuestManager = require("managers.quest.quest_manager")

jediManagerName = "VillageJediManager"

NOTINABUILDING = 0

NUMBEROFTREESTOMASTER = 6

VillageJediManager = JediManager:new {
	screenplayName = jediManagerName,
	jediManagerName = jediManagerName,
	jediProgressionType = VILLAGEJEDIPROGRESSION,
	startingEvent = nil,
}

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

	Glowing:checkForceStatusCommand(pPlayer)
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

	if (VillageJediManagerCommon.isVillageEligible(pPlayer) and not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		awardSkill(pPlayer, "force_title_jedi_novice")
	end

	-- VILLAGE UNLOCK CHAIN DISABLED (Ghosts): never resume the intro unlock chain.
	-- if (FsIntro:isOnIntro(pPlayer)) then
	-- 	FsIntro:onLoggedIn(pPlayer)
	-- end

	if (FsOutro:isOnOutro(pPlayer)) then
		FsOutro:onLoggedIn(pPlayer)
	end

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

	if (FsOutro:isOnOutro(pPlayer)) then
		FsOutro:onLoggedOut(pPlayer)
	end

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

	if skillName == "force_title_jedi_novice" and CreatureObject(pPlayer):getForceSensitiveSkillCount(true) > 0 then
		return false
	end

	if string.find(skillName, "force_sensitive_") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and CreatureObject(pPlayer):getForceSensitiveSkillCount(false) <= 12 then
		return false
	end

	if string.find(skillName, "force_discipline_") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and not CreatureObject(pPlayer):villageKnightPrereqsMet(skillName) then
		return false
	end

	return true
end

-- Handling of the onFSTreesCompleted event.
-- @param pPlayer pointer to the creature object of the player
function VillageJediManager:onFSTreeCompleted(pPlayer, branch)
	if (pPlayer == nil) then
		return
	end

	if (QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.OLD_MAN_FINAL) or VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_COMPLETED_VILLAGE) or VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_DEFEATED_MELLIACHAE)) then
		return
	end

	if (VillageJediManagerCommon.getLearnedForceSensitiveBranches(pPlayer) >= NUMBEROFTREESTOMASTER) then
		VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_COMPLETED_VILLAGE)
		FsOutro:startOldMan(pPlayer)
	end
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
