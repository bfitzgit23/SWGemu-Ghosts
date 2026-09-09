HolocronDiscoveryScholarConvoHandler = conv_handler:new {}

function HolocronDiscoveryScholarConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
	if pPlayer == nil or pNpc == nil or pConvoTemplate == nil then return nil end
	local convoTemplate = LuaConversationTemplate(pConvoTemplate)

	local state = readScreenPlayData(pPlayer, "HolocronJedi", "jedi_discovery_state")
	local expectedNpcID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "discovery_npc_id")) or 0
	if state ~= "activated" or expectedNpcID ~= SceneObject(pNpc):getObjectID() then
		return convoTemplate:getScreen("leave")
	end

	return convoTemplate:getScreen("intro")
end

function HolocronDiscoveryScholarConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if pPlayer == nil or pNpc == nil or pConvScreen == nil then return pConvScreen end

	local screenID = LuaConversationScreen(pConvScreen):getScreenID()

	if screenID == "complete" then
		writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_holocron_studies_unlocked", "1")
		writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_discovery_state", "studies_unlocked")
		CreatureObject(pPlayer):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFFThe mysteries contained within ordinary holocrons no longer feel entirely beyond your understanding.")
		createEvent(1500, "HolocronJedi", "despawnDiscoveryNpc", pPlayer, "")
	end

	return pConvScreen
end
