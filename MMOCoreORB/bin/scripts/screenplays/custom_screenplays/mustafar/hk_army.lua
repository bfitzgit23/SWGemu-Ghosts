hkArmyScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "hkArmyScreenPlay",
}

registerScreenPlay("hkArmyScreenPlay", true)

-- The HK-47 droid battlefield. Every droid is dropped on the ground it stands on
-- instead of a hard-coded height, and the formation is spread out rather than
-- packed into ranks five metres apart, so the mobiles line up with the terrain
-- and can path and fight around each other.
local hk47Position = { x = 3455.0, y = 1004.9, heading = -166 }

local hk77Positions = {
	{ 3438.0, 987.0, 90 },
	{ 3438.0, 997.0, 90 },
	{ 3438.0, 1007.0, 90 },
	{ 3438.0, 1017.0, 90 },
	{ 3438.0, 1027.0, 90 },
	{ 3426.0, 992.0, 90 },
	{ 3426.0, 1002.0, 90 },
	{ 3426.0, 1012.0, 90 },
	{ 3426.0, 1022.0, 90 },
	{ 3426.0, 1032.0, 90 },
}

local magnaguardPositions = {
	{ 3470.0, 990.0, -90 },
	{ 3470.0, 1020.0, -90 },
	{ 3455.0, 962.0, 0 },
	{ 3455.0, 1048.0, 180 },
}

function hkArmyScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnMobiles()
	end
end

function hkArmyScreenPlay:spawnMobiles()
	local z = getWorldFloor(hk47Position.x, hk47Position.y, "mustafar")
	spawnMobile("mustafar", "hk47", 3600, hk47Position.x, z, hk47Position.y, hk47Position.heading, 0)

	for i = 1, #hk77Positions do
		local pos = hk77Positions[i]
		local floor = getWorldFloor(pos[1], pos[2], "mustafar")
		spawnMobile("mustafar", "hk77", 3600, pos[1], floor, pos[2], pos[3], 0)
	end

	for i = 1, #magnaguardPositions do
		local pos = magnaguardPositions[i]
		local floor = getWorldFloor(pos[1], pos[2], "mustafar")
		spawnMobile("mustafar", "magnaguard", 3600, pos[1], floor, pos[2], pos[3], 0)
	end
end
