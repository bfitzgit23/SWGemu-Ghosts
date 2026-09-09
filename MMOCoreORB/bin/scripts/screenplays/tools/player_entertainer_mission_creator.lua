-- Player-created entertainer mission setup. The mission generator applies the
-- chosen performance and duration when the player next browses an entertainer terminal.

player_entertainer_mission_creator = ScreenPlay:new {
	numberOfActs = 1
}

function player_entertainer_mission_creator:start()
end

function player_entertainer_mission_creator:openWindow(pPlayer)
	if pPlayer == nil then
		return
	end

	local sui = SuiListBox.new("player_entertainer_mission_creator", "typeSelection")
	sui.setTargetNetworkId(SceneObject(pPlayer):getObjectID())
	sui.setTitle("Create Entertainer Mission")
	sui.setPrompt("Choose the performance required for your custom mission.")
	sui.add("Dance", "")
	sui.add("Play Music", "")
	sui.add("Reset Custom Entertainer Mission", "")
	sui.sendTo(pPlayer)
end

function player_entertainer_mission_creator:typeSelection(pPlayer, pSui, eventIndex, args)
    if eventIndex == 1 or args == "-1" then
        return
    end

    local choice = tonumber(args)

    if choice == 2 then
        deleteScreenPlayData(pPlayer, "player_entertainer_mission_creator", "enabled")
        deleteScreenPlayData(pPlayer, "player_entertainer_mission_creator", "type")
        deleteScreenPlayData(pPlayer, "player_entertainer_mission_creator", "duration")

        CreatureObject(pPlayer):sendSystemMessage(
            "Custom entertainer mission settings have been reset."
        )
        return
    end

    if choice ~= 0 and choice ~= 1 then
        return
    end

    local performanceType = choice == 0 and "dance" or "music"

    writeScreenPlayData(
        pPlayer,
        "player_entertainer_mission_creator",
        "type",
        performanceType
    )

    -- Ghosts entertainer missions are fixed at
    -- 10 minutes for 100,000 credits.
    writeScreenPlayData(
        pPlayer,
        "player_entertainer_mission_creator",
        "duration",
        "10"
    )

    writeScreenPlayData(
        pPlayer,
        "player_entertainer_mission_creator",
        "enabled",
        "1"
    )

    CreatureObject(pPlayer):sendSystemMessage(
        "Custom entertainer mission saved: 10 minutes for 100,000 credits. Browse the terminal to generate it."
    )
end

registerScreenPlay("player_entertainer_mission_creator", true)
