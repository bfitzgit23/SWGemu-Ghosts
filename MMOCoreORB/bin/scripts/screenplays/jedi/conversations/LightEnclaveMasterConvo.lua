-- Light Enclave Master Conversation Template
-- Location: screenplays/jedi/conversations/LightEnclaveMasterConvo.lua

LightEnclaveMasterConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "LightEnclaveMasterConvoHandler",
	screens = {}
}

intro_screen = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "Jedi Knight. You stand before the Council having proven your valor. Few reach this point. The path to Mastery is the deepest commitment a Jedi can make — it is a lifetime of service to the Force and to others. Do you seek to walk this path?",
	stopConversation = "false",
	options = {
		{"I seek the rank of Jedi Master.", "begin_trial"},
		{"I must reflect further.", "not_ready"},
	}
}
LightEnclaveMasterConvoTemplate:addScreen(intro_screen)

begin_trial_screen = ConvoScreen:new {
	id = "begin_trial",
	leftDialog = "",
	customDialogText = "Then your final trial begins. Seek out and defeat the greatest champion of darkness you can find. Return here when victory is yours, and the Council will bestow upon you the title of Jedi Master.",
	stopConversation = "false",
	options = {
		{"I am honored. I will not fail.", "farewell"},
	}
}
LightEnclaveMasterConvoTemplate:addScreen(begin_trial_screen)

not_ready_screen = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "",
	customDialogText = "Wisdom lies in knowing when you are not ready. Return when the Force moves you.",
	stopConversation = "true",
	options = {}
}
LightEnclaveMasterConvoTemplate:addScreen(not_ready_screen)

farewell_screen = ConvoScreen:new {
	id = "farewell",
	leftDialog = "",
	customDialogText = "The Force is strong with you, Knight. Go, and return victorious.",
	stopConversation = "true",
	options = {}
}
LightEnclaveMasterConvoTemplate:addScreen(farewell_screen)

addConversationTemplate("LightEnclaveMaster", LightEnclaveMasterConvoTemplate)
