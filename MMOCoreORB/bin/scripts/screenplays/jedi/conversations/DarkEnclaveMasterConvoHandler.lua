-- Dark Enclave Master Conversation Handler
-- Location: screenplays/jedi/conversations/DarkEnclaveMasterConvoHandler.lua

DarkEnclaveMasterConvoHandler = {}

function DarkEnclaveMasterConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
	if pPlayer == nil or pNpc == nil then return "" end
	return "intro"
end

function DarkEnclaveMasterConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvoScreen)
	local screen = LuaConversationScreen(pConvoScreen)
	local screenID = screen:getScreenID()

	if screenID == "begin_trial" then
		if pPlayer ~= nil then
			local oid = SceneObject(pPlayer):getObjectID()
			writeData(tostring(oid) .. ":dark_master_trial_active", 1)
		end
	end

	return pConvoScreen
end
