-- Dark Enclave Knight Conversation Handler
-- Location: screenplays/jedi/conversations/DarkEnclaveKnightConvoHandler.lua

DarkEnclaveKnightConvoHandler = {}

function DarkEnclaveKnightConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
	if pPlayer == nil or pNpc == nil then return "" end
	return "intro"
end

function DarkEnclaveKnightConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvoScreen)
	local screen = LuaConversationScreen(pConvoScreen)
	local screenID = screen:getScreenID()

	if screenID == "begin_trial" then
		if pPlayer ~= nil then
			local oid = SceneObject(pPlayer):getObjectID()
			writeData(tostring(oid) .. ":dark_knight_trial_active", 1)
		end
	end

	return pConvoScreen
end
