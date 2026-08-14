-- Light Enclave Master Conversation Handler
-- Location: screenplays/jedi/conversations/LightEnclaveMasterConvoHandler.lua

LightEnclaveMasterConvoHandler = {}

function LightEnclaveMasterConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
	if pPlayer == nil or pNpc == nil then return "" end
	return "intro"
end

function LightEnclaveMasterConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvoScreen)
	local screen = LuaConversationScreen(pConvoScreen)
	local screenID = screen:getScreenID()

	if screenID == "begin_trial" then
		if pPlayer ~= nil then
			local oid = SceneObject(pPlayer):getObjectID()
			writeData(tostring(oid) .. ":master_trial_active", 1)
		end
	end

	return pConvoScreen
end
