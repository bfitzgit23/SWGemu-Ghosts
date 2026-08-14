--[[
	Ghosts of the Old Republic - Jedi Trainer Conversation
	Location: MMOCoreORB/bin/scripts/mobile/conversations/trainer/jedi_trainer_combined_convo.lua

	Registered as "jediTrainerConvoTemplate" to match the naming convention
	used by trainer_conv.lua (see lines 157-158 of that file).

	No require() calls  SWGEmu's CreatureTemplateManager loads this file
	directly. Any require() will cause a module-not-found error.
--]]

jediTrainerConvoTemplate = ConversationTemplate:new {
	initialScreen   = "intro",
	templateType    = "Lua",
	luaClassHandler = "JediTrainerConvoHandler",
	screens         = {},
}

-- -----------------------------------------------------------------------------
-- Intro
-- -----------------------------------------------------------------------------
local intro = ConversationScreen:new {
	leftDialog       = "The Force flows through all things. I am here to guide those who walk the path  whether you follow the light, the dark, or the balance between them.\n\nWhat do you seek?",
	stopConversation = "false",
	options          = {},
}
intro:addOption("Train me in the Jedi disciplines.",  "train_jedi")
intro:addOption("Train me in the Grey Jedi path.",    "train_grey")
intro:addOption("Tell me about the Enclave.",         "about_enclave")
intro:addOption("Farewell.",                          "farewell")
jediTrainerConvoTemplate.screens["intro"] = intro

-- -----------------------------------------------------------------------------
-- Jedi path
-- -----------------------------------------------------------------------------
local train_jedi = ConversationScreen:new {
	leftDialog       = "The Jedi disciplines encompass Lightsaber, Force Powers, Healing, Enhancements, and Defence. I can instruct you in all of them up to the rank of Knight.\n\nWhen you are ready to advance beyond Knight, seek the Enclave  they alone may grant you the title of Master.",
	stopConversation = "false",
	options          = {},
}
train_jedi:addOption("Understood.", "intro")
jediTrainerConvoTemplate.screens["train_jedi"] = train_jedi

-- -----------------------------------------------------------------------------
-- Grey Jedi path
-- -----------------------------------------------------------------------------
local train_grey = ConversationScreen:new {
	leftDialog       = "The Grey Jedi walk between light and dark  beholden to neither, yet understanding both. I can guide you through the full Grey path: from novice through the Elder disciplines and the Rank of Council.\n\nBalance is harder to maintain than it appears.",
	stopConversation = "false",
	options          = {},
}
train_grey:addOption("I understand. Let us begin.", "intro")
jediTrainerConvoTemplate.screens["train_grey"] = train_grey

-- -----------------------------------------------------------------------------
-- About Enclave
-- -----------------------------------------------------------------------------
local about_enclave = ConversationScreen:new {
	leftDialog       = "The Enclave is the seat of mastery for those who follow the Jedi path. Once you have reached the rank of Knight through my teachings, travel there to be elevated to Master.\n\nThe Grey Jedi answer to their own council  but even they may find wisdom at the Enclave.",
	stopConversation = "false",
	options          = {},
}
about_enclave:addOption("Thank you for the guidance.", "intro")
jediTrainerConvoTemplate.screens["about_enclave"] = about_enclave

-- -----------------------------------------------------------------------------
-- Farewell
-- -----------------------------------------------------------------------------
local farewell = ConversationScreen:new {
	leftDialog       = "May the Force guide your steps, wherever they take you.",
	stopConversation = "true",
	options          = {},
}
jediTrainerConvoTemplate.screens["farewell"] = farewell

-- -----------------------------------------------------------------------------
-- Handler
-- -----------------------------------------------------------------------------
JediTrainerConvoHandler = conv_handler:new {}

function JediTrainerConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convo = LuaConversationTemplate(pConvTemplate)
	return convo:getScreen("intro")
end

function JediTrainerConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	return pConvScreen
end