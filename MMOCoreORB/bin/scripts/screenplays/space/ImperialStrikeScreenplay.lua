local SpaceHelpers = require("utils.space_helpers")

-- SpaceDestroyScreenplay guides the player to existing Rebel spawn points and
-- counts the kills, but it has no payout of its own.  Imperial strike missions
-- use this subclass so a completed story strike pays once, just like the duty
-- missions.
ImperialStrikeScreenplay = SpaceDestroyScreenplay:new {
	className = "ImperialStrikeScreenplay",

	creditReward = 0,
}

registerScreenPlay("ImperialStrikeScreenplay", false)

function ImperialStrikeScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	SpaceDestroyScreenplay.completeQuest(self, pPlayer, notifyClient)

	if (self.creditReward > 0) then
		SpaceHelpers:spaceCreditReward(pPlayer, self.creditReward)
	end
end
