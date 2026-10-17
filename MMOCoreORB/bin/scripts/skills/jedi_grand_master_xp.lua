-- Ghosts: Jedi Grand Master / Dark Lord XP economy fix (2026-10-13)
--
-- Problem: the whole jedi_grand_master_* / jedi_dark_lord_* sub-tree is priced in
-- jedi_general (xpCost 500,000 - 10,000,000 per box) but the entry boxes
-- jedi_grand_master_novice / jedi_dark_lord_novice declared xpType "gcw_skill_xp"
-- in datatables/skill/skills.iff. The jedi_general caps a player actually earns
-- from lightsaber combat come from the combat_jedi_* boxes (400,000 from
-- combat_jedi_light/dark_03; the first 200,000,000 cap only appears deep on the
-- combat_jedi_elder_rank_* line), so nobody could bank the 500,000 the entry box
-- costs - let alone the 7,500,000-10,000,000 masters - and the tree was a dead end.
--
-- Fix: these four boxes now use jedi_general, the same currency as the rest of the
-- tree, with a 200,000,000 cap - the same cap combat_jedi_elder_rank_master already
-- grants. Lightsaber combat awards jedi_general (weapon xpType), so the Grand Master
-- and Dark Lord trees are completable again.
--
-- This file is a Lua skill override: Lua skills are loaded after the iff skills and
-- replace them by name (same mechanism already used here for
-- social_language_bothan_speak). Every field below is replicated exactly from the
-- skills.iff row; only xpType and xpCap differ.

jedi_grand_master_novice = {
	skillName = "jedi_grand_master_novice",
	parentName = "jedi_grand_master",
	graphType = 4,
	godOnly = 0,
	title = 1,
	profession = 1,
	hidden = 0,
	moneyRequired = 0,
	pointsRequired = 4,
	skillsRequiredCount = 0,
	skillsRequired = {},
	preclusionSkills = {},
	xpType = "jedi_general",
	xpCost = 500000,
	xpCap = 200000000,
	missionsRequired = {},
	statsRequired = {},
	speciesRequired = {},
	skillAbility = {},
	commands = {},
	apprenticeshipsRequired = 0,
	jediStateRequired = 4,
	skillModifiers = {
		{ "jedi_force_power_max", 500 },
		{ "jedi_force_power_regen", 5 },
		{ "force_control_light", 25 },
		{ "force_manipulation_light", 25 },
		{ "force_power_light", 25 },
		{ "private_force_lightning_cone_power", 1 },
		{ "private_force_lightning_single_power", 1 },
		{ "force_choke", 5 },
		{ "polearmlightsaber_accuracy", 10 },
		{ "polearmlightsaber_speed", 10 },
		{ "twohandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_toughness", 5 },
		{ "twohandlightsaber_toughness", 5 },
		{ "polearmlightsaber_toughness", 5 },
		{ "saber_block", 5 },
		{ "lightsaber_toughness", 5 },
		{ "jedi_saber_experimentation", 25 }
	},
	schematicsGranted = {},
	schematicsRevoked = {},
	searchable = 0
}
addSkill(jedi_grand_master_novice)

jedi_grand_master_master = {
	skillName = "jedi_grand_master_master",
	parentName = "jedi_grand_master",
	graphType = 4,
	godOnly = 0,
	title = 1,
	profession = 0,
	hidden = 0,
	moneyRequired = 75000000,
	pointsRequired = 4,
	skillsRequiredCount = 0,
	skillsRequired = {
		"jedi_grand_master_lightsaber_04",
		"jedi_grand_master_force_powers_04",
		"jedi_grand_master_defence_04",
		"jedi_grand_master_guardian_04"
	},
	preclusionSkills = {},
	xpType = "jedi_general",
	xpCost = 10000000,
	xpCap = 200000000,
	missionsRequired = {},
	statsRequired = {},
	speciesRequired = {},
	skillAbility = {},
	commands = {},
	apprenticeshipsRequired = 0,
	jediStateRequired = 4,
	skillModifiers = {
		{ "jedi_force_power_max", 500 },
		{ "jedi_force_power_regen", 5 },
		{ "force_control_light", 25 },
		{ "force_manipulation_light", 25 },
		{ "force_power_light", 25 },
		{ "private_force_lightning_cone_power", 1 },
		{ "private_force_lightning_single_power", 1 },
		{ "force_choke", 5 },
		{ "polearmlightsaber_accuracy", 10 },
		{ "polearmlightsaber_speed", 10 },
		{ "twohandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_toughness", 5 },
		{ "twohandlightsaber_toughness", 5 },
		{ "polearmlightsaber_toughness", 5 },
		{ "saber_block", 5 },
		{ "lightsaber_toughness", 5 },
		{ "jedi_saber_experimentation", 25 }
	},
	schematicsGranted = {},
	schematicsRevoked = {},
	searchable = 0
}
addSkill(jedi_grand_master_master)

jedi_dark_lord_novice = {
	skillName = "jedi_dark_lord_novice",
	parentName = "jedi_dark_lord",
	graphType = 4,
	godOnly = 0,
	title = 1,
	profession = 1,
	hidden = 0,
	moneyRequired = 0,
	pointsRequired = 4,
	skillsRequiredCount = 0,
	skillsRequired = {},
	preclusionSkills = {},
	xpType = "jedi_general",
	xpCost = 500000,
	xpCap = 200000000,
	missionsRequired = {},
	statsRequired = {},
	speciesRequired = {},
	skillAbility = {},
	commands = {},
	apprenticeshipsRequired = 0,
	jediStateRequired = 8,
	skillModifiers = {
		{ "jedi_force_power_max", 500 },
		{ "jedi_force_power_regen", 5 },
		{ "force_control_dark", 25 },
		{ "force_manipulation_dark", 25 },
		{ "force_power_dark", 25 },
		{ "private_force_lightning_cone_power", 1 },
		{ "private_force_lightning_single_power", 1 },
		{ "force_choke", 5 },
		{ "polearmlightsaber_speed", 10 },
		{ "twohandlightsaber_accuracy", 10 },
		{ "polearmlightsaber_accuracy", 10 },
		{ "onehandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_toughness", 5 },
		{ "twohandlightsaber_toughness", 5 },
		{ "polearmlightsaber_toughness", 5 },
		{ "saber_block", 5 },
		{ "lightsaber_toughness", 5 },
		{ "jedi_saber_experimentation", 25 }
	},
	schematicsGranted = {},
	schematicsRevoked = {},
	searchable = 0
}
addSkill(jedi_dark_lord_novice)

jedi_dark_lord_master = {
	skillName = "jedi_dark_lord_master",
	parentName = "jedi_dark_lord",
	graphType = 4,
	godOnly = 0,
	title = 1,
	profession = 0,
	hidden = 0,
	moneyRequired = 75000000,
	pointsRequired = 4,
	skillsRequiredCount = 0,
	skillsRequired = {
		"jedi_dark_lord_lightsaber_04",
		"jedi_dark_lord_force_powers_04",
		"jedi_dark_lord_defence_04",
		"jedi_dark_lord_tyrant_04"
	},
	preclusionSkills = {},
	xpType = "jedi_general",
	xpCost = 1500000,
	xpCap = 200000000,
	missionsRequired = {},
	statsRequired = {},
	speciesRequired = {},
	skillAbility = {},
	commands = {},
	apprenticeshipsRequired = 0,
	jediStateRequired = 8,
	skillModifiers = {
		{ "jedi_force_power_max", 500 },
		{ "jedi_force_power_regen", 5 },
		{ "force_control_dark", 25 },
		{ "force_manipulation_dark", 25 },
		{ "force_power_dark", 25 },
		{ "private_force_lightning_cone_power", 1 },
		{ "private_force_lightning_single_power", 1 },
		{ "force_choke", 5 },
		{ "polearmlightsaber_speed", 10 },
		{ "twohandlightsaber_accuracy", 10 },
		{ "polearmlightsaber_accuracy", 10 },
		{ "onehandlightsaber_accuracy", 10 },
		{ "onehandlightsaber_toughness", 5 },
		{ "twohandlightsaber_toughness", 5 },
		{ "polearmlightsaber_toughness", 5 },
		{ "saber_block", 5 },
		{ "lightsaber_toughness", 5 },
		{ "jedi_saber_experimentation", 25 }
	},
	schematicsGranted = {},
	schematicsRevoked = {},
	searchable = 0
}
addSkill(jedi_dark_lord_master)
