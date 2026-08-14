-- Dark Enclave Knight Conversation Template
-- Location: screenplays/jedi/conversations/DarkEnclaveKnightConvo.lua

DarkEnclaveKnightConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "DarkEnclaveKnightConvoHandler",
	screens = {}
}

intro_screen = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "So you come seeking advancement, Padawan. Power is not given — it is taken. To earn the rank of Knight, you must prove your strength. Destroy a Jedi Champion and bring proof of your victory.",
	stopConversation = "false",
	options = {
		{"I will prove my strength.", "begin_trial"},
		{"I am not ready.", "not_ready"},
	}
}
DarkEnclaveKnightConvoTemplate:addScreen(intro_screen)

begin_trial_screen = ConvoScreen:new {
	id = "begin_trial",
	leftDialog = "",
	customDialogText = "Good. Doubt is weakness. Go — destroy a Champion of the Light Side. Return when you have proven yourself worthy of the dark path.",
	stopConversation = "false",
	options = {
		{"It will be done.", "farewell"},
	}
}
DarkEnclaveKnightConvoTemplate:addScreen(begin_trial_screen)

not_ready_screen = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "",
	customDialogText = "Then you waste my time. Do not return until you have the will to act.",
	stopConversation = "true",
	options = {}
}
DarkEnclaveKnightConvoTemplate:addScreen(not_ready_screen)

farewell_screen = ConvoScreen:new {
	id = "farewell",
	leftDialog = "",
	customDialogText = "Strength and cunning, Padawan. Let nothing stand in your way.",
	stopConversation = "true",
	options = {}
}
DarkEnclaveKnightConvoTemplate:addScreen(farewell_screen)

addConversationTemplate("DarkEnclaveKnight", DarkEnclaveKnightConvoTemplate)
