local ObjectManager = require("managers.object.object_manager")

-- The four Mustafar miner stories. Foreman Chivos at the Mensix Mining Facility
-- signs the player on (right-click him and choose Use) and pays when the last
-- place in a story has been reached. The places themselves advance the job.
-- Progress is per character.

MinerForemanMenuComponent = {}

function MinerForemanMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@ui_radial:item_use")

	return 0
end

function MinerForemanMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	if (selectedID == 20) then
		mustafarMinerQuests:foremanUse(pPlayer)
	end

	return 0
end

mustafarMinerQuests = ScreenPlay:new {
	screenplayName = "mustafarMinerQuests",
	areas = {},
	quests = {
		{
			id = "strike",
			name = "The Strike",
			credits = 7500,
			item = "object/tangible/loot/mustafar/old_republic_tech_01.iff",
			itemName = "an Old Republic power cell",
			steps = {
				{ -507.47, 58.0, 3681.4, 70, "The wrecked Klegger mining facility. The picket line was here." },
				{ -6225.11, 41.474, 4388.46, 70, "The field miner camp in the Smoking Forest. They never came back from the picket." },
				{ -2155.66, 62.7735, 5511.92, 70, "The Mensix supply yard. The strike was settled here, badly." }
			}
		},
		{
			id = "madness",
			name = "Miner Madness",
			credits = 6000,
			item = "object/tangible/loot/mustafar/lava_geode.iff",
			itemName = "a lava geode",
			steps = {
				{ -4018.92, 75.1095, 2432.66, 70, "The Crystal Flats. The miner's tracks start here." },
				{ -4650.37, 186.342, 1692.05, 70, "The crystal falls. He was collecting something here, and something collected him." },
				{ -5920.99, 86.3664, 102.05, 70, "The salvage bandit camp. The miner's hoard is here." }
			}
		},
		{
			id = "fragments",
			name = "Fragments of the Past",
			credits = 8000,
			item = "object/tangible/loot/mustafar/old_republic_data_cube_01.iff",
			itemName = "an Old Republic data cube",
			steps = {
				{ -2542.81, 147.81, 58.28, 70, "The Chu-Gon Dar ruins. A fragment of Old Republic stone." },
				{ -610.59, 87.1491, 6031.32, 70, "The sealed Old Republic facility. A second fragment." },
				{ 79.3501, 128.963, 3971.21, 70, "The Jedi ruins. The fragments fit together." }
			}
		},
		{
			id = "shard",
			name = "The Cursed Shard",
			credits = 9000,
			item = "object/tangible/loot/mustafar/lava_crystal_click.iff",
			itemName = "a living lava crystal",
			steps = {
				{ -2789.93, 21.4531, 5921.04, 70, "The temple ruins. The shard is warm in your hand." },
				{ -2974.96, 118.937, 4176.87, 70, "The main lava flow. The shard drinks the heat." },
				{ 79.3501, 128.963, 3971.21, 70, "The Jedi ruins. The shard is quiet at last." }
			}
		}
	}
}

registerScreenPlay("mustafarMinerQuests", true)

function mustafarMinerQuests:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnForeman()

		for qi, quest in ipairs(self.quests) do
			for si, step in ipairs(quest.steps) do
				self:spawnStepArea(qi, si, step)
			end
		end
	end
end

function mustafarMinerQuests:spawnForeman()
	local pNpc = spawnMobile("mustafar", "must_foreman_chivos", 3600, -79.5, 10.8, 64.0, math.rad(-138), 12112226)

	if (pNpc == nil) then
		return
	end

	SceneObject(pNpc):setObjectMenuComponent("MinerForemanMenuComponent")
end

function mustafarMinerQuests:spawnStepArea(questIndex, stepIndex, step)
	local x, y, z, radius = step[1], step[2], step[3], step[4]
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", x, y, z, radius, 0)

	if (pArea == nil) then
		return
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(radius)
	mustafarMinerQuests.areas[SceneObject(pArea):getObjectID()] = { quest = questIndex, step = stepIndex }
	createObserver(ENTEREDAREA, "mustafarMinerQuests", "notifyStep", pArea)
end

function mustafarMinerQuests:foremanUse(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)

	if (creature == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- pay for a finished job first
	for i, quest in ipairs(mustafarMinerQuests.quests) do
		local key = playerID .. ":mustafarMinerQuests:" .. quest.id

		if (readData(key .. ":ready") == 1 and readData(key .. ":done") ~= 1) then
			local pInventory = creature:getSlottedObject("inventory")

			if (pInventory ~= nil) then
				local pItem = giveItem(pInventory, quest.item, -1)

				if (pItem ~= nil) then
					SceneObject(pItem):setCustomObjectName(quest.itemName)
				end
			end

			creature:addCashCredits(quest.credits, true)
			writeData(key .. ":done", 1)
			deleteData(key .. ":ready")
			deleteData(key)
			creature:sendSystemMessage("\\#66FF66" .. quest.name .. " is settled: " .. quest.credits .. " credits and " .. quest.itemName .. ".")
			creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
			return
		end
	end

	-- otherwise sign on for the first job not yet taken
	for i, quest in ipairs(mustafarMinerQuests.quests) do
		local key = playerID .. ":mustafarMinerQuests:" .. quest.id

		if (readData(key .. ":accepted") ~= 1 and readData(key .. ":done") ~= 1) then
			writeData(key .. ":accepted", 1)
			writeData(key, 0)
			creature:sendSystemMessage("\\#66CCFF" .. quest.name .. " is yours. " .. quest.steps[1][5])
			creature:playMusicMessage("sound/ui_npe2_quest_received.snd")
			mustafarMinerQuests:addWaypoint(pPlayer, quest.steps[1], quest.name)
			return
		end
	end

	creature:sendSystemMessage("\\#CCCCCCForeman Chivos has nothing else for you. Every job on his slate is taken or settled.")
end

function mustafarMinerQuests:acceptJob(pPlayer, questID)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)

	if (creature == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	for i, quest in ipairs(mustafarMinerQuests.quests) do
		if (quest.id == questID) then
			local key = playerID .. ":mustafarMinerQuests:" .. quest.id

			if (readData(key .. ":accepted") == 1) then
				creature:sendSystemMessage("\\#CCCCCC" .. quest.name .. " is already on your slate.")
				mustafarMinerQuests:addWaypoint(pPlayer, quest.steps[1], quest.name)
				return
			end

			if (readData(key .. ":done") == 1) then
				creature:sendSystemMessage("\\#CCCCCC" .. quest.name .. " is settled. I have nothing else like it.")
				return
			end

			writeData(key .. ":accepted", 1)
			writeData(key, 0)
			creature:sendSystemMessage("\\#66CCFF" .. quest.name .. " is yours. " .. quest.steps[1][5])
			creature:playMusicMessage("sound/ui_npe2_quest_received.snd")
			mustafarMinerQuests:addWaypoint(pPlayer, quest.steps[1], quest.name)
			return
		end
	end
end

function mustafarMinerQuests:addWaypoint(pPlayer, step, name)
	local player = LuaCreatureObject(pPlayer)
	local pGhost = player:getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):addWaypoint("mustafar", name, "", step[1], 0, step[3], WAYPOINT_ORANGE, true, true, 0)
end

function mustafarMinerQuests:notifyStep(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil or pArea == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local info = mustafarMinerQuests.areas[SceneObject(pArea):getObjectID()]

	if (info == nil) then
		return 0
	end

	local playerID = SceneObject(pMovingObject):getObjectID()
	local quest = mustafarMinerQuests.quests[info.quest]
	local key = playerID .. ":mustafarMinerQuests:" .. quest.id

	if (readData(key .. ":accepted") ~= 1 or readData(key .. ":done") == 1 or readData(key .. ":ready") == 1) then
		return 0
	end

	local reached = readData(key)

	if (reached == nil) then
		reached = 0
	end

	if (info.step ~= reached + 1) then
		return 0
	end

	local creature = CreatureObject(pMovingObject)
	creature:sendSystemMessage("\\#66CCFF" .. quest.steps[info.step][5])

	if (info.step < #quest.steps) then
		writeData(key, info.step)
		creature:playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return 0
	end

	writeData(key, info.step)
	writeData(key .. ":ready", 1)
	creature:sendSystemMessage("\\#66FF66" .. quest.name .. ": the trail goes cold. Return to Foreman Chivos at the Mensix Mining Facility for your pay.")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
	return 0
end
