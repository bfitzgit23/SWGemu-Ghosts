-- Conversation templates are loaded by the mobile template manager, where
-- ConvoTemplate, ConvoScreen, and addConversationTemplate are available.
HolocronDiscoveryScholarConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "HolocronDiscoveryScholarConvoHandler",
	screens = {}
}

local intro = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "You there. Yes... you. That object you were carrying. Where did you find it?",
	stopConversation = "false",
	options = {
		{"I don't even know what it was.", "identify_holocron"},
		{"I would rather not discuss it.", "leave"}
	}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(intro)

local identifyHolocron = ConvoScreen:new {
	id = "identify_holocron",
	leftDialog = "",
	customDialogText = "No. I suppose you wouldn't. A holocron... or perhaps only the remains of one.",
	stopConversation = "false",
	options = {
		{"A holocron?", "explain_holocron"}
	}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(identifyHolocron)

local explainHolocron = ConvoScreen:new {
	id = "explain_holocron",
	leftDialog = "",
	customDialogText = "Once, they were vessels of knowledge. Memories. Lessons. Warnings. The Jedi made them. So did others. Some carried wisdom. Others carried things better left forgotten.",
	stopConversation = "false",
	options = {
		{"Why would something like that come to me?", "why_player"}
	}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(explainHolocron)

local whyPlayer = ConvoScreen:new {
	id = "why_player",
	leftDialog = "",
	customDialogText = "That is a much more interesting question. Holocrons have a peculiar habit of remaining silent in the hands of those they have nothing to say to.",
	stopConversation = "false",
	options = {
		{"So what am I supposed to do?", "instructions"}
	}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(whyPlayer)

local instructions = ConvoScreen:new {
	id = "instructions",
	leftDialog = "",
	customDialogText = "Listen. Search. There are more scattered throughout the galaxy: buried in ruins, carried by collectors, taken as trophies, or hidden by people who never understood what they possessed. Most are dead. Some are damaged. A few still whisper.",
	stopConversation = "false",
	options = {
		{"And if I find them?", "complete"}
	}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(instructions)

local complete = ConvoScreen:new {
	id = "complete",
	leftDialog = "",
	customDialogText = "Then perhaps, eventually, you'll understand why this one found you.",
	stopConversation = "true",
	options = {}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(complete)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "As you wish. If you seek answers, find me before the trail grows cold.",
	stopConversation = "true",
	options = {}
}
HolocronDiscoveryScholarConvoTemplate:addScreen(leave)

addConversationTemplate("HolocronDiscoveryScholar", HolocronDiscoveryScholarConvoTemplate)
