-- High Inquisitor Jerec encounter recovered from Ghosts_old.
--
-- The legacy screenplay implemented its own respawn scheduler and called
-- custom broadcast methods that are not part of the current Lua API.  The
-- current implementation uses spawnMobile's supported respawn value instead;
-- the creature template remains responsible for combat abilities and loot.

InquisitorBossScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "InquisitorBossScreenPlay",
	planet = "rori",
	respawn = 10800,
	cellID = 18500002,
}

registerScreenPlay("InquisitorBossScreenPlay", true)

function InquisitorBossScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
	end
end

function InquisitorBossScreenPlay:spawnMobiles()
	local guards = {
		{-5371, 76, 5045, 130}, {-5376, 76, 5041, 130},
		{-5372, 76, 5029, 130}, {-5356, 76, 5037, 130},
		{-5340, 76, 5010, 130}, {-5345, 76, 5001, 95},
		{-5391, 76, 5044, 85},  {-5384, 76, 5037, 68},
		{-5343, 76, 5068, 150}, {-5349, 76, 5064, 150},
		{-5340, 76, 5047, 120}, {-5316, 76, 5048, 170},
		{-5309, 76, 5023, 170}, {-5318, 76, 5024, 170},
		{-5320, 76, 5006, 170},
	}

	for i = 1, #guards do
		local guard = guards[i]
		spawnMobile(self.planet, "inquisitor_trooper", 1800,
			guard[1], guard[2], guard[3], guard[4], self.cellID)
	end

	spawnMobile(self.planet, "inquisitor_sancor", self.respawn,
		-5352, 76, 5052, 176, self.cellID)
	spawnMobile(self.planet, "inquisitor_vrke", self.respawn,
		-5361, 76, 5046, 100, self.cellID)
	spawnMobile(self.planet, "high_inquisitor", self.respawn,
		-5349, 76, 5042, 330, self.cellID)
end
