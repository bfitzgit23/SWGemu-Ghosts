JakkuCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "JakkuCityScreenPlay",
	planet = "jakku",
	walkpointList = {}
}

registerScreenPlay("JakkuCityScreenPlay", true)

function JakkuCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function JakkuCityScreenPlay:spawnSceneObjects()
	-- Battle Of Jakku (-4263, 6, -2411)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -4263, 6, -2411, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", -4261, 6, -2411, 0, math.rad(0))
end

function JakkuCityScreenPlay:spawnMobiles()
end
