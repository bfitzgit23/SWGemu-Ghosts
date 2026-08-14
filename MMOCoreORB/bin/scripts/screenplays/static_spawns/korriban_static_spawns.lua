--Korriban Static Spawns - TEMPLE CONCENTRATED SPAWNS!
local ObjectManager = require("managers.object.object_manager")

KorribanStaticSpawnsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KorribanStaticSpawnsScreenPlay",
}

registerScreenPlay("KorribanStaticSpawnsScreenPlay", true)

function KorribanStaticSpawnsScreenPlay:start()
	if (isZoneEnabled("korriban")) then
		self:spawnMobiles()
	end
end

-- Helper function to check if coordinates are near starport
function KorribanStaticSpawnsScreenPlay:isNearStarport(x, z)
	local starportX = -1811
	local starportZ = -676
	local noSpawnRadius = 300

	local distance = math.sqrt((x - starportX)^2 + (z - starportZ)^2)
	return distance < noSpawnRadius
end

function KorribanStaticSpawnsScreenPlay:spawnMobiles()

	-- =====================================================
	-- VALLEY OF THE DARK LORDS - TEMPLE SPAWNS!
	-- 265 SPAWNS distributed across 8 temple locations!
	-- =====================================================

	-- BANE'S TOMB (-1469, -407) - 15 SPAWNS
	-- Top of valley, major location!
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(40) - 20
		local z = -407 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(50) - 25
		local z = -407 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(50) - 25
		local z = -407 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 1 (-1525, -674) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1525 + getRandomNumber(40) - 20
		local z = -674 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1525 + getRandomNumber(50) - 25
		local z = -674 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1525 + getRandomNumber(50) - 25
		local z = -674 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 2 (-1294, -577) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1294 + getRandomNumber(40) - 20
		local z = -577 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1294 + getRandomNumber(50) - 25
		local z = -577 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1294 + getRandomNumber(50) - 25
		local z = -577 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 3 (-1479, -948) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1479 + getRandomNumber(40) - 20
		local z = -948 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1479 + getRandomNumber(50) - 25
		local z = -948 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1479 + getRandomNumber(50) - 25
		local z = -948 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 4 (-1200, -834) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1200 + getRandomNumber(40) - 20
		local z = -834 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1200 + getRandomNumber(50) - 25
		local z = -834 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1200 + getRandomNumber(50) - 25
		local z = -834 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 5 (-1120, -1019) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1120 + getRandomNumber(40) - 20
		local z = -1019 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1120 + getRandomNumber(50) - 25
		local z = -1019 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1120 + getRandomNumber(50) - 25
		local z = -1019 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 6 (-1434, -1194) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1434 + getRandomNumber(40) - 20
		local z = -1194 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1434 + getRandomNumber(50) - 25
		local z = -1194 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1434 + getRandomNumber(50) - 25
		local z = -1194 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- END TEMPLE (-1125, -1347) - 20 SPAWNS (Bottom of valley, biggest!)
	for i = 1, 3 do
		local x = -1125 + getRandomNumber(50) - 25
		local z = -1347 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 4 do
		local x = -1125 + getRandomNumber(60) - 30
		local z = -1347 + getRandomNumber(60) - 30
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
	end
	for i = 1, 4 do
		local x = -1125 + getRandomNumber(60) - 30
		local z = -1347 + getRandomNumber(60) - 30
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- VALLEY AREA BETWEEN TEMPLES - 170 SPAWNS SPREAD OUT!
	-- Distributed evenly across the entire valley area
	-- =====================================================

	-- Define temple zone bounds (from Bane's Tomb to End Temple)
	local minX = -1525  -- West edge
	local maxX = -1120  -- East edge
	local minZ = -1347  -- South edge (End Temple)
	local maxZ = -407   -- North edge (Bane's Tomb)

	-- Dark Jedi Knights (80 total) - Spread across valley
	for i = 1, 40 do
		local x = minX + getRandomNumber(maxX - minX)
		local z = minZ + getRandomNumber(maxZ - minZ)
		spawnMobile("korriban", "dark_jedi_knight", 360, x, 0, z, getRandomNumber(360), 0)
	end

	-- Dark Jedi Sentinels (60 total) - Spread across valley
	for i = 1, 20 do
		local x = minX + getRandomNumber(maxX - minX)
		local z = minZ + getRandomNumber(maxZ - minZ)
		spawnMobile("korriban", "dark_jedi_sentinel", 240, x, 0, z, getRandomNumber(360), 0)
	end

	-- Rancors (30 total) - Roaming valley
	-- NOTE: rancor_bull was failing (template missing). Using rancor.
	for i = 1, 30 do
		local x = minX + getRandomNumber(maxX - minX)
		local z = minZ + getRandomNumber(maxZ - minZ)
		spawnMobile("korriban", "rancor", 480, x, 0, z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- ARCHAEOLOGICAL OUTPOST - REMOVED (too close to starport)
	-- =====================================================

	-- FRIENDLY SCIENTISTS - Moved FAR from starport to -1200, -500
	local pNpc = spawnMobile("korriban", "scientist", 1, -1200, 0, -500, 0, 0)
	self:setMoodString(pNpc, "neutral")

	pNpc = spawnMobile("korriban", "scientist", 1, -1198, 0, -495, 45, 0)
	self:setMoodString(pNpc, "npc_use_terminal_high")

	pNpc = spawnMobile("korriban", "commoner", 1, -1196, 0, -502, -90, 0)
	self:setMoodString(pNpc, "worried")

	pNpc = spawnMobile("korriban", "commoner", 1, -1203, 0, -497, 135, 0)
	self:setMoodString(pNpc, "conversation")

	pNpc = spawnMobile("korriban", "commoner_technician", 1, -1202, 0, -501, -45, 0)
	self:setMoodString(pNpc, "neutral")

	pNpc = spawnMobile("korriban", "commoner", 1, -1197, 0, -498, 90, 0)
	self:setMoodString(pNpc, "nervous")

	pNpc = spawnMobile("korriban", "protocol_droid_3po", 1, -1204, 0, -500, 180, 0)
	self:setMoodString(pNpc, "neutral")

	-- =====================================================
	-- SHYRACK CAVE (457, -235) - FORCE-SENSITIVE NPCs!
	-- =====================================================

	-- Force-Sensitive Crypt Crawlers (45 total)
	for i = 1, 25 do
		local x = 457 + getRandomNumber(60) - 30
		local z = -235 + getRandomNumber(60) - 30
		spawnMobile("korriban", "force_sensitive_crypt_crawler", 240, x, 0, z, getRandomNumber(360), 0)
	end

	-- Force Crystal Hunters (24 total)
	for i = 1, 14 do
		local x = 455 + getRandomNumber(50) - 25
		local z = -240 + getRandomNumber(50) - 25
		spawnMobile("korriban", "force_crystal_hunter", 360, x, 0, z, getRandomNumber(360), 0)
	end

	-- Forsaken Force Drifters (15 total)
	for i = 1, 8 do
		local x = 460 + getRandomNumber(50) - 25
		local z = -235 + getRandomNumber(50) - 25
		spawnMobile("korriban", "forsaken_force_drifter", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- Dark Jedi Cave Explorers (18 total)
	for i = 1, 5 do
		local x = 465 + getRandomNumber(40) - 20
		local z = -228 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_sentinel", 300, x, 0, z, getRandomNumber(360), 0)
	end

	for i = 1, 5 do
		local x = 452 + getRandomNumber(40) - 20
		local z = -242 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_knight", 240, x, 0, z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- DRESHDAE VALLEY (1060, -5332)
	-- =====================================================

	-- Dark Jedi in town (45 total)
	for i = 1, 10 do
		local x = 1055 + getRandomNumber(150) - 25
		local z = -5330 + getRandomNumber(150) - 25
		spawnMobile("korriban", "dark_jedi_knight", 300, x, 0, z, getRandomNumber(360), 0)
	end

	for i = 1, 10 do
		local x = 1065 + getRandomNumber(50) - 25
		local z = -5335 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- RANDOM WILDERNESS SPAWNS - WITH LARGER STARPORT EXCLUSION!
	-- =====================================================

	-- Rancors (260 total) - Avoid starport!
	-- NOTE: rancor_bull was failing (template missing). Using rancor.
	for i = 1, 260 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "rancor", 600, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Dark Jedi Masters (120 total) - Avoid starport!
	for i = 1, 60 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Dark Jedi Knights (100 total)
	for i = 1, 100 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Dark Jedi Sentinels (120 total)
	for i = 1, 60 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Kliknik (240 total)
	for i = 1, 240 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "kliknik", 300, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Acklays (40 spawns)
	for i = 1, 60 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "acklay", 540, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Giant Kimogila (60 spawns)
	for i = 1, 60 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "giant_dune_kimogila", 540, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- MORE Wandering Dark Jedi (105 total)
	for i = 1, 55 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_knight", 480, x, 0, z, getRandomNumber(360), 0)
		end
	end

	for i = 1, 15 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 0, z, getRandomNumber(360), 0)
		end
	end

	for i = 1, 15 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_knight", 360, x, 0, z, getRandomNumber(360), 0)
		end
	end

	-- Wandering Masters (120 total)
	for i = 1, 120 do
		local attempts = 0
		local x, z
		repeat
			x = getRandomNumber(4000) - 2000
			z = getRandomNumber(4000) - 2000
			attempts = attempts + 1
		until not self:isNearStarport(x, z) or attempts > 100

		if not self:isNearStarport(x, z) then
			spawnMobile("korriban", "dark_jedi_master", 600, x, 0, z, getRandomNumber(360), 0)
		end
	end

end