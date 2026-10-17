local Logger = require("utils.logger")
local SpaceHelpers = require("utils.space_helpers")

--[[

	Vortex Squadron Quests

	Core3 only ever implemented Havoc (Corellia/Lok), CorSec and the RSF squadrons.
	Vortex (Naboo/Dantooine) and Crimson Phoenix (Tatooine/Yavin IV/Dathomir/Rori)
	were left as empty stubs, which is why V3-FX - the Vortex tier 1 trainer in
	Moenia - had nothing to hand out.

	This file provides the Vortex entry tier: the two duty missions V3-FX offers a
	Vortex pilot, flown in space_naboo, mirroring the Kreezo duty missions in
	HavocSquadronScreenplay.lua.  Tiers 2-4 (Vrovel, Ezkiel, Evin) are still to be
	written.

]]

--[[

	Tier 1 -- V3-FX Duty Missions (Naboo)

]]

-- Sweep and clear Imperial warships in the Naboo system.
destroy_duty_naboo_rebel_6 = SpaceDutyDestroyScreenplay:new {
	className = "destroy_duty_naboo_rebel_6",

	questName = "naboo_rebel_6",
	questType = "destroy_duty",

	questZone = "space_naboo",

	creditReward = 100,

	sideQuest = false,
	sideQuestType = "",

	totalLevels = 5,
	totalRounds = 2,
	totalWaves = 3,

	minDistance = 12500,
	maxDistance = 17500,

	bossShip = "imp_tie_fighter_tier2_naboo",
	shipTypes = {
		{"imp_tie_fighter_tier1_naboo"},
	},
}

registerScreenPlay("destroy_duty_naboo_rebel_6", true)

-- Four-point patrol above Naboo; the ship's sensor data is collected on return.
patrol_duty_naboo_rebel_7 = SpaceDutyPatrolScreenplay:new {
	className = "patrol_duty_naboo_rebel_7",

	questName = "naboo_rebel_7",
	questType = "patrol_duty",

	questZone = "space_naboo",

	creditReward = 500,
	itemReward = {},

	sideQuest = false,
	sideQuestType = "",

	patrolPoints = {
		{patrolPointName = "naboo_rebel_tier1_duty_1", x = -7133, z = 1932, y = -977, patrolNumber = 1, radius = 250},
		{patrolPointName = "naboo_rebel_tier1_duty_2", x = -4653, z = -4807, y = 2728, patrolNumber = 2, radius = 250},
		{patrolPointName = "naboo_rebel_tier1_duty_3", x = -3672, z = -7131, y = 2145, patrolNumber = 3, radius = 250},
		{patrolPointName = "naboo_rebel_tier1_duty_4", x = -2389, z = -5285, y = -810, patrolNumber = 4, radius = 250},
	},
}

registerScreenPlay("patrol_duty_naboo_rebel_7", true)

--[[

	VortexSquadronScreenplay

]]

VortexSquadronScreenplay = ScreenPlay:new {
	screenplayName = "VortexSquadronScreenplay",

	-- Tier 1 (V3-FX), Naboo
	QUEST_STRING_DUTY_1 = {type = "destroy_duty", name = "naboo_rebel_6"},
	QUEST_STRING_DUTY_2 = {type = "patrol_duty", name = "naboo_rebel_7"},
}

registerScreenPlay("VortexSquadronScreenplay", false)

function VortexSquadronScreenplay:start()
end

-- Called by SpaceHelpers when a pilot leaves the squadron, so no duty is left
-- hanging in their quest log.
function VortexSquadronScreenplay:resetV3fxQuests(pPlayer)
	if (pPlayer == nil) then
		return
	end

	destroy_duty_naboo_rebel_6:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DUTY_1.type, self.QUEST_STRING_DUTY_1.name, false)

	patrol_duty_naboo_rebel_7:resetQuest(pPlayer)
	SpaceHelpers:clearSpaceQuest(pPlayer, self.QUEST_STRING_DUTY_2.type, self.QUEST_STRING_DUTY_2.name, false)
end
