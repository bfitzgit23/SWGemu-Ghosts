--Dromund Kaas (Kaas) Static Spawns
--Ancient Sith Empire homeworld with heavy Dark Jedi, Force users, and unique creatures
local ObjectManager = require("managers.object.object_manager")

KaasStaticSpawnsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KaasStaticSpawnsScreenPlay",
}

registerScreenPlay("KaasStaticSpawnsScreenPlay", true)

function KaasStaticSpawnsScreenPlay:start()
	if (isZoneEnabled("kaas")) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function KaasStaticSpawnsScreenPlay:spawnSceneObjects()
	-- Atmospheric decorations for ancient Sith world
	
	-- Mysterious Shrine (-6374, 6400)
	spawnSceneObject("kaas", "object/static/particle/particle_distant_light.iff", -6374, 80, 6400, 0, 0, 0, 1, 0)
	spawnSceneObject("kaas", "object/static/structure/general/streetlamp_small_style_01_on.iff", -6370, 80, 6395, 0, math.rad(45))
	
	-- Imperial Garrison (-5163, -2238) - as per planet_manager travel point
	spawnSceneObject("kaas", "object/tangible/furniture/imperial/rug_imperial_02.iff", -5163, 80, -2238, 0, 0, 0, 1, 0)
	spawnSceneObject("kaas", "object/static/structure/general/flagpole_imperial_02.iff", -5160, 80, -2235, 0, 0, 0, 1, 0)
	
	-- Mysterious Shrine 2 (-4495, -7535)
	spawnSceneObject("kaas", "object/static/particle/particle_fire.iff", -4495, 80, -7535, 0, 0, 0, 1, 0)
end

function KaasStaticSpawnsScreenPlay:spawnMobiles()

	-- =====================================================
	-- IMPERIAL GARRISON (-5163, -2238)
	-- Heavy Imperial and Dark Jedi presence
	-- =====================================================
	
	-- Dark Jedi Elite Forces
	spawnMobile("kaas", "dark_jedi_master", 720, -5163, 80, -2238, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_master", 720, -5150, 80, -2225, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, -5155, 80, -2245, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, -5170, 80, -2230, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, -5145, 80, -2250, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, -5158, 80, -2242, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, -5168, 80, -2234, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, -5160, 80, -2228, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, -5152, 80, -2248, getRandomNumber(360), 0)
	
	-- Prophet Forces (Elite Imperial Dark Side users)
	spawnMobile("kaas", "prophet_kadann", 900, -5140, 80, -2240, 0, 0)
	spawnMobile("kaas", "prophet_cronal", 900, -5180, 80, -2235, 180, 0)
	spawnMobile("kaas", "herald_of_the_prophets", 600, -5163, 80, -2250, 90, 0)
	spawnMobile("kaas", "stormtrooper_prophets", 480, -5155, 80, -2232, getRandomNumber(360), 0)
	spawnMobile("kaas", "stormtrooper_prophets", 480, -5170, 80, -2244, getRandomNumber(360), 0)
	spawnMobile("kaas", "at_st_prophets", 600, -5175, 80, -2240, getRandomNumber(360), 0)
	
	-- Battle Droids (Garrison defense)
	spawnMobile("kaas", "kaas_s_battle_droid", 420, -5148, 80, -2235, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_battle_droid", 360, -5177, 80, -2232, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_battle_droid", 360, -5150, 80, -2242, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_droideka", 480, -5165, 80, -2245, getRandomNumber(360), 0)
	
	-- =====================================================
	-- MYSTERIOUS SHRINE (-6374, 6400)
	-- Ancient Sith site with ghosts and dark cultists
	-- =====================================================
	
	spawnMobile("kaas", "sith_ghost", 600, -6374, 80, 6400, getRandomNumber(360), 0)
	spawnMobile("kaas", "sith_ghost", 600, getRandomNumber(10) - 6380, 80, getRandomNumber(10) + 6395, getRandomNumber(360), 0)
	spawnMobile("kaas", "sith_ghost", 600, getRandomNumber(10) - 6368, 80, getRandomNumber(10) + 6405, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "insane_vitiate_cultist", 480, getRandomNumber(10) - 6370, 80, getRandomNumber(10) + 6395, getRandomNumber(360), 0)
	spawnMobile("kaas", "insane_vitiate_cultist", 480, getRandomNumber(10) - 6378, 80, getRandomNumber(10) + 6402, getRandomNumber(360), 0)
	spawnMobile("kaas", "insane_vitiate_cultist", 480, getRandomNumber(10) - 6372, 80, getRandomNumber(10) + 6408, getRandomNumber(360), 0)
	
	-- Vitiate himself (ultra rare boss)
	spawnMobile("kaas", "vitiate", 1800, -6374, 80, 6400, 0, 0)
	
	-- Dark Jedi guarding the shrine
	spawnMobile("kaas", "dark_jedi_master", 720, getRandomNumber(15) - 6365, 80, getRandomNumber(15) + 6390, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(15) - 6383, 80, getRandomNumber(15) + 6410, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel", 480, getRandomNumber(15) - 6368, 80, getRandomNumber(15) + 6408, getRandomNumber(360), 0)
	
	-- =====================================================
	-- MYSTERIOUS SHRINE 2 (-4495, -7535)
	-- Secondary Sith site
	-- =====================================================
	
	spawnMobile("kaas", "sith_ghost", 600, -4495, 80, -7535, getRandomNumber(360), 0)
	spawnMobile("kaas", "sith_ghost", 600, getRandomNumber(10) - 4500, 80, getRandomNumber(10) - 7540, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "insane_vitiate_cultist", 480, getRandomNumber(10) - 4490, 80, getRandomNumber(10) - 7530, getRandomNumber(360), 0)
	spawnMobile("kaas", "insane_vitiate_cultist", 480, getRandomNumber(10) - 4502, 80, getRandomNumber(10) - 7542, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(15) - 4488, 80, getRandomNumber(15) - 7525, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_trained_archaist", 420, getRandomNumber(15) - 4505, 80, getRandomNumber(15) - 7548, getRandomNumber(360), 0)
	
	-- =====================================================
	-- REBEL OUTPOST (-6131, 2705)
	-- Rebel forces vs Dark Jedi conflict zone
	-- =====================================================
	
	-- Rebels (already spawned by kaas_regions static spawns, but add context)
	-- Dark Jedi attacking the outpost
	spawnMobile("kaas", "dark_jedi_knight", 600, -6145, 80, 2690, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, -6120, 80, 2720, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel", 480, -6140, 80, 2715, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, -6125, 80, 2695, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "force_sensitive_renegade", 360, -6150, 80, 2700, getRandomNumber(360), 0)
	spawnMobile("kaas", "forsaken_force_drifter", 360, -6115, 80, 2710, getRandomNumber(360), 0)
	
	-- =====================================================
	-- SWAMP GENERAL (6017, -1141)
	-- Dangerous swamp with creatures and dark siders
	-- =====================================================
	
	-- Kell Dragons (apex predators)
	spawnMobile("kaas", "kell_dragon", 720, 6017, 80, -1141, getRandomNumber(360), 0)
	spawnMobile("kaas", "kell_dragon", 720, getRandomNumber(30) + 6000, 80, getRandomNumber(30) - 1160, getRandomNumber(360), 0)
	spawnMobile("kaas", "kell_dragon", 720, getRandomNumber(30) + 6030, 80, getRandomNumber(30) - 1125, getRandomNumber(360), 0)
	
	-- Gundarks (dangerous beasts)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(40) + 6000, 80, getRandomNumber(40) - 1150, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(40) + 6000, 80, getRandomNumber(40) - 1150, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(40) + 6000, 80, getRandomNumber(40) - 1150, getRandomNumber(360), 0)
	
	-- Sleens (pack hunters)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(50) + 5990, 80, getRandomNumber(50) - 1170, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(50) + 5990, 80, getRandomNumber(50) - 1170, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(50) + 5990, 80, getRandomNumber(50) - 1170, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(50) + 5990, 80, getRandomNumber(50) - 1170, getRandomNumber(360), 0)
	
	-- Dark Jedi studying the creatures
	spawnMobile("kaas", "dark_jedi_knight", 600, 6010, 80, -1135, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_trained_archaist", 420, 6025, 80, -1148, getRandomNumber(360), 0)
	
	-- =====================================================
	-- EASTERN ISLANDS (2850, 3890) & (3342, 2634)
	-- Remote islands with experimental nanite horrors
	-- =====================================================
	
	-- Island 1 (2850, 3890)
	spawnMobile("kaas", "nanite_infected_human_cyborg", 540, getRandomNumber(20) + 2840, 80, getRandomNumber(20) + 3880, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_infected_human_cyborg", 540, getRandomNumber(20) + 2840, 80, getRandomNumber(20) + 3880, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_infected_human_cyborg", 540, getRandomNumber(20) + 2840, 80, getRandomNumber(20) + 3880, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_reanimated_clone_trooper", 600, getRandomNumber(20) + 2845, 80, getRandomNumber(20) + 3885, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_reanimated_clone_trooper", 600, getRandomNumber(20) + 2845, 80, getRandomNumber(20) + 3885, getRandomNumber(360), 0)
	
	-- Chiss Herald (rare spawn)
	spawnMobile("kaas", "chiss_hunter_herald", 900, 2850, 80, 3890, getRandomNumber(360), 0)
	
	-- Dark Jedi overseeing nanite experiments
	spawnMobile("kaas", "dark_jedi_master", 720, 2855, 80, 3895, 180, 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, 2845, 80, 3885, 90, 0)
	
	-- Island 2 (3342, 2634)
	spawnMobile("kaas", "nanite_infected_human_cyborg", 540, getRandomNumber(30) + 3330, 80, getRandomNumber(30) + 2620, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_infected_human_cyborg", 540, getRandomNumber(30) + 3330, 80, getRandomNumber(30) + 2620, getRandomNumber(360), 0)
	spawnMobile("kaas", "nanite_reanimated_clone_trooper", 600, getRandomNumber(30) + 3335, 80, getRandomNumber(30) + 2625, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "dark_jedi_knight", 600, 3345, 80, 2638, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_crystal_hunter", 360, 3340, 80, 2630, getRandomNumber(360), 0)
	
	-- =====================================================
	-- NORTHERN ISLANDS (-70, 6370)
	-- Small island with wildlife
	-- =====================================================
	
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(15) - 75, 80, getRandomNumber(15) + 6365, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(15) - 75, 80, getRandomNumber(15) + 6365, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(15) - 75, 80, getRandomNumber(15) + 6365, getRandomNumber(360), 0)
	
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(15) - 70, 80, getRandomNumber(15) + 6370, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(15) - 70, 80, getRandomNumber(15) + 6370, getRandomNumber(360), 0)
	
	-- =====================================================
	-- WILDERNESS SPAWNS - DARK JEDI PATROLS
	-- Wandering Dark Side Force users across the planet
	-- =====================================================
	
	-- Dark Jedi Masters (rare, powerful)
	spawnMobile("kaas", "dark_jedi_master", 720, getRandomNumber(500) - 3000, 80, getRandomNumber(500) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_master", 720, getRandomNumber(500) + 2000, 80, getRandomNumber(500) - 2000, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_master", 720, getRandomNumber(500) - 1000, 80, getRandomNumber(500) + 3000, getRandomNumber(360), 0)
	
	-- Dark Jedi Knights (common patrols)
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(600) - 2500, 80, getRandomNumber(600) + 500, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(600) + 1500, 80, getRandomNumber(600) - 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(600) - 500, 80, getRandomNumber(600) + 2500, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_knight", 600, getRandomNumber(600) + 3000, 80, getRandomNumber(600) - 500, getRandomNumber(360), 0)
	
	-- Dark Jedi Sentinels (guards)
	spawnMobile("kaas", "dark_jedi_sentinel", 480, getRandomNumber(600) - 2000, 80, getRandomNumber(600) + 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel", 480, getRandomNumber(600) + 2500, 80, getRandomNumber(600) - 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, getRandomNumber(600) - 1500, 80, getRandomNumber(600) + 2000, getRandomNumber(360), 0)
	spawnMobile("kaas", "dark_jedi_sentinel_imperial", 480, getRandomNumber(600) + 1000, 80, getRandomNumber(600) - 2500, getRandomNumber(360), 0)
	
	-- Force-sensitive NPCs (scouts and hunters)
	spawnMobile("kaas", "force_trained_archaist", 420, getRandomNumber(700) - 2200, 80, getRandomNumber(700) + 800, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_trained_archaist", 420, getRandomNumber(700) + 1800, 80, getRandomNumber(700) - 1200, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_sensitive_crypt_crawler", 360, getRandomNumber(700) - 1800, 80, getRandomNumber(700) + 1200, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_sensitive_crypt_crawler", 360, getRandomNumber(700) + 2200, 80, getRandomNumber(700) - 800, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_sensitive_renegade", 360, getRandomNumber(700) - 1200, 80, getRandomNumber(700) + 1800, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_sensitive_renegade", 360, getRandomNumber(700) + 2800, 80, getRandomNumber(700) - 1400, getRandomNumber(360), 0)
	spawnMobile("kaas", "forsaken_force_drifter", 360, getRandomNumber(700) - 800, 80, getRandomNumber(700) + 2200, getRandomNumber(360), 0)
	spawnMobile("kaas", "forsaken_force_drifter", 360, getRandomNumber(700) + 1400, 80, getRandomNumber(700) - 2800, getRandomNumber(360), 0)
	spawnMobile("kaas", "novice_force_mystic", 300, getRandomNumber(700) - 2800, 80, getRandomNumber(700) + 1400, getRandomNumber(360), 0)
	spawnMobile("kaas", "novice_force_mystic", 300, getRandomNumber(700) + 800, 80, getRandomNumber(700) - 2200, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_crystal_hunter", 360, getRandomNumber(700) - 1400, 80, getRandomNumber(700) + 2800, getRandomNumber(360), 0)
	spawnMobile("kaas", "force_crystal_hunter", 360, getRandomNumber(700) + 2200, 80, getRandomNumber(700) - 1800, getRandomNumber(360), 0)
	
	-- =====================================================
	-- WILDERNESS SPAWNS - CREATURES
	-- Native Dromund Kaas wildlife
	-- =====================================================
	
	-- Kell Dragons (scattered, dangerous)
	spawnMobile("kaas", "kell_dragon", 720, getRandomNumber(800) - 3500, 80, getRandomNumber(800) + 2000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kell_dragon", 720, getRandomNumber(800) + 2500, 80, getRandomNumber(800) - 3000, getRandomNumber(360), 0)
	
	-- Gundark packs
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(700) - 3000, 80, getRandomNumber(700) + 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(700) - 3000, 80, getRandomNumber(700) + 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(700) + 2000, 80, getRandomNumber(700) - 2500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_gundark", 480, getRandomNumber(700) + 2000, 80, getRandomNumber(700) - 2500, getRandomNumber(360), 0)
	
	-- Sleen packs (common)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) - 2500, 80, getRandomNumber(800) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) - 2500, 80, getRandomNumber(800) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) - 2500, 80, getRandomNumber(800) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) + 1500, 80, getRandomNumber(800) - 2000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) + 1500, 80, getRandomNumber(800) - 2000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_sleen", 360, getRandomNumber(800) + 1500, 80, getRandomNumber(800) - 2000, getRandomNumber(360), 0)
	
	-- Vine Cats (common, predators)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(900) - 2000, 80, getRandomNumber(900) + 500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(900) - 2000, 80, getRandomNumber(900) + 500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(900) + 1000, 80, getRandomNumber(900) - 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_vine_cat", 300, getRandomNumber(900) + 1000, 80, getRandomNumber(900) - 1500, getRandomNumber(360), 0)
	
	-- Mailocs (herbivores)
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(900) - 1500, 80, getRandomNumber(900) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(900) - 1500, 80, getRandomNumber(900) + 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(900) + 1500, 80, getRandomNumber(900) - 1000, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_mailoc", 360, getRandomNumber(900) + 1500, 80, getRandomNumber(900) - 1000, getRandomNumber(360), 0)
	
	-- Ysalamiri (Force-blocking creatures, rare)
	spawnMobile("kaas", "kaas_ysalamiri", 600, getRandomNumber(1000) - 2500, 80, getRandomNumber(1000) + 1500, getRandomNumber(360), 0)
	spawnMobile("kaas", "kaas_ysalamiri", 600, getRandomNumber(1000) + 2000, 80, getRandomNumber(1000) - 2000, getRandomNumber(360), 0)

end