KaasCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KaasCityScreenPlay",
	planet = "kaas",
	walkpointList = {}
}

registerScreenPlay("KaasCityScreenPlay", true)

function KaasCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function KaasCityScreenPlay:spawnSceneObjects()
	-- Imperial Garrison (-5163, 80, -2238)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -5163, 80, -2238, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", -5161, 80, -2238, 0, math.rad(0))
end

function KaasCityScreenPlay:spawnMobiles()
end
