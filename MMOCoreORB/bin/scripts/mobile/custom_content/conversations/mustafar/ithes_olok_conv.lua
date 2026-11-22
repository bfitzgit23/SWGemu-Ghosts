-- Ithes Olok, beside the Chu-Gon Dar cube. The dialogue explains the cube,
-- hints at combinations and hands out the three test relics; the cube itself
-- takes three relics and answers (see chugondar_cube.lua).

ithesOlokConv = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "ithesOlokConvHandler",
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
		{ "Give me something to test it with.", "take_relics" },
		{ "Which relics go together?", "hints" },
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
		{ "What do I put in it?", "what_goes_in" },
		{ "Back.", "intro" }
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
		{ "Which relics go together?", "hints" },
		{ "I will try my luck.", "leave" }
	}
}
ithesOlokConv:addScreen(answers)

local whatGoesIn = ConvoScreen:new {
	id = "what_goes_in",
	leftDialog = "",
	customDialogText = "Anything that glows faintly with the Force. The beasts of Mustafar swallow them out in the flats, so search the creatures you put down. Put three in the cube and use it. Three different relics, no more, no less.",
	stopConversation = "false",
	options = {
		{ "Which relics go together?", "hints" },
		{ "Give me something to test it with.", "take_relics" },
		{ "I will find my own.", "relics" }
	}
}
ithesOlokConv:addScreen(whatGoesIn)

local hints = ConvoScreen:new {
	id = "hints",
	leftDialog = "",
	customDialogText = "Three relics, and never the same relic twice. A few the old hands swear by: a barely glowing with a dimly glowing and a faintly glowing, and the cube gives up a humming power cell. A barely with a dimly and a warmly, and you get a painted thing worth a wall. Two faintly glowing with a warmly glowing, and it made a long table for the hall. There are seventeen answers I know of.",
	stopConversation = "false",
	options = {
		{ "Where do I find relics?", "relics" },
		{ "Give me something to test it with.", "take_relics" },
		{ "I will try my luck.", "leave" }
	}
}
ithesOlokConv:addScreen(hints)

local relics = ConvoScreen:new {
	id = "relics",
	leftDialog = "",
	customDialogText = "Hunt. The beasts of this world are full of them, and stronger beasts are worth the trouble. If you want to start now, say so and I will part with three that I have no more use for.",
	stopConversation = "false",
	options = {
		{ "Give me something to test it with.", "take_relics" },
		{ "Which relics go together?", "hints" },
		{ "I will try my luck.", "leave" }
	}
}
ithesOlokConv:addScreen(relics)

local takeRelics = ConvoScreen:new {
	id = "take_relics",
	leftDialog = "",
	customDialogText = "Take these three. Put them in the cube and see what the Symbols make of you.",
	stopConversation = "true",
	options = {}
}
ithesOlokConv:addScreen(takeRelics)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "The Symbols are patient. I am not.",
	stopConversation = "true",
	options = {}
}
ithesOlokConv:addScreen(leave)

addConversationTemplate("ithes_olok_conv", ithesOlokConv)
