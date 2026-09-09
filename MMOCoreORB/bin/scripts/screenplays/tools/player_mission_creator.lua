-- Player-created destroy mission setup. The C++ mission generator validates and
-- applies these preferences when the player next browses a mission terminal.

player_mission_creator = ScreenPlay:new {
	numberOfActs = 1,
	directions = {
		{name = "North", value = 360},
		{name = "North West", value = 45},
		{name = "West", value = 90},
		{name = "South West", value = 135},
		{name = "South", value = 180},
		{name = "South East", value = 225},
		{name = "East", value = 270},
		{name = "North East", value = 315},
	}
}

function player_mission_creator:start()
end

function player_mission_creator:openWindow(pPlayer)
	if pPlayer == nil then
		return
	end

	local sui = SuiListBox.new("player_mission_creator", "typeSelection")
	sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())
	sui.setTitle("Create Player Mission")
	sui.setPrompt("Choose the mission type. A single-creature mission pays 75% of a nest/lair mission. The server calculates the reward from the selected level.")
	sui.add("Single Creature", "")
	sui.add("Nest / Lair", "")
	sui.add("Reset Custom Mission", "")
	sui.sendTo(pPlayer)
end

function player_mission_creator:typeSelection(pPlayer, pSui, eventIndex, args)
	if eventIndex == 1 or args == "-1" then
		return
	end

	local choice = tonumber(args)
	if choice == 2 then
		deleteScreenPlayData(pPlayer, "player_mission_creator", "enabled")
		deleteScreenPlayData(pPlayer, "player_mission_creator", "type")
		deleteScreenPlayData(pPlayer, "player_mission_creator", "level")
		deleteScreenPlayData(pPlayer, "player_mission_creator", "direction")
		deleteScreenPlayData(pPlayer, "player_mission_creator", "template")
		CreatureObject(pPlayer):sendSystemMessage("Player-created mission settings have been reset.")
		return
	end

	writeScreenPlayData(pPlayer, "player_mission_creator", "enabled", "1")
	writeScreenPlayData(pPlayer, "player_mission_creator", "type", choice == 0 and "single" or "nest")

	local sui = SuiInputBox.new("player_mission_creator", "levelSelection")
	sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())
	sui.setTitle("Mission Level")
	sui.setPrompt("Enter a mission level from 1 to 250. Level 10 nest missions pay 2,000 credits and level 250 nest missions pay 1,000,000 credits.")
	sui.sendTo(pPlayer)
end

function player_mission_creator:levelSelection(pPlayer, pSui, eventIndex, args)
	if eventIndex == 1 then
		return
	end

	local level = tonumber(args)
	if level == nil or level < 1 or level > 250 or level ~= math.floor(level) then
		CreatureObject(pPlayer):sendSystemMessage("Mission level must be a whole number from 1 to 250.")
		self:openWindow(pPlayer)
		return
	end

	writeScreenPlayData(pPlayer, "player_mission_creator", "level", tostring(level))
	writeScreenPlayData(pPlayer, "mission_level_choice", "levelChoice", tostring(level))

	local sui = SuiListBox.new("player_mission_creator", "directionSelection")
	sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())
	sui.setTitle("Mission Direction")
	sui.setPrompt("Choose the direction. The target will be placed approximately 1,500 meters from your current position.")
	for i = 1, #self.directions do
		sui.add(self.directions[i].name, "")
	end
	sui.sendTo(pPlayer)
end

function player_mission_creator:directionSelection(pPlayer, pSui, eventIndex, args)
	if eventIndex == 1 or args == "-1" then
		return
	end

	local selected = self.directions[tonumber(args) + 1]
	if selected == nil then
		return
	end

	writeScreenPlayData(pPlayer, "player_mission_creator", "direction", tostring(selected.value))
	writeScreenPlayData(pPlayer, "mission_direction_choice", "directionChoice", tostring(selected.value))
	self:showCreatureSelection(pPlayer)
end

function player_mission_creator:showCreatureSelection(pPlayer)
	local planet = SceneObject(pPlayer):getZoneName()
	local wantedType = readScreenPlayData(pPlayer, "player_mission_creator", "type")
	local choices = {}
	local catalogCount = tonumber(readScreenPlayData(pPlayer, "player_mission_catalog", "count")) or 0

	if catalogCount > 0 then
		for i = 0, catalogCount - 1 do
			local template = readScreenPlayData(pPlayer, "player_mission_catalog", "template" .. i)
			local isSingle = string.find(template, "boss_01", 1, true) ~= nil
			local isNest = string.find(template, "_lair_", 1, true) ~= nil or string.find(template, "_nest_", 1, true) ~= nil
			if (wantedType == "single" and isSingle) or (wantedType == "nest" and isNest) then
				table.insert(choices, template)
			end
		end
	end

	if #choices == 0 then
		-- The creature spawn tables may live in a separate Lua state on some cores.
		-- An empty target tells C++ to choose a valid planet target of the requested type.
		writeScreenPlayData(pPlayer, "player_mission_creator", "template", "")
		CreatureObject(pPlayer):sendSystemMessage("Mission preset saved. Browse this terminal to receive your custom " .. wantedType .. " missions.")
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":playerMissionChoiceCount", #choices)
	for i = 1, #choices do
		writeStringData(playerID .. ":playerMissionChoice:" .. i, choices[i])
	end

	local sui = SuiListBox.new("player_mission_creator", "creatureSelection")
	sui.setTargetNetworkId(playerID)
	sui.setTitle("Planet Creature")
	sui.setPrompt("Choose a creature available in " .. planet .. ".")
	for i = 1, #choices do
		local name = string.gsub(choices[i], "^" .. planet .. "_", "")
		name = string.gsub(name, "_", " ")
		sui.add(name, "")
	end
	sui.sendTo(pPlayer)
end

function player_mission_creator:creatureSelection(pPlayer, pSui, eventIndex, args)
	if eventIndex == 1 or args == "-1" then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local index = tonumber(args) + 1
	local count = readData(playerID .. ":playerMissionChoiceCount")
	if index < 1 or index > count then
		return
	end

	local template = readStringData(playerID .. ":playerMissionChoice:" .. index)
	writeScreenPlayData(pPlayer, "player_mission_creator", "template", template)
	CreatureObject(pPlayer):sendSystemMessage("Mission preset saved. Browse this terminal to receive your custom missions.")
end

registerScreenPlay("player_mission_creator", true)
