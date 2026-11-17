local Logger = require("utils.logger")
require("utils.helpers")
local SpaceHelpers = require("utils.space_helpers")

-- The three Imperial squadron starter trainers share the generic trainer
-- conversation.  Their template name is what tells us which squadron the player
-- is standing in front of.
local IMPERIAL_TRAINERS = {
	{
		npcName = "hakassha_sireen",
		squadron = "black_epsilon",
		name = "Black Epsilon",
		joinScreen = "pilot_trainer_imperial_join_black_epsilon",
		hubScreen = "pilot_trainer_imperial_duty_hub_black_epsilon",
		hubText = "Black Epsilon Command has two assignments ready. A Rebel B-Wing prototype cell is operating in the Corellia system, and a patrol route needs an Imperial presence. Which assignment will you take?",
		tiers = {
			{
				label = "Tier I",
				destroy = {type = "destroy_duty", quest = "corellia_imperial_6", screenplay = "destroy_duty_corellia_imperial_6", system = "Corellia", title = "Destroy B-Wing Prototypes"},
				patrol = {type = "patrol", quest = "corellia_imperial_1", screenplay = "patrol_duty_corellia_imperial_1", system = "Corellia", title = "Bait Rebel Attack"},
			},
			{
				label = "Tier II",
				destroy = {type = "destroy_duty", quest = "corellia_imperial_8", screenplay = "destroy_duty_corellia_imperial_8", system = "Corellia", title = "Stop Hidden Dagger Activity"},
				patrol = {type = "patrol", quest = "corellia_imperial_15", screenplay = "patrol_duty_corellia_imperial_15", system = "Corellia", title = "Head in the Clouds"},
			},
			{
				label = "Tier III",
				destroy = {type = "destroy_duty", quest = "corellia_imperial_10", screenplay = "destroy_duty_corellia_imperial_10", system = "Corellia", title = "Disrupt Rebel Operations"},
				patrol = {type = "patrol", quest = "corellia_imperial_tier3_1b", screenplay = "patrol_duty_corellia_imperial_tier3_1b", system = "Corellia", title = "On the Prowl"},
			},
		},
		destroyType = "destroy_duty",
		destroyQuest = "corellia_imperial_6",
		destroyClass = "destroy_duty_corellia_imperial_6",
		destroySystem = "Corellia",
		patrolType = "patrol",
		patrolQuest = "corellia_imperial_1",
		patrolClass = "patrol_duty_corellia_imperial_1",
		patrolSystem = "Corellia",
	},
	{
		npcName = "akal_colzet",
		squadron = "storm",
		name = "Storm Squadron",
		joinScreen = "pilot_trainer_imperial_join_storm",
		hubScreen = "pilot_trainer_imperial_duty_hub_storm",
		hubText = "Storm Squadron has two assignments ready. Commerce raiders are active along the Tatooine routes, and the Bestine orbital security circuit needs another patrol. Which assignment will you take?",
		tiers = {
			{
				label = "Tier I",
				destroy = {type = "destroy_duty", quest = "tatooine_imperial_6", screenplay = "destroy_duty_tatooine_imperial_6", system = "Tatooine", title = "Hunt Commerce Raiders"},
				patrol = {type = "patrol", quest = "tatooine_imperial_1", screenplay = "patrol_duty_tatooine_imperial_1", system = "Tatooine", title = "Patrol Bestine Commerce Route"},
			},
			{
				label = "Tier II",
				destroy = {type = "destroy", quest = "tatooine_imperial_2", screenplay = "destroy_tatooine_imperial_2", system = "Tatooine", title = "Hunt the Commerce Raiders"},
				patrol = {type = "patrol", quest = "tatooine_imperial_3", screenplay = "patrol_duty_tatooine_imperial_3", system = "Tatooine", title = "Patrol Bestine Security Route"},
			},
			{
				label = "Tier III",
				destroy = {type = "destroy", quest = "tatooine_imperial_tier3_4", screenplay = "destroy_tatooine_imperial_tier3_4", system = "Endor", title = "Thinning the Herd"},
				patrol = {type = "patrol", quest = "tatooine_imperial_tier3_2_d", screenplay = "patrol_duty_tatooine_imperial_tier3_2_d", system = "Endor", title = "Keeping Watch"},
			},
		},
		destroyType = "destroy_duty",
		destroyQuest = "tatooine_imperial_6",
		destroyClass = "destroy_duty_tatooine_imperial_6",
		destroySystem = "Tatooine",
		patrolType = "patrol",
		patrolQuest = "tatooine_imperial_1",
		patrolClass = "patrol_duty_tatooine_imperial_1",
		patrolSystem = "Tatooine",
	},
	{
		npcName = "barn_sinkko",
		squadron = "inquisition",
		name = "Imperial Inquisition",
		joinScreen = "pilot_trainer_imperial_join_inquisition",
		hubScreen = "pilot_trainer_imperial_duty_hub_inquisition",
		hubText = "The Inquisition has two assignments ready. Rebel fighters are massing in the Dantooine system, and a training patrol is due in the Naboo system. Which assignment will you take?",
		tiers = {
			{
				label = "Tier I",
				destroy = {type = "destroy_duty", quest = "naboo_imperial_tier2_destroyduty", screenplay = "destroy_duty_naboo_imperial_tier2", system = "Dantooine", title = "Destroy X-Wing's in Dantooine Sector"},
				patrol = {type = "patrol", quest = "naboo_imperial_1", screenplay = "patrol_duty_naboo_imperial_1", system = "Naboo", title = "Follow Imperial Training Patrol"},
			},
			{
				label = "Tier II",
				destroy = {type = "destroy", quest = "naboo_imperial_2", screenplay = "destroy_naboo_imperial_2", system = "Naboo", title = "Destroy Rebel Fighters"},
				patrol = {type = "patrol", quest = "naboo_imperial_3", screenplay = "patrol_duty_naboo_imperial_3", system = "Naboo", title = "Locate Decoy E-62 Transport"},
			},
			{
				label = "Tier III",
				destroy = {type = "destroy", quest = "naboo_imperial_tier3_4", screenplay = "destroy_naboo_imperial_tier3_4", system = "Dathomir", title = "Thinning the Herd"},
				patrol = {type = "patrol", quest = "naboo_imperial_tier3_2_d", screenplay = "patrol_duty_naboo_imperial_tier3_2_d", system = "Dathomir", title = "Keeping Watch"},
			},
		},
		destroyType = "destroy_duty",
		destroyQuest = "naboo_imperial_tier2_destroyduty",
		destroyClass = "destroy_duty_naboo_imperial_tier2",
		destroySystem = "Dantooine",
		patrolType = "patrol",
		patrolQuest = "naboo_imperial_1",
		patrolClass = "patrol_duty_naboo_imperial_1",
		patrolSystem = "Naboo",
	},
}

local function npcNameMatches(pNpc, npcName)
	if (pNpc == nil or npcName == nil) then
		return false
	end

	local objectName = SceneObject(pNpc):getObjectName()

	if (objectName == nil) then
		return false
	end

	local lowerName = string.lower(objectName)
	local lowerNpc = string.lower(npcName)

	if (string.find(lowerName, lowerNpc, 1, true) ~= nil) then
		return true
	end

	return string.find(lowerName, string.gsub(lowerNpc, "_", " "), 1, true) ~= nil
end

local function getImperialTrainerInfo(pNpc)
	for i = 1, #IMPERIAL_TRAINERS, 1 do
		local trainer = IMPERIAL_TRAINERS[i]

		if (npcNameMatches(pNpc, trainer.npcName)) then
			return trainer
		end
	end

	return nil
end

local function getSquadronType(squadron)
	if (squadron == "black_epsilon") then
		return BLACK_EPSILON_SQUADRON
	elseif (squadron == "storm") then
		return STORM_SQUADRON
	elseif (squadron == "inquisition") then
		return INQUISITION_SQUADRON
	end

	return nil
end

local function isInSquadron(pPlayer, squadron)
	if (squadron == "black_epsilon") then
		return SpaceHelpers:isBlackEpsilonSquadron(pPlayer)
	elseif (squadron == "storm") then
		return SpaceHelpers:isStormSquadron(pPlayer)
	elseif (squadron == "inquisition") then
		return SpaceHelpers:isInquisitionSquadron(pPlayer)
	end

	return false
end

local function isInAnyImperialSquadron(pPlayer)
	return SpaceHelpers:isBlackEpsilonSquadron(pPlayer) or SpaceHelpers:isStormSquadron(pPlayer) or SpaceHelpers:isInquisitionSquadron(pPlayer)
end

local function canJoinImperialSquadron(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	-- Neutral and Rebel pilots already have their own squadron tracks.  A neutral
	-- or Imperial character who has not started pilot training can still be sworn
	-- in; the trainer grants the novice pilot box as part of joining.
	if (SpaceHelpers:isNeutralPilot(pPlayer) or SpaceHelpers:isRebelPilot(pPlayer) or CreatureObject(pPlayer):getFaction() == FACTIONREBEL) then
		return false
	end

	return true
end

local function cloneWithCustomText(convoTemplate, screenID, text)
	local screen = convoTemplate:getScreen(screenID)

	if (screen == nil) then
		return nil
	end

	-- ConversationTemplate:getScreen() returns a lightuserdata, not a
	-- LuaConversationScreen wrapper.  Wrapping it is required before calling
	-- cloneScreen(); indexing the raw pointer aborted every custom dialog screen.
	local clonedScreen = LuaConversationScreen(screen):cloneScreen()

	if (clonedScreen == nil) then
		return screen
	end

	LuaConversationScreen(clonedScreen):setCustomDialogText(text)

	return clonedScreen
end

local function missionActive(pPlayer, mission)
	return SpaceHelpers:isSpaceQuestActive(pPlayer, mission.type, mission.quest)
end

local function missionComplete(pPlayer, mission)
	return SpaceHelpers:isSpaceQuestComplete(pPlayer, mission.type, mission.quest)
end

-- The trainer advances a tier only after both assignments in the previous tier
-- are complete.  Tiers are independent of the pilot skill tree so a pilot who
-- has just joined can start the entry tier immediately.
local function getDutyState(pPlayer, trainer)
	local firstIncomplete = nil

	for i = 1, #trainer.tiers, 1 do
		local tier = trainer.tiers[i]
		local destroyActive = missionActive(pPlayer, tier.destroy)
		local patrolActive = missionActive(pPlayer, tier.patrol)

		if (destroyActive or patrolActive) then
			return {active = true, tierIndex = i, tier = tier}
		end

		local destroyComplete = missionComplete(pPlayer, tier.destroy)
		local patrolComplete = missionComplete(pPlayer, tier.patrol)

		if (firstIncomplete == nil and not (destroyComplete and patrolComplete)) then
			firstIncomplete = i
		end
	end

	if (firstIncomplete == nil) then
		return {active = false, tierIndex = #trainer.tiers, allComplete = true}
	end

	return {active = false, tierIndex = firstIncomplete, allComplete = false}
end

-- Resolve the mission screenplay at call time.  The squadron screenplays are
-- loaded after this handler, so these globals cannot be captured at file load.
local function getDutyScreenplay(mission)
	if (mission == nil or mission.screenplay == nil) then
		return nil
	end

	return _G[mission.screenplay]
end

local function getDutyScreen(convoTemplate, pPlayer, trainer)
	local dutyState = getDutyState(pPlayer, trainer)

	if (dutyState.active) then
		local tier = dutyState.tier

		return cloneWithCustomText(convoTemplate, "pilot_trainer_imperial_has_duty",
			"You are still on " .. tier.label .. " assignment for " .. trainer.name .. ". Finish it before requesting another.")
	end

	local tier = trainer.tiers[dutyState.tierIndex]
	local text

	if (dutyState.allComplete) then
		text = "All current " .. trainer.name .. " tiers are complete. The " .. tier.label .. " assignments remain available for repeat runs."
	else
		text = trainer.name .. " " .. tier.label .. " has two assignments ready: " .. tier.destroy.title .. " and " .. tier.patrol.title .. ". Which assignment will you take?"
	end

	return cloneWithCustomText(convoTemplate, trainer.hubScreen, text)
end

local function startDuty(pPlayer, pNpc, convoTemplate, trainer, kind)
	local dutyState = getDutyState(pPlayer, trainer)

	if (dutyState.active) then
		return getDutyScreen(convoTemplate, pPlayer, trainer)
	end

	local tier = trainer.tiers[dutyState.tierIndex]

	if (tier == nil) then
		return nil
	end

	local mission = tier.destroy

	if (kind == "patrol") then
		mission = tier.patrol
	end

	if (mission == nil) then
		return nil
	end

	local screenplay = getDutyScreenplay(mission)

	if (screenplay == nil) then
		return nil
	end

	-- Replaying a completed tier must clear the finished journal entry first.
	if (missionComplete(pPlayer, mission)) then
		screenplay:resetQuest(pPlayer)
	end

	screenplay:startQuest(pPlayer, pNpc)

	if (not missionActive(pPlayer, mission)) then
		return cloneWithCustomText(convoTemplate, "pilot_trainer_imperial_duty_started",
			"I could not assign that duty right now. Check your datapad and mission log, then try again.")
	end

	local orders = "Clear every enemy fighter and commander at the marked coordinates."

	if (mission.type == "destroy") then
		orders = "Destroy four Rebel targets at the marked coordinates."
	elseif (kind == "patrol") then
		orders = "Fly to all four marked nav points in order."
	end

	return cloneWithCustomText(convoTemplate, "pilot_trainer_imperial_duty_started",
		"Assignment logged. " .. tier.label .. " for " .. trainer.name .. ". Check your datapad and launch into the " .. mission.system .. " system. " .. orders)
end


pilotTrainerConvoHandler = conv_handler:new {}

-- Map the trainer NPC to the faction starter ship granted by grantStarterShip().
-- RSF (Naboo Security Force) is the Imperial navy recruiter (vanilla: surrender text
-- points Imperial pilots at the navy recruiter on Naboo).
--
-- NB: the social group is read through AiAgent, not CreatureObject.  Only
-- LuaAiAgent registers getSocialGroup() (LuaAiAgent.cpp), so calling it on a
-- CreatureObject throws "attempt to call a nil value", which aborts the whole
-- screen handler and leaves the client showing an empty "[]" conversation.
local function starterShipFaction(pNpc)
	if (pNpc == nil) then
		return "neutral"
	end

	local agent = AiAgent(pNpc)

	if (agent == nil) then
		return "neutral"
	end

	local socialGroup = agent:getSocialGroup()

	if (socialGroup == "rebel") then
		return "rebel"
	elseif (socialGroup == "imperial" or socialGroup == "naboo_security_force") then
		return "imperial"
	end

	return "neutral"
end

-- Where a trainer that has no mission chain of its own sends the player.
--
-- The answer only depends on the player, never on which trainer was asked, so two
-- different trainers can never point at each other.  The squadrons' wired chains
-- decide the target:
--   Havoc   - Kreezo (Corellia, Tyrena) holds the tier 1 chain, Lady Viopa (Lok,
--             Nym's stronghold) takes over once tier 1 is complete.  Both
--             conversations are registered, so both are safe to name.
--   Vortex  - V3-FX (Naboo, Moenia) for tier 1 and for whatever comes after it.  The
--             upstream tier 2 trainer is Brother Vrovel (Dantooine), but on this
--             server his conversation is not registered - mobile/space/vrovel.lua has
--             conversationTemplate = "" and the vrovel_convo/evin_convo/ezkiel_convo
--             includes are commented out in space_conversations.lua - so naming him
--             would send the player to an NPC that cannot talk.  V3-FX's own handler
--             is the one that hands out the Vortex duties.
--   Crimson Phoenix - the four trainers exist in the world (Eker in the Yavin 4
--             Labour Outpost, Da'la Socuna in Mos Espa, Arnecio Ulvaw Op in the
--             Dathomir Science Outpost, Ufwol in the Rori Rebel Outpost) but their
--             quest chain is not registered (see
--             mobile/conversations/space/space_conversations.lua), so the coordinator
--             is the honest answer.
--   anyone else - the pilot coordinator of their own faction.
--
-- Returns {screen = <screen id>, message = <system message>, waypoint = <function>}.
-- Every named NPC and place below is the one the waypoint helpers already point at.
local function assignmentAdvice(pPlayer)
	if (SpaceHelpers:isRebelPilot(pPlayer)) then
		if (SpaceHelpers:isHavocSquadron(pPlayer)) then
			if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 1)) then
				return {
					screen = "pilot_trainer_report_havoc",
					message = "Lady Viopa, Havoc Squadron's trainer, works out of Nym's stronghold on Lok.",
					waypoint = function(p) SpaceHelpers:addViopaWaypoint(p) end,
				}
			end

			return {
				screen = "pilot_trainer_report_basic",
				message = "Kreezo, Havoc Squadron's trainer, is in Tyrena on Corellia.",
				waypoint = function(p) SpaceHelpers:addArkonSquadWaypoint(p) end,
			}
		elseif (SpaceHelpers:isVortexSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "V3-FX, Vortex Squadron's trainer, is in Moenia on Naboo.",
				waypoint = function(p) SpaceHelpers:addVortexSquadWaypoint(p) end,
			}
		elseif (SpaceHelpers:isCrimsonPhoenixSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_crimson",
				message = "Crimson Phoenix has no assignments for you yet. J'pai Brek, the Rebel Pilot Coordinator, is in Tyrena on Corellia.",
				waypoint = function(p) SpaceHelpers:addRebelPilotWaypoint(p) end,
			}
		end

		return {
			screen = "pilot_trainer_report_basic",
			message = "J'pai Brek, the Rebel Pilot Coordinator, is in Tyrena on Corellia and will place you in a squadron.",
			waypoint = function(p) SpaceHelpers:addRebelPilotWaypoint(p) end,
		}
	elseif (SpaceHelpers:isImperialPilot(pPlayer)) then
		if (SpaceHelpers:isBlackEpsilonSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Hakassha Sireen, Black Epsilon's trainer, is at the Imperial Outpost on Talus.",
				waypoint = function(p) SpaceHelpers:addBlackEpsilonSquadWaypoint(p) end,
			}
		elseif (SpaceHelpers:isStormSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Akal Colzet, Storm Squadron's trainer, is in the Bestine Pilot's Club on Tatooine.",
				waypoint = function(p) SpaceHelpers:addStormSquadWaypoint(p) end,
			}
		elseif (SpaceHelpers:isInquisitionSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Barn Sinkko, the Imperial Inquisition's trainer, is in the association hall in Kaadara on Naboo.",
				waypoint = function(p) SpaceHelpers:addImperialInquisitionSquadWaypoint(p) end,
			}
		end

		return {
			screen = "pilot_trainer_report_basic",
			message = "Landau, the Imperial Pilot Coordinator, is in Theed on Naboo.",
			waypoint = function(p) SpaceHelpers:addImperialPilotWaypoint(p) end,
		}
	elseif (SpaceHelpers:isNeutralPilot(pPlayer)) then
		if (SpaceHelpers:isCorsecSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Rhea, the CorSec Squadron trainer, is in Coronet on Corellia.",
				waypoint = function(p) SpaceHelpers:addCorsecPilotWaypoint(p) end,
			}
		elseif (SpaceHelpers:isRSFSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Dinge, the RSF Squadron trainer, is in Theed on Naboo.",
				waypoint = function(p) SpaceHelpers:addRSFPilotWaypoint(p) end,
			}
		elseif (SpaceHelpers:isSmugglerSquadron(pPlayer)) then
			return {
				screen = "pilot_trainer_report_basic",
				message = "Dravis, the Smugglers Alliance trainer, is in Mos Eisley on Tatooine.",
				waypoint = function(p) SpaceHelpers:addSmugglersPilotWaypoint(p) end,
			}
		end

		-- Still no squadron: the coordinator is the one who hands them out.  There is no
		-- waypoint helper for him (space_helpers.lua stops at the squadron trainers), so
		-- the message carries the location on its own.
		return {
			screen = "pilot_trainer_report_basic",
			message = "Gil Burtin, the neutral coordinator, is in Bestine on Tatooine and will place you in a squadron.",
		}
	end

	-- Not a pilot at all yet: the coordinator is the one who starts the chain.
	return {
		screen = "pilot_trainer_report_basic",
		message = "Speak with your faction's pilot coordinator about joining a squadron.",
	}
end

function pilotTrainerConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local trainer = getImperialTrainerInfo(pNpc)

	if (trainer ~= nil) then
		if (isInSquadron(pPlayer, trainer.squadron)) then
			local dutyScreen = getDutyScreen(convoTemplate, pPlayer, trainer)

			if (dutyScreen ~= nil) then
				return dutyScreen
			end
		elseif (canJoinImperialSquadron(pPlayer) and not isInAnyImperialSquadron(pPlayer)) then
			local joinScreen = convoTemplate:getScreen(trainer.joinScreen)

			if (joinScreen ~= nil) then
				return joinScreen
			end
		end
	end

	return convoTemplate:getScreen("pilot_trainer_greeting")
end

function pilotTrainerConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	pConvScreen = screen:cloneScreen()
	local screenID = screen:getScreenID()

	if (screenID == "pilot_trainer_grant_ship") then
		-- DirectorManager::grantStarterShip() returns one boolean to the caller, so
		-- anything that is not an explicit true is a failed hand-out.
		local granted = grantStarterShip(pPlayer, starterShipFaction(pNpc))

		if (granted == true) then
			CreatureObject(pPlayer):sendSystemMessage("Starter ship assigned. It is parked at the nearest starport.")
		else
			CreatureObject(pPlayer):sendSystemMessage("I could not assign a ship right now - no landing zone nearby. Try again from a starport.")
		end
	elseif (screenID == "pilot_trainer_imperial_join_accept") then
		local trainer = getImperialTrainerInfo(pNpc)

		if (trainer ~= nil and canJoinImperialSquadron(pPlayer) and not isInAnyImperialSquadron(pPlayer)) then
			if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_novice")) then
				SpaceHelpers:grantNovicePilot(pPlayer, "imperialPilot")
			end

			if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_novice")) then
				CreatureObject(pPlayer):sendSystemMessage("I could not enroll you in the Imperial Navy. Check your skill points and try again.")
				LuaConversationScreen(pConvScreen):setCustomDialogText("I could not enroll you in the Imperial Navy. Check your skill points and try again.")
				return pConvScreen
			end

			local squadronType = getSquadronType(trainer.squadron)

			if (squadronType == nil or SpaceHelpers:setSquadronType(pPlayer, squadronType) == false or not isInSquadron(pPlayer, trainer.squadron)) then
				CreatureObject(pPlayer):sendSystemMessage("I could not assign you to " .. trainer.name .. ". Please try again.")
				LuaConversationScreen(pConvScreen):setCustomDialogText("I could not assign you to " .. trainer.name .. ". Please try again.")
				return pConvScreen
			end

			local pGhost = CreatureObject(pPlayer):getPlayerObject()

			if (pGhost ~= nil) then
				local ghost = LuaPlayerObject(pGhost)

				if (ghost ~= nil and ghost:getPilotTier() < 1) then
					ghost:incrementPilotTier()
				end
			end

			CreatureObject(pPlayer):sendSystemMessage("You are now assigned to " .. trainer.name .. ".")

			local welcome = cloneWithCustomText(LuaConversationTemplate(pConvTemplate), "pilot_trainer_imperial_joined",
				"Welcome to " .. trainer.name .. ". You are now assigned to the squadron. Use the options below to request a starship or return to your duties.")

			if (welcome ~= nil) then
				return welcome
			end
		end
	elseif (screenID == "pilot_trainer_imperial_duty_destroy" or screenID == "pilot_trainer_imperial_duty_patrol") then
		local trainer = getImperialTrainerInfo(pNpc)

		if (trainer ~= nil) then
			local convoTemplate = LuaConversationTemplate(pConvTemplate)
			local kind = "destroy"

			if (screenID == "pilot_trainer_imperial_duty_patrol") then
				kind = "patrol"
			end

			local started = startDuty(pPlayer, pNpc, convoTemplate, trainer, kind)

			if (started ~= nil) then
				return started
			end
		end
	elseif (screenID == "pilot_trainer_imperial_duty_return") then
		local trainer = getImperialTrainerInfo(pNpc)

		if (trainer ~= nil) then
			local convoTemplate = LuaConversationTemplate(pConvTemplate)
			local dutyScreen = getDutyScreen(convoTemplate, pPlayer, trainer)

			if (dutyScreen ~= nil) then
				return dutyScreen
			end
		end
	elseif (screenID == "pilot_trainer_missions_report") then
		local advice = assignmentAdvice(pPlayer)

		if (advice.waypoint ~= nil) then
			advice.waypoint(pPlayer)
		end

		if (advice.message ~= nil) then
			CreatureObject(pPlayer):sendSystemMessage(advice.message)
		end

		local convoTemplate = LuaConversationTemplate(pConvTemplate)

		if (convoTemplate ~= nil and advice.screen ~= nil) then
			-- Only a screen that really exists may be returned: returning nil here
			-- would send the client nothing at all.
			local nextScreen = convoTemplate:getScreen(advice.screen)

			if (nextScreen ~= nil) then
				return nextScreen
			end
		end
	end

	return pConvScreen
end
