local SpaceHelpers = require("utils.space_helpers")

v3fxConvoHandler = conv_handler:new {}

-- Hand out a Rebel starter ship, at most one per conversation.  DirectorManager::
-- grantStarterShip() returns one boolean; anything that is not an explicit true is
-- treated as a failure.
local function grantRebelStarterShip(pPlayer)
	if (SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
		return
	end

	local granted = grantStarterShip(pPlayer, "rebel")

	if (granted == true) then
		CreatureObject(pPlayer):sendSystemMessage("Starter ship assigned. It is parked at the nearest starport.")
	else
		CreatureObject(pPlayer):sendSystemMessage("I could not assign a ship right now - no landing zone nearby. Try again from a starport.")
	end
end

-- The Vortex tier 1 trainer (V3-FX, Moenia, Naboo).  Written from the Kreezo
-- handler in screenplays/space/conversations/rebel/havoc_squadron, retargeted at
-- Vortex Squadron and space_naboo.
function v3fxConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return convoTemplate:getScreen("no_jtl")
	end

	-- Player is an Imperial Pilot
	if (SpaceHelpers:isImperialPilot(pPlayer)) then
		return convoTemplate:getScreen("imperial_pilot")
	-- Player is a Neutral Pilot
	elseif (SpaceHelpers:isNeutralPilot(pPlayer)) then
		return convoTemplate:getScreen("neutral_pilot")
	-- Player is not a Rebel pilot yet
	elseif (not SpaceHelpers:isRebelPilot(pPlayer)) then
		return convoTemplate:getScreen("recruit_hint")
	-- Rebel pilot, but flying for somebody else
	elseif (not SpaceHelpers:isVortexSquadron(pPlayer)) then
		return convoTemplate:getScreen("non_vortex_pilot")
	end

	-- Player has no usable ship (never had one, or the control device was destroyed)
	if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
		grantRebelStarterShip(pPlayer)

		return convoTemplate:getScreen("grant_ship")
	end

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local patrolDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local patrolDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	-- A duty is still in the player's quest log
	if ((destroyDutyStarted and not destroyDutyComplete) or (patrolDutyStarted and not patrolDutyComplete)) then
		CreatureObject(pNpc):doAnimation("shake_head_no")

		return convoTemplate:getScreen("has_duty")
	-- A duty was just flown
	elseif (destroyDutyComplete or patrolDutyComplete) then
		CreatureObject(pNpc):doAnimation("nod_head_once")

		return convoTemplate:getScreen("duty_complete")
	end

	CreatureObject(pNpc):doAnimation("salute1")

	return convoTemplate:getScreen("duty_missions")
end

function v3fxConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	pConvScreen = screen:cloneScreen()
	local screenID = screen:getScreenID()

	-- Player joined the Vortex
	if (screenID == "join_vortex") then
		SpaceHelpers:setSquadronType(pPlayer, VORTEX_SQUADRON)
	elseif (screenID == "grant_ship" or screenID == "where_ship") then
		grantRebelStarterShip(pPlayer)
	-- Duty missions
	elseif (screenID == "duty_destroy") then
		destroy_duty_naboo_rebel_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "duty_patrol") then
		patrol_duty_naboo_rebel_7:startQuest(pPlayer, pNpc)
	end

	return pConvScreen
end
