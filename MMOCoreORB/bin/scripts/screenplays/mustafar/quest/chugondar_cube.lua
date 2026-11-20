local ObjectManager = require("managers.object.object_manager")

-- The Chu-Gon Dar cube at the ruins, with Ithes Olok beside it.
--
-- The four symbol stones around the cube each give up one glowing relic every
-- few minutes. Three relics go into the cube: if their glow combination is one
-- the Symbols answer to, the three are consumed and replaced by a single item.
-- A combination the cube does not know leaves the relics alone.
--
-- Glow tiers: 0 barely, 1 dimly, 2 faintly, 3 warmly.

ChugondarCubeMenuComponent = {}

function ChugondarCubeMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@ui_radial:item_use")

	return 0
end

function ChugondarCubeMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	if (selectedID == 20) then
		chugondarCube:activateCube(pPlayer)
	end

	return 0
end

IthesOlokMenuComponent = {}

function IthesOlokMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@ui_radial:item_use")

	return 0
end

function IthesOlokMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	if (selectedID == 20) then
		chugondarCube:giveTestRelics(pPlayer)
	end

	return 0
end

chugondarCube = ScreenPlay:new {
	screenplayName = "chugondarCube",
	areas = {},
	recipes = {
		{ tiers = { 0, 0, 0 }, template = "object/tangible/loot/mustafar/old_republic_tech_01.iff", name = "a humming Old Republic power cell" },
		{ tiers = { 0, 0, 1 }, template = "object/tangible/loot/mustafar/must_painting_01.iff", name = "a Mustafar painting of the Cataclysm" },
		{ tiers = { 0, 0, 2 }, template = "object/tangible/loot/mustafar/must_chair_01.iff", name = "a Mustafarian chair" },
		{ tiers = { 0, 1, 1 }, template = "object/tangible/loot/mustafar/must_table_small_01.iff", name = "a low Mustafarian table" },
		{ tiers = { 0, 1, 2 }, template = "object/tangible/loot/mustafar/throw_pillow_01.iff", name = "a blue throw pillow" },
		{ tiers = { 0, 2, 3 }, template = "object/tangible/loot/mustafar/generic_eye_of_mesra.iff", name = "the Eye of Mesra" },
		{ tiers = { 1, 1, 1 }, template = "object/tangible/loot/mustafar/trophey_lava_beetle.iff", name = "a mounted lava beetle" },
		{ tiers = { 1, 1, 2 }, template = "object/tangible/loot/mustafar/must_display_case.iff", name = "an Old Republic display case" },
		{ tiers = { 1, 2, 2 }, template = "object/tangible/loot/mustafar/jedi_relic_01.iff", name = "a Jedi relic" },
		{ tiers = { 1, 2, 3 }, template = "object/tangible/loot/mustafar/mustafar_map.iff", name = "a survey map of Mustafar" },
		{ tiers = { 1, 3, 3 }, template = "object/tangible/loot/mustafar/sith_relic_01.iff", name = "a Sith relic" },
		{ tiers = { 2, 2, 2 }, template = "object/tangible/loot/mustafar/old_republic_tech_05.iff", name = "an Old Republic tech component" },
		{ tiers = { 2, 2, 3 }, template = "object/tangible/loot/mustafar/lava_geode.iff", name = "a lava geode" },
		{ tiers = { 2, 3, 3 }, template = "object/tangible/loot/mustafar/trophey_xandank.iff", name = "a mounted xandank head" },
		{ tiers = { 3, 3, 3 }, template = "object/tangible/loot/mustafar/lava_crystal_click.iff", name = "a living lava crystal" }
	},
	stones = {
		{ x = -2520, y = 148, z = 40, relic = "Barely Glowing Relic", template = "object/tangible/loot/mustafar/cube/loot/cube_loot_0a.iff" },
		{ x = -2565, y = 148, z = 40, relic = "Dimly Glowing Relic", template = "object/tangible/loot/mustafar/cube/loot/cube_loot_1a.iff" },
		{ x = -2520, y = 148, z = 78, relic = "Faintly Glowing Relic", template = "object/tangible/loot/mustafar/cube/loot/cube_loot_2a.iff" },
		{ x = -2565, y = 148, z = 78, relic = "Warmly Glowing Relic", template = "object/tangible/loot/mustafar/cube/loot/cube_loot_3a.iff" }
	}
}

registerScreenPlay("chugondarCube", true)

function chugondarCube:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnCubeDevice()
		self:spawnStones()
		self:spawnItesOlok()
	end
end

function chugondarCube:spawnCubeDevice()
	local pCube = spawnSceneObject("mustafar", "object/tangible/loot/mustafar/old_republic_data_cube_01.iff", -2542.81, 148, 58.28, 0, math.rad(0))

	if (pCube == nil) then
		return
	end

	SceneObject(pCube):setObjectMenuComponent("ChugondarCubeMenuComponent")
end

function chugondarCube:spawnItesOlok()
	local pNpc = spawnMobile("mustafar", "npc_ithes_olok", 3600, -2534.0, 148, 66.0, math.rad(210), 0)

	if (pNpc == nil) then
		return
	end

	SceneObject(pNpc):setObjectMenuComponent("IthesOlokMenuComponent")
end

function chugondarCube:spawnStones()
	for i, stone in ipairs(self.stones) do
		local pArea = spawnActiveArea("mustafar", "object/active_area.iff", stone.x, stone.y, stone.z, 6, 0)

		if (pArea ~= nil) then
			local activeArea = LuaActiveArea(pArea)
			activeArea:setCellObjectID(0)
			activeArea:setRadius(6)
			chugondarCube.areas[SceneObject(pArea):getObjectID()] = i
			createObserver(ENTEREDAREA, "chugondarCube", "notifyStone", pArea)
		end
	end
end

function chugondarCube:notifyStone(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil or pArea == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local index = chugondarCube.areas[SceneObject(pArea):getObjectID()]

	if (index == nil) then
		return 0
	end

	local stone = chugondarCube.stones[index]
	local creature = CreatureObject(pMovingObject)
	local key = SceneObject(pMovingObject):getObjectID() .. ":chugondarCube:stone:" .. index

	if (readData(key) == 1) then
		creature:sendSystemMessage("\#CCCCCCThe symbol on this stone is dull. Give it a few minutes to answer again.")
		return 0
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory == nil) then
		return 0
	end

	local pRelic = giveItem(pInventory, stone.template, -1)

	if (pRelic == nil) then
		creature:sendSystemMessage("\#CCCCCCThe stone answers, but you have no room to take what it offers.")
		return 0
	end

	SceneObject(pRelic):setCustomObjectName(stone.relic)
	writeData(key, 1)
	createEvent(300000, "chugondarCube", "clearStone", pMovingObject, tostring(index))
	creature:sendSystemMessage("\#B266FFThe symbol on the stone answers, and " .. stone.relic .. " is in your hand.")
	return 0
end

function chugondarCube:clearStone(pPlayer, pArgs)
	if (pPlayer == nil) then
		return
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. ":chugondarCube:stone:" .. pArgs)
end

function chugondarCube:giveTestRelics(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)
	local key = SceneObject(pPlayer):getObjectID() .. ":chugondarCube:testRelics"

	if (readData(key) == 1) then
		creature:sendSystemMessage("\#CCCCCCIthes Olok: Three is all I can spare. The stones will answer you again soon enough.")
		return
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local relics = {
		{ "Barely Glowing Relic", "object/tangible/loot/mustafar/cube/loot/cube_loot_0a.iff" },
		{ "Barely Glowing Relic", "object/tangible/loot/mustafar/cube/loot/cube_loot_0b.iff" },
		{ "Barely Glowing Relic", "object/tangible/loot/mustafar/cube/loot/cube_loot_0c.iff" }
	}

	for i, relic in ipairs(relics) do
		local pRelic = giveItem(pInventory, relic[2], -1)

		if (pRelic ~= nil) then
			SceneObject(pRelic):setCustomObjectName(relic[1])
		end
	end

	writeData(key, 1)
	creature:sendSystemMessage("\#B266FFIthes Olok presses three relics into your hand. \"Put them in the cube and use it. Three, no more, no less.\"")
end

function chugondarCube:activateCube(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)
	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local inventory = LuaSceneObject(pInventory)
	local items = { {}, {}, {}, {} }
	local counts = { 0, 0, 0, 0 }
	local total = 0

	for i = 0, inventory:getContainerObjectsSize() - 1 do
		local pItem = inventory:getContainerObject(i)

		if (pItem ~= nil) then
			local tier = chugondarCube:getGlowTier(pItem)

			if (tier ~= nil) then
				total = total + 1
				counts[tier] = counts[tier] + 1
				table.insert(items[tier], pItem)
			end
		end
	end

	if (total < 3) then
		creature:sendSystemMessage("\#CCCCCCThe face of the Chu-Gon Dar cube is dark. It wants three glowing relics.")
		return
	end

	local recipe = chugondarCube:findRecipe(counts)

	if (recipe == nil) then
		creature:sendSystemMessage("\#CCCCCCThe Chu-Gon Dar cube shudders slightly, but nothing special seems to happen.")
		return
	end

	local pReward = giveItem(pInventory, recipe.template, -1)

	if (pReward == nil) then
		creature:sendSystemMessage("\#CCCCCCThe cube shimmers, but you have no room to hold what it makes.")
		return
	end

	for i, tier in ipairs(recipe.tiers) do
		local pItem = table.remove(items[tier])

		if (pItem ~= nil) then
			local item = LuaSceneObject(pItem)
			item:destroyObjectFromWorld(true)
			item:destroyObjectFromDatabase(true)
		end
	end

	creature:sendSystemMessage("\#B266FFThe surface of the Chu-Gon Dar Cube shimmers with the power of the Force. Inside rests " .. recipe.name .. ".")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

function chugondarCube:findRecipe(counts)
	for i, recipe in ipairs(self.recipes) do
		local need = { 0, 0, 0, 0 }
		local fits = true

		for j, tier in ipairs(recipe.tiers) do
			need[tier] = need[tier] + 1
		end

		for tier = 0, 3 do
			if (counts[tier] < need[tier]) then
				fits = false
			end
		end

		if (fits) then
			return recipe
		end
	end

	return nil
end

function chugondarCube:getGlowTier(pItem)
	local name = string.lower(SceneObject(pItem):getDisplayedName())

	if (string.find(name, "barely", 1, true) ~= nil) then
		return 0
	end

	if (string.find(name, "dimly", 1, true) ~= nil) then
		return 1
	end

	if (string.find(name, "faintly", 1, true) ~= nil) then
		return 2
	end

	if (string.find(name, "warmly", 1, true) ~= nil) then
		return 3
	end

	return nil
end
