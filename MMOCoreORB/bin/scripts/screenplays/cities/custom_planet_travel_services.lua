-- Completes the normal Core3 travel service chain for custom-planet points.
-- The city screenplays already place purchase terminals.  A nearby shuttle
-- with ShuttleZoneComponent is still required so PlanetManager can attach and
-- schedule the PlanetTravelPoint; the collector consumes the purchased ticket.

CustomPlanetTravelServices = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CustomPlanetTravelServices",

	travelServices = {
		{"coruscant", -1851, 40, -175},
		{"coruscant", 1538, 40, 779},
		{"coruscant", 2248, 0, -4546},
		{"coruscant", -28, 40, 3202},
		{"coruscant", -96, 40, 3149},
		{"geonosis", -8, 5, -24},
		{"hoth", 0, 0, -2000},
		{"hutta", -789, 80, 1769},
		{"jakku", -4263, 6, -2411},
		{"kaas", -5163, 80, -2238},
		{"kashyyyk", -669.73, 18.85, -148.48},
		{"korriban", -1751, 91, -641},
		{"mandalore", -5689, 0, -5034},
		{"mandalore", 1568, 4, -6415},
		{"mandalore", 1432, 1.9, -6163},
		{"mandalore", 6275, 1, -6211},
		{"mandalore", -6648, 30, 5583},
		{"mandalore", 4713, 2, 7154},
		{"mandalore", 1068, 1, 2733},
		{"mustafar", -2475, 230.1, 1624.7},
		{"taanab", 2100, 45, 5400},
		{"taanab", 3610, 31.7, -5425}
	}
}

registerScreenPlay("CustomPlanetTravelServices", true)

function CustomPlanetTravelServices:start()
	for i = 1, #self.travelServices do
		local service = self.travelServices[i]
		local planet = service[1]

		if isZoneEnabled(planet) then
			local x = service[2]
			local z = service[3]
			local y = service[4]

			spawnSceneObject(planet,
				"object/tangible/travel/ticket_collector/ticket_collector.iff",
				x + 3, z, y, 0, 0)
			spawnSceneObject(planet,
				"object/mobile/player_transport.iff",
				x + 15, z, y, 0, 0)
		end
	end
end
