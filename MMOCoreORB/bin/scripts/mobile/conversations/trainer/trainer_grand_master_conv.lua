-- ============================================================
-- Grand Jedi Master Trainer - Conversation Template
-- Path: scripts/mobile/conversations/trainer/trainer_grand_jedi_master_conv.lua
-- This registers the conversation template that the trainer
-- mobile references via conversationTemplate field.
-- ============================================================

trainer_grand_jedi_master_convotemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "trainer_conv_handler",
	screens = {}
}

intro = ConvoScreen:new {
	id = "intro",
	leftDialog = "@skill_teacher:trainer_grand_jedi_master",
	stopConversation = "false",
	options = {
		{"@skill_teacher:opt1_1", "msg2_1"},
		{"@skill_teacher:opt1_2", "msg2_2"},
		{"@skill_teacher:opt1_3", "msg2_3"},
		{"@skill_teacher:opt1_4", "msg2_4"},
	}
}
trainer_grand_jedi_master_convotemplate:addScreen(intro)

addConversationTemplate("trainer_grand_jedi_master_convotemplate", trainer_grand_jedi_master_convotemplate)