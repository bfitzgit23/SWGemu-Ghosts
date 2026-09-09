-- jedi_trainer_spawns.lua
-- Static spawns for Grand Jedi Master and Dark Jedi Lord trainers
-- Location: bin/scripts/screenplays/jedi/jedi_trainer_spawns.lua

JediTrainerSpawns = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "JediTrainerSpawns",
}

registerScreenPlay("JediTrainerSpawns", true)

function JediTrainerSpawns:start()
    createEvent(10000, "JediTrainerSpawns", "doSpawn", nil, "")
end

function JediTrainerSpawns:doSpawn(pPlayer, params)
    -- YAVIN 4 — Grand Jedi Master Trainer (Light Enclave)
    if isZoneEnabled("yavin4") then
        spawnMobile("yavin4", "jedi_grand_master_trainer", 0, -5575,
            getWorldFloor(-5575, 4905, "yavin4"), 4905, 0, 0)

        -- YAVIN 4 — Dark Jedi Lord Trainer (Dark Enclave)
        spawnMobile("yavin4", "jedi_dark_lord_trainer", 0, 5085,
            getWorldFloor(5085, 308, "yavin4"), 308, 0, 0)
    end

    if isZoneEnabled("corellia") then
        -- CORELLIA — Grand Jedi Master Trainer
        spawnMobile("corellia", "jedi_grand_master_trainer", 0, -171,
            getWorldFloor(-171, -4724, "corellia"), -4724, 0, 0)

        -- CORELLIA — Dark Jedi Lord Trainer
        spawnMobile("corellia", "jedi_dark_lord_trainer", 0, -171,
            getWorldFloor(-171, -4730, "corellia"), -4730, 0, 0)
    end

    return 0
end
