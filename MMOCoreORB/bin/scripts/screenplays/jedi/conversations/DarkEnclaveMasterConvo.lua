-- Dark Enclave Master Conversation Template
-- Location: screenplays/jedi/conversations/DarkEnclaveMasterConvo.lua

DarkEnclaveMasterConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "DarkEnclaveMasterConvoHandler",
	screens = {}
}

intro_screen = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "You stand before the Dark Council, Knight. Your victories have been noted. Mastery is not a gift — it is dominance made permanent. To claim it, you must destroy the greatest Jedi Champion on this world. Do you accept?",
	stopConversation = "false",
	options = {
		{"I accept. The title of Master will be mine.", "begin_trial"},
		{"I am not yet ready.", "not_ready"},
	}
}
DarkEnclaveMasterConvoTemplate:addScreen(intro_screen)

begin_trial_screen = ConvoScreen:new {
	id = "begin_trial",
	leftDialog = "",
	customDialogText = "Then go. Crush the light's greatest warrior. Return with proof of your supremacy, and the Dark Council will recognize you as a Master of the dark side.",
	stopConversation = "false",
	options = {
		{"It will be done.", "farewell"},
	}
}
DarkEnclaveMasterConvoTemplate:addScreen(begin_trial_screen)

not_ready_screen = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "",
	customDialogText = "Hesitation. A weakness. Do not waste the Council's time until you have hardened your resolve.",
	stopConversation = "true",
	options = {}
}
DarkEnclaveMasterConvoTemplate:addScreen(not_ready_screen)

farewell_screen = ConvoScreen:new {
	id = "farewell",
	leftDialog = "",
	customDialogText = "The dark side will see you through, Knight. Do not return unless you have succeeded.",
	stopConversation = "true",
	options = {}
}
DarkEnclaveMasterConvoTemplate:addScreen(farewell_screen)

addConversationTemplate("DarkEnclaveMaster", DarkEnclaveMasterConvoTemplate)
