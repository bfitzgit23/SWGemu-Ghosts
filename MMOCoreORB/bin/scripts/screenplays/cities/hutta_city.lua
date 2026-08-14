HuttaCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "HuttaCityScreenPlay",
	planet = "hutta",
	walkpointList = {}
}

registerScreenPlay("HuttaCityScreenPlay", true)

function HuttaCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function HuttaCityScreenPlay:spawnSceneObjects()
	-- Bilbousa Starport (-789, 80, 1769)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -789, 80, 1769, 0, math.rad(0))
end

function HuttaCityScreenPlay:spawnMobiles()
end
