local ObjectManager = require("managers.object.object_manager")

-- The four Mustafar miner stories. Each is walked, not talked: the objective
-- areas are on the real mining sites, so the quest advances when the player
-- reaches the place the story is about. Progress is per character.
mustafarMinerQuests = ScreenPlay:new {
	screenplayName = "mustafarMinerQuests",
	areas = {}
}

registerScreenPlay("mustafarMinerQuests", true)

mustafarMinerQuests.quests = {
	{
		id = "strike",
		name = "The Strike",
		credits = 7500,
		item = "object/tangible/loot/mustafar/old_republic_tech_01.iff",
		steps = {
			{ -507.47, 58.0, 3681.4, 70, "The wrecked Klegger mining facility. The picket line was here." },
			{ -6225.11, 41.474, 4388.46, 70, "The field miner camp in the Smoking Forest." },
			{ -2155.66, 62.7735, 5511.92, 70, "The Mensix supply yard. The strike is settled." },
		}
	},
	{
		id = "madness",
		name = "Miner Madness",
		credits = 6000,
		item = "object/tangible/loot/mustafar/lava_geode.iff",
		steps = {
			{ -4018.92, 75.1095, 2432.66, 70, "The Crystal Flats. The miner's tracks start here." },
			{ -4650.37, 186.342, 1692.05, 70, "The crystal falls. He was collecting something here." },
			{ -5920.99, 86.3664, 102.05, 70, "The salvage bandit camp. The miner's hoard is here." },
		}
	},
	{
		id = "fragments",
		name = "Fragments of the Past",
		credits = 8000,
		item = "object/tangible/loot/mustafar/old_republic_data_cube_01.iff",
		steps = {
			{ -2542.81, 147.81, 58.28, 70, "The Chu-Gon Dar ruins. A fragment of Old Republic stone." },
			{ -610.59, 87.1491, 6031.32, 70, "The sealed Old Republic facility. A second fragment." },
			{ 79.3501, 128.963, 3971.21, 70, "The Jedi ruins. The fragments fit together." },
		}
	},
	{
		id = "shard",
		name = "The Cursed Shard",
		credits = 9000,
		item = "object/tangible/loot/mustafar/lava_crystal_click.iff",
		steps = {
			{ -2789.93, 21.4531, 5921.04, 70, "The temple ruins. The shard is warm in your hand." },
			{ -2974.96, 118.937, 4176.87, 70, "The main lava flow. The shard drinks the heat." },
			{ 79.3501, 128.963, 3971.21, 70, "The Jedi ruins. The shard is quiet at last." },
		}
	}
}

function mustafarMinerQuests:start()
	if (isZoneEnabled("mustafar")) then
		for qi, quest in ipairs(self.quests) do
			for si, step in ipairs(quest.steps) do
				self:spawnStepArea(qi, si, step)
			end
		end
	end
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

	if (readData(key .. ":done") == 1) then
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
	local stepText = quest.steps[info.step][5]

	if (info.step == 1) then
		creature:sendSystemMessage("\#66CCFF" .. quest.name .. " started.")
		creature:playMusicMessage("sound/ui_npe2_quest_received.snd")
	end

	creature:sendSystemMessage("\#66CCFF" .. stepText)

	if (info.step < #quest.steps) then
		writeData(key, info.step)
		creature:playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return 0
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, quest.item, -1)
	end

	creature:addCashCredits(quest.credits, true)
	creature:sendSystemMessage("\#66FF66" .. quest.name .. " complete. " .. quest.credits .. " credits awarded.")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
	writeData(key .. ":done", 1)
	deleteData(key)
	return 0
end
