local ObjectManager = require("managers.object.object_manager")

-- Mustafar lava. Standing in a lava flow burns players for as long as they
-- stay in it; ordinary vehicles cannot be damaged from Lua yet, so riders are
-- only hurt once they step out and stand in it themselves.
mustafarLavaHazard = ScreenPlay:new {
	screenplayName = "mustafarLavaHazard",
	burning = {}
}

registerScreenPlay("mustafarLavaHazard", true)

function mustafarLavaHazard:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnLavaArea(-2974.96, 118.94, 4176.87, 90)  -- main lava flow
		self:spawnLavaArea(-2790.0, 21.45, 5921.04, 60)   -- northern crust, Burning Plains
		self:spawnLavaArea(-3703.1, 136.58, 3405.69, 55)  -- lava by the Kubaza cavern
		self:spawnLavaArea(-4650.37, 186.34, 1692.05, 50) -- crystal falls
	end
end

function mustafarLavaHazard:spawnLavaArea(x, y, z, radius)
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", x, y, z, radius, 0)

	if (pArea == nil) then
		return nil
	end

	local activeArea = LuaActiveArea(pArea)
	activeArea:setCellObjectID(0)
	activeArea:setRadius(radius)
	createObserver(ENTEREDAREA, "mustafarLavaHazard", "notifyLavaEnter", pArea)
	createObserver(EXITEDAREA, "mustafarLavaHazard", "notifyLavaExit", pArea)
	return pArea
end

function mustafarLavaHazard:notifyLavaEnter(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	local playerID = SceneObject(pMovingObject):getObjectID()
	mustafarLavaHazard.burning[playerID] = true
	CreatureObject(pMovingObject):sendSystemMessage("\#FF6600The lava erupts around you. Get out of the flow!")
	mustafarLavaHazard:scheduleBurn(pMovingObject)
	return 0
end

function mustafarLavaHazard:notifyLavaExit(pArea, pMovingObject, pPlayer)
	if (pMovingObject == nil) then
		return 0
	end

	if (not SceneObject(pMovingObject):isPlayerCreature()) then
		return 0
	end

	mustafarLavaHazard.burning[SceneObject(pMovingObject):getObjectID()] = nil
	return 0
end

function mustafarLavaHazard:scheduleBurn(pPlayer)
	createEvent(3000, "mustafarLavaHazard", "lavaTick", pPlayer, "")
end

function mustafarLavaHazard:lavaTick(pPlayer, pArgs)
	if (pPlayer == nil) then
		return 0
	end

	if (not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (not mustafarLavaHazard.burning[playerID]) then
		return 0
	end

	local creature = CreatureObject(pPlayer)

	if (creature:isDead()) then
		mustafarLavaHazard.burning[playerID] = nil
		return 0
	end

	creature:inflictDamage(pPlayer, 0, 150, 0)
	creature:sendSystemMessage("\#FF6600The lava sears you!")
	mustafarLavaHazard:scheduleBurn(pPlayer)
	return 0
end
