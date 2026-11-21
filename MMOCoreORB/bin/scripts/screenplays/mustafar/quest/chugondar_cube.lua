local ObjectManager = require("managers.object.object_manager")

-- The Chu-Gon Dar cube at the ruins, with Ithes Olok beside it.
--
-- Glowing relics drop from the creatures of Mustafar, in tiers that depend on
-- how dangerous the beast is: the rank and file carry barely and dimly glowing
-- relics, the big ones carry faintly and warmly glowing relics. Put three of
-- them in the cube and use it: if the three are a combination the Symbols
-- answer to, they are consumed and the cube produces a single item. Any other
-- three leave the relics untouched.
--
-- Combinations are matched by relic template, not by name.

local BARELY_A = "object/tangible/loot/mustafar/cube/loot/cube_loot_0a.iff"
local BARELY_B = "object/tangible/loot/mustafar/cube/loot/cube_loot_0b.iff"
local DIMLY_A = "object/tangible/loot/mustafar/cube/loot/cube_loot_1a.iff"
local DIMLY_B = "object/tangible/loot/mustafar/cube/loot/cube_loot_1b.iff"
local FAINTLY_A = "object/tangible/loot/mustafar/cube/loot/cube_loot_2a.iff"
local FAINTLY_B = "object/tangible/loot/mustafar/cube/loot/cube_loot_2b.iff"
local WARMLY_A = "object/tangible/loot/mustafar/cube/loot/cube_loot_3a.iff"
local WARMLY_B = "object/tangible/loot/mustafar/cube/loot/cube_loot_3b.iff"

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
	relicTemplates = { BARELY_A, BARELY_B, DIMLY_A, DIMLY_B, FAINTLY_A, FAINTLY_B, WARMLY_A, WARMLY_B },
	recipes = {
		{ relics = { BARELY_A, DIMLY_A, FAINTLY_A }, template = "object/tangible/loot/mustafar/old_republic_tech_01.iff", name = "a humming Old Republic power cell" },
		{ relics = { BARELY_B, DIMLY_B, WARMLY_A }, template = "object/tangible/loot/mustafar/must_painting_01.iff", name = "a Mustafar painting of the Cataclysm" },
		{ relics = { DIMLY_A, FAINTLY_B, WARMLY_B }, template = "object/tangible/loot/mustafar/must_chair_01.iff", name = "a Mustafarian chair" },
		{ relics = { BARELY_A, BARELY_B, DIMLY_A }, template = "object/tangible/loot/mustafar/throw_pillow_01.iff", name = "a blue throw pillow" },
		{ relics = { BARELY_A, BARELY_B, DIMLY_B }, template = "object/tangible/loot/mustafar/must_table_small_01.iff", name = "a low Mustafarian table" },
		{ relics = { DIMLY_A, DIMLY_B, FAINTLY_B }, template = "object/tangible/loot/mustafar/must_display_case.iff", name = "an Old Republic display case" },
		{ relics = { BARELY_A, FAINTLY_A, WARMLY_A }, template = "object/tangible/loot/mustafar/generic_eye_of_mesra.iff", name = "the Eye of Mesra" },
		{ relics = { DIMLY_A, FAINTLY_B, WARMLY_B }, template = "object/tangible/loot/mustafar/jedi_relic_01.iff", name = "a Jedi relic" },
		{ relics = { BARELY_B, DIMLY_B, WARMLY_B }, template = "object/tangible/loot/mustafar/mustafar_map.iff", name = "a survey map of Mustafar" },
		{ relics = { FAINTLY_A, FAINTLY_B, WARMLY_A }, template = "object/tangible/loot/mustafar/must_table_large_01.iff", name = "a long Mustafarian table" },
		{ relics = { FAINTLY_B, WARMLY_A, WARMLY_B }, template = "object/tangible/loot/mustafar/trophey_xandank.iff", name = "a mounted xandank head" },
		{ relics = { DIMLY_B, FAINTLY_A, WARMLY_B }, template = "object/tangible/loot/mustafar/sith_relic_01.iff", name = "a Sith relic" },
		{ relics = { BARELY_B, DIMLY_A, FAINTLY_B }, template = "object/tangible/loot/mustafar/lava_geode.iff", name = "a lava geode" },
		{ relics = { BARELY_A, DIMLY_B, FAINTLY_B }, template = "object/tangible/loot/mustafar/must_painting_02.iff", name = "a Mustafar painting of the lava fields" },
		{ relics = { DIMLY_B, FAINTLY_A, WARMLY_A }, template = "object/tangible/loot/mustafar/old_republic_tech_05.iff", name = "an Old Republic tech component" },
		{ relics = { BARELY_B, FAINTLY_B, WARMLY_A }, template = "object/tangible/loot/mustafar/trophey_lava_beetle.iff", name = "a mounted lava beetle" },
		{ relics = { BARELY_A, DIMLY_A, WARMLY_B }, template = "object/tangible/loot/mustafar/lava_crystal_click.iff", name = "a living lava crystal" }
	}
}

registerScreenPlay("chugondarCube", true)

function chugondarCube:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnCubeDevice()
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

function chugondarCube:giveTestRelics(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)
	local key = SceneObject(pPlayer):getObjectID() .. ":chugondarCube:testRelics"

	if (readData(key) == 1) then
		creature:sendSystemMessage("\#CCCCCCIthes Olok: Three is all I can spare. The beasts of the flats carry more.")
		return
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local relics = { BARELY_A, DIMLY_A, FAINTLY_A }

	for i, template in ipairs(relics) do
		giveItem(pInventory, template, -1)
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

	local recipe, items = chugondarCube:findRecipe(pInventory)

	if (recipe == nil) then
		if (chugondarCube:hasRelic(pInventory)) then
			creature:sendSystemMessage("\#CCCCCCThe Chu-Gon Dar cube shudders slightly, but nothing special seems to happen.")
		else
			creature:sendSystemMessage("\#CCCCCCThe face of the Chu-Gon Dar cube is dark and cold. It wants three glowing relics, no two of them alike, to answer with anything at all.")
		end

		return
	end

	local pReward = giveItem(pInventory, recipe.template, -1)

	if (pReward == nil) then
		creature:sendSystemMessage("\#CCCCCCThe cube shimmers, but you have no room to hold what it makes.")
		return
	end

	for i, pItem in ipairs(items) do
		local item = LuaSceneObject(pItem)
		item:destroyObjectFromWorld(true)
		item:destroyObjectFromDatabase(true)
	end

	creature:sendSystemMessage("\#B266FFThe surface of the Chu-Gon Dar Cube shimmers with the power of the Force. Inside rests " .. recipe.name .. ".")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

-- Returns the first recipe whose three relics are all in the container, with the
-- three relic objects to consume. Every recipe lists three different templates,
-- so each lookup returns a different relic.
function chugondarCube:findRecipe(pContainer)
	for i, recipe in ipairs(self.recipes) do
		local items = {}
		local complete = true

		for j, template in ipairs(recipe.relics) do
			local pItem = getContainerObjectByTemplate(pContainer, template, false)

			if (pItem == nil) then
				complete = false
				break
			end

			items[j] = pItem
		end

		if (complete) then
			return recipe, items
		end
	end

	return nil, nil
end

-- True when any glowing relic at all is in the container, whatever its tier.
function chugondarCube:hasRelic(pContainer)
	for i, template in ipairs(self.relicTemplates) do
		if (getContainerObjectByTemplate(pContainer, template, false) ~= nil) then
			return true
		end
	end

	return false
end
