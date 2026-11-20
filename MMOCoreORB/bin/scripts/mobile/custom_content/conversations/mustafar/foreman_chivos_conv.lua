-- Foreman Chivos at the Mensix Mining Facility. The dialogue tells the four
-- miner stories; signing on and collecting pay is done from his radial menu
-- (see mustafar_miner_quests.lua).

foremanChivosConv = ConvoTemplate:new {
	initialScreen = "menu",
	templateType = "Lua",
	screens = {}
}

local menu = ConvoScreen:new {
	id = "menu",
	leftDialog = "",
	customDialogText = "You are not one of mine, and that is the only reason I am talking to you. Four jobs on my slate and nobody sober enough to walk them.",
	stopConversation = "false",
	options = {
		{ "Tell me about the jobs.", "jobs" },
		{ "What does the work pay?", "pay" },
		{ "Nothing today.", "leave" }
	}
}
foremanChivosConv:addScreen(menu)

local jobs = ConvoScreen:new {
	id = "jobs",
	leftDialog = "",
	customDialogText = "The Strike. Miner Madness. Fragments of the Past. The Cursed Shard. Pick one and I will put it on your slate and mark the first place.",
	stopConversation = "false",
	options = {
		{ "The Strike.", "strike" },
		{ "Miner Madness.", "madness" },
		{ "Fragments of the Past.", "fragments" },
		{ "The Cursed Shard.", "shard" },
		{ "Back.", "menu" }
	}
}
foremanChivosConv:addScreen(jobs)

local strike = ConvoScreen:new {
	id = "strike",
	leftDialog = "",
	customDialogText = "Klegger's old facility went dark three weeks back and the picket line outside it never came home. Start at the wreck, then the field camp in the Smoking Forest, then my supply yard. /way -507 3681 wreck; /way -6225 4388 camp; /way -2155 5511 yard.",
	stopConversation = "false",
	options = {
		{ "How do I sign on?", "sign_on" },
		{ "Back to the list.", "jobs" }
	}
}
foremanChivosConv:addScreen(strike)

local madness = ConvoScreen:new {
	id = "madness",
	leftDialog = "",
	customDialogText = "Vess has been digging the Crystal Flats on his own time and has stopped reporting in. His tracks run to the falls, and the bandits camp past them. /way -4018 2432 flats; /way -4650 1692 falls; /way -5920 102 camp.",
	stopConversation = "false",
	options = {
		{ "How do I sign on?", "sign_on" },
		{ "Back to the list.", "jobs" }
	}
}
foremanChivosConv:addScreen(madness)

local fragments = ConvoScreen:new {
	id = "fragments",
	leftDialog = "",
	customDialogText = "Three fragments of Old Republic stone and I want all three. One in the Chu-Gon Dar ruins, one at the sealed facility, and the last in the Jedi ruins where the surveyors swear they fit. /way -2542 58 ruins; /way -610 6031 facility; /way 79 3971 jedi ruins.",
	stopConversation = "false",
	options = {
		{ "How do I sign on?", "sign_on" },
		{ "Back to the list.", "jobs" }
	}
}
foremanChivosConv:addScreen(fragments)

local shard = ConvoScreen:new {
	id = "shard",
	leftDialog = "",
	customDialogText = "A shard came out of the temple ruins and every miner who touched it has had the same dream. Walk it to the lava flow, then leave it in the Jedi ruins where the cult will not follow. /way -2789 5921 temple; /way -2974 4176 lava; /way 79 3971 jedi ruins.",
	stopConversation = "false",
	options = {
		{ "How do I sign on?", "sign_on" },
		{ "Back to the list.", "jobs" }
	}
}
foremanChivosConv:addScreen(shard)

local pay = ConvoScreen:new {
	id = "pay",
	leftDialog = "",
	customDialogText = "Six thousand for the madness, seven and a half for the strike, eight for the fragments, nine for the shard. You get paid when the last place is walked, not before.",
	stopConversation = "false",
	options = {
		{ "Back.", "menu" }
	}
}
foremanChivosConv:addScreen(pay)

local signOn = ConvoScreen:new {
	id = "sign_on",
	leftDialog = "",
	customDialogText = "Right-click me and choose Use. I will put the next job on your slate and mark its first place on your datapad. Come back to me the same way when the last place is walked.",
	stopConversation = "true",
	options = {}
}
foremanChivosConv:addScreen(signOn)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "Then move. The lava does not wait and neither do I.",
	stopConversation = "true",
	options = {}
}
foremanChivosConv:addScreen(leave)

addConversationTemplate("foreman_chivos_conv", foremanChivosConv)
