--Korriban Static Spawns - TEMPLE CONCENTRATED SPAWNS!
local ObjectManager = require("managers.object.object_manager")

-- Static spawn data only carried x/z, so every mob was placed at a flat y of 0 and
-- ended up buried under the valley floor (visible on radar, invisible in the world).
-- Ask the zone for the real terrain height at each spawn point instead.
local function gy(x, z)
	local h = getTerrainHeightForZone("korriban", x, z)

	if h == nil or h ~= h then
		return 0
	end

	return h
end

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
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(50) - 25
		local z = -407 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(50) - 25
		local z = -407 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 1 (-1525, -674) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1525 + getRandomNumber(40) - 20
		local z = -674 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1525 + getRandomNumber(50) - 25
		local z = -674 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1525 + getRandomNumber(50) - 25
		local z = -674 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 2 (-1294, -577) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1294 + getRandomNumber(40) - 20
		local z = -577 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1294 + getRandomNumber(50) - 25
		local z = -577 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1294 + getRandomNumber(50) - 25
		local z = -577 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 3 (-1479, -948) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1479 + getRandomNumber(40) - 20
		local z = -948 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1479 + getRandomNumber(50) - 25
		local z = -948 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1479 + getRandomNumber(50) - 25
		local z = -948 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 4 (-1200, -834) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1200 + getRandomNumber(40) - 20
		local z = -834 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1200 + getRandomNumber(50) - 25
		local z = -834 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1200 + getRandomNumber(50) - 25
		local z = -834 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 5 (-1120, -1019) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1120 + getRandomNumber(40) - 20
		local z = -1019 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1120 + getRandomNumber(50) - 25
		local z = -1019 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1120 + getRandomNumber(50) - 25
		local z = -1019 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 6 (-1434, -1194) - 10 SPAWNS
	for i = 1, 1 do
		local x = -1434 + getRandomNumber(40) - 20
		local z = -1194 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 2 do
		local x = -1434 + getRandomNumber(50) - 25
		local z = -1194 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 1 do
		local x = -1434 + getRandomNumber(50) - 25
		local z = -1194 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- END TEMPLE (-1125, -1347) - 20 SPAWNS (Bottom of valley, biggest!)
	for i = 1, 3 do
		local x = -1125 + getRandomNumber(50) - 25
		local z = -1347 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 4 do
		local x = -1125 + getRandomNumber(60) - 30
		local z = -1347 + getRandomNumber(60) - 30
		spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end
	for i = 1, 4 do
		local x = -1125 + getRandomNumber(60) - 30
		local z = -1347 + getRandomNumber(60) - 30
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- TOMB BOSSES & NAMED ADDS - INSIDE THE TOMBS
	-- Each named Sith Lord now stands in its tomb's interior hall instead
	-- of the courtyard. The coordinates are the retail interior spawn
	-- points for the same building templates, and the Exar Kun temple
	-- points are the floor centroids of its own cell meshes.
	-- =====================================================

	-- BLUELEAF TEMPLE 1 (-1526, -675) - Revan + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -0.6, -37.3, -28.3, 0, 42000043)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -9, -37.3, -9, 90, 42000043)
	spawnMobile("korriban", "dark_jedi_master", 600, 6.6, -37.3, 12.8, 180, 42000043)
	spawnMobile("korriban", "dark_jedi_master", 600, 10.2, -37.3, 4.8, 90, 42000043)

	-- BLUELEAF TEMPLE 2 (-1295, -577) - Exar Kun + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -0.6, -37.3, -28.3, 0, 42000046)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -9, -37.3, -9, 90, 42000046)
	spawnMobile("korriban", "dark_jedi_master", 600, -10.5, -37.3, 4.2, 0, 42000046)
	spawnMobile("korriban", "dark_jedi_master", 600, -12.1, -37.3, 18.2, 180, 42000046)

	-- WOOLAMANDER TEMPLE 1 (-1510, -956) - Revan + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -13.5, 2, -4.7, 0, 42000018)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, 8.2, 2, -9.4, 90, 42000018)
	spawnMobile("korriban", "dark_jedi_master", 600, -19, 2, 1.4, 0, 42000018)
	spawnMobile("korriban", "dark_jedi_master", 600, 18.5, 2, 1, 180, 42000018)
	spawnMobile("korriban", "dark_jedi_knight", 600, -60.5, 2, 22, 180, 42000022)
	spawnMobile("korriban", "dark_jedi_knight", 600, -46, 2, -13.4, 0, 42000022)

	-- WOOLAMANDER TEMPLE 2 (-1171, -832) - Exar Kun + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -13.5, 2, -4.7, 0, 42000007)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, 8.2, 2, -9.4, 90, 42000007)
	spawnMobile("korriban", "dark_jedi_master", 600, -19, 2, 1.4, 0, 42000007)
	spawnMobile("korriban", "dark_jedi_master", 600, 18.5, 2, 1, 180, 42000007)

	-- BLUELEAF TEMPLE 5 (-1110, -1005) - Revan + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -0.6, -37.3, -28.3, 0, 42000040)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -9, -37.3, -9, 90, 42000040)
	spawnMobile("korriban", "dark_jedi_master", 600, 10.9, -37.3, -3.9, 90, 42000040)

	-- BLUELEAF TEMPLE 6 (-1474, -1210) - Exar Kun + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -0.6, -37.3, -28.3, 0, 42000003)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -9, -37.3, -9, 90, 42000003)
	spawnMobile("korriban", "dark_jedi_master", 600, 6.6, -37.3, 12.8, 180, 42000003)

	-- SITH ACADEMY (-1125, -1347) - Darth Bane (Eternal) + Sith Sorcerer
	spawnMobile("korriban", "darth_bane_korriban", 600, 0, 55, -30, 180, 42000037)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -11, 55, -5, 90, 42000037)
	spawnMobile("korriban", "dark_jedi_master", 600, 10, 55, -20, 180, 42000037)
	spawnMobile("korriban", "dark_jedi_master", 600, -9, 55, 4, 0, 42000037)

	-- EXAR KUN'S TOMB (temple_exar_kun) - Exar Kun in the grand hall,
	-- Darth Bane and the revan_clone extra boss on the lower level.
	-- Cell floors: hall and upper rooms y=0, lower rooms y=-6.
	spawnMobile("korriban", "exar_kun_korriban", 600, 0, 0, -8, 180, 42000204)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, 0, 0, 10, 0, 42000204)
	spawnMobile("korriban", "dark_jedi_master", 600, 8, 0, -20, 180, 42000204)
	spawnMobile("korriban", "dark_jedi_master", 600, -8, 0, -20, 180, 42000204)
	spawnMobile("korriban", "dark_jedi_knight", 600, 0, 0, 0, 90, 42000208)
	spawnMobile("korriban", "dark_jedi_knight", 600, 0.5, 0, -11, 90, 42000209)
	spawnMobile("korriban", "darth_bane_korriban", 600, -0.9, 0, -29.3, 0, 42000213)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, 4, 0, -24, 180, 42000213)
	spawnMobile("korriban", "revan_clone", 600, 0.5, -6, -19.9, 0, 42000215)
	spawnMobile("korriban", "dark_jedi_master", 600, 8, -6, -25, 180, 42000215)
	spawnMobile("korriban", "dark_jedi_master", 600, -8, -6, -15, 0, 42000215)

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
		spawnMobile("korriban", "dark_jedi_knight", 360, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- Dark Jedi Sentinels (60 total) - Spread across valley
	for i = 1, 20 do
		local x = minX + getRandomNumber(maxX - minX)
		local z = minZ + getRandomNumber(maxZ - minZ)
		spawnMobile("korriban", "dark_jedi_sentinel", 240, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- Rancors (30 total) - Roaming valley
	-- NOTE: rancor_bull was failing (template missing). Using rancor.
	for i = 1, 30 do
		local x = minX + getRandomNumber(maxX - minX)
		local z = minZ + getRandomNumber(maxZ - minZ)
		spawnMobile("korriban", "rancor", 480, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- ARCHAEOLOGICAL OUTPOST - REMOVED (too close to starport)
	-- =====================================================

	-- FRIENDLY SCIENTISTS - Moved FAR from starport to -1200, -500
	local pNpc = spawnMobile("korriban", "scientist", 1, -1200, gy(-1200, -500), -500, 0, 0)
	self:setMoodString(pNpc, "neutral")

	pNpc = spawnMobile("korriban", "scientist", 1, -1198, gy(-1198, -495), -495, 45, 0)
	self:setMoodString(pNpc, "npc_use_terminal_high")

	pNpc = spawnMobile("korriban", "commoner", 1, -1196, gy(-1196, -502), -502, -90, 0)
	self:setMoodString(pNpc, "worried")

	pNpc = spawnMobile("korriban", "commoner", 1, -1203, gy(-1203, -497), -497, 135, 0)
	self:setMoodString(pNpc, "conversation")

	pNpc = spawnMobile("korriban", "commoner_technician", 1, -1202, gy(-1202, -501), -501, -45, 0)
	self:setMoodString(pNpc, "neutral")

	pNpc = spawnMobile("korriban", "commoner", 1, -1197, gy(-1197, -498), -498, 90, 0)
	self:setMoodString(pNpc, "nervous")

	pNpc = spawnMobile("korriban", "protocol_droid_3po", 1, -1204, gy(-1204, -500), -500, 180, 0)
	self:setMoodString(pNpc, "neutral")

	-- =====================================================
	-- SHYRACK CAVE (457, -235) - FORCE-SENSITIVE NPCs!
	-- =====================================================

	-- Force-Sensitive Crypt Crawlers (45 total)
	for i = 1, 25 do
		local x = 457 + getRandomNumber(60) - 30
		local z = -235 + getRandomNumber(60) - 30
		spawnMobile("korriban", "force_sensitive_crypt_crawler", 240, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- Force Crystal Hunters (24 total)
	for i = 1, 14 do
		local x = 455 + getRandomNumber(50) - 25
		local z = -240 + getRandomNumber(50) - 25
		spawnMobile("korriban", "force_crystal_hunter", 360, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- Forsaken Force Drifters (15 total)
	for i = 1, 8 do
		local x = 460 + getRandomNumber(50) - 25
		local z = -235 + getRandomNumber(50) - 25
		spawnMobile("korriban", "forsaken_force_drifter", 420, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- Dark Jedi Cave Explorers (18 total)
	for i = 1, 5 do
		local x = 465 + getRandomNumber(40) - 20
		local z = -228 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_sentinel", 300, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	for i = 1, 5 do
		local x = 452 + getRandomNumber(40) - 20
		local z = -242 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_knight", 240, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- =====================================================
	-- DRESHDAE VALLEY (1060, -5332)
	-- =====================================================

	-- Dark Jedi in town (45 total)
	for i = 1, 10 do
		local x = 1055 + getRandomNumber(150) - 25
		local z = -5330 + getRandomNumber(150) - 25
		spawnMobile("korriban", "dark_jedi_knight", 300, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	for i = 1, 10 do
		local x = 1065 + getRandomNumber(50) - 25
		local z = -5335 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "rancor", 600, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "kliknik", 300, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "acklay", 540, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "giant_dune_kimogila", 540, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_knight", 480, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_knight", 360, x, gy(x, z), z, getRandomNumber(360), 0)
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
			spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
		end
	end

	-- =====================================================
	-- INTERIORS - SITH ACADEMY AND THE TOMBS
	-- The tombs and the academy are Yavin temple buildings from the
	-- zone's world snapshot, so their cells are real objects with fixed
	-- object IDs. The coordinates below are the interior coordinates the
	-- retail temple spawns use for those same building templates; the
	-- academy floor height comes from the throne-hall furniture placed in
	-- korriban_valley.lua.
	-- =====================================================

	-- SITH ACADEMY (temple_massassi) - throne hall, cell 42000037
	local academy = 42000037
	spawnMobile("korriban", "dark_jedi_master", 900, -10, 55, -30, 90, academy)
	spawnMobile("korriban", "dark_jedi_knight", 900, 10, 55, -28, 180, academy)
	spawnMobile("korriban", "dark_jedi_knight", 900, -11, 55, -5, 0, academy)
	spawnMobile("korriban", "dark_jedi_sentinel", 900, 9, 55, 0, 270, academy)
	spawnMobile("korriban", "dark_jedi_sentinel", 900, 0, 55, 6, 180, academy)

	-- TEMPLE_BLUELEAF TOMBS - main hall, second cell of each temple
	local blueleafTombs = { 42000003, 42000040, 42000043, 42000046 }

	for i = 1, #blueleafTombs do
		local cell = blueleafTombs[i]
		spawnMobile("korriban", "dark_jedi_knight", 900, -9, -37.3, -9, 90, cell)
		spawnMobile("korriban", "dark_jedi_sentinel", 900, 6.6, -37.3, 12.8, 180, cell)
		spawnMobile("korriban", "dark_jedi_master", 900, -0.6, -37.3, -28.3, 0, cell)
	end

	-- TEMPLE_WOOLAMANDER TOMBS - three inner rooms per temple
	local woolamanderTombs = {
		{ 42000007, 42000011, 42000014 },
		{ 42000018, 42000022, 42000025 },
	}

	for i = 1, #woolamanderTombs do
		local rooms = woolamanderTombs[i]

		spawnMobile("korriban", "dark_jedi_sentinel", 900, -19, 2, 1.4, 90, rooms[1])
		spawnMobile("korriban", "dark_jedi_knight", 900, 8.2, 2, -9.4, 180, rooms[1])

		spawnMobile("korriban", "dark_jedi_master", 900, -73, 2, -12, 0, rooms[2])
		spawnMobile("korriban", "dark_jedi_knight", 900, -46, 2, -13.4, 90, rooms[2])

		spawnMobile("korriban", "dark_jedi_sentinel", 900, 62.4, 2, 18.5, 270, rooms[3])
		spawnMobile("korriban", "dark_jedi_knight", 900, 76.2, 2, -9, 180, rooms[3])
	end

end
