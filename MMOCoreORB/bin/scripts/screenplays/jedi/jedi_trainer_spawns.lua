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
    -- Prevent duplicate trainers from spawning every restart / reload.
    if readStringSharedMemory("JediTrainerSpawnsSpawned") == "1" then
        return 0
    end

    -- YAVIN 4 — Grand Jedi Master Trainer (Light Enclave)
    spawnMobile("yavin4", "jedi_grand_master_trainer", 0, -5575, 0, 4905, 0, 0)

    -- YAVIN 4 — Dark Jedi Lord Trainer (Dark Enclave)
    spawnMobile("yavin4", "jedi_dark_lord_trainer", 0, 5085, 0, 308, 0, 0)

    -- CORELLIA — Grand Jedi Master Trainer
    spawnMobile("corellia", "jedi_grand_master_trainer", 0, -171, 0, -4724, 0, 0)

    -- CORELLIA — Dark Jedi Lord Trainer
    spawnMobile("corellia", "jedi_dark_lord_trainer", 0, -171, 0, -4730, 0, 0)

    writeStringSharedMemory("JediTrainerSpawnsSpawned", "1")
    return 0
end
