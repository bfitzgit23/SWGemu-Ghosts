function createInformantTemplate(lvl)
	informant_npc_convotemplate = ConvoTemplate:new {
		initialScreen = "convoscreenstart",
		templateType = "InformantNPC",
		screens = {}
	}
	
	--The any-level informant (option link 0) has no level banner.
	local dialog = lvl
	if (lvl == "0") then
		dialog = ""
	end

	informant_npc_convoscreenstart = ConvoScreen:new {
		id = "convoscreenstart",
		leftDialog = dialog, --Level of the informant.
		stopConversation = "true",
		options = { 
			{"level", lvl }
		}
	}
	informant_npc_convotemplate:addScreen(informant_npc_convoscreenstart);

	addConversationTemplate("informant_npc_lvl_" .. lvl, informant_npc_convotemplate);
end

createInformantTemplate("1")
createInformantTemplate("2")
createInformantTemplate("3")
createInformantTemplate("0") --level-less informant: serves every mission level