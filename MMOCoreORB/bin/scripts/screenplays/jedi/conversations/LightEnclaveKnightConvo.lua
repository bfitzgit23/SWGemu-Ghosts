-- Light Enclave Knight Conversation Template
-- Location: screenplays/jedi/conversations/LightEnclaveKnightConvo.lua

LightEnclaveKnightConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "LightEnclaveKnightConvoHandler",
	screens = {}
}

intro_screen = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "Padawan. You have come far, but the path to Knighthood demands more. Only those who have proven themselves in combat and wisdom may advance. Are you prepared to face the Knight Trial?",
	stopConversation = "false",
	options = {
		{"I am ready to face the Knight Trial.", "begin_trial"},
		{"I am not yet ready.", "not_ready"},
	}
}
LightEnclaveKnightConvoTemplate:addScreen(intro_screen)

begin_trial_screen = ConvoScreen:new {
	id = "begin_trial",
	leftDialog = "",
	customDialogText = "Then hear me well. The trial is not of strength alone — it is of commitment. Seek out and defeat a Champion of the Dark Side. Return to me when it is done, and I will recognize your advancement.",
	stopConversation = "false",
	options = {
		{"I will return victorious.", "farewell"},
	}
}
LightEnclaveKnightConvoTemplate:addScreen(begin_trial_screen)

not_ready_screen = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "",
	customDialogText = "Patience is itself a virtue of the Jedi. Return when you feel the Force guiding you forward.",
	stopConversation = "true",
	options = {}
}
LightEnclaveKnightConvoTemplate:addScreen(not_ready_screen)

farewell_screen = ConvoScreen:new {
	id = "farewell",
	leftDialog = "",
	customDialogText = "May the Force be with you, Padawan.",
	stopConversation = "true",
	options = {}
}
LightEnclaveKnightConvoTemplate:addScreen(farewell_screen)

addConversationTemplate("LightEnclaveKnight", LightEnclaveKnightConvoTemplate)
