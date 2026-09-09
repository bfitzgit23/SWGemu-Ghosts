NalhuttaVolcanoScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "nalhuttaVolcanoScreenPlay",


}

registerScreenPlay("NalhuttaVolcanoScreenPlay", true)

function NalhuttaVolcanoScreenPlay:start()
	if (isZoneEnabled("hutta")) then
		self:spawnMobiles()

	end
end

function NalhuttaVolcanoScreenPlay:spawnMobiles()
--[[
	spawnMobile("hutta", "sherkar", 3600, 5000, 76, 5000, 0, 0)

	spawnMobile("hutta", "sherkarmini", 15, 5000, 76, 5010, 0, 0)	
	spawnMobile("hutta", "sherkarmini", 15, 5000, 76, 4990, 0, 0)

	spawnMobile("hutta", "sherkarmini", 15, 5010, 76, 5000, 0, 0)
	spawnMobile("hutta", "sherkarmini", 15, 4990, 76, 5000, 0, 0)

	spawnMobile("hutta", "sherkarmini", 15, 4990, 76, 4990, 0, 0)
	spawnMobile("hutta", "sherkarmini", 15, 5010, 76, 5010, 0, 0)

	spawnMobile("hutta", "sherkarmini", 15, 4990, 76, 5010, 0, 0)
	spawnMobile("hutta", "sherkarmini", 15, 5010, 76, 4990, 0, 0)
	]]--


end
