--[[
	Ghosts of the Old Republic - Jedi Trainer Conversation
	Location: MMOCoreORB/bin/scripts/mobile/conversations/trainer/jedi_trainer_combined_convo.lua

	Registered as "jediTrainerConvoTemplate" to match the naming convention
	used by trainer_conv.lua (see lines 150-152 of that file).

	Uses the engine trainer_conv_handler (same handler as grand master / dark lord
	templates), so jedi and grey-jedi players actually get skill lists and training.
	The trainerType screen is processed first (invisible to the player) so the engine
	sets the trainer type to trainer_jedi BEFORE the player sees the intro.
--]]

jediTrainerConvoTemplate = ConvoTemplate:new {
	initialScreen   = "",
	templateType    = "Lua",
	luaClassHandler = "trainer_conv_handler",
	screens         = {},
}

-- -----------------------------------------------------------------------------
-- Trainer type (processed first, invisible to player; sets trainer_jedi so the
-- engine lists jedi skills and honors the jedi qualification gates)
-- -----------------------------------------------------------------------------
local trainerType = ConvoScreen:new {
	id            = "trainerType",
	leftDialog    = "",
	stopConversation = "false",
	options       = {
		{ "trainerType", "trainer_jedi" },
	},
}
jediTrainerConvoTemplate:addScreen(trainerType)

-- -----------------------------------------------------------------------------
-- Intro
-- -----------------------------------------------------------------------------
local intro = ConvoScreen:new {
	id            = "intro",
	leftDialog    = "The Force flows through all things. I am here to guide those who walk the path  whether you follow the light, the dark, or the balance between them.\n\nWhat do you seek?",
	stopConversation = "false",
	options       = {
		{ "Train me in the Jedi disciplines.", "train_jedi" },
		{ "Train me in the Grey Jedi path.",   "train_grey" },
		{ "Tell me about the Enclave.",        "about_enclave" },
		{ "Farewell.",                         "farewell" },
	},
}
jediTrainerConvoTemplate:addScreen(intro)

-- -----------------------------------------------------------------------------
-- Jedi path
-- -----------------------------------------------------------------------------
local train_jedi = ConvoScreen:new {
	id            = "train_jedi",
	leftDialog    = "The Jedi disciplines encompass Lightsaber, Force Powers, Healing, Enhancements, and Defence. I can instruct you in all of them up to the rank of Knight.\n\nWhen you are ready to advance beyond Knight, seek the Enclave  they alone may grant you the title of Master.",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt1_1", "msg2_1" },
		{ "@skill_teacher:opt1_2", "msg2_2" },
	},
}
jediTrainerConvoTemplate:addScreen(train_jedi)

-- -----------------------------------------------------------------------------
-- Grey Jedi path
-- -----------------------------------------------------------------------------
local train_grey = ConvoScreen:new {
	id            = "train_grey",
	leftDialog    = "The Grey Jedi walk between light and dark  beholden to neither, yet understanding both. I can guide you through the full Grey path: from novice through the Elder disciplines and the Rank of Council.\n\nBalance is harder to maintain than it appears.",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt1_1", "msg2_1" },
		{ "@skill_teacher:opt1_2", "msg2_2" },
	},
}
jediTrainerConvoTemplate:addScreen(train_grey)

-- -----------------------------------------------------------------------------
-- Skill listing / learning screens (standard trainer flow)
-- -----------------------------------------------------------------------------
local msg2_1 = ConvoScreen:new {
	id            = "msg2_1",
	leftDialog    = "",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt2_1", "learn" },
		{ "@skill_teacher:opt2_2", "msg2_2" },
		{ "@skill_teacher:opt2_3", "intro" },
	},
}
jediTrainerConvoTemplate:addScreen(msg2_1)

local msg2_2 = ConvoScreen:new {
	id            = "msg2_2",
	leftDialog    = "",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt2_1", "learn" },
		{ "@skill_teacher:opt2_2", "msg2_2" },
		{ "@skill_teacher:opt2_3", "intro" },
	},
}
jediTrainerConvoTemplate:addScreen(msg2_2)

local learn = ConvoScreen:new {
	id            = "learn",
	leftDialog    = "",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt3_1", "confirm_learn" },
		{ "@skill_teacher:opt3_2", "msg2_1" },
		{ "@skill_teacher:opt3_3", "intro" },
	},
}
jediTrainerConvoTemplate:addScreen(learn)

local confirm_learn = ConvoScreen:new {
	id            = "confirm_learn",
	leftDialog    = "",
	stopConversation = "false",
	options       = {
		{ "@skill_teacher:opt4_1", "intro" },
		{ "@skill_teacher:opt4_2", "learn" },
		{ "@skill_teacher:opt4_3", "intro" },
	},
}
jediTrainerConvoTemplate:addScreen(confirm_learn)

-- -----------------------------------------------------------------------------
-- About Enclave
-- -----------------------------------------------------------------------------
local about_enclave = ConvoScreen:new {
	id            = "about_enclave",
	leftDialog    = "The Enclave is the seat of mastery for those who follow the Jedi path. Once you have reached the rank of Knight through my teachings, travel there to be elevated to Master.\n\nThe Grey Jedi answer to their own council  but even they may find wisdom at the Enclave.",
	stopConversation = "false",
	options       = {
		{ "Thank you for the guidance.", "intro" },
	},
}
jediTrainerConvoTemplate:addScreen(about_enclave)

-- -----------------------------------------------------------------------------
-- Farewell
-- -----------------------------------------------------------------------------
local farewell = ConvoScreen:new {
	id            = "farewell",
	leftDialog    = "May the Force guide your steps, wherever they take you.",
	stopConversation = "true",
	options       = {},
}
jediTrainerConvoTemplate:addScreen(farewell)

