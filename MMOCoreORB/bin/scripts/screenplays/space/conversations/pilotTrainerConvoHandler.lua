local Logger = require("utils.logger")
require("utils.helpers")
local SpaceHelpers = require("utils.space_helpers")

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
