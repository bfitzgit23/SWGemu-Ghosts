-- DISABLED - Missing mobile files for darth_caedus and darth_caedus_follower
-- To enable: Create the mobile files first, then uncomment below

--[[
DarthCaedusCave = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "DarthCaedusCave"
}

registerScreenPlay("DarthCaedusCave", true)

function DarthCaedusCave:start()
	if (isZoneEnabled("mandalore")) then
		self:spawnMobiles()
	end
end

function DarthCaedusCave:spawnMobiles()
	--Cave of Darth Caedus  
	
	-- 50+ darth_caedus_follower spawns
	spawnMobile("mandalore", "darth_caedus_follower", 1800, 9.6, -15.6, -8.5, -47, 8566152)
	-- ... (all other spawns)
	
	-- Darth Caedus boss
	spawnMobile("mandalore", "darth_caedus", 10800, -91.1, -100.7, -95.8, 170, 8566162)
end
--]]