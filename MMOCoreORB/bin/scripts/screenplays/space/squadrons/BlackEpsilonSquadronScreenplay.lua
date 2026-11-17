local SpaceHelpers = require("utils.space_helpers")

--[[

	Black Epsilon Squadron Quests

	The squadron trainer is Hakassha Sireen at the Imperial Outpost on Talus.
	Black Epsilon flies in the Corellia system.  The tier 2 and 3 duties use the
	client's native Black Epsilon duty tables, so their titles and messages need
	no custom TRE.

]]

--[[

	Tier 1 -- Hakassha Sireen Duty Missions (Corellia)

]]

-- Hunt the B-Wing prototype cell operating in the Corellia system.
destroy_duty_corellia_imperial_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_corellia_imperial_6",

	questName = "corellia_imperial_6",
	questType = "destroy_duty",

	questZone = "space_corellia",

	creditReward = 100,

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

registerScreenPlay("destroy_duty_corellia_imperial_6", true)

-- Show the flag around Corellia and draw the Rebel patrols out.
patrol_duty_corellia_imperial_1 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_corellia_imperial_1",

	questName = "corellia_imperial_1",
	questType = "patrol",

	questZone = "space_corellia",

	creditReward = 250,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "corellia_imperial_patrol_1", x = -2137, z = -2099, y = -3565, patrolNumber = 1, radius = 300},
		{patrolPointName = "corellia_imperial_patrol_2", x = -6321, z = -1417, y = -3345, patrolNumber = 2, radius = 300},
		{patrolPointName = "corellia_imperial_patrol_3", x = -6662, z = -2384, y = -2625, patrolNumber = 3, radius = 300},
		{patrolPointName = "corellia_imperial_patrol_4", x = -7252, z = -3694, y = -574, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_corellia_imperial_1", true)

--[[

	Tier 2 -- Hakassha Sireen Duty Missions (Corellia)

]]

-- Break up the Hidden Daggers' operations in the Corellia system.
destroy_duty_corellia_imperial_8 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_corellia_imperial_8",

	questName = "corellia_imperial_8",
	questType = "destroy_duty",

	questZone = "space_corellia",

	creditReward = 150,

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

registerScreenPlay("destroy_duty_corellia_imperial_8", true)

-- Run the Tier 2 patrol through the tier 2 target box.
patrol_duty_corellia_imperial_15 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_corellia_imperial_15",

	questName = "corellia_imperial_15",
	questType = "patrol",

	questZone = "space_corellia",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "corellia_imperial_tier2_assassinate_1", x = -6932, z = -1364, y = -644, patrolNumber = 1, radius = 300},
		{patrolPointName = "corellia_imperial_tier2_assassinate_2", x = -5275, z = -1116, y = -6269, patrolNumber = 2, radius = 300},
		{patrolPointName = "corellia_imperial_tier2_assassinate_3", x = -2854, z = -236, y = -6778, patrolNumber = 3, radius = 300},
		{patrolPointName = "corellia_imperial_tier2_assassinate_4", x = 15, z = 877, y = -7202, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_corellia_imperial_15", true)

--[[

	Tier 3 -- Hakassha Sireen Duty Missions (Corellia)

]]

-- Disrupt the Rebel operations that replaced the Hidden Daggers.
destroy_duty_corellia_imperial_10 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_corellia_imperial_10",

	questName = "corellia_imperial_10",
	questType = "destroy_duty",

	questZone = "space_corellia",

	creditReward = 225,

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

registerScreenPlay("destroy_duty_corellia_imperial_10", true)

-- Fly the Tier 3 Black Epsilon patrol through the tier 3 patrol box.
patrol_duty_corellia_imperial_tier3_1b = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_corellia_imperial_tier3_1b",

	questName = "corellia_imperial_tier3_1b",
	questType = "patrol",

	questZone = "space_corellia",

	creditReward = 400,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "corellia_imperial_tier3_leg_1_patrol_1", x = -2753, z = 4190, y = 4780, patrolNumber = 1, radius = 300},
		{patrolPointName = "corellia_imperial_tier3_leg_1_patrol_2", x = -685, z = 4105, y = 3238, patrolNumber = 2, radius = 300},
		{patrolPointName = "corellia_imperial_tier3_leg_1_patrol_3", x = 1121, z = 3734, y = 3940, patrolNumber = 3, radius = 300},
		{patrolPointName = "corellia_imperial_tier3_leg_1_inspect", x = -5418, z = 3746, y = 3641, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_corellia_imperial_tier3_1b", true)

--[[

	BlackEpsilonSquadronScreenplay

]]

BlackEpsilonSquadronScreenplay = ScreenPlay:new {
	screenplayName = "BlackEpsilonSquadronScreenplay",

	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "corellia_imperial_6"},
	QUEST_STRING_DUTY_2 = {type = "patrol", name = "corellia_imperial_1"},
}

registerScreenPlay("BlackEpsilonSquadronScreenplay", false)

function BlackEpsilonSquadronScreenplay:start()
end

-- Called by SpaceHelpers when a pilot leaves the squadron, so no duty is left
-- hanging in their quest log.  Clear every tier.
function BlackEpsilonSquadronScreenplay:resetHakasshaQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	destroy_duty_corellia_imperial_6:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_duty", "corellia_imperial_6", false)

	patrol_duty_corellia_imperial_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "corellia_imperial_1", false)

	destroy_duty_corellia_imperial_8:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_duty", "corellia_imperial_8", false)

	patrol_duty_corellia_imperial_15:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "corellia_imperial_15", false)

	destroy_duty_corellia_imperial_10:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_duty", "corellia_imperial_10", false)

	patrol_duty_corellia_imperial_tier3_1b:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "corellia_imperial_tier3_1b", false)
end
