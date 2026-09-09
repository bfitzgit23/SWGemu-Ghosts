--Korriban Static Spawns - NO SITH CREATURES, TRIPLE DENSITY!
local ObjectManager = require("managers.object.object_manager")

KorribanStaticSpawnsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KorribanStaticSpawnsScreenPlay",
}

registerScreenPlay("KorribanStaticSpawnsScreenPlay", true)

function KorribanStaticSpawnsScreenPlay:start()
	if (isZoneEnabled("korriban")) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function KorribanStaticSpawnsScreenPlay:spawnSceneObjects()
	spawnSceneObject("korriban", "object/static/structure/general/statue_imperial_soldier_hum_m.iff", -1346, 91, -830, 0, math.rad(0))
	spawnSceneObject("korriban", "object/static/structure/general/campfire_logs_burnt_small.iff", -1300, 91, -850, 0, math.rad(45))
	spawnSceneObject("korriban", "object/tangible/furniture/all/frn_all_toolchest_lg_s01.iff", -1712, 91, -679, 0, 0, 0, 1, 0)
	spawnSceneObject("korriban", "object/tangible/camp/camp_light_s2.iff", -1710, 91, -675, 0, 0, 0, 1, 0)
	spawnSceneObject("korriban", "object/tangible/camp/camp_stool_tall.iff", -1715, 91, -680, 0, 0, 0, 1, 0)
end

function KorribanStaticSpawnsScreenPlay:spawnMobiles()

	-- =====================================================
	-- VALLEY OF THE DARK LORDS (-1346, -830)
	-- MASSIVE DARK JEDI ARMY - 250+ SPAWNS!
	-- =====================================================
	
	-- DARK JEDI MASTERS (15 total - was 8)
	for i = 1, 15 do
		local x = -1346 + getRandomNumber(100) - 50
		local z = -830 + getRandomNumber(100) - 50
		spawnMobile("korriban", "dark_jedi_master", 600, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DARK JEDI KNIGHTS (40 total - was 20)
	for i = 1, 40 do
		local x = -1346 + getRandomNumber(120) - 60
		local z = -830 + getRandomNumber(120) - 60
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DARK JEDI SENTINELS (40 total - was 20)
	for i = 1, 40 do
		local x = -1346 + getRandomNumber(120) - 60
		local z = -830 + getRandomNumber(120) - 60
		if i <= 20 then
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 91, z, getRandomNumber(360), 0)
		else
			spawnMobile("korriban", "dark_jedi_sentinel_imperial", 420, x, 91, z, getRandomNumber(360), 0)
		end
	end
	
	-- FORCE-SENSITIVE NPCs (80 total - was 40)
	for i = 1, 20 do
		local x = -1346 + getRandomNumber(140) - 70
		local z = -830 + getRandomNumber(140) - 70
		spawnMobile("korriban", "force_trained_archaist", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 20 do
		local x = -1346 + getRandomNumber(140) - 70
		local z = -830 + getRandomNumber(140) - 70
		spawnMobile("korriban", "force_sensitive_crypt_crawler", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 20 do
		local x = -1346 + getRandomNumber(140) - 70
		local z = -830 + getRandomNumber(140) - 70
		spawnMobile("korriban", "force_sensitive_renegade", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 20 do
		local x = -1346 + getRandomNumber(140) - 70
		local z = -830 + getRandomNumber(140) - 70
		spawnMobile("korriban", "forsaken_force_drifter", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- NOVICE FORCE MYSTICS (30 total - was 15)
	for i = 1, 30 do
		local x = -1346 + getRandomNumber(120) - 60
		local z = -830 + getRandomNumber(120) - 60
		spawnMobile("korriban", "novice_force_mystic", 240, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- FORCE CRYSTAL HUNTERS (30 total - was 15)
	for i = 1, 30 do
		local x = -1346 + getRandomNumber(120) - 60
		local z = -830 + getRandomNumber(120) - 60
		spawnMobile("korriban", "force_crystal_hunter", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DEADLY CREATURES (30 total - was 15)
	for i = 1, 10 do
		local x = -1346 + getRandomNumber(120) - 60
		local z = -830 + getRandomNumber(120) - 60
		spawnMobile("korriban", "terentatek", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 20 do
		local x = -1346 + getRandomNumber(140) - 70
		local z = -830 + getRandomNumber(140) - 70
		spawnMobile("korriban", "hssiss", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- =====================================================
	-- ARCHAEOLOGICAL OUTPOST (-1712, -679)
	-- MASSIVE CREATURE PRESENCE - 150+ SPAWNS!
	-- =====================================================
	
	-- DARK JEDI MASTERS (12 total - was 6)
	for i = 1, 12 do
		local x = -1712 + getRandomNumber(80) - 40
		local z = -679 + getRandomNumber(80) - 40
		spawnMobile("korriban", "dark_jedi_master", 600, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DARK JEDI KNIGHTS (30 total - was 15)
	for i = 1, 30 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DARK JEDI SENTINELS (30 total - was 15)
	for i = 1, 30 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		if i <= 15 then
			spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 91, z, getRandomNumber(360), 0)
		else
			spawnMobile("korriban", "dark_jedi_sentinel_imperial", 420, x, 91, z, getRandomNumber(360), 0)
		end
	end
	
	-- FORCE-SENSITIVE NPCs (60 total - was 30)
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(120) - 60
		local z = -679 + getRandomNumber(120) - 60
		spawnMobile("korriban", "force_sensitive_renegade", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(120) - 60
		local z = -679 + getRandomNumber(120) - 60
		spawnMobile("korriban", "forsaken_force_drifter", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(120) - 60
		local z = -679 + getRandomNumber(120) - 60
		spawnMobile("korriban", "force_trained_archaist", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(120) - 60
		local z = -679 + getRandomNumber(120) - 60
		spawnMobile("korriban", "force_crystal_hunter", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- DEADLY CREATURES (30 total - was 10)
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		spawnMobile("korriban", "terentatek", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 15 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		spawnMobile("korriban", "tukata", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- MUTANT CREATURES (20 new spawns!)
	for i = 1, 10 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		spawnMobile("korriban", "mutant_rancor", 540, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 10 do
		local x = -1712 + getRandomNumber(100) - 50
		local z = -679 + getRandomNumber(100) - 50
		spawnMobile("korriban", "mutant_acklay", 540, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- FRIENDLY SCIENTISTS (moved to safer outer area)
	local pNpc = spawnMobile("korriban", "archaeologist_leader", 1, -1750, 91, -710, 0, 0)
	self:setMoodString(pNpc, "neutral")
	
	pNpc = spawnMobile("korriban", "reltha_aiden", 1, -1748, 91, -705, 45, 0)
	self:setMoodString(pNpc, "npc_use_terminal_high")
	
	pNpc = spawnMobile("korriban", "bex_delata", 1, -1746, 91, -712, -90, 0)
	self:setMoodString(pNpc, "worried")
	
	pNpc = spawnMobile("korriban", "omor_rikan", 1, -1753, 91, -707, 135, 0)
	self:setMoodString(pNpc, "conversation")
	
	pNpc = spawnMobile("korriban", "taelan_delar", 1, -1752, 91, -711, -45, 0)
	self:setMoodString(pNpc, "neutral")
	
	pNpc = spawnMobile("korriban", "bray_terex", 1, -1747, 91, -708, 90, 0)
	self:setMoodString(pNpc, "nervous")
	
	pNpc = spawnMobile("korriban", "moraband_bunker_protocol_droid", 1, -1754, 91, -710, 180, 0)
	self:setMoodString(pNpc, "neutral")
	
	-- =====================================================
	-- SHYRACK CAVE (457, -235) - TRIPLED DENSITY
	-- =====================================================
	
	-- Shyracks (45 total - was 15)
	for i = 1, 45 do
		local x = 457 + getRandomNumber(60) - 30
		local z = -235 + getRandomNumber(60) - 30
		spawnMobile("korriban", "shyrack", 240, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Klor Slugs (30 total - was 10)
	for i = 1, 30 do
		local x = 460 + getRandomNumber(50) - 25
		local z = -230 + getRandomNumber(50) - 25
		spawnMobile("korriban", "klor_slug", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Tukata (24 total - was 8)
	for i = 1, 24 do
		local x = 455 + getRandomNumber(50) - 25
		local z = -240 + getRandomNumber(50) - 25
		spawnMobile("korriban", "tukata", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Hssiss (15 new spawns!)
	for i = 1, 15 do
		local x = 460 + getRandomNumber(50) - 25
		local z = -235 + getRandomNumber(50) - 25
		spawnMobile("korriban", "hssiss", 420, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Cave explorers (18 total - was 6)
	for i = 1, 9 do
		local x = 465 + getRandomNumber(40) - 20
		local z = -228 + getRandomNumber(40) - 20
		spawnMobile("korriban", "force_sensitive_crypt_crawler", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 9 do
		local x = 452 + getRandomNumber(40) - 20
		local z = -242 + getRandomNumber(40) - 20
		spawnMobile("korriban", "novice_force_mystic", 240, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- =====================================================
	-- DRESHDAE VALLEY (1060, -5332) - TRIPLED DENSITY
	-- =====================================================
	
	-- Force users in town (30 total - was 10)
	for i = 1, 15 do
		local x = 1055 + getRandomNumber(50) - 25
		local z = -5330 + getRandomNumber(50) - 25
		spawnMobile("korriban", "force_crystal_hunter", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 15 do
		local x = 1065 + getRandomNumber(50) - 25
		local z = -5335 + getRandomNumber(50) - 25
		spawnMobile("korriban", "novice_force_mystic", 240, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Dark Jedi in town (15 new spawns!)
	for i = 1, 10 do
		local x = 1060 + getRandomNumber(40) - 20
		local z = -5332 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 5 do
		local x = 1060 + getRandomNumber(40) - 20
		local z = -5332 + getRandomNumber(40) - 20
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Tukata around outskirts (60 total - was 20)
	for i = 1, 60 do
		local x = 1080 + getRandomNumber(100) - 50
		local z = -5350 + getRandomNumber(100) - 50
		spawnMobile("korriban", "tukata", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Hssiss around outskirts (45 total - was 15)
	for i = 1, 45 do
		local x = 1040 + getRandomNumber(100) - 50
		local z = -5310 + getRandomNumber(100) - 50
		spawnMobile("korriban", "hssiss", 420, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- =====================================================
	-- RANDOM WILDERNESS SPAWNS - MASSIVE DENSITY
	-- =====================================================
	
	-- Terentateks (60 total - was 20)
	for i = 1, 60 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "terentatek", 600, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Hssiss packs (120 total - was 40)
	for i = 1, 120 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "hssiss", 420, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Tukata packs (180 total - was 60)
	for i = 1, 180 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "tukata", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Klor slugs (90 total - was 30)
	for i = 1, 90 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "klor_slug", 300, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Shyracks (90 total - was 30)
	for i = 1, 90 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "shyrack", 240, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Mutant Rancors (40 new spawns!)
	for i = 1, 40 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "mutant_rancor", 540, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Mutant Acklays (40 new spawns!)
	for i = 1, 40 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "mutant_acklay", 540, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Wandering Dark Jedi (90 total - was 30)
	for i = 1, 30 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "dark_jedi_knight", 480, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 30 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "dark_jedi_sentinel", 420, x, 91, z, getRandomNumber(360), 0)
	end
	
	for i = 1, 30 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "force_trained_archaist", 360, x, 91, z, getRandomNumber(360), 0)
	end
	
	-- Wandering Masters (15 new spawns!)
	for i = 1, 15 do
		local x = getRandomNumber(4000) - 2000
		local z = getRandomNumber(4000) - 2000
		spawnMobile("korriban", "dark_jedi_master", 600, x, 91, z, getRandomNumber(360), 0)
	end

end
