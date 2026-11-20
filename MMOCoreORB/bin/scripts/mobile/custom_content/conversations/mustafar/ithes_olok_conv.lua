-- Ithes Olok, beside the Chu-Gon Dar cube. The dialogue only explains the cube
-- and the relics; handing out the three test relics is done from his radial
-- menu (see chugondar_cube.lua), because Lua conversation handlers are not
-- called by this server.

ithesOlokConv = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	screens = {}
}

local intro = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "You have the look of someone who has been poking at old stone. Good. Most who come here only want to sell the place.",
	stopConversation = "false",
	options = {
		{ "What is this cube?", "what_is" },
		{ "What do I put in it?", "what_goes_in" },
		{ "Nothing. Good day.", "leave" }
	}
}
ithesOlokConv:addScreen(intro)

local whatIs = ConvoScreen:new {
	id = "what_is",
	leftDialog = "",
	customDialogText = "The Chu-Gon Dar cube. Four symbols were cut into the stone around it, and the cube answers to all of them at once. It was made to hold three things and answer them.",
	stopConversation = "false",
	options = {
		{ "Answer them how?", "answers" },
		{ "What do I put in it?", "what_goes_in" }
	}
}
ithesOlokConv:addScreen(whatIs)

local answers = ConvoScreen:new {
	id = "answers",
	leftDialog = "",
	customDialogText = "It makes something new out of what it is given, and what it gives back depends entirely on what went in. Three relics of the right glow, and the cube answers. Three of the wrong glow, and it shudders and keeps them.",
	stopConversation = "false",
	options = {
		{ "Where do I find relics?", "relics" },
		{ "I will try my luck.", "leave" }
	}
}
ithesOlokConv:addScreen(answers)

local whatGoesIn = ConvoScreen:new {
	id = "what_goes_in",
	leftDialog = "",
	customDialogText = "The stones standing around the cube give up glowing relics. Put three of them in the cube and use it. Three, no more, no less. One barely glowing thing and two warm ones is not the same as three warm ones.",
	stopConversation = "false",
	options = {
		{ "Give me something to test it with.", "test_relics" },
		{ "I will find my own.", "relics" }
	}
}
ithesOlokConv:addScreen(whatGoesIn)

local relics = ConvoScreen:new {
	id = "relics",
	leftDialog = "",
	customDialogText = "The stones answer on their own, given a few minutes between asking. If you want to start now, right-click me and choose Use, and I will part with three that I have no more use for.",
	stopConversation = "false",
	options = {
		{ "I will try my luck.", "leave" }
	}
}
ithesOlokConv:addScreen(relics)

local testRelics = ConvoScreen:new {
	id = "test_relics",
	leftDialog = "",
	customDialogText = "Take these three. Right-click me and choose Use if you want them. Then put them in the cube and see what the Symbols make of you.",
	stopConversation = "true",
	options = {}
}
ithesOlokConv:addScreen(testRelics)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "The Symbols are patient. I am not.",
	stopConversation = "true",
	options = {}
}
ithesOlokConv:addScreen(leave)

addConversationTemplate("ithes_olok_conv", ithesOlokConv)
