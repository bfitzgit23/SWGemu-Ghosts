-- The generic pilot trainer conversation, used by every trainer that has no mission
-- chain of its own (the faction pilot trainers, the freelance/neutral ones, and the four
-- Crimson Phoenix trainers whose squadron conversations are not wired yet).
--
-- Those trainers hand out a starter ship, and now also say who does hand out
-- assignments: the squadron's own trainer while the player still owes it a tier, or the
-- pilot coordinator.  The handler picks the report screen per player.
--
-- Dialog text has to be a string-table id.  The client resolves anything without a
-- leading '@' as a loc key and renders it as "[]", which is why the first version of
-- this template (plain English text) showed up empty in game.
--
-- Every id below is borrowed from a conversation the client already ships, so nothing
-- has to be added to a client TRE:
--   @conversation/privateer_broker            gil_burtin_convo.lua  (neutral coordinator)
--   @conversation/corellia_privateer_trainer  rhea_convo.lua        (CorSec trainer)
--   @conversation/naboo_privateer_trainer_1   dinge_convo.lua       (RSF trainer)
--   @conversation/corellia_rebel_trainer_1    kreezo_convo.lua      (Havoc tier 1)
--   @conversation/naboo_rebel_trainer_1       v3fx_convo.lua        (Vortex tier 1)
--   @conversation/tatooine_rebel_trainer_1    socuna_convo.lua      (Crimson Phoenix)
--
-- NB an option may only link to a screen that exists in this template.
-- ConversationObserverImplementation::getNextConversationScreen() resolves the link and
-- gives up (closing the conversation, without ever calling runScreenHandlers) when the
-- screen is missing, so "pilot_trainer_missions_report" below has to stay declared even
-- though the handler replaces it with the per-player report screen.

pilot_trainer_convo_template = ConvoTemplate:new {
	initialScreen = "pilot_trainer_greeting",
	templateType = "Lua",
	luaClassHandler = "pilotTrainerConvoHandler",
	screens = {}
}

pilot_trainer_greeting = ConvoScreen:new {
	id = "pilot_trainer_greeting",
	leftDialog = "@conversation/privateer_broker:s_13dd951a", -- Hey, I've heard people talkin' about you! Rumor is you've turned into a pretty decent pilot! What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_ac05bfba", "pilot_trainer_missions"}, -- Are there any missions I can fly?
		{"@conversation/naboo_rebel_trainer_1:s_a42932d7", "pilot_trainer_request_ship"}, -- I will need a starship.
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "pilot_trainer_bye"}, -- I need to take care of some things first.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_greeting);

-- "I cannot assign you missions" - the client's own words for a trainer that is not in
-- the player's chain.
pilot_trainer_missions = ConvoScreen:new {
	id = "pilot_trainer_missions",
	leftDialog = "@conversation/corellia_rebel_trainer_1:s_150b3020", -- Since you're not in my unit I cannot assign you missions. You ought to go talk to your commanding officer for such things.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_60c4f974", "pilot_trainer_missions_report"}, -- Where do I go?
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "pilot_trainer_bye"}, -- I need to take care of some things first.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_missions);

-- Link screen for "Where do I go?".  runScreenHandlers turns it into the report screen
-- that names the destination trainer the player can actually go and see; the name, the
-- place and a waypoint also arrive as a system message.  This declaration is the
-- fallback for a player whose faction has no wired chain.
pilot_trainer_missions_report = ConvoScreen:new {
	id = "pilot_trainer_missions_report",
	leftDialog = "@conversation/corellia_rebel_trainer_1:s_150b3020", -- Since you're not in my unit I cannot assign you missions. You ought to go talk to your commanding officer for such things.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_missions_report);

-- One report screen per destination; the handler returns the one that matches the
-- player.  Every line below is the client's own text from the chain in question.
pilot_trainer_report_basic = ConvoScreen:new {
	id = "pilot_trainer_report_basic",
	leftDialog = "@conversation/corellia_rebel_trainer_1:s_150b3020", -- Since you're not in my unit I cannot assign you missions. You ought to go talk to your commanding officer for such things.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_report_basic);

pilot_trainer_report_havoc = ConvoScreen:new {
	id = "pilot_trainer_report_havoc",
	leftDialog = "@conversation/corellia_rebel_trainer_1:s_d828284a", -- You got it! Meet the Alliance Intel chief stationed on Lok. Her name is Lady Viopa, and she hangs out in Nym's compound. She'll have work for you when you arrive.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_report_havoc);

pilot_trainer_report_crimson = ConvoScreen:new {
	id = "pilot_trainer_report_crimson",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_b2c15146", -- Unfortunately, since you are not part of my unit, I cannot assign you missions. You should probably return and speak with your commanding officer.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_report_crimson);


-- Imperial squadron enrollment.  The broker only gives directions; the trainer
-- records the squadron so a player cannot be enrolled by a conversation they
-- never finished.
pilot_trainer_imperial_join_black_epsilon = ConvoScreen:new {
	id = "pilot_trainer_imperial_join_black_epsilon",
	customDialogText = "You are not assigned to a squadron yet. Black Epsilon is stationed at the Imperial Base on Talus, and they need pilots. Are you ready to join Black Epsilon?",
	stopConversation = "false",
	options = {
		{"@conversation/faction_recruiter_imperial:s_434", "pilot_trainer_imperial_join_accept"}, -- Absolutely. It would be a great honor to serve the Empire.
		{"@conversation/imperial_broker:s_169df3bb", "pilot_trainer_bye"}, -- Never mind.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_join_black_epsilon);

pilot_trainer_imperial_join_storm = ConvoScreen:new {
	id = "pilot_trainer_imperial_join_storm",
	customDialogText = "You are not assigned to a squadron yet. Storm Squadron is based in the Bestine Pilot's Club on Tatooine, and they need pilots. Are you ready to join Storm Squadron?",
	stopConversation = "false",
	options = {
		{"@conversation/faction_recruiter_imperial:s_434", "pilot_trainer_imperial_join_accept"}, -- Absolutely. It would be a great honor to serve the Empire.
		{"@conversation/imperial_broker:s_169df3bb", "pilot_trainer_bye"}, -- Never mind.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_join_storm);

pilot_trainer_imperial_join_inquisition = ConvoScreen:new {
	id = "pilot_trainer_imperial_join_inquisition",
	customDialogText = "You are not assigned to a squadron yet. The Imperial Inquisition operates from the association hall in Kaadara on Naboo. Are you ready to join the Imperial Inquisition?",
	stopConversation = "false",
	options = {
		{"@conversation/faction_recruiter_imperial:s_434", "pilot_trainer_imperial_join_accept"}, -- Absolutely. It would be a great honor to serve the Empire.
		{"@conversation/imperial_broker:s_169df3bb", "pilot_trainer_bye"}, -- Never mind.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_join_inquisition);

pilot_trainer_imperial_join_accept = ConvoScreen:new {
	id = "pilot_trainer_imperial_join_accept",
	customDialogText = "Then it's settled.",
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_join_accept);

pilot_trainer_imperial_joined = ConvoScreen:new {
	id = "pilot_trainer_imperial_joined",
	customDialogText = "Welcome to the squadron.",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_2d5d4bf0", "pilot_trainer_imperial_duty_return"}, -- I'm interested in a duty.
		{"@conversation/naboo_rebel_trainer_1:s_a42932d7", "pilot_trainer_request_ship"}, -- I will need a starship.
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "pilot_trainer_bye"}, -- I need to take care of some things first.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_joined);

pilot_trainer_imperial_assigned = ConvoScreen:new {
	id = "pilot_trainer_imperial_assigned",
	customDialogText = "You are already assigned to a squadron.",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_2d5d4bf0", "pilot_trainer_imperial_duty_return"}, -- I'm interested in a duty.
		{"@conversation/naboo_rebel_trainer_1:s_a42932d7", "pilot_trainer_request_ship"}, -- I will need a starship.
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "pilot_trainer_bye"}, -- I need to take care of some things first.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_assigned);

-- Imperial duty hubs.  The option labels are the client's own Imperial trainer
-- text; the left dialog is custom because each squadron has different targets.
pilot_trainer_imperial_duty_hub_black_epsilon = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_hub_black_epsilon",
	customDialogText = "Black Epsilon Command has two assignments ready. A Rebel B-Wing prototype cell is operating in the Corellia system, and a patrol route needs an Imperial presence. Which assignment will you take?",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_13e807c3", "pilot_trainer_imperial_duty_destroy"}, -- [Destroy Duty] I'm interested in hunting more B-Wing Prototypes.
		{"@conversation/tatooine_imperial_trainer_1:s_46c2a109", "pilot_trainer_imperial_duty_patrol"}, -- [Patrol Duty] I'm interested in going on patrol.
		{"@conversation/tatooine_imperial_trainer_1:s_670201ae", "pilot_trainer_request_ship"}, -- I need a ship.
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_hub_black_epsilon);

pilot_trainer_imperial_duty_hub_storm = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_hub_storm",
	customDialogText = "Storm Squadron has two assignments ready. Commerce raiders are active along the Tatooine routes, and the Bestine orbital security circuit needs another patrol. Which assignment will you take?",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_259013cd", "pilot_trainer_imperial_duty_destroy"}, -- [Destroy Duty] I'm interested in hunting pirates.
		{"@conversation/tatooine_imperial_trainer_1:s_46c2a109", "pilot_trainer_imperial_duty_patrol"}, -- [Patrol Duty] I'm interested in going on patrol.
		{"@conversation/tatooine_imperial_trainer_1:s_670201ae", "pilot_trainer_request_ship"}, -- I need a ship.
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_hub_storm);

pilot_trainer_imperial_duty_hub_inquisition = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_hub_inquisition",
	customDialogText = "The Inquisition has two assignments ready. Rebel fighters are massing in the Dantooine system, and a training patrol is due in the Naboo system. Which assignment will you take?",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_2d5d4bf0", "pilot_trainer_imperial_duty_destroy"}, -- I'm interested in a duty.
		{"@conversation/tatooine_imperial_trainer_1:s_46c2a109", "pilot_trainer_imperial_duty_patrol"}, -- [Patrol Duty] I'm interested in going on patrol.
		{"@conversation/tatooine_imperial_trainer_1:s_670201ae", "pilot_trainer_request_ship"}, -- I need a ship.
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_hub_inquisition);

-- These are the two link targets from the hub.  runScreenHandlers starts the
-- matching screenplay and replaces the screen with the briefing below.
pilot_trainer_imperial_duty_destroy = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_destroy",
	customDialogText = "I cannot assign that duty right now.",
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_destroy);

pilot_trainer_imperial_duty_patrol = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_patrol",
	customDialogText = "I cannot assign that patrol right now.",
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_patrol);

pilot_trainer_imperial_duty_started = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_started",
	customDialogText = "Assignment logged. Check your datapad for the details.",
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_started);

pilot_trainer_imperial_has_duty = ConvoScreen:new {
	id = "pilot_trainer_imperial_has_duty",
	customDialogText = "You are still on assignment. Finish it before requesting another.",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_has_duty);

pilot_trainer_imperial_duty_complete = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_complete",
	customDialogText = "Your last assignment is complete. I have another one ready when you are.",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_2d5d4bf0", "pilot_trainer_imperial_duty_return"}, -- I'm interested in a duty.
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_complete);

-- Link target used by the joined and completed screens.  The handler replaces it
-- with the correct squadron hub for the trainer being spoken to.
pilot_trainer_imperial_duty_return = ConvoScreen:new {
	id = "pilot_trainer_imperial_duty_return",
	customDialogText = "Choose an assignment.",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_1091c96a", "pilot_trainer_bye"}, -- I'm done for now.
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_imperial_duty_return);

pilot_trainer_request_ship = ConvoScreen:new {
	id = "pilot_trainer_request_ship",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b24af40a", -- You're going to need a ship, of course. I'll add these control codes for a basic one to your datapad.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b9b27823", "pilot_trainer_grant_ship"}, -- Thank you.
		{"@conversation/naboo_privateer_trainer_1:s_4358efe9", "pilot_trainer_grant_ship"}, -- Where is my ship?
	}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_request_ship);

pilot_trainer_grant_ship = ConvoScreen:new {
	id = "pilot_trainer_grant_ship",
	leftDialog = "@conversation/corellia_privateer_trainer:s_198b5a97", -- I've given you the control codes to a basic ship. The codes are visible in your datapad. Open your personal datapad to find them.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_grant_ship);

pilot_trainer_bye = ConvoScreen:new {
	id = "pilot_trainer_bye",
	leftDialog = "@conversation/privateer_broker:s_1d546116", -- Hm? Well, ok. See ya.
	stopConversation = "true",
	options = {}
}
pilot_trainer_convo_template:addScreen(pilot_trainer_bye);

addConversationTemplate("pilot_trainer_convo_template", pilot_trainer_convo_template);
