-- Light Enclave Knight Conversation Handler
-- Location: screenplays/jedi/conversations/LightEnclaveKnightConvoHandler.lua

LightEnclaveKnightConvoHandler = {}

function LightEnclaveKnightConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
	if pPlayer == nil or pNpc == nil then return "" end
	return "intro"
end

function LightEnclaveKnightConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvoScreen)
	local screen = LuaConversationScreen(pConvoScreen)
	local screenID = screen:getScreenID()

	if screenID == "begin_trial" then
		-- Set trial active flag
		if pPlayer ~= nil then
			local oid = SceneObject(pPlayer):getObjectID()
			writeData(tostring(oid) .. ":knight_trial_active", 1)
		end
	end

	return pConvoScreen
end
