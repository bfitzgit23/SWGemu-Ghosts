local ObjectManager = require("managers.object.object_manager")

-- Chandrila landmarks. The two shuttleports are the only coordinates this map
-- publishes, so the new spots sit a short walk out from them; nudge a row in
-- the table below if a spot sits better somewhere else.
chandrilaLandmarks = ScreenPlay:new {
	screenplayName = "chandrilaLandmarks",
	areas = {}
}

registerScreenPlay("chandrilaLandmarks", true)

chandrilaLandmarks.spots = {
	{ id = "junari",    name = "Junari Point",       x = -4872, y = 18, z = 664,
	  text = "Junari Point. Boats pull in along the boardwalk and the water is warm enough to swim." },
	{ id = "sahot",     name = "Lake Sah'ot",        x = -4472, y = 18, z = -436,
	  text = "Lake Sah'ot. Anglers work the shallows for sahot eels and the rangers pay for a full catch." },
	{ id = "canyon",    name = "Crystal Canyon",     x = 1678,  y = 6,  z = -4161,
	  text = "Crystal Canyon. Something in the crystal seams keeps the local predators close." },
	{ id = "mothma",    name = "Mothma Estate",      x = -722,  y = 6,  z = -2661,
	  text = "Mothma Estate. Rebel pilots fly low over the estate most afternoons." },
	{ id = "gladean",   name = "Gladean State Park", x = 578,   y = 6,  z = -1561,
	  text = "Gladean State Park. Chandrilan paralopes graze between the walking trails." },
	{ id = "emita",     name = "Emita",              x = -5872, y = 18, z = -636,
	  text = "Emita. A fishing village of a few hundred people and one very busy dock." }
}

function chandrilaLandmarks:start()
	if (isZoneEnabled("chandrila")) then
		for i, spot in ipairs(self.spots) do
			self:spawnSpot(i, spot)
		end

		self:spawnCanyonGuardians()
		self:spawnLakeJobs()
		self:spawnEmitaStarportTerminal()
	end
end

function chandrilaLandmarks:spawnSpot(index, spot)
	spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", spot.x, spot.y, spot.z, 0, math.rad(0))
	spawnMobile("chandrila", "chandrila_park_ranger", 600, spot.x + 3, spot.y, spot.z + 2, 0, 0)

	local pArea = spawnActiveArea("chandrila", "object/active_area.iff", spot.x, spot.y, spot.z, 60, 0)

	if (pArea == nil) then
		return
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(60)
	chandrilaLandmarks.areas[SceneObject(pArea):getObjectID()] = index
	createObserver(ENTEREDAREA, "chandrilaLandmarks", "notifySpot", pArea)
end

function chandrilaLandmarks:notifySpot(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil or pArea == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local index = chandrilaLandmarks.areas[SceneObject(pArea):getObjectID()]

	if (index == nil) then
		return 0
	end

	local spot = chandrilaLandmarks.spots[index]
	local creature = CreatureObject(pMovingObject)
	local key = SceneObject(pMovingObject):getObjectID() .. ":chandrilaLandmarks:" .. spot.id

	if (readData(key) == 1) then
		return 0
	end

	writeData(key, 1)
	creature:sendSystemMessage("\#99CCFF" .. spot.text)

	if (spot.id == "mothma") then
		creature:sendSystemMessage("\#FF6666A rebel flight roars low over the Mothma Estate, trailing smoke and cheering crowds.")
	end

	return 0
end

function chandrilaLandmarks:spawnCanyonGuardians()
	local guardians = {
		{ 1678, 6, -4161, "chand_rasp" },
		{ 1708, 6, -4131, "chand_rasp" },
		{ 1648, 6, -4131, "chand_rasp" },
		{ 1708, 6, -4191, "chand_gubbur" },
		{ 1648, 6, -4191, "chand_gubbur" },
		{ 1678, 6, -4121, "chand_gubbur" },
	}

	for i, g in ipairs(guardians) do
		spawnMobile("chandrila", g[4], 900, g[1], g[2], g[3], 0, 0)
	end
end

function chandrilaLandmarks:spawnLakeJobs()
	local pArea = spawnActiveArea("chandrila", "object/active_area.iff", -4472, 18, -436, 80, 0)

	if (pArea == nil) then
		return
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(80)
	createObserver(ENTEREDAREA, "chandrilaLandmarks", "notifyLakeJob", pArea)
end

function chandrilaLandmarks:notifyLakeJob(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local creature = CreatureObject(pMovingObject)
	local key = SceneObject(pMovingObject):getObjectID() .. ":chandrilaLandmarks:lake_job"

	if (readData(key) == 1) then
		creature:sendSystemMessage("\#CCCCCCThe Sah'ot rangers have no more work for you today.")
		return 0
	end

	local pInventory = creature:getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, "object/tangible/loot/mustafar/lava_geode.iff", -1)
	end

	creature:addCashCredits(4000, true)
	writeData(key, 1)
	creature:sendSystemMessage("\#66FF66The Lake Sah'ot rangers pay you 4,000 credits for the day's catch.")
	creature:playMusicMessage("sound/ui_npe2_quest_credits.snd")
	return 0
end

function chandrilaLandmarks:spawnEmitaStarportTerminal()
	-- Emita's dock gets a public starship terminal, so pilots can launch and
	-- land from the village instead of walking back to a Chandrila shuttleport.
	spawnSceneObject("chandrila", "object/tangible/terminal/terminal_travel.iff", -5866, 18, -630, 0, math.rad(200))
end
