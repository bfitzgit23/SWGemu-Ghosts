CoruscantCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "CoruscantCityScreenPlay",

	planet = "coruscant",

	walkpointList = {
	}
}

registerScreenPlay("CoruscantCityScreenPlay", true)

function CoruscantCityScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function CoruscantCityScreenPlay:spawnSceneObjects()
	-- Collective Commerce District (-1851, 40, -175)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -1851, 40, -175, 0, math.rad(0))
	
	
	-- Monument Square (1538, 40, 779)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 1538, 40, 779, 0, math.rad(0))
	
	
	-- Entertainment District (2248, 0, -4546)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", 2248, 0, -4546, 0, math.rad(0))
	
	
	-- Spaceport District Shuttle (-28, 40, 3202)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -28, 40, 3202, 0, math.rad(0))
	
	
	-- Coruscant Spaceport (-96, 40, 3149)
	spawnSceneObject(self.planet, "object/tangible/terminal/terminal_travel.iff", -96, 40, 3149, 0, math.rad(0))
end

function CoruscantCityScreenPlay:spawnMobiles()
	-- Add NPCs here if needed
end
