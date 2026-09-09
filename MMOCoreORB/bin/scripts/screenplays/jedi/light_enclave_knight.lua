--[[
    Light Jedi Knight Trial
    Triggered from the holocron radial menu when status == "padawan" and
    knight_holocrons_used >= 50.

    4 waves spawn in the open world ~100-200m from the player.
    Each wave taunts the Jedi Code on spawn (system message).
    Each kill confirms a line of the Code (system message).
    Victory recites the full Code and grants Knight rank.

    No teleport. No cells. No ENTEREDAREA. Works on any planet.
]]
-- Coded by BoosterSteel 19-03-2026


LightEnclaveKnight = ScreenPlay:new {
    numberOfActs = 1,
    screenPlayName = "LightEnclaveKnight",
}

registerScreenPlay("LightEnclaveKnight", false)

-- ============================================================
-- CONSTANTS
-- ============================================================

local POLL_MS    = 5000
local WAVE_DELAY = 15000

local WAVE_TEMPLATES = {
    "trial_guardian_wave1",
    "trial_guardian_wave2",
    "trial_guardian_wave3",
    "trial_guardian_wave4",
}

local WAVE_NAMES = {
    "Sith Acolyte",
    "Sith Marauder",
    "Sith Lord",
    "Sith Champion",
}

-- Sent to player when mob spawns
local WAVE_TAUNTS = {
    "\\#FF4444[Sith Acolyte]: There IS emotion - your fear feeds me.",
    "\\#FF4444[Sith Marauder]: Ignorance brought you here. Ignorance will bury you.",
    "\\#FF4444[Sith Lord]: Your passion is a chain around your neck. I will pull it tight.",
    "\\#FF4444[Sith Champion]: Order is an illusion. Chaos is the only truth.",
}

-- Sent to player when mob dies
local WAVE_KILLQUOTES = {
    "\\#88CCFF[Council Elder]: There is no emotion... there is peace.",
    "\\#88CCFF[Council Elder]: There is no ignorance... there is knowledge.",
    "\\#88CCFF[Council Elder]: There is no passion... there is serenity.",
    "\\#88CCFF[Council Elder]: There is no chaos... there is harmony.",
}

-- ============================================================
-- HELPERS
-- ============================================================

local function rsd(pPlayer, key)
    return readScreenPlayData(pPlayer, "HolocronJedi", key)
end

local function wsd(pPlayer, key, val)
    writeScreenPlayData(pPlayer, "HolocronJedi", key, val)
end

local function playerKey(pPlayer, suffix)
    return "LightKnightTrial:" .. SceneObject(pPlayer):getObjectID() .. ":" .. suffix
end

-- Spawn a mobile 100-200m from the player in open world
local function spawnNearPlayer(pPlayer, template)
    local zone = SceneObject(pPlayer):getZoneName()
    if zone == nil or zone == "" then return nil end

    local px = SceneObject(pPlayer):getWorldPositionX()
    local py = SceneObject(pPlayer):getWorldPositionY()
    local pz = SceneObject(pPlayer):getWorldPositionZ()

    local d, dd = 100, 71
    local candidates = {
        { d,  0}, {0,  d}, {-d,  0}, {0, -d},
        { dd, dd}, {-dd, dd}, {dd, -dd}, {-dd, -dd},
    }

    for _, off in ipairs(candidates) do
        local tx, ty = px + off[1], py + off[2]
        local pMob = spawnMobile(zone, template, 0, tx, pz, ty, 0, 0)
        if pMob ~= nil then return pMob end
    end

    -- Fallback: spawn close
    return spawnMobile(zone, template, 0, px + 20, pz, py + 20, 0, 0)
end

-- ============================================================
-- ENTRY POINT - called from holocron radial
-- ============================================================

function LightEnclaveKnight:onTrialAccept(pPlayer)
    if pPlayer == nil then return end

    local status = rsd(pPlayer, "jedi_status")
    if status ~= "padawan" then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: You are not yet ready for this trial.")
        return
    end

    if not holocron_progression_timer_ready(pPlayer, "padawan_unlocked_at", "The Knight trials") then
        return
    end

    local wave = readData(playerKey(pPlayer, "wave"))
    if wave ~= nil and wave > 0 then
        CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: Your trial is already underway. Seek your opponent.")
        return
    end

    local name = CreatureObject(pPlayer):getFirstName()

    writeData(playerKey(pPlayer, "wave"), 1)
    writeData(playerKey(pPlayer, "mob_id"), 0)

    CreatureObject(pPlayer):sendSystemMessage("\\#88CCFF[Council Elder]: The trial begins, " .. name .. ". Four servants of the dark side stand between you and the rank of Jedi Knight. Face them. Silence them. Let the Code guide your blade.")
    createEvent(2000, "LightEnclaveKnight", "doSpawnWave", pPlayer, "1")
end

-- ============================================================
-- WAVE SPAWNING
-- ============================================================

function LightEnclaveKnight:doSpawnWave(pPlayer, params)
    if pPlayer == nil then return end

    local waveNum  = tonumber(params)
    local template = WAVE_TEMPLATES[waveNum]
    local name     = WAVE_NAMES[waveNum]
    local taunt    = WAVE_TAUNTS[waveNum]

    local pMob = spawnNearPlayer(pPlayer, template)

    if pMob == nil then
        CreatureObject(pPlayer):sendSystemMessage("\\#FF4444 Trial error: could not spawn wave " .. waveNum .. ". Contact an admin.")
        writeData(playerKey(pPlayer, "wave"), 0)
        return
    end

    SceneObject(pMob):setCustomObjectName(name)
    writeData(playerKey(pPlayer, "mob_id"), SceneObject(pMob):getObjectID())
    writeData(playerKey(pPlayer, "wave"), waveNum)

    -- Add a waypoint so the player can find the mob
    local pGhost = CreatureObject(pPlayer):getPlayerObject()
    if pGhost ~= nil then
        local zone = SceneObject(pPlayer):getZoneName()
        local mx = SceneObject(pMob):getWorldPositionX()
        local my = SceneObject(pMob):getWorldPositionY()
        local wpID = PlayerObject(pGhost):addWaypoint(zone, name, "", mx, my, WAYPOINTRED, true, true, 0)
        writeData(playerKey(pPlayer, "waypoint_id"), wpID)
    end

    -- Taunt fires as system message to the player
    CreatureObject(pPlayer):sendSystemMessage(taunt)

    createEvent(POLL_MS, "LightEnclaveKnight", "checkWaveKill", pPlayer, tostring(waveNum))
end

-- ============================================================
-- KILL CHECK
-- ============================================================

function LightEnclaveKnight:checkWaveKill(pPlayer, params)
    if pPlayer == nil then return end

    local waveNum = tonumber(params)
    if readData(playerKey(pPlayer, "wave")) ~= waveNum then return end

    local mobID = readData(playerKey(pPlayer, "mob_id"))
    local pMob  = mobID and getSceneObject(mobID) or nil
    local isDead = (pMob == nil) or (CreatureObject(pMob):isDead())

    if isDead then
        self:onWaveKilled(pPlayer, waveNum)
    else
        createEvent(POLL_MS, "LightEnclaveKnight", "checkWaveKill", pPlayer, tostring(waveNum))
    end
end

function LightEnclaveKnight:onWaveKilled(pPlayer, waveNum)
    if pPlayer == nil then return end

    -- Remove the waypoint for the killed mob
    local pGhostKill = CreatureObject(pPlayer):getPlayerObject()
    if pGhostKill ~= nil then
        local wpID = readData(playerKey(pPlayer, "waypoint_id"))
        if wpID ~= nil and wpID ~= 0 then
            PlayerObject(pGhostKill):removeWaypoint(wpID, true)
            writeData(playerKey(pPlayer, "waypoint_id"), 0)
        end
    end

    -- Council Elder confirms the Code line
    CreatureObject(pPlayer):sendSystemMessage(WAVE_KILLQUOTES[waveNum])

    if waveNum < 4 then
        CreatureObject(pPlayer):sendSystemMessage("\\#AAAAAA Recover your strength. The next challenger approaches in 15 seconds...")
        createEvent(WAVE_DELAY, "LightEnclaveKnight", "spawnNextWave", pPlayer, tostring(waveNum + 1))
    else
        self:onTrialComplete(pPlayer)
    end
end

function LightEnclaveKnight:spawnNextWave(pPlayer, params)
    if pPlayer == nil then return end
    self:doSpawnWave(pPlayer, params)
end

-- ============================================================
-- TRIAL COMPLETE
-- ============================================================

function LightEnclaveKnight:onTrialComplete(pPlayer)
    if pPlayer == nil then return end

    -- Clear final waypoint
    local pGhostFin = CreatureObject(pPlayer):getPlayerObject()
    if pGhostFin ~= nil then
        local wpID = readData(playerKey(pPlayer, "waypoint_id"))
        if wpID ~= nil and wpID ~= 0 then
            PlayerObject(pGhostFin):removeWaypoint(wpID, true)
            writeData(playerKey(pPlayer, "waypoint_id"), 0)
        end
    end

    writeData(playerKey(pPlayer, "wave"), 0)
    writeData(playerKey(pPlayer, "mob_id"), 0)

    createEvent(2000, "LightEnclaveKnight", "showVictoryBox", pPlayer, "")
end

function LightEnclaveKnight:showVictoryBox(pPlayer, params)
    if pPlayer == nil then return end

    local name = CreatureObject(pPlayer):getFirstName()

    local sui = SuiMessageBox.new("LightEnclaveKnight", "onVictoryClose")
    sui.setTitle("Knight of the Jedi Order")
    sui.setPrompt(
        "You have spoken the Code through action, not words.\n\n" ..
        "There is no emotion, there is peace.\n" ..
        "There is no ignorance, there is knowledge.\n" ..
        "There is no passion, there is serenity.\n" ..
        "There is no chaos, there is harmony.\n" ..
        "There is no death, there is the Force.\n\n" ..
        "Arise, " .. name .. " - Knight of the Jedi Order.\n\n" ..
        "The Force walks with you now and always."
    )
    sui.setOkButtonText("For the Force")
    sui.setCancelButtonText("Close")
    sui.sendTo(pPlayer)
end

function LightEnclaveKnight:onVictoryClose(pPlayer, pSui, eventIndex, ...)
    if pPlayer == nil then return end
    -- Store alignment now while we have a valid pointer
    wsd(pPlayer, "jedi_alignment", "light")
    -- Defer the grant via createEvent so the player pointer is freshly resolved
    -- SUI callback pointers can go stale by the time the function executes
    createEvent(500, "LightEnclaveKnight", "doGrantKnight", pPlayer, "light")
end

function LightEnclaveKnight:doGrantKnight(pPlayer, params)
    if pPlayer == nil then return end
    -- C++ has already granted force_title_jedi_rank_03 + force_rank_novice via
    -- HolocronKnightGrantPending flag (triggered on any holocron interaction).
    -- holocron_grant_knight calls JediTrials:unlockJediKnight which skips addSkill
    -- since the player already has the skill, then sets FRS/faction/jediState.
    holocron_grant_knight(pPlayer, params)
end
