local SpaceHelpers = require("utils.space_helpers")

-- SpacePatrolScreenplay does not pay its creditReward.  The Imperial squadron
-- patrols need a payout like the destroy duties, so this subclass completes the
-- patrol normally and then credits the reward once, after confirming the quest
-- was still active.
ImperialDutyPatrolScreenplay = SpaceDutyPatrolScreenplay:new {
	className = "ImperialDutyPatrolScreenplay",

	creditReward = 0,
}

registerScreenPlay("ImperialDutyPatrolScreenplay", false)

function ImperialDutyPatrolScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	SpacePatrolScreenplay.completeQuest(self, pPlayer, notifyClient)

	if (self.creditReward > 0) then
		SpaceHelpers:spaceCreditReward(pPlayer, self.creditReward)
	end
end
