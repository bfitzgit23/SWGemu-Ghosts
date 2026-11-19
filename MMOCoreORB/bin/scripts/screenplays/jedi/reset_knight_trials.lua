-- ============================================================
-- reset_knight_trials.lua
-- bin/scripts/screenplays/jedi/reset_knight_trials.lua
--
-- Ghosts admin script: Revan and Xixx never finished the Knight trials but
-- the shard still treats them as Knighted. Two things mark a character as a
-- Knight:
--   * having force_title_jedi_rank_03 (or higher), and
--   * KnightTrials "completedTrials" = 1, which JediTrials:onPlayerLoggedIn
--     writes for every rank 03 holder and which is never cleared again.
-- So a character whose Knight title was removed earlier still carries the
-- completed flag, and the trial code refuses to start the trials for them.
--
-- This script puts both characters back to Padawan on their next login:
--   * surrenders the Knight title (rank 03/04/master) and every FRS rank
--   * deletes the KnightTrials and JediTrials trial state
--   * sets jedi_status back to "padawan" with a fresh Padawan timer
--   * keeps the Padawan titles (rank 01/02) and every force skill
-- The Knight trials can then be started normally again.
--
-- Runs once per character, then self-disables.
-- ============================================================

ResetKnightTrials = ScreenPlay:new {
	numberOfActs = 1,
}

registerScreenPlay("ResetKnightTrials", false)

local TARGET_ACCOUNT_ID = 3
local TARGET_NAMES = { xixx = true, revan = true }

-- Everything a Knight carries that a Padawan must not, deepest first.
local KNIGHT_SKILLS = {
	"force_title_jedi_master",
	"force_title_jedi_rank_04",
	"force_title_jedi_rank_03",
	"force_rank_light_rank_10",
	"force_rank_light_rank_09",
	"force_rank_light_rank_08",
	"force_rank_light_rank_07",
	"force_rank_light_rank_06",
	"force_rank_light_rank_05",
	"force_rank_light_rank_04",
	"force_rank_light_rank_03",
	"force_rank_light_rank_02",
	"force_rank_light_rank_01",
	"force_rank_light_master",
	"force_rank_light_novice",
	"force_rank_light",
	"force_rank_dark_rank_10",
	"force_rank_dark_rank_09",
	"force_rank_dark_rank_08",
	"force_rank_dark_rank_07",
	"force_rank_dark_rank_06",
	"force_rank_dark_rank_05",
	"force_rank_dark_rank_04",
	"force_rank_dark_rank_03",
	"force_rank_dark_rank_02",
	"force_rank_dark_rank_01",
	"force_rank_dark_master",
	"force_rank_dark_novice",
	"force_rank_dark",
}

local function removeSkill(creature, name, removed)
	if not creature:hasSkill(name) then
		return removed
	end

	creature:surrenderSkill(name)

	if not creature:hasSkill(name) then
		return removed + 1
	end

	return removed
end

function ResetKnightTrials:playerLoggedIn(pPlayer)
	if pPlayer == nil then return end

	local creature = CreatureObject(pPlayer)
	local firstName = string.lower(creature:getFirstName() or "")

	if not TARGET_NAMES[firstName] then return end

	local ghost = creature:getPlayerObject()
	if ghost == nil then return end
	if PlayerObject(ghost):getAccountID() ~= TARGET_ACCOUNT_ID then return end
	if readScreenPlayData(pPlayer, "ResetKnightTrials", "done") == "1" then return end

	-- Let the Jedi manager accept the surrenders for this one pass.
	writeScreenPlayData(pPlayer, "ResetKnightTrials", "allow", "1")

	local removed = 0
	for i = 1, #KNIGHT_SKILLS do
		removed = removeSkill(creature, KNIGHT_SKILLS[i], removed)
	end

	writeScreenPlayData(pPlayer, "ResetKnightTrials", "allow", "0")

	-- Padawan titles stay; restore them if an earlier reset took them too.
	if not creature:hasSkill("force_title_jedi_novice") then
		awardSkill(pPlayer, "force_title_jedi_novice", true)
	end
	if not creature:hasSkill("force_title_jedi_rank_01") then
		awardSkill(pPlayer, "force_title_jedi_rank_01", true)
	end
	if not creature:hasSkill("force_title_jedi_rank_02") then
		awardSkill(pPlayer, "force_title_jedi_rank_02", true)
	end

	-- Clear the trial state that marks the Knight trials as finished.
	deleteScreenPlayData(pPlayer, "KnightTrials", "completedTrials")
	deleteScreenPlayData(pPlayer, "KnightTrials", "startedTrials")
	deleteScreenPlayData(pPlayer, "JediTrials", "JediCouncil")
	deleteScreenPlayData(pPlayer, "JediTrials", "currentTrial")
	deleteScreenPlayData(pPlayer, "JediTrials", "failureCount")
	deleteScreenPlayData(pPlayer, "JediTrials", "huntTarget")
	deleteScreenPlayData(pPlayer, "JediTrials", "huntTargetCount")
	deleteScreenPlayData(pPlayer, "JediTrials", "huntTargetGoal")
	deleteScreenPlayData(pPlayer, "JediTrials", "trialShrineID")

	-- Back to Padawan on the holocron path, with a fresh training timer.
	writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_status", "padawan")
	writeScreenPlayData(pPlayer, "HolocronJedi", "knight_unlocked_at", "")
	writeScreenPlayData(pPlayer, "HolocronJedi", "knight_holocrons_used", "0")
	writeScreenPlayData(pPlayer, "HolocronJedi", "padawan_unlocked_at", tostring(os.time()))
	writeScreenPlayData(pPlayer, "HolocronJedi", "master_unlocked_at", "")
	writeScreenPlayData(pPlayer, "HolocronJedi", "master_phase", "")
	writeScreenPlayData(pPlayer, "HolocronJedi", "master_holocrons_used", "0")

	PlayerObject(ghost):setJediState(2)
	PlayerObject(ghost):setFrsCouncil(0)
	PlayerObject(ghost):setFrsRank(0)

	creature:sendSystemMessage("\\#FFAA00[Knight Trials]\\#FFFFFF You are a Jedi Padawan again. Your Knight trials are not completed - the enclave will start them for you.")

	print("ResetKnightTrials: " .. creature:getFirstName() .. " reset to Padawan, " .. removed .. " knight skills surrendered")

	writeScreenPlayData(pPlayer, "ResetKnightTrials", "done", "1")
end
