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
	-- TOMB BOSSES & NAMED ADDS
	-- Each of the 8 tombs gets a primary Sith Lord + a Sith Sorcerer add
	-- + 2-4 dark jedi adds depending on tomb size.
	-- =====================================================

	-- BANE'S TOMB (-1469, -407) — Darth Bane (hardest) + Sith Sorcerer + 3 adds
	spawnMobile("korriban", "darth_bane_korriban", 600, -1469, gy(-1469, -407), -407, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1462, gy(-1462, -402), -402, 180, 0)
	for i = 1, 3 do
		local x = -1469 + getRandomNumber(40) - 20
		local z = -407 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 1 (-1525, -674) — Revan (Sith Lord) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -1525, gy(-1525, -674), -674, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1518, gy(-1518, -668), -668, 90, 0)
	for i = 1, 2 do
		local x = -1525 + getRandomNumber(40) - 20
		local z = -674 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 2 (-1294, -577) — Exar Kun (Spirit) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -1294, gy(-1294, -577), -577, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1288, gy(-1288, -572), -572, 200, 0)
	for i = 1, 2 do
		local x = -1294 + getRandomNumber(40) - 20
		local z = -577 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 3 (-1479, -948) — Revan (Sith Lord) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -1479, gy(-1479, -948), -948, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1472, gy(-1472, -942), -942, 45, 0)
	for i = 1, 2 do
		local x = -1479 + getRandomNumber(40) - 20
		local z = -948 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 4 (-1200, -834) — Exar Kun (Spirit) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -1200, gy(-1200, -834), -834, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1193, gy(-1193, -829), -829, 120, 0)
	for i = 1, 2 do
		local x = -1200 + getRandomNumber(40) - 20
		local z = -834 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 5 (-1120, -1019) — Revan (Sith Lord) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "revan_korriban", 600, -1120, gy(-1120, -1019), -1019, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1114, gy(-1114, -1014), -1014, 270, 0)
	for i = 1, 2 do
		local x = -1120 + getRandomNumber(40) - 20
		local z = -1019 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- SITH TEMPLE 6 (-1434, -1194) — Exar Kun (Spirit) + Sith Sorcerer + 2 adds
	spawnMobile("korriban", "exar_kun_korriban", 600, -1434, gy(-1434, -1194), -1194, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1428, gy(-1428, -1189), -1189, 30, 0)
	for i = 1, 2 do
		local x = -1434 + getRandomNumber(40) - 20
		local z = -1194 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
	end

	-- END TEMPLE (-1125, -1347) — Darth Bane (Eternal) + Sith Sorcerer + 4 adds
	spawnMobile("korriban", "darth_bane_korriban", 600, -1125, gy(-1125, -1347), -1347, 0, 0)
	spawnMobile("korriban", "sith_sorcerer_korriban", 600, -1119, gy(-1119, -1341), -1341, 160, 0)
	for i = 1, 4 do
		local x = -1125 + getRandomNumber(50) - 25
		local z = -1347 + getRandomNumber(50) - 25
		spawnMobile("korriban", "dark_jedi_master", 600, x, gy(x, z), z, getRandomNumber(360), 0)
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
