-- ============================================================
-- Dark Jedi Lord Trainer - Conversation Template
-- Path: scripts/mobile/conversations/trainer/trainer_dark_jedi_lord_conv.lua
-- ============================================================

trainer_dark_jedi_lord_convotemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "trainer_conv_handler",
	screens = {}
}

intro = ConvoScreen:new {
	id = "intro",
	leftDialog = "@skill_teacher:trainer_dark_jedi_lord",
	stopConversation = "false",
	options = {
		{"@skill_teacher:opt1_1", "msg2_1"},
		{"@skill_teacher:opt1_2", "msg2_2"},
		{"@skill_teacher:opt1_3", "msg2_3"},
		{"@skill_teacher:opt1_4", "msg2_4"},
	}
}
trainer_dark_jedi_lord_convotemplate:addScreen(intro)

addConversationTemplate("trainer_dark_jedi_lord_convotemplate", trainer_dark_jedi_lord_convotemplate)
