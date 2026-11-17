local SpaceHelpers = require("utils.space_helpers")

--[[

	Imperial Inquisition Squadron Quests

	The squadron trainer is Barn Sinkko in the association hall in Kaadara on
	Naboo.  Tier 1 uses the native Inquisition duty tables.  Tier 2 stays around
	Naboo, while tier 3 follows the Inquisition's Rebel hunt into Dathomir.
	All titles come from client spacequest tables, so no custom TRE is needed.

]]

--[[

	Tier 1 -- Barn Sinkko Duty Missions (Dantooine / Naboo)

]]

-- Sweep the Rebel fighter concentration in the Dantooine system.
destroy_duty_naboo_imperial_tier2 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_imperial_tier2",

	questName = "naboo_imperial_tier2_destroyduty",
	questType = "destroy_duty",

	questZone = "space_dantooine",

	creditReward = 125,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 3,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 10000,
	maxDistance = 15000,

	bossShip = "reb_xwing_tier2",
	shipTypes = {
		{"reb_xwing_tier1"},
		{"reb_ywing_tier1"},
	},
}

registerScreenPlay("destroy_duty_naboo_imperial_tier2", true)

-- Fly the Inquisition training and security circuit in the Naboo system.
patrol_duty_naboo_imperial_1 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_naboo_imperial_1",

	questName = "naboo_imperial_1",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "naboo_imperial_patrol_1", x = -2455, z = 2645, y = -3905, patrolNumber = 1, radius = 300},
		{patrolPointName = "naboo_imperial_escort_2", x = -2934, z = 3049, y = -3022, patrolNumber = 2, radius = 300},
		{patrolPointName = "naboo_imperial_escort_3", x = -930, z = 3507, y = -5308, patrolNumber = 3, radius = 300},
		{patrolPointName = "naboo_imperial_patrol_4", x = -5399, z = 2837, y = -2966, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_naboo_imperial_1", true)

--[[

	Tier 2 -- Barn Sinkko Strike Missions (Naboo)

]]

-- Destroy the Rebel fighter screen around the Naboo defense positions.
destroy_naboo_imperial_2 = ImperialStrikeScreenplay:new {
	className = "destroy_naboo_imperial_2",

	questName = "naboo_imperial_2",
	questType = "destroy",

	questZone = "space_naboo",

	creditReward = 250,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "rebel_defense_4", x = -4892, z = 6147, y = 6901},
		{patrolPointName = "rebel_defense_2", x = -5998, z = 5792, y = 6563},
		{patrolPointName = "rebel_base_defense_1", x = -5667, z = 6271, y = 6288},
		{patrolPointName = "rebel_generic_1", x = -172, z = -2813, y = -425},
	},

	shipTypes = {
		"reb_xwing_tier1",
		"reb_ywing_tier1",
		"reb_ywing_tier2",
		"reb_z95_tier1",
		"reb_xwing_cadet_tier1",
	},
}

registerScreenPlay("destroy_naboo_imperial_2", true)

-- Locate the Inquisition's decoy E-62 transport.
patrol_duty_naboo_imperial_3 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_naboo_imperial_3",

	questName = "naboo_imperial_3",
	questType = "patrol",

	questZone = "space_naboo",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "naboo_imperial_tier2_escortduty_6", x = -3203, z = 3201, y = -3078, patrolNumber = 1, radius = 300},
		{patrolPointName = "naboo_imperial_tier2_escortduty_5", x = -2169, z = 2068, y = -2002, patrolNumber = 2, radius = 300},
		{patrolPointName = "naboo_imperial_tier2_escortduty_4", x = -1352, z = 1269, y = -1205, patrolNumber = 3, radius = 300},
		{patrolPointName = "naboo_imperial_patrol_2", x = -2946, z = 2568, y = -2486, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_naboo_imperial_3", true)

--[[

	Tier 3 -- Barn Sinkko Strike Missions (Dathomir)

]]

-- Thinning the Herd: break the Rebel defenders in the Dathomir system.
destroy_naboo_imperial_tier3_4 = ImperialStrikeScreenplay:new {
	className = "destroy_naboo_imperial_tier3_4",

	questName = "naboo_imperial_tier3_4",
	questType = "destroy",

	questZone = "space_dathomir",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "rebel_defenders_2", x = 5131, z = 242, y = -512},
		{patrolPointName = "rebel_defenders_1", x = 7438, z = -450, y = 1370},
		{patrolPointName = "rebel_patrol_1", x = 7077, z = -1467, y = 1776},
		{patrolPointName = "tatooine_rebel_tier3_2_suspect_1", x = 5585, z = 4809, y = -2403},
	},

	shipTypes = {
		"reb_xwing_tier4",
		"reb_ywing_tier4",
		"reb_z95_tier4",
		"reb_awing_tier4",
		"reb_bwing_tier4",
	},
}

registerScreenPlay("destroy_naboo_imperial_tier3_4", true)

-- Keep watch over the Inquisition's Dathomir patrol lane.
patrol_duty_naboo_imperial_tier3_2_d = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_naboo_imperial_tier3_2_d",

	questName = "naboo_imperial_tier3_2_d",
	questType = "patrol",

	questZone = "space_dathomir",

	creditReward = 400,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "naboo_imperial_tier3_spacebattle1", x = 1303, z = 2316, y = 4521, patrolNumber = 1, radius = 300},
		{patrolPointName = "naboo_imperial_tier4_assassinate2_1", x = 2795, z = -5791, y = 6336, patrolNumber = 2, radius = 300},
		{patrolPointName = "naboo_imperial_tier4_assassinate2_2", x = 2631, z = -7584, y = 4070, patrolNumber = 3, radius = 300},
		{patrolPointName = "naboo_imperial_tier4_assassinate2_3", x = 3072, z = -6658, y = 5858, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_naboo_imperial_tier3_2_d", true)

--[[

	InquisitionSquadronScreenplay

]]

InquisitionSquadronScreenplay = ScreenPlay:new {
	screenplayName = "InquisitionSquadronScreenplay",

	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_imperial_tier2_destroyduty"},
	QUEST_STRING_DUTY_2 = {type = "patrol", name = "naboo_imperial_1"},
}

registerScreenPlay("InquisitionSquadronScreenplay", false)

function InquisitionSquadronScreenplay:start()
end

-- Called by SpaceHelpers when a pilot leaves the squadron, so no duty is left
-- hanging in their quest log.  Clear every tier.
function InquisitionSquadronScreenplay:resetBarnQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	destroy_duty_naboo_imperial_tier2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_duty", "naboo_imperial_tier2_destroyduty", false)

	patrol_duty_naboo_imperial_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "naboo_imperial_1", false)

	destroy_naboo_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "naboo_imperial_2", false)

	patrol_duty_naboo_imperial_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "naboo_imperial_3", false)

	destroy_naboo_imperial_tier3_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "naboo_imperial_tier3_4", false)

	patrol_duty_naboo_imperial_tier3_2_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "naboo_imperial_tier3_2_d", false)
end
