-- ============================================================
-- reset_xixx_jedi.lua
-- bin/scripts/screenplays/jedi/reset_xixx_jedi.lua
--
-- Ghosts admin script: one-shot reset of Xixx Lightning's Jedi
-- skills back to Padawan while keeping force progression.
--
-- Runs the first time the character logs in after this script is
-- installed, then self-disables (screenplay data flag "done").
--
-- Reset scope:
--   * Surrenders all force_discipline_* skills (the Knight boxes)
--   * Surrenders force_rank_light / force_rank_light_novice (FRS)
--   * Surrenders force_title_jedi_rank_03 (Knight title)
--   * Keeps: force_title_jedi_novice/rank_01/rank_02 (Padawan),
--            all force_sensitive_* (village/FS profession)
--   * Sets jediState to 2 (Padawan) and resets holocron gate data
--   * Wipes stored jedi_status so the gatekeeper treats her as a
--     Padawan again (7-day padawan->knight timer restarts from
--     the restore of JEDI_STAGE_DELAY_SECONDS in holocron.lua)
-- ============================================================

ResetXixxJedi = ScreenPlay:new {
	numberOfActs = 1,
}

registerScreenPlay("ResetXixxJedi", false)

-- The character's first name (lowercase compare)
local TARGET_FIRST_NAME = "xixx"

-- Skills to surrender, in dependency-safe order (children first).
-- We enumerate the known rank suffixes rather than relying on list
-- iteration, which is not exposed to Lua.
local SURRENDER_PATTERNS = {
	-- force_discipline_* tree (children _01.._04 then master then novice)
	"force_discipline_defender_force_defense_0",
	"force_discipline_defender_melee_defense_0",
	"force_discipline_defender_preternatural_defense_0",
	"force_discipline_defender_ranged_defense_0",
	"force_discipline_enhancements_movement_0",
	"force_discipline_enhancements_protection_0",
	"force_discipline_enhancements_resistance_0",
	"force_discipline_enhancements_synergy_0",
	"force_discipline_healing_damage_0",
	"force_discipline_healing_other_0",
	"force_discipline_healing_states_0",
	"force_discipline_healing_wound_0",
	"force_discipline_powers_debuff_0",
	"force_discipline_powers_lightning_0",
	"force_discipline_powers_mental_0",
	"force_discipline_powers_push_0",
	"force_discipline_light_saber_one_hand_0",
	"force_discipline_light_saber_polearm_0",
	"force_discipline_light_saber_technique_0",
	"force_discipline_light_saber_two_hand_0",
	"force_discipline_defender_force_defense_04",
	"force_discipline_defender_melee_defense_04",
	"force_discipline_defender_preternatural_defense_04",
	"force_discipline_defender_ranged_defense_04",
	"force_discipline_enhancements_movement_04",
	"force_discipline_enhancements_protection_04",
	"force_discipline_enhancements_resistance_04",
	"force_discipline_enhancements_synergy_04",
	"force_discipline_healing_damage_04",
	"force_discipline_healing_other_04",
	"force_discipline_healing_states_04",
	"force_discipline_healing_wound_04",
	"force_discipline_powers_debuff_04",
	"force_discipline_powers_lightning_04",
	"force_discipline_powers_mental_04",
	"force_discipline_powers_push_04",
	"force_discipline_light_saber_one_hand_04",
	"force_discipline_light_saber_polearm_04",
	"force_discipline_light_saber_technique_04",
	"force_discipline_light_saber_two_hand_04",
	"force_discipline_defender_master",
	"force_discipline_enhancements_master",
	"force_discipline_healing_master",
	"force_discipline_powers_master",
	"force_discipline_light_saber_master",
	"force_discipline_defender_novice",
	"force_discipline_enhancements_novice",
	"force_discipline_healing_novice",
	"force_discipline_powers_novice",
	"force_discipline_light_saber_novice",
	-- FRS (knight) ranks
	"force_rank_light_novice",
	"force_rank_light",
	-- Knight title
	"force_title_jedi_rank_03",
}

function ResetXixxJedi:playerLoggedIn(pPlayer)
	if pPlayer == nil then return end

	local creature = CreatureObject(pPlayer)
	local firstName = string.lower(creature:getFirstName() or "")
	if firstName ~= TARGET_FIRST_NAME then return end

	-- one-shot guard
	if readScreenPlayData(pPlayer, "ResetXixxJedi", "done") == "1" then return end

	creature:sendSystemMessage("\\#FFAA00[Jedi Reset]\\#FFFFFF Your Jedi training is being reset to Padawan...")

	-- 1. Surrender every listed skill the character currently has
	local surrendered = 0
	for _, skill in ipairs(SURRENDER_PATTERNS) do
		if creature:hasSkill(skill) then
			creature:surrenderSkill(skill)
			surrendered = surrendered + 1
		end
	end

	-- 2. Reset jediState to Padawan (2)
	local pGhost = creature:getPlayerObject()
	if pGhost ~= nil then
		PlayerObject(pGhost):setJediState(2)
	end

	-- 3. Clear the holocron gate status so she is treated as Padawan
	writeScreenPlayData(pPlayer, "HolocronJedi", "jedi_status", "padawan")
	writeScreenPlayData(pPlayer, "HolocronJedi", "knight_unlocked_at", "")
	writeScreenPlayData(pPlayer, "HolocronJedi", "padawan_unlocked_at", tostring(os.time()))
	writeScreenPlayData(pPlayer, "HolocronJedi", "master_holocrons_used", "0")
	writeScreenPlayData(pPlayer, "HolocronJedi", "knight_holocrons_used", "0")
	writeScreenPlayData(pPlayer, "HolocronJedi", "holocrons_used", "0")
	writeScreenPlayData(pPlayer, "HolocronJedi", "holocron_studies_total", "")

	-- 4. Clear the knight council selection (light=1 / dark=2) by
	-- overwriting with an invalid value; the next knight grant re-sets it.
	writeScreenPlayData(pPlayer, "JediTrials", "JediCouncil", "")

	creature:sendSystemMessage("\\#FFAA00[Jedi Reset]\\#FFFFFF Done. " .. surrendered ..
		" Jedi skills surrendered. You are a Jedi Padawan again. The seven-day Knight timer is re-enabled server-wide.")

	print("ResetXixxJedi: reset " .. surrendered .. " skills for Xixx Lightning")

	-- self-disable
	writeScreenPlayData(pPlayer, "ResetXixxJedi", "done", "1")
end
