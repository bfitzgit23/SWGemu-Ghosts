local ObjectManager = require("managers.object.object_manager")

-- The Symbols of Chu-Gon Dar. Four pedestals stand around the cube in the
-- ruins; each answers to one combination and hands it over once per character.
chugondarCube = ScreenPlay:new {
	screenplayName = "chugondarCube",
	areas = {},
	pedestals = {
		{ -2520, 148, 40, "object/tangible/item/som/sher_kar_syringe.iff", "a syringe", "the suppressor combination" },
		{ -2565, 148, 40, "object/tangible/collection/rare_melee_caller_storms.iff", "the Caller of Storms", "the storm combination" },
		{ -2520, 148, 78, "object/tangible/collection/rare_melee_blade_betrayer.iff", "the Blade of the Betrayer", "the betrayer combination" },
		{ -2565, 148, 78, "object/tangible/loot/generic/usable/large_dispersal_unit_generic_lt_4.iff", "a dispersal unit", "the dispersal combination" }
	}
}

registerScreenPlay("chugondarCube", true)

function chugondarCube:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnCubeDevice()

		for i, pedestal in ipairs(self.pedestals) do
			self:spawnPedestal(i, pedestal)
		end
	end
end

function chugondarCube:spawnCubeDevice()
	spawnSceneObject("mustafar", "object/tangible/loot/mustafar/old_republic_data_cube_01.iff", -2542.81, 148, 58.28, 0, math.rad(0))
end

function chugondarCube:spawnPedestal(index, pedestal)
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", pedestal[1], pedestal[2], pedestal[3], 12, 0)

	if (pArea == nil) then
		return
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(12)
	chugondarCube.areas[SceneObject(pArea):getObjectID()] = index
	createObserver(ENTEREDAREA, "chugondarCube", "notifyPedestal", pArea)
end

function chugondarCube:notifyPedestal(pArea, pMovingObject, pPlayer)
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

	local pedestal = chugondarCube.pedestals[index]
	local playerID = SceneObject(pMovingObject):getObjectID()
	local key = playerID .. ":chugondarCube:" .. index
	local creature = CreatureObject(pMovingObject)

	if (readData(key) == 1) then
		creature:sendSystemMessage("\#CCCCCCThe cube has already given you this combination.")
		return 0
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory == nil) then
		return 0
	end

	giveItem(pInventory, pedestal[4], -1)
	writeData(key, 1)
	creature:sendSystemMessage("\#B266FFThe Symbols of Chu-Gon Dar resolve: " .. pedestal[6] .. " yields " .. pedestal[5] .. ".")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
	return 0
end
