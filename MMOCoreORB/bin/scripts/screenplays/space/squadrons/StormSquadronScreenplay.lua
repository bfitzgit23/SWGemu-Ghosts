local SpaceHelpers = require("utils.space_helpers")

--[[

	Storm Squadron Quests

	The squadron trainer is Akal Colzet in the Bestine Pilot's Club on Tatooine.
	Tier 1 uses Storm's native duty tables.  Tiers 2 and 3 escalate to the
	client's destroy story tables, using the Rebel spawn routes already present
	in Tatooine and Endor, so no custom TRE is needed.

]]

--[[

	Tier 1 -- Akal Colzet Duty Missions (Tatooine)

]]

-- Clear the commerce raiders operating along the Bestine routes.
destroy_duty_tatooine_imperial_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_tatooine_imperial_6",

	questName = "tatooine_imperial_6",
	questType = "destroy_duty",

	questZone = "space_tatooine",

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

registerScreenPlay("destroy_duty_tatooine_imperial_6", true)

-- Fly the standard Bestine Orbital Region security circuit.
patrol_duty_tatooine_imperial_1 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_tatooine_imperial_1",

	questName = "tatooine_imperial_1",
	questType = "patrol",

	questZone = "space_tatooine",

	creditReward = 250,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "imperial_escortduty_1", x = 5392, z = -3840, y = 620, patrolNumber = 1, radius = 300},
		{patrolPointName = "imperial_escortduty_2", x = 2356, z = -3868, y = 4288, patrolNumber = 2, radius = 300},
		{patrolPointName = "imperial_escortduty_3", x = -1136, z = -3592, y = 4100, patrolNumber = 3, radius = 300},
		{patrolPointName = "imperial_escortduty_4", x = -5188, z = -3188, y = 4736, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_tatooine_imperial_1", true)

--[[

	Tier 2 -- Akal Colzet Strike Missions (Tatooine)

]]

-- Hunt the commerce raiders and their escorts at the established Rebel spawn
-- routes.  SpaceDestroyScreenplay guides the player to the spawn points and
-- counts the kills; ImperialStrikeScreenplay adds the payout.
destroy_tatooine_imperial_2 = ImperialStrikeScreenplay:new {
	className = "destroy_tatooine_imperial_2",

	questName = "tatooine_imperial_2",
	questType = "destroy",

	questZone = "space_tatooine",

	creditReward = 250,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "rebel_convoy_01", x = 3311, z = -194, y = -2736},
		{patrolPointName = "dest_rebel_base_smugglers", x = -1582, z = 2176, y = -3265},
		{patrolPointName = "rebel_recon_threat_1", x = 1038, z = -1972, y = 227},
		{patrolPointName = "rebel_base_guard_1", x = 3440, z = -414, y = -2628},
	},

	shipTypes = {
		"reb_xwing_tier1",
		"reb_ywing_tier1",
		"reb_z95_tier1",
		"reb_xwing_tier1_tatooine",
		"reb_ywing_tier1_tatooine",
	},
}

registerScreenPlay("destroy_tatooine_imperial_2", true)

-- Patrol the Bestine security route.
patrol_duty_tatooine_imperial_3 = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_tatooine_imperial_3",

	questName = "tatooine_imperial_3",
	questType = "patrol",

	questZone = "space_tatooine",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "bestine_security_patrol_1", x = 2458, z = -3985, y = 2511, patrolNumber = 1, radius = 300},
		{patrolPointName = "bestine_security_patrol_2", x = 1923, z = -3956, y = 3964, patrolNumber = 2, radius = 300},
		{patrolPointName = "bestine_security_patrol_3", x = 507, z = -2183, y = 4492, patrolNumber = 3, radius = 300},
		{patrolPointName = "bestine_security_patrol_4", x = -610, z = -3462, y = 5448, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_tatooine_imperial_3", true)

--[[

	Tier 3 -- Akal Colzet Strike Missions (Endor)

]]

-- Thinning the Herd: hit the Rebel defenders around the Endor generators.
-- The tier 3 Storm story moves out of Tatooine, so the mission zone follows it.
destroy_tatooine_imperial_tier3_4 = ImperialStrikeScreenplay:new {
	className = "destroy_tatooine_imperial_tier3_4",

	questName = "tatooine_imperial_tier3_4",
	questType = "destroy",

	questZone = "space_endor",

	creditReward = 300,

	sideQuest = false,
	sideQuestType = "",

	killsRequired = 4,

	shipLocations = {
		{patrolPointName = "rebel_generator_defense_3", x = 1501, z = 6494, y = 4192},
		{patrolPointName = "rebel_generator_defense_2", x = -3581, z = 2443, y = 4804},
		{patrolPointName = "rebel_generator_defense_1", x = -3506, z = 2756, y = 4747},
		{patrolPointName = "rebel_spies_1", x = -7378, z = -1321, y = 6649},
	},

	shipTypes = {
		"reb_xwing_tier4",
		"reb_ywing_tier4",
		"reb_z95_tier4",
		"reb_awing_tier4",
		"reb_bwing_tier4",
	},
}

registerScreenPlay("destroy_tatooine_imperial_tier3_4", true)

-- Keep watch over the Endor patrol lane.
patrol_duty_tatooine_imperial_tier3_2_d = ImperialDutyPatrolScreenplay:new {
	className = "patrol_duty_tatooine_imperial_tier3_2_d",

	questName = "tatooine_imperial_tier3_2_d",
	questType = "patrol",

	questZone = "space_endor",

	creditReward = 400,

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "tatooine_imperial_tier3_patrol1_2", x = 659, z = -2035, y = 3506, patrolNumber = 1, radius = 300},
		{patrolPointName = "tatooine_imperial_tier3_patrol1_3", x = -385, z = -2351, y = 5481, patrolNumber = 2, radius = 300},
		{patrolPointName = "tatooine_imperial_tier3_patrol1_4", x = -1032, z = -1624, y = 7179, patrolNumber = 3, radius = 300},
		{patrolPointName = "tatooine_imperial_tier3_escort1_1", x = 2340, z = -4531, y = 7123, patrolNumber = 4, radius = 300},
	},
}

registerScreenPlay("patrol_duty_tatooine_imperial_tier3_2_d", true)

--[[

	StormSquadronScreenplay

]]

StormSquadronScreenplay = ScreenPlay:new {
	screenplayName = "StormSquadronScreenplay",

	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "tatooine_imperial_6"},
	QUEST_STRING_DUTY_2 = {type = "patrol", name = "tatooine_imperial_1"},
}

registerScreenPlay("StormSquadronScreenplay", false)

function StormSquadronScreenplay:start()
end

-- Called by SpaceHelpers when a pilot leaves the squadron, so no duty is left
-- hanging in their quest log.  Clear every tier.
function StormSquadronScreenplay:resetAkalQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	destroy_duty_tatooine_imperial_6:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy_duty", "tatooine_imperial_6", false)

	patrol_duty_tatooine_imperial_1:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "tatooine_imperial_1", false)

	destroy_tatooine_imperial_2:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "tatooine_imperial_2", false)

	patrol_duty_tatooine_imperial_3:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "tatooine_imperial_3", false)

	destroy_tatooine_imperial_tier3_4:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "destroy", "tatooine_imperial_tier3_4", false)

	patrol_duty_tatooine_imperial_tier3_2_d:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, "patrol", "tatooine_imperial_tier3_2_d", false)
end
