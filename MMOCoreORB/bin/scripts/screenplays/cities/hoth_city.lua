HothCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "HothCityScreenPlay",

	planet = "hoth",

	walkpointList = {
	}
}

registerScreenPlay("HothCityScreenPlay", true)

function HothCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function HothCityScreenPlay:spawnSceneObjects()
	-- Scavenger Outpost (0, 0, -2000)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 0, 0, -2000, 0, math.rad(0))
end

function HothCityScreenPlay:spawnMobiles()
	-- Add NPCs here if needed
end
