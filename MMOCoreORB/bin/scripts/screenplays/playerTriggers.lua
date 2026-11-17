PlayerTriggers = { }

function PlayerTriggers:playerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedIn(pPlayer)
	BestineElection:playerLoggedIn(pPlayer)
	GCWXp:registerPlayerObservers(pPlayer)
	ResetXixxJedi:playerLoggedIn(pPlayer)
	RestoreResetJediRank02:playerLoggedIn(pPlayer)
end

function PlayerTriggers:playerLoggedOut(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedOut(pPlayer)
end
