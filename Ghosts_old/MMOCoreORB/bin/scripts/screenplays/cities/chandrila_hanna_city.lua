ChandrilaHannaCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "ChandrilaHannaCityScreenPlay",

	planet = "chandrila",

	walkpointList = {
	}
}

registerScreenPlay("ChandrilaHannaCityScreenPlay", true)

function ChandrilaHannaCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function ChandrilaHannaCityScreenPlay:spawnSceneObjects()
	-- Hanna City Spaceport (178, 6, -2961)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 178, 6, -2961, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", 180, 6, -2961, 0, math.rad(0))
	
	-- Nayli Outpost (-5272, 18, 264)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -5272, 18, 264, 0, math.rad(0))
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_ticket_collector.iff", -5270, 18, 264, 0, math.rad(0))
end

function ChandrilaHannaCityScreenPlay:spawnMobiles()
	-- Add NPCs here if needed
end
