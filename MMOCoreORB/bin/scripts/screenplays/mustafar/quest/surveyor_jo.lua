local ObjectManager = require("managers.object.object_manager")

-- Surveyor Jo Kelsev's marker rounds at Mensix. Walk into each of a region's
-- staked points and the datapad records it; report back to Jo to be paid.
-- Progress is per character, per region. Jo stands in the Mensix Mining
-- Facility with the rest of the facility's staff.

SurveyorJoMenuComponent = {}

function SurveyorJoMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@ui_radial:item_use")

	return 0
end

function SurveyorJoMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	if (selectedID == 20) then
		surveyorJo:use(pPlayer)
	end

	return 0
end

surveyorJo = ScreenPlay:new {
	screenplayName = "surveyorJo",
	areas = {},
	regions = {
		{
			id = "berken",
			name = "Berken's Flow",
			pay = 5000,
			markers = {
				{ -507.47, 58.0, 3681.4 },
				{ -574.82, 61.786, 2491.94 },
				{ 392.49, 45.1373, 2220.11 },
				{ 79.3501, 128.963, 3971.21 },
				{ -610.59, 87.1491, 6031.32 }
			}
		},
		{
			id = "burning",
			name = "The Burning Plains",
			pay = 5000,
			markers = {
				{ -2155.66, 62.7735, 5511.92 },
				{ -2776.59, 23.5186, 4593.53 },
				{ -2805.63, 122.179, 5131.71 },
				{ -2789.93, 21.4531, 5921.04 },
				{ -4490.58, 15.909, 5905.25 }
			}
		},
		{
			id = "volcano",
			name = "The Central Volcano",
			pay = 5000,
			markers = {
				{ -2974.96, 118.937, 4176.87 },
				{ -3703.1, 136.583, 3405.69 },
				{ -2783.21, 144.265, 3154.02 }
			}
		},
		{
			id = "crystal",
			name = "The Crystal Flats",
			pay = 5000,
			markers = {
				{ -4018.92, 75.1095, 2432.66 },
				{ -5207.46, 5.71105, 2506.45 },
				{ -4650.37, 186.342, 1692.05 },
				{ -5920.99, 86.3664, 102.05 },
				{ -4248.21, 73.8265, 177.7 }
			}
		},
		{
			id = "mining",
			name = "The Mining Field",
			pay = 5000,
			markers = {
				{ -2949.52, 133.114, 1293.82 },
				{ -2035.3, 151.1, 704.2 },
				{ -2542.81, 147.81, 58.28 },
				{ -734.32, 103.559, -193.217 },
				{ 168.49, 127.989, -205.708 }
			}
		},
		{
			id = "smoking",
			name = "The Smoking Forest",
			pay = 5000,
			markers = {
				{ -4284.06, 80.8645, 3375.31 },
				{ -5151.03, 180.804, 4243.6 },
				{ -6225.11, 41.474, 4388.46 },
				{ -4430.97, 44.4592, -4960.32 },
				{ -5453.01, 137.572, 6194.37 }
			}
		},
		{
			id = "tulrus",
			name = "The Tulrus Nesting Grounds",
			pay = 5000,
			markers = {
				{ -1660.25, 74.0196, 2445.78 },
				{ -1797.86, 83.2939, 3038.4 },
				{ -1971, 85.2697, 4073.65 }
			}
		}
	}
}

registerScreenPlay("surveyorJo", true)

function surveyorJo:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnSurveyor()

		for ri, region in ipairs(self.regions) do
			for mi, marker in ipairs(region.markers) do
				self:spawnMarkerArea(ri, mi, marker)
			end
		end
	end
end

function surveyorJo:spawnSurveyor()
	local pNpc = spawnMobile("mustafar", "surveyor_jo", 3600, -73.5, 10.8, 64.0, math.rad(-138), 12112226)

	if (pNpc == nil) then
		return
	end

	SceneObject(pNpc):setObjectMenuComponent("SurveyorJoMenuComponent")
	print("[surveyorJo] Surveyor Jo spawned at Mensix")
end

function surveyorJo:spawnMarkerArea(regionIndex, markerIndex, marker)
	local radius = 14
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", marker[1], marker[2], marker[3], radius, 0)

	if (pArea == nil) then
		return
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(radius)
	surveyorJo.areas[SceneObject(pArea):getObjectID()] = { region = regionIndex, marker = markerIndex }
	createObserver(ENTEREDAREA, "surveyorJo", "notifyMarker", pArea)
end

function surveyorJo:getRegion(regionID)
	for i, region in ipairs(surveyorJo.regions) do
		if (region.id == regionID) then
			return region
		end
	end

	return nil
end

function surveyorJo:keyFor(pPlayer, regionID)
	return SceneObject(pPlayer):getObjectID() .. ":surveyorJo:" .. regionID
end

function surveyorJo:use(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not surveyorJo:payRounds(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("\\#CCCCCCSurveyor Jo wants you to walk a round before she pays. Ask her about the markers.")
	end
end

function surveyorJo:startRound(pPlayer, regionID)
	local region = surveyorJo:getRegion(regionID)

	if (region == nil or pPlayer == nil) then
		return
	end

	local creature = CreatureObject(pPlayer)
	local key = surveyorJo:keyFor(pPlayer, regionID)

	if (readData(key .. ":done") == 1) then
		creature:sendSystemMessage("\\#CCCCCC" .. region.name .. " has already been walked and paid for.")
		return
	end

	if (readData(key .. ":active") == 1) then
		creature:sendSystemMessage("\\#66CCFF" .. region.name .. " is already on your datapad. " .. #region.markers .. " stakes to walk.")
		surveyorJo:addWaypoint(pPlayer, region, 1)
		return
	end

	writeData(key .. ":active", 1)
	creature:sendSystemMessage("\\#66CCFF" .. region.name .. " is yours. Walk all " .. #region.markers .. " stakes and return to Surveyor Jo for your pay.")
	creature:playMusicMessage("sound/ui_npe2_quest_received.snd")
	surveyorJo:addWaypoint(pPlayer, region, 1)
end

function surveyorJo:addWaypoint(pPlayer, region, markerIndex)
	local marker = region.markers[markerIndex]

	if (marker == nil) then
		return
	end

	local player = LuaCreatureObject(pPlayer)
	local pGhost = player:getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):addWaypoint("mustafar", region.name .. " " .. markerIndex, "", marker[1], marker[2], marker[3], WAYPOINT_ORANGE, true, true, 0)
end

function surveyorJo:notifyMarker(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil or pArea == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local info = surveyorJo.areas[SceneObject(pArea):getObjectID()]

	if (info == nil) then
		return 0
	end

	local region = surveyorJo.regions[info.region]

	if (region == nil) then
		return 0
	end

	local key = surveyorJo:keyFor(pMovingObject, region.id)

	if (readData(key .. ":active") ~= 1 or readData(key .. ":ready") == 1 or readData(key .. ":done") == 1) then
		return 0
	end

	local markerKey = key .. ":m" .. info.marker

	if (readData(markerKey) == 1) then
		return 0
	end

	writeData(markerKey, 1)

	local checked = 0

	for i = 1, #region.markers do
		if (readData(key .. ":m" .. i) == 1) then
			checked = checked + 1
		end
	end

	local creature = CreatureObject(pMovingObject)

	if (checked < #region.markers) then
		creature:sendSystemMessage("\\#66CCFF" .. region.name .. ": stake " .. checked .. " of " .. #region.markers .. " checked.")
		creature:playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return 0
	end

	writeData(key .. ":ready", 1)
	creature:sendSystemMessage("\\#66FF66" .. region.name .. ": every stake is checked. Return to Surveyor Jo at the Mensix Mining Facility for your pay.")
	creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
	return 0
end

function surveyorJo:payRounds(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	for i, region in ipairs(surveyorJo.regions) do
		local key = surveyorJo:keyFor(pPlayer, region.id)

		if (readData(key .. ":ready") == 1 and readData(key .. ":done") ~= 1) then
			local creature = CreatureObject(pPlayer)
			creature:addCashCredits(region.pay, true)
			writeData(key .. ":done", 1)
			deleteData(key .. ":ready")
			deleteData(key .. ":active")
			creature:sendSystemMessage("\\#66FF66" .. region.name .. " is settled: " .. region.pay .. " credits.")
			creature:playMusicMessage("sound/ui_npe2_quest_completed.snd")
			return true
		end
	end

	return false
end
