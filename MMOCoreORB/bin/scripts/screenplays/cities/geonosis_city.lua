GeonosisCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "GeonosisCityScreenPlay",
	planet = "geonosis",
	walkpointList = {}
}

registerScreenPlay("GeonosisCityScreenPlay", true)

function GeonosisCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function GeonosisCityScreenPlay:spawnSceneObjects()
	-- Geonosis City (-8, 5, -24)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -8, 5, -24, 0, math.rad(0))
end

function GeonosisCityScreenPlay:spawnMobiles()
end