-- V3-FX (Vortex Squadron trainer, Moenia, Naboo) conversation.
--
-- Every line below is the client's own text for this NPC, taken from
-- string/en/conversation/naboo_rebel_trainer_1.stf.  The ids are content hashes, so
-- they can only be used with the table they came from - do not copy ids between
-- conversation tables.

v3fx_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "v3fxConvoHandler",
	screens = {}
}

-- JTL Disabled / no player object
v3fx_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_a425f33d", -- I have no use for you.
	stopConversation = "true",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_no_jtl)

-- Imperial Pilot
v3fx_convo_imperial = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_3fc246bd", -- Error.  You have been grounded by Alliance HQ.  There are serious accusations against you... Working for the Empire?!
	stopConversation = "true",
	animation = "wave_finger_warning",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_imperial)

-- Neutral / Privateer Pilot
v3fx_convo_neutral = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_466afe42", -- Forgive me. I am not authorized to assign missions to you. Perhaps you should speak with your commanding officer.
	stopConversation = "true",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_neutral)

-- Rebel, but not flying for the Alliance yet
v3fx_convo_recruit = ConvoScreen:new {
	id = "recruit_hint",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_2ff8ef01", -- Good for you!  Alliance command will be happy to have you as an asset both in space and planetside!  Just seek a Rebel Recruiter and tell him you want to join.  I'm certain there won't be a problem with it.
	stopConversation = "true",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_recruit)

-- Rebel pilot, but not part of the Vortex
v3fx_convo_not_vortex = ConvoScreen:new {
	id = "non_vortex_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_8c6a4b66", -- Oh. You are an Alliance pilot, but I do not recognize you. How may I be of service?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7ed5fec3", "join_vortex"}, -- I want to be part of the Alliance.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "goodbye"}, -- Goodbye, V3.
	}
}
v3fx_convo:addScreen(v3fx_convo_not_vortex)

v3fx_convo_join = ConvoScreen:new {
	id = "join_vortex",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_7d2cd92d", -- Then it is my pleasure to welcome you to the Alliance space navy.
	stopConversation = "false",
	animation = "salute1",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b9b27823", "duty_missions"}, -- Thank you.
		{"@conversation/naboo_rebel_trainer_1:s_a42932d7", "grant_ship"}, -- I will need a starship.
	}
}
v3fx_convo:addScreen(v3fx_convo_join)

-- No usable ship (never had one, or the control device was destroyed)
v3fx_convo_ship = ConvoScreen:new {
	id = "grant_ship",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_efd8333f", -- You are in luck. The Alliance has stowed a number of restored fighter craft at starports here on Naboo. I will upload the security codes for one of these vessels to your datapad.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b9b27823", "where_ship"}, -- Thank you.
	}
}
v3fx_convo:addScreen(v3fx_convo_ship)

v3fx_convo_where_ship = ConvoScreen:new {
	id = "where_ship",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_26bc1385", -- A basic Z95 starship is being held for you at the starport. I have uploaded the control codes for this ship to your personal datapad. Any time you wish to review the ship status, open your datapad and examine the ship control device.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_fc27931b", "duty_missions"}, -- Thanks.
	}
}
v3fx_convo:addScreen(v3fx_convo_where_ship)

-- Duty mission offer
v3fx_convo_duties = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_400d7391", -- Greetings, my friend. You will be pleased to know that Alliance High Command has authorized me to offer you a selection of combat duty missions. Are you interested in a duty mission?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_ac05bfba", "duty_types"}, -- Are there any missions I can fly?
		{"@conversation/naboo_rebel_trainer_1:s_6106187c", "duty_types"}, -- What is a duty mission?
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "goodbye"}, -- Goodbye, V3.
	}
}
v3fx_convo:addScreen(v3fx_convo_duties)

v3fx_convo_duty_types = ConvoScreen:new {
	id = "duty_types",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_96184c1", -- A duty mission is an excellent way of earning experience towards your next training session. No good trainer would teach a pilot with no experience. Duty missions have no real end to them, you simply finish whenever you are ready. Would you like a duty mission?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7a27e11", "duty_destroy"}, -- I'll blast any Imperial crosses my path!
		{"@conversation/naboo_rebel_trainer_1:s_cf63ee80", "duty_patrol"}, -- I would like to patrol Naboo space.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "goodbye"}, -- Goodbye, V3.
	}
}
v3fx_convo:addScreen(v3fx_convo_duty_types)

v3fx_convo_duty_destroy = ConvoScreen:new {
	id = "duty_destroy",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_ca5e8b8b", -- Affirmative, sir. I have placed your ID on the duty roster. You are free to sweep and clear Imperial warships in the area. You can return to the ground at any time when you feel that you have learned enough.
	stopConversation = "true",
	animation = "salute1",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_duty_destroy)

v3fx_convo_duty_patrol = ConvoScreen:new {
	id = "duty_patrol",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_4d3c3acd", -- You will fly a four-point patrol above Naboo. We will need your ship's sensor data when you are finished.
	stopConversation = "true",
	animation = "salute1",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_duty_patrol)

-- A duty is still running
v3fx_convo_has_duty = ConvoScreen:new {
	id = "has_duty",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_e31d65b7", -- The duty logs indicate that you are in mid-mission. We have nothing to discuss until you are finished.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_41e49ae6", "goodbye"}, -- Good day to you, then.
	}
}
v3fx_convo:addScreen(v3fx_convo_has_duty)

-- Duty flown to completion
v3fx_convo_complete = ConvoScreen:new {
	id = "duty_complete",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_45e27f53", -- You are clearly a superior pilot! Congratulations.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_ac05bfba", "duty_missions"}, -- Are there any missions I can fly?
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "goodbye"}, -- Goodbye, V3.
	}
}
v3fx_convo:addScreen(v3fx_convo_complete)

v3fx_convo_goodbye = ConvoScreen:new {
	id = "goodbye",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_41e49ae6", -- Good day to you, then.
	stopConversation = "true",
	options = {}
}
v3fx_convo:addScreen(v3fx_convo_goodbye)

addConversationTemplate("v3fx_convo", v3fx_convo);
