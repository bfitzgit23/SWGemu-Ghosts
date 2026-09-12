-- ============================================================
-- gcw_xp.lua
-- bin/scripts/screenplays/gcw/gcw_xp.lua
--
-- Ghosts: GCW experience (faction points) earned from BOTH PVE
-- and PVP kills, mirroring the FRS xp change.
--
-- PVE: killing an opposing-faction creature grants GCW points
--      scaled by the victim's combat level.
-- PVP: killing an enemy-faction player grants GCW points.
--
-- Wiring:
--  * Observers (KILLEDCREATURE for PVE, PLAYERKILLED for PVP)
--    are registered on every player at login via
--    PlayerTriggers:playerLoggedIn (see bottom of this file).
--
-- GCW points are granted as faction standing to the killer's own
-- faction ("imperial"/"rebel" are the GCW standings in PreCU).
-- ============================================================

GCWXp = ScreenPlay:new {
	numberOfActs = 1,
}

registerScreenPlay("GCWXp", false)

-- ---- tuning knobs -------------------------------------------------

local GCW_PVE_BASE = 10          -- base points per PVE kill
local GCW_PVE_CL_SCALE = 0.5     -- extra points per victim combat level
local GCW_PVE_MAX = 150          -- cap per PVE kill
local GCW_PVE_DAILY_CAP = 100000 -- daily cap per player (0 = off)

local GCW_PVP_BASE = 50          -- points per enemy-player kill
local GCW_PVP_DAILY_CAP = 25000  -- daily cap for PVP points (0 = off)

local GCW_DAY_LEN = 86400

-- screenplay data keys (stored in "GCWXp" table)
local K_PVE_PTS = "gcw_pve_points_today"
local K_PVE_DAY = "gcw_pve_day_stamp"
local K_PVP_PTS = "gcw_pvp_points_today"
local K_PVP_DAY = "gcw_pvp_day_stamp"

local TABLE = "GCWXp"

-- ---- helpers ------------------------------------------------------

local function rolloverDaily(pPlayer, ptsKey, dayKey)
	local now = os.time()
	local stamp = tonumber(readScreenPlayData(pPlayer, TABLE, dayKey)) or 0
	if now - stamp >= GCW_DAY_LEN then
		writeScreenPlayData(pPlayer, TABLE, ptsKey, "0")
		writeScreenPlayData(pPlayer, TABLE, dayKey, tostring(now))
	end
end

local function addDailyPoints(pPlayer, ptsKey, dayKey, points, cap)
	rolloverDaily(pPlayer, ptsKey, dayKey)
	if cap > 0 then
		local today = tonumber(readScreenPlayData(pPlayer, TABLE, ptsKey)) or 0
		if today >= cap then
			return false
		end
		points = math.min(points, cap - today)
	end
	local today = tonumber(readScreenPlayData(pPlayer, TABLE, ptsKey)) or 0
	writeScreenPlayData(pPlayer, TABLE, ptsKey, tostring(today + points))
	return true
end

-- returns "imperial"/"rebel" standing name for a faction crc, or nil
local function factionStandingName(factionCrc)
	if factionCrc == FACTIONIMPERIAL then
		return "imperial"
	elseif factionCrc == FACTIONREBEL then
		return "rebel"
	end
	return nil
end

-- returns "rebel" if fed "imperial" and vice versa; nil otherwise
local function enemyStandingName(standingName)
	if standingName == "imperial" then
		return "rebel"
	elseif standingName == "rebel" then
		return "imperial"
	end
	return nil
end

-- ---- award logic --------------------------------------------------

-- pKiller / pVictim are creature pointers (SceneObject userdata)
function GCWXp:awardPveKill(pKiller, pVictim)
	if pKiller == nil or pVictim == nil then return end

	local killer = CreatureObject(pKiller)
	if killer:getPlayerObject() == nil then return end -- only players earn

	-- victim must be an AI creature (not a player, not a pet/droid of a player)
	local victim = CreatureObject(pVictim)
	if victim:getPlayerObject() ~= nil then return end

	local killerStanding = factionStandingName(killer:getFaction())
	if killerStanding == nil then return end -- neutrals earn no GCW xp

	local victimStanding = factionStandingName(victim:getFaction())
	if victimStanding == nil or victimStanding == killerStanding then
		return -- same-faction or neutral kill: no GCW xp
	end

	local level = victim:getLevel()
	local points = GCW_PVE_BASE + math.floor(level * GCW_PVE_CL_SCALE)
	points = math.min(points, GCW_PVE_MAX)
	if points <= 0 then return end

	if not addDailyPoints(pKiller, K_PVE_PTS, K_PVE_DAY, points, GCW_PVE_DAILY_CAP) then
		return
	end

	local ghost = killer:getPlayerObject()
	if ghost ~= nil then
		PlayerObject(ghost):increaseFactionStanding(killerStanding, points)
	end
end

function GCWXp:awardPvpKill(pKiller, pVictim)
	if pKiller == nil or pVictim == nil then return end

	local killer = CreatureObject(pKiller)
	if killer:getPlayerObject() == nil then return end

	local victim = CreatureObject(pVictim)
	if victim:getPlayerObject() == nil then return end -- PVP only

	local killerStanding = factionStandingName(killer:getFaction())
	if killerStanding == nil then return end

	local victimStanding = factionStandingName(victim:getFaction())
	if victimStanding == nil or victimStanding == killerStanding then
		return -- same-faction duel: no GCW xp
	end

	if not killer:isInRangeWithObject(pVictim, 128) then return end

	local points = GCW_PVP_BASE
	if not addDailyPoints(pKiller, K_PVP_PTS, K_PVP_DAY, points, GCW_PVP_DAILY_CAP) then
		return
	end

	local ghost = killer:getPlayerObject()
	if ghost ~= nil then
		PlayerObject(ghost):increaseFactionStanding(killerStanding, points)
	end
	killer:sendSystemMessage("\\#32CD32You have earned " .. points .. " GCW experience for defeating an enemy combatant.")
end

-- ---- observer handlers --------------------------------------------
-- Observer callbacks receive (sceneObjectRegisteredOn, arg1, arg2).
-- KILLEDCREATURE: registered on the player; arg1 = victim creature.
-- PLAYERKILLED:   registered on the player (the victim); arg1 =
--                 the killer's SceneObject pointer.
-- Return 0 = keep observer, 1 = drop observer.

function GCWXp:notifyPveKill(pPlayer, pVictim)
	self:awardPveKill(pPlayer, pVictim)
	return 0
end

function GCWXp:notifyPlayerKilled(pVictim, pKiller)
	-- pVictim is the registered player (who died); pKiller is arg1.
	self:awardPvpKill(pKiller, pVictim)
	return 0
end

-- ---- login registration -------------------------------------------

function GCWXp:registerPlayerObservers(pPlayer)
	if pPlayer == nil then return end

	-- idempotent: drop only THIS screenplay's previous observers first
	dropObserver(KILLEDCREATURE, "GCWXp", "notifyPveKill", pPlayer)
	dropObserver(PLAYERKILLED, "GCWXp", "notifyPlayerKilled", pPlayer)

	createObserver(KILLEDCREATURE, "GCWXp", "notifyPveKill", pPlayer)
	createObserver(PLAYERKILLED, "GCWXp", "notifyPlayerKilled", pPlayer)
end
