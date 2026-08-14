KorribanCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KorribanCityScreenPlay",
	planet = "korriban",
	walkpointList = {}
}

registerScreenPlay("KorribanCityScreenPlay", true)

function KorribanCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function KorribanCityScreenPlay:spawnSceneObjects()
	-- Korriban Starport (-1751, 91, -641)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -1751, 91, -641, 0, math.rad(0))
end

function KorribanCityScreenPlay:spawnMobiles()
end
