-- LUA definitions for setting Novice Artisan to 5 skill points
-- and the full Merchant/Business line to 0 skill points

----------------------
-- artisan_novice.lua
----------------------
skill = {
	skillName = "artisan_novice",
	parentName = "",
	isProfession = true,
	receivedTitle = "@skill_name:artisan_novice",
	requiredSkills = {},
	requiredSkillPoints = 5,
	skillCost = 5,
	commands = {},
}

-------------------------
-- merchant_novice.lua
-------------------------
skill = {
	skillName = "merchant_novice",
	parentName = "",
	isProfession = true,
	receivedTitle = "@skill_name:merchant_novice",
	requiredSkills = {"artisan_novice"},
	requiredSkillPoints = 0,
	skillCost = 0,
	commands = {"auctionCreate"},
}

-------------------------
-- merchant_business.lua
-------------------------
skill = {
	skillName = "merchant_business",
	parentName = "merchant_novice",
	isProfession = false,
	receivedTitle = "@skill_name:merchant_business",
	requiredSkills = {"merchant_novice"},
	requiredSkillPoints = 0,
	skillCost = 0,
	commands = {},
}

--------------------------
-- merchant_advertising.lua
--------------------------
skill = {
	skillName = "merchant_advertising",
	parentName = "merchant_novice",
	isProfession = false,
	receivedTitle = "@skill_name:merchant_advertising",
	requiredSkills = {"merchant_novice"},
	requiredSkillPoints = 0,
	skillCost = 0,
	commands = {},
}

--------------------------
-- merchant_marketeer.lua
--------------------------
skill = {
	skillName = "merchant_marketeer",
	parentName = "merchant_business",
	isProfession = false,
	receivedTitle = "@skill_name:merchant_marketeer",
	requiredSkills = {"merchant_business"},
	requiredSkillPoints = 0,
	skillCost = 0,
	commands = {},
}

----------------------
-- merchant_master.lua
----------------------
skill = {
	skillName = "merchant_master",
	parentName = "merchant_marketeer",
	isProfession = false,
	receivedTitle = "@skill_name:merchant_master",
	requiredSkills = {"merchant_marketeer", "merchant_business", "merchant_advertising"},
	requiredSkillPoints = 0,
	skillCost = 0,
	commands = {"vendorManage"},
}
