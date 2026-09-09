StaticJediTrainers = ScreenPlay:new {
	numberOfActs = 1,

	-- One accessible trainer beside an existing Brawler trainer area on each
	-- enabled civilian world that has a Brawler trainer.
	locations = {
		{"corellia", -160, 28, -4754, 88, 0, "Coronet"},
		{"naboo", -4854, 6, 4087, -47, 0, "Theed"},
		{"rori", 5339.31, 80, 5530.48, 0, 0, "Restuss"},
		{"talus", -8, 1, -13, 0, 4265407, "Nashal"},
		{"tatooine", 3500, 5, -4765, 91, 0, "Mos Eisley"},
	}
}

registerScreenPlay("StaticJediTrainers", true)

function StaticJediTrainers:start()
	for _, location in ipairs(self.locations) do
		if isZoneEnabled(location[1]) then
			local pTrainer = spawnMobile(location[1], "trainer_jedi", 0,
				location[2], location[3], location[4], location[5], location[6])

			if pTrainer == nil then
				printLuaError("StaticJediTrainers failed to spawn the Jedi trainer at " .. location[7])
			end
		end
	end
end
