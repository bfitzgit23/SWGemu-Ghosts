-- Foreman Chivos at the Mensix Mining Facility. The dialogue tells the four
-- miner stories and can sign the player on directly; right-clicking him and
-- choosing Use still works as the short path (see mustafar_miner_quests.lua).

foremanChivosConvHandler = {}

function foremanChivosConvHandler:getNextConversationScreen(pConversationTemplate, pConversingPlayer, selectedOption)
	local convosession = CreatureObject(pConversingPlayer):getConversationSession()
	local lastConversationScreen = nil

	if (convosession ~= nil) then
		local session = LuaConversationSession(convosession)
		lastConversationScreen = session:getLastConversationScreen()
	end

	local conversation = LuaConversationTemplate(pConversationTemplate)
	local nextConversationScreen

	if (lastConversationScreen ~= nil) then
		local luaLastConversationScreen = LuaConversationScreen(lastConversationScreen)
		local optionLink = luaLastConversationScreen:getOptionLink(selectedOption)

		nextConversationScreen = conversation:getScreen(optionLink)

		if nextConversationScreen == nil then
			nextConversationScreen = conversation:getScreen("menu")
		end
	else
		nextConversationScreen = conversation:getScreen("menu")
	end

	return nextConversationScreen
end

function foremanChivosConvHandler:runScreenHandlers(pConversationTemplate, pConversingPlayer, pConversingNpc, selectedOption, pConversationScreen)
	local screen = LuaConversationScreen(pConversationScreen)
	local screenID = screen:getScreenID()

	if (screenID == "accept_strike") then
		mustafarMinerQuests:acceptJob(pConversingPlayer, "strike")
	elseif (screenID == "accept_madness") then
		mustafarMinerQuests:acceptJob(pConversingPlayer, "madness")
	elseif (screenID == "accept_fragments") then
		mustafarMinerQuests:acceptJob(pConversingPlayer, "fragments")
	elseif (screenID == "accept_shard") then
		mustafarMinerQuests:acceptJob(pConversingPlayer, "shard")
	elseif (screenID == "collect_pay") then
		mustafarMinerQuests:foremanUse(pConversingPlayer)
	end

	return pConversationScreen
end

foremanChivosConv = ConvoTemplate:new {
	initialScreen = "menu",
	templateType = "Lua",
	luaClassHandler = "foremanChivosConvHandler",
	screens = {}
}

local menu = ConvoScreen:new {
	id = "menu",
	leftDialog = "",
	customDialogText = "You are not one of mine, and that is the only reason I am talking to you. Four jobs on my slate and nobody sober enough to walk them.",
	stopConversation = "false",
	options = {
		{ "Tell me about the jobs.", "jobs" },
		{ "I am here for my pay.", "collect_pay" },
		{ "What does the work pay?", "pay" },
		{ "Nothing today.", "leave" }
	}
}
foremanChivosConv:addScreen(menu)

local jobs = ConvoScreen:new {
	id = "jobs",
	leftDialog = "",
	customDialogText = "The Strike. Miner Madness. Fragments of the Past. The Cursed Shard. Pick one and it goes on your slate with the first place marked.",
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
		{ "Put me on that job.", "accept_strike" },
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
		{ "Put me on that job.", "accept_madness" },
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
		{ "Put me on that job.", "accept_fragments" },
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
		{ "Put me on that job.", "accept_shard" },
		{ "Back to the list.", "jobs" }
	}
}
foremanChivosConv:addScreen(shard)

local function acceptedScreen(id, text)
	local screen = ConvoScreen:new {
		id = id,
		leftDialog = "",
		customDialogText = text,
		stopConversation = "true",
		options = {}
	}

	foremanChivosConv:addScreen(screen)
end

acceptedScreen("accept_strike", "The Strike is yours. The first place is on your datapad. Walk all three and come back to me.")
acceptedScreen("accept_madness", "Miner Madness is yours. The first place is on your datapad. Walk all three and come back to me.")
acceptedScreen("accept_fragments", "Fragments of the Past is yours. The first place is on your datapad. Walk all three and come back to me.")
acceptedScreen("accept_shard", "The Cursed Shard is yours. The first place is on your datapad. Walk all three and come back to me.")

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

local collect = ConvoScreen:new {
	id = "collect_pay",
	leftDialog = "",
	customDialogText = "Let me see. ... That is the last place walked. Here is your pay, and there is more work if you want it.",
	stopConversation = "true",
	options = {}
}
foremanChivosConv:addScreen(collect)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "Then move. The lava does not wait and neither do I.",
	stopConversation = "true",
	options = {}
}
foremanChivosConv:addScreen(leave)

addConversationTemplate("foreman_chivos_conv", foremanChivosConv)
