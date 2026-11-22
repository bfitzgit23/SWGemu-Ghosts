-- Surveyor Jo Kelsev at the Mensix Mining Facility. She hands out the marker
-- rounds described in surveyor_jo.lua; walking into a marker area records it,
-- and reporting back to her pays the round out.

surveyorJoConvHandler = {}

function surveyorJoConvHandler:getNextConversationScreen(pConversationTemplate, pConversingPlayer, selectedOption)
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
			nextConversationScreen = conversation:getScreen("intro")
		end
	else
		nextConversationScreen = conversation:getScreen("intro")
	end

	return nextConversationScreen
end

function surveyorJoConvHandler:runScreenHandlers(pConversationTemplate, pConversingPlayer, pConversingNpc, selectedOption, pConversationScreen)
	local screen = LuaConversationScreen(pConversationScreen)
	local screenID = screen:getScreenID()

	if (screenID == "collect_pay") then
		surveyorJo:payRounds(pConversingPlayer)
	elseif (screenID == "accept_berken") then
		surveyorJo:startRound(pConversingPlayer, "berken")
	elseif (screenID == "accept_burning") then
		surveyorJo:startRound(pConversingPlayer, "burning")
	elseif (screenID == "accept_volcano") then
		surveyorJo:startRound(pConversingPlayer, "volcano")
	elseif (screenID == "accept_crystal") then
		surveyorJo:startRound(pConversingPlayer, "crystal")
	elseif (screenID == "accept_mining") then
		surveyorJo:startRound(pConversingPlayer, "mining")
	elseif (screenID == "accept_smoking") then
		surveyorJo:startRound(pConversingPlayer, "smoking")
	elseif (screenID == "accept_tulrus") then
		surveyorJo:startRound(pConversingPlayer, "tulrus")
	end

	return pConversationScreen
end

surveyorJoConv = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "surveyorJoConvHandler",
	screens = {}
}

local intro = ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "You have the walk of someone who has been out on the flows. Good. I keep markers on every region of this rock and I am short-handed checking them. Walk a round for me and I will pay for it.",
	stopConversation = "false",
	options = {
		{ "What are these markers?", "markers" },
		{ "I am here for my pay.", "collect_pay" },
		{ "Which round do you need walked?", "rounds" },
		{ "Not today.", "leave" }
	}
}
surveyorJoConv:addScreen(intro)

local markers = ConvoScreen:new {
	id = "markers",
	leftDialog = "",
	customDialogText = "Survey stakes, mostly. The crust shifts and the old readings go bad, so somebody has to stand at each one and confirm it still sits where the map says. Walk into a marker and your datapad will record it. Five thousand credits a region, and no fighting required.",
	stopConversation = "false",
	options = {
		{ "Which round do you need walked?", "rounds" },
		{ "I will take one.", "rounds" },
		{ "Not today.", "leave" }
	}
}
surveyorJoConv:addScreen(markers)

local rounds = ConvoScreen:new {
	id = "rounds",
	leftDialog = "",
	customDialogText = "Pick a region. I will mark the staked points on your datapad and you walk them in any order you like. Come back to me when the last one is checked.",
	stopConversation = "false",
	options = {
		{ "Berken's Flow.", "accept_berken" },
		{ "The Burning Plains.", "accept_burning" },
		{ "The Central Volcano.", "accept_volcano" },
		{ "The Crystal Flats.", "accept_crystal" },
		{ "The Mining Field.", "accept_mining" },
		{ "The Smoking Forest.", "accept_smoking" },
		{ "The Tulrus Nesting Grounds.", "accept_tulrus" },
		{ "Back.", "intro" }
	}
}
surveyorJoConv:addScreen(rounds)

local function acceptScreen(id, text)
	local screen = ConvoScreen:new {
		id = id,
		leftDialog = "",
		customDialogText = text,
		stopConversation = "true",
		options = {}
	}

	surveyorJoConv:addScreen(screen)
end

acceptScreen("accept_berken", "Berken's Flow is yours. The stakes are on your datapad. Walk them and come back.")
acceptScreen("accept_burning", "The Burning Plains is yours. Mind the lava between the stakes. Walk them and come back.")
acceptScreen("accept_volcano", "The Central Volcano is yours. The stakes are on your datapad. Walk them and come back.")
acceptScreen("accept_crystal", "The Crystal Flats is yours. The stakes are on your datapad. Walk them and come back.")
acceptScreen("accept_mining", "The Mining Field is yours. The stakes are on your datapad. Walk them and come back.")
acceptScreen("accept_smoking", "The Smoking Forest is yours. The stakes are on your datapad. Walk them and come back.")
acceptScreen("accept_tulrus", "The Tulrus Nesting Grounds is yours. Watch the tulrus. Walk the stakes and come back.")

local collect = ConvoScreen:new {
	id = "collect_pay",
	leftDialog = "",
	customDialogText = "Let me see the readings. ... That will do. Here is your five thousand, and the next round is yours if you want it.",
	stopConversation = "true",
	options = {}
}
surveyorJoConv:addScreen(collect)

local leave = ConvoScreen:new {
	id = "leave",
	leftDialog = "",
	customDialogText = "Then keep clear of the stakes. I will be here.",
	stopConversation = "true",
	options = {}
}
surveyorJoConv:addScreen(leave)

addConversationTemplate("surveyor_jo_conv", surveyorJoConv)
