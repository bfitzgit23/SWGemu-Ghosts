MandaloreCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MandaloreCityScreenPlay",
	planet = "mandalore",
	walkpointList = {}
}

registerScreenPlay("MandaloreCityScreenPlay", true)

function MandaloreCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function MandaloreCityScreenPlay:spawnSceneObjects()
	-- Bralsin
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -5689, 0, -5034, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", -5687, 0, -5034, 0, math.rad(0))
	
	-- Keldabe Starport
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 1568, 4, -6415, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 1570, 4, -6415, 0, math.rad(0))
	
	-- Keldabe Shuttleport
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 1432, 1.9, -6163, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 1434, 1.9, -6163, 0, math.rad(0))
	
	-- Sundari
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 6275, 1, -6211, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 6277, 1, -6211, 0, math.rad(0))
	
	-- Norg Bral
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -6648, 30, 5583, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", -6646, 30, 5583, 0, math.rad(0))
	
	-- Enceri
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 4713, 2, 7154, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 4715, 2, 7154, 0, math.rad(0))
	
	-- Shuror
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 1068, 1, 2733, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 1070, 1, 2733, 0, math.rad(0))
end

function MandaloreCityScreenPlay:spawnMobiles()
end
