/*
* HolocronMenuComponent.cpp
*
*  Created on: 09/16/2019
*      Author: TOXIC
*
*  Modified: Aftermath Server
*      Added: "Use for Studies" (221) - awards Jedi unlock points, visible to all players
*      Added: "Speak to the Gatekeeper" (222) - visible only when threshold is hit and player is pre-Padawan
*/
// Coded by BoosterSteel 19-03-2026


#include "HolocronMenuComponent.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/zone/managers/skill/SkillManager.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/packets/player/PlayMusicMessage.h"
#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/objects/region/CityRegion.h"
#include "server/zone/ZoneServer.h"
#include "server/chat/ChatManager.h"
#include "server/zone/managers/jedi/JediManager.h"
#include "server/zone/managers/director/DirectorManager.h"

// ============================================================
// RADIAL MENU IDs
// 213-220: existing Aftermath menu items (unchanged)
// 221:     "Use for Studies"       - all players, awards Jedi points
// 222:     "Speak to the Gatekeeper" - shown only when threshold hit + pre-Padawan
// ============================================================

void HolocronMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {

	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);
	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	if (ghost == nullptr)
		return;

	// Check if Lua has flagged this player for Padawan skill grants.
	// The flag is set by holocron_grant_padawan() which fires via createEvent —
	// asynchronously, long after handleObjectMenuSelect has returned.
	// fillObjectMenuResponse fires on every radial menu open, making it the
	// reliable C++ hook for post-event grant processing.
	if (player->getScreenPlayState("HolocronJediGrantPending") == 1) {
		player->setScreenPlayState("HolocronJediGrantPending", 0);
		grantPadawanSkills(player);
		ghost->setJediState(2);
	}

	// Knight grant pending — set by Lua doGrantKnight via HolocronKnightGrantPending flag
	if (player->getScreenPlayState("HolocronKnightGrantPending") == 1) {
		player->setScreenPlayState("HolocronKnightGrantPending", 0);
		grantKnightSkills(player);
	}

	// Master Phase 1 grant pending — grants jedi_grand_master_novice or jedi_dark_lord_novice
	if (player->getScreenPlayState("HolocronMasterGrantPending") == 1) {
		player->setScreenPlayState("HolocronMasterGrantPending", 0);
		grantMasterPhase1Skills(player);
	}

	// Master Final grant pending — grants force_rank_light_master or force_rank_dark_master
	if (player->getScreenPlayState("HolocronMasterFinalGrantPending") == 1) {
		player->setScreenPlayState("HolocronMasterFinalGrantPending", 0);
		grantMasterFinalSkills(player);
	}

	// ---- EXISTING ITEMS (unchanged) ----
	if (ghost->getJediState() >= 1) {
		menuResponse->addRadialMenuItem(213, 3, "Reveal Encrypted Data");
		menuResponse->addRadialMenuItemToRadialID(213, 215, 3, "Regenerate Full Force");
		menuResponse->addRadialMenuItemToRadialID(213, 216, 3, "Visibility");
		menuResponse->addRadialMenuItemToRadialID(213, 220, 3, "Unlock Gray Jedi");
	}

	// ---- AFTERMATH JEDI UNLOCK ITEMS ----
	// All eligibility checks handled in Lua, not here

	menuResponse->addRadialMenuItem(221, 3, "Use for Studies");
	menuResponse->addRadialMenuItem(222, 3, "Speak to the Gatekeeper");
	menuResponse->addRadialMenuItem(223, 3, "Reset Jedi Progress");

	// Dev tools - admin only, all under a single [DEV] submenu
	if (ghost->isPrivileged()) {
		menuResponse->addRadialMenuItem(224, 3, "[DEV]");
		menuResponse->addRadialMenuItemToRadialID(224, 225, 3, "Set Visibility 0");
		menuResponse->addRadialMenuItemToRadialID(224, 226, 3, "Set Visibility 25");
		menuResponse->addRadialMenuItemToRadialID(224, 227, 3, "Set Visibility 50");
		menuResponse->addRadialMenuItemToRadialID(224, 228, 3, "Set Visibility 75");
		menuResponse->addRadialMenuItemToRadialID(224, 229, 3, "Set Visibility 100");
		menuResponse->addRadialMenuItemToRadialID(224, 230, 3, "Show Visibility");
		menuResponse->addRadialMenuItemToRadialID(224, 231, 3, "Start Force Alignment Hunters");
		menuResponse->addRadialMenuItemToRadialID(224, 232, 3, "Start Bounty Hunter");
		menuResponse->addRadialMenuItemToRadialID(224, 233, 3, "Stop All Hunters");
		menuResponse->addRadialMenuItemToRadialID(224, 234, 3, "Debug Jedi Status");
		menuResponse->addRadialMenuItemToRadialID(224, 236, 3, "Add 50 Holocrons");
		menuResponse->addRadialMenuItemToRadialID(224, 235, 3, "Debug Master Trial");
	}

}

int HolocronMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* creature, byte selectedID) const {
	ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

	if (ghost == nullptr)
		return 0;

	ZoneServer* zserv = creature->getZoneServer();

	if (zserv == nullptr)
		return 0;

	// ---- EXISTING HANDLERS (unchanged) ----


	if (selectedID == 20 || selectedID == 213) {
		if (ghost->getJediState() >= 1) {
			// Award XP then destroy the holocron so it cannot be spammed
			ZoneServer* zServ = creature->getZoneServer();
			if (zServ != nullptr) {
				ManagedReference<PlayerManager*> playerManager = zServ->getPlayerManager();
				if (playerManager != nullptr) {
					playerManager->awardExperience(creature, "gcw_skill_xp", 1000, true, 1.0f);
					creature->sendSystemMessage("The holocron pulses with energy and crumbles to dust. (+1000 GCW Skill XP)");
					sceneObject->destroyObjectFromWorld(true);
				}
			}
		} else {
			// Not yet Force Sensitive - original behaviour
			JediManager::instance()->useItem(sceneObject, JediManager::ITEMHOLOCRON, creature);
		}
		return 0;
	}

	if (selectedID == 215 && (ghost->getJediState() >= 1)) {
		ManagedReference<PlayerObject*> playerObject = creature->getPlayerObject();
		if (!creature->checkCooldownRecovery("force_replenish_cooldown")) {
			if (playerObject->getForcePower() >= playerObject->getForcePowerMax()) {
				creature->sendSystemMessage("@jedi_spam:holocron_force_max");
			} else {
				StringIdChatParameter stringId;
				Time* cdTime = creature->getCooldownTime("force_replenish_cooldown");
				int timeLeft = floor((float)cdTime->miliDifference() / 1000) * -1;
				stringId.setStringId("@innate:equil_wait");
				stringId.setDI(timeLeft);
				creature->sendSystemMessage(stringId);
				error("Cooldown In Effect You May Not Replenish Force: " + creature->getFirstName());
				return 0;
			}
			return 0;
		}
		if (playerObject != nullptr && playerObject->getJediState() >= 1) {
			if (playerObject->getForcePower() < playerObject->getForcePowerMax()) {
				creature->sendSystemMessage("@jedi_spam:holocron_force_replenish");
				playerObject->setForcePower(playerObject->getForcePowerMax(), true);
				creature->addCooldown("force_replenish_cooldown", 3600 * 1000);
				sceneObject->destroyObjectFromWorld(true);
				creature->playEffect("clienteffect/pl_force_absorb_hit.cef");
				PlayMusicMessage* pmm = new PlayMusicMessage("sound/music_become_light_jedi.snd");
				playerObject->sendMessage(pmm);
			} else {
				creature->sendSystemMessage("Your force pool is currently full");
			}
		} else {
			JediManager::instance()->useItem(sceneObject, JediManager::ITEMHOLOCRON, creature);
		}
		return 0;
	}

	if (selectedID == 216 && (ghost->getJediState() >= 1)) {
		ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
		box->setPromptTitle("Jedi Visibility");
		int jediVis1 = ghost->getVisibility();
		StringBuffer promptText;
		String playerName = creature->getFirstName();
		promptText << "\\#00ff00 " << playerName << " Has " << "\\#000000 " << "(" << "\\#ffffff " << jediVis1 << "\\#000000 " << ")" << "\\#00ff00 " << " Jedi Visibility" << endl;
		box->setPromptText(promptText.toString());
		ghost->addSuiBox(box);
		creature->sendMessage(box->generateMessage());
	}

	if (selectedID == 220 && (ghost->getJediState() >= 1) && (ghost->getSkillPoints() == 250)) {
		ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::CITY_ADMIN_CONFIRM_UPDATE_TYPE);
		creature->sendSystemMessage("You Have Unlocked Gray Jedi");
		int jediVis1 = ghost->getVisibility();
		box->setPromptTitle("Gray Jedi Progress");
		StringBuffer promptText;
		String playerName = creature->getFirstName();
		promptText << "\\#ffffff " << playerName << "\\#00ff00 Your Visibility is at: " << jediVis1;
		box->setPromptText(promptText.toString());
		ghost->addSuiBox(box);
		creature->sendMessage(box->generateMessage());
		SkillManager::instance()->awardSkill("combat_jedi_novice", creature, true, true, true);
		Vector3 coords(5294.95, -4123.03, 0);
		String zoneName = "dathomir";
		ghost->setTrainerCoordinates(coords);
		ghost->setTrainerZoneName(zoneName);
		creature->sendExecuteConsoleCommand("/pause 10;/findmytrainer");
		box->setForceCloseDistance(5.f);
	}

	if (selectedID == 220 && (ghost->getJediState() >= 1) && (ghost->getSkillPoints() < 250) && !creature->hasSkill("combat_jedi_novice")) {
		creature->sendSystemMessage("You do not meet the requirements for this feature, Force Sensitive and 250 skill points must be free to become gray jedi");
		return 0;
	}

	// ---- AFTERMATH JEDI UNLOCK HANDLERS ----

	// 221: "Use for Studies"
	if (selectedID == 221) {
		// Check all pending grants so any holocron interaction completes them
		if (creature->getScreenPlayState("HolocronKnightGrantPending") == 1) {
			creature->setScreenPlayState("HolocronKnightGrantPending", 0);
			grantKnightSkills(creature);
		}
		if (creature->getScreenPlayState("HolocronMasterGrantPending") == 1) {
			creature->setScreenPlayState("HolocronMasterGrantPending", 0);
			grantMasterPhase1Skills(creature);
		}
		if (creature->getScreenPlayState("HolocronMasterFinalGrantPending") == 1) {
			creature->setScreenPlayState("HolocronMasterFinalGrantPending", 0);
			grantMasterFinalSkills(creature);
		}
		callLuaHolocronFunction(sceneObject, creature, "holocron_use_for_studies");
		return 0;
	}

	// 222: "Speak to the Gatekeeper"  Lua handles all eligibility/state checks.
	// After the Lua function runs, if jedi_status is now "padawan" we grant skills
	// from C++ using checkRequirements=false (same as /grantskill).
	// Lua awardSkill() uses checkRequirements=true which fails for non-admin players.
	if (selectedID == 222) {
		// Check all pending grants
		if (creature->getScreenPlayState("HolocronKnightGrantPending") == 1) {
			creature->setScreenPlayState("HolocronKnightGrantPending", 0);
			grantKnightSkills(creature);
		}
		if (creature->getScreenPlayState("HolocronMasterGrantPending") == 1) {
			creature->setScreenPlayState("HolocronMasterGrantPending", 0);
			grantMasterPhase1Skills(creature);
		}
		if (creature->getScreenPlayState("HolocronMasterFinalGrantPending") == 1) {
			creature->setScreenPlayState("HolocronMasterFinalGrantPending", 0);
			grantMasterFinalSkills(creature);
		}
		callLuaHolocronFunction(sceneObject, creature, "holocron_speak_to_gatekeeper");

		// If Lua set HolocronJediGrantPending=1 during the call above,
		// grant all Padawan skills now with checkRequirements=false.
		// This is the only path confirmed to work — same as /grantskill and
		// the character builder terminal C++ handler.
		if (creature->getScreenPlayState("HolocronJediGrantPending") == 1) {
			creature->setScreenPlayState("HolocronJediGrantPending", 0);
			grantPadawanSkills(creature);
			ManagedReference<PlayerObject*> ghost222 = creature->getPlayerObject();
			if (ghost222 != nullptr)
				ghost222->setJediState(2);
		}

		return 0;
	}

	// 223: "Reset Jedi Progress"
	if (selectedID == 223) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_reset_progress");
		return 0;
	}


	// DEV: 225-229 set visibility
	if (selectedID == 225 && ghost->isPrivileged()) { ghost->setVisibility(0.0f);   creature->sendSystemMessage("[DEV] Visibility set to 0");   return 0; }
	if (selectedID == 226 && ghost->isPrivileged()) { ghost->setVisibility(25.0f);  creature->sendSystemMessage("[DEV] Visibility set to 25");  return 0; }
	if (selectedID == 227 && ghost->isPrivileged()) { ghost->setVisibility(50.0f);  creature->sendSystemMessage("[DEV] Visibility set to 50");  return 0; }
	if (selectedID == 228 && ghost->isPrivileged()) { ghost->setVisibility(75.0f);  creature->sendSystemMessage("[DEV] Visibility set to 75");  return 0; }
	if (selectedID == 229 && ghost->isPrivileged()) { ghost->setVisibility(100.0f); creature->sendSystemMessage("[DEV] Visibility set to 100"); return 0; }

	// DEV: 230 show visibility
	if (selectedID == 230 && ghost->isPrivileged()) {
		int currentVis = ghost->getVisibility();
		StringBuffer msg;
		msg << "[DEV] Current visibility: " << currentVis;
		creature->sendSystemMessage(msg.toString());
		return 0;
	}

	// DEV: 231 start force alignment hunters
	if (selectedID == 231 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_dev_start_hunters");
		return 0;
	}

	// DEV: 232 start bounty hunter
	if (selectedID == 232 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_dev_start_bh_hunters");
		return 0;
	}

	// DEV: 233 stop all hunters
	if (selectedID == 233 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_dev_stop_hunters");
		return 0;
	}

	// DEV: 234 debug jedi status
	if (selectedID == 234 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_debug_status");
		return 0;
	}

	// DEV: 235 debug master trial
	if (selectedID == 235 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_debug_master");
		return 0;
	}

	// DEV: 236 add 50 holocrons
	if (selectedID == 236 && ghost->isPrivileged()) {
		callLuaHolocronFunction(sceneObject, creature, "holocron_dev_add_50_holocrons");
		return 0;
	}


	return 0;
}

// ============================================================
// grantPadawanSkills
//
// Grants all Force Sensitive and Jedi title skills needed for Padawan unlock.
// Uses checkRequirements=FALSE — same as /grantskill command — because the Lua
// global awardSkill() uses checkRequirements=TRUE which fails silently for
// non-admin players even when canLearnSkill() returns true.
//
// Called from handleObjectMenuSelect after holocron_speak_to_gatekeeper confirms
// the player has passed their trial (jedi_status == "padawan" in screenplay data).
// All state-setting, mail, and effects remain in Lua. Only skill grants are here.
// ============================================================

static const char* FS_SKILLS[] = {
	// Combat Prowess
	"force_sensitive_combat_prowess_novice",
	"force_sensitive_combat_prowess_ranged_accuracy_01",
	"force_sensitive_combat_prowess_ranged_accuracy_02",
	"force_sensitive_combat_prowess_ranged_accuracy_03",
	"force_sensitive_combat_prowess_ranged_accuracy_04",
	"force_sensitive_combat_prowess_ranged_speed_01",
	"force_sensitive_combat_prowess_ranged_speed_02",
	"force_sensitive_combat_prowess_ranged_speed_03",
	"force_sensitive_combat_prowess_ranged_speed_04",
	"force_sensitive_combat_prowess_melee_accuracy_01",
	"force_sensitive_combat_prowess_melee_accuracy_02",
	"force_sensitive_combat_prowess_melee_accuracy_03",
	"force_sensitive_combat_prowess_melee_accuracy_04",
	"force_sensitive_combat_prowess_melee_speed_01",
	"force_sensitive_combat_prowess_melee_speed_02",
	"force_sensitive_combat_prowess_melee_speed_03",
	"force_sensitive_combat_prowess_melee_speed_04",
	"force_sensitive_combat_prowess_master",
	// Enhanced Reflexes
	"force_sensitive_enhanced_reflexes_novice",
	"force_sensitive_enhanced_reflexes_ranged_defense_01",
	"force_sensitive_enhanced_reflexes_ranged_defense_02",
	"force_sensitive_enhanced_reflexes_ranged_defense_03",
	"force_sensitive_enhanced_reflexes_ranged_defense_04",
	"force_sensitive_enhanced_reflexes_melee_defense_01",
	"force_sensitive_enhanced_reflexes_melee_defense_02",
	"force_sensitive_enhanced_reflexes_melee_defense_03",
	"force_sensitive_enhanced_reflexes_melee_defense_04",
	"force_sensitive_enhanced_reflexes_vehicle_control_01",
	"force_sensitive_enhanced_reflexes_vehicle_control_02",
	"force_sensitive_enhanced_reflexes_vehicle_control_03",
	"force_sensitive_enhanced_reflexes_vehicle_control_04",
	"force_sensitive_enhanced_reflexes_survival_01",
	"force_sensitive_enhanced_reflexes_survival_02",
	"force_sensitive_enhanced_reflexes_survival_03",
	"force_sensitive_enhanced_reflexes_survival_04",
	"force_sensitive_enhanced_reflexes_master",
	// Crafting Mastery
	"force_sensitive_crafting_mastery_novice",
	"force_sensitive_crafting_mastery_experimentation_01",
	"force_sensitive_crafting_mastery_experimentation_02",
	"force_sensitive_crafting_mastery_experimentation_03",
	"force_sensitive_crafting_mastery_experimentation_04",
	"force_sensitive_crafting_mastery_assembly_01",
	"force_sensitive_crafting_mastery_assembly_02",
	"force_sensitive_crafting_mastery_assembly_03",
	"force_sensitive_crafting_mastery_assembly_04",
	"force_sensitive_crafting_mastery_repair_01",
	"force_sensitive_crafting_mastery_repair_02",
	"force_sensitive_crafting_mastery_repair_03",
	"force_sensitive_crafting_mastery_repair_04",
	"force_sensitive_crafting_mastery_technique_01",
	"force_sensitive_crafting_mastery_technique_02",
	"force_sensitive_crafting_mastery_technique_03",
	"force_sensitive_crafting_mastery_technique_04",
	"force_sensitive_crafting_mastery_master",
	// Heightened Senses
	"force_sensitive_heightened_senses_novice",
	"force_sensitive_heightened_senses_healing_01",
	"force_sensitive_heightened_senses_healing_02",
	"force_sensitive_heightened_senses_healing_03",
	"force_sensitive_heightened_senses_healing_04",
	"force_sensitive_heightened_senses_surveying_01",
	"force_sensitive_heightened_senses_surveying_02",
	"force_sensitive_heightened_senses_surveying_03",
	"force_sensitive_heightened_senses_surveying_04",
	"force_sensitive_heightened_senses_persuasion_01",
	"force_sensitive_heightened_senses_persuasion_02",
	"force_sensitive_heightened_senses_persuasion_03",
	"force_sensitive_heightened_senses_persuasion_04",
	"force_sensitive_heightened_senses_luck_01",
	"force_sensitive_heightened_senses_luck_02",
	"force_sensitive_heightened_senses_luck_03",
	"force_sensitive_heightened_senses_luck_04",
	"force_sensitive_heightened_senses_master",
	nullptr
};

void HolocronMenuComponent::grantMasterPhase1Skills(CreatureObject* creature) const {
	SkillManager* skillManager = SkillManager::instance();

	// Council type: 1 = light, 2 = dark
	int councilType = creature->getScreenPlayState("HolocronKnightCouncil");

	// NOTE: force_master, force_master_light, force_master_dark,
	// jedi_grand_master_unlock, and jedi_dark_lord_unlock have been DELETED
	// from skills.iff. jedi_grand_master_novice and jedi_dark_lord_novice are
	// now direct children of force_title_jedi_rank_03 in the skill tree.
	// The intermediate chain is no longer needed here.

	// Ensure Knight prereqs are present (idempotent — safe to re-grant)
	if (!creature->hasSkill("force_title_jedi_rank_03"))
		skillManager->awardSkill("force_title_jedi_rank_03", creature, false, false, true);

	if (councilType == 2) {
		// Dark path — Knight FRS prereqs + novice directly
		if (!creature->hasSkill("force_rank_dark"))
			skillManager->awardSkill("force_rank_dark", creature, false, false, true);
		if (!creature->hasSkill("force_rank_dark_novice"))
			skillManager->awardSkill("force_rank_dark_novice", creature, false, false, true);
		if (!creature->hasSkill("jedi_dark_lord_novice"))
			skillManager->awardSkill("jedi_dark_lord_novice", creature, false, false, true);
	} else {
		// Light path — Knight FRS prereqs + novice directly
		if (!creature->hasSkill("force_rank_light"))
			skillManager->awardSkill("force_rank_light", creature, false, false, true);
		if (!creature->hasSkill("force_rank_light_novice"))
			skillManager->awardSkill("force_rank_light_novice", creature, false, false, true);
		if (!creature->hasSkill("jedi_grand_master_novice"))
			skillManager->awardSkill("jedi_grand_master_novice", creature, false, false, true);
	}

	creature->setScreenPlayState("HolocronMasterPhase1Granted", 1);
}

void HolocronMenuComponent::grantMasterFinalSkills(CreatureObject* creature) const {
	SkillManager* skillManager = SkillManager::instance();

	int councilType = creature->getScreenPlayState("HolocronKnightCouncil");

	if (councilType == 2) {
		// Dark — grant jedi_dark_lord_master
		// checkRequirements=false bypasses the 75M credit and 75M gcw_skill_xp cost
		if (!creature->hasSkill("jedi_dark_lord_master"))
			skillManager->awardSkill("jedi_dark_lord_master", creature, false, false, true);
	} else {
		// Light — grant jedi_grand_master_master
		if (!creature->hasSkill("jedi_grand_master_master"))
			skillManager->awardSkill("jedi_grand_master_master", creature, false, false, true);
	}

	creature->setScreenPlayState("HolocronMasterFinalGranted", 1);
}

void HolocronMenuComponent::grantKnightSkills(CreatureObject* creature) const {
	SkillManager* skillManager = SkillManager::instance();

	// Grant Jedi Knight rank skill
	if (!creature->hasSkill("force_title_jedi_rank_03"))
		skillManager->awardSkill("force_title_jedi_rank_03", creature, false, false, true);

	// Grant FRS rank skills. The tree is:
	//   force_rank (GOD_ONLY) -> force_rank_light -> force_rank_light_novice
	// force_rank_light and force_rank_light_novice are NOT GOD_ONLY themselves.
	// We must grant force_rank_light first as it is the parent of novice.
	// checkRequirements=false bypasses the force_rank GOD_ONLY prereq.
	int councilType = creature->getScreenPlayState("HolocronKnightCouncil");
	if (councilType == 2) {
		// Dark council
		if (!creature->hasSkill("force_rank_dark"))
			skillManager->awardSkill("force_rank_dark", creature, false, false, true);
		if (!creature->hasSkill("force_rank_dark_novice"))
			skillManager->awardSkill("force_rank_dark_novice", creature, false, false, true);
	} else {
		// Light council
		if (!creature->hasSkill("force_rank_light"))
			skillManager->awardSkill("force_rank_light", creature, false, false, true);
		if (!creature->hasSkill("force_rank_light_novice"))
			skillManager->awardSkill("force_rank_light_novice", creature, false, false, true);
	}

	// Set flag so Lua pollKnightGrant proceeds with FRS council/faction/jediState
	creature->setScreenPlayState("HolocronKnightSkillGranted", 1);
}

void HolocronMenuComponent::grantPadawanSkills(CreatureObject* creature) const {
	SkillManager* skillManager = SkillManager::instance();

	// Step 1: force_title_jedi_novice — root of the entire FS tree
	if (!creature->hasSkill("force_title_jedi_novice"))
		skillManager->awardSkill("force_title_jedi_novice", creature, false, false, true);

	// Step 2: Set VillageUnlockScreenPlay states so canLearnSkill passes
	// C++ order: setScreenPlayState(name, value)
	static const char* FS_BRANCHES[] = {
		"force_sensitive_combat_prowess_melee_accuracy",
		"force_sensitive_combat_prowess_melee_speed",
		"force_sensitive_combat_prowess_ranged_accuracy",
		"force_sensitive_combat_prowess_ranged_speed",
		"force_sensitive_crafting_mastery_assembly",
		"force_sensitive_crafting_mastery_experimentation",
		"force_sensitive_crafting_mastery_repair",
		"force_sensitive_crafting_mastery_technique",
		"force_sensitive_enhanced_reflexes_melee_defense",
		"force_sensitive_enhanced_reflexes_ranged_defense",
		"force_sensitive_enhanced_reflexes_survival",
		"force_sensitive_enhanced_reflexes_vehicle_control",
		"force_sensitive_heightened_senses_healing",
		"force_sensitive_heightened_senses_luck",
		"force_sensitive_heightened_senses_persuasion",
		"force_sensitive_heightened_senses_surveying",
		nullptr
	};

	for (int i = 0; FS_BRANCHES[i] != nullptr; i++) {
		String key = String("VillageUnlockScreenPlay:") + FS_BRANCHES[i];
		creature->setScreenPlayState(key, 2);
	}

	// Step 3: Grant all FS skills in prereq order (novice before boxes, boxes before master)
	// checkRequirements=false matches /grantskill behaviour — bypasses canLearnSkill
	// and skill point checks. Multiple passes ensure each tier unlocks the next.
	bool anyGranted = true;
	while (anyGranted) {
		anyGranted = false;
		for (int i = 0; FS_SKILLS[i] != nullptr; i++) {
			if (!creature->hasSkill(FS_SKILLS[i])) {
				if (skillManager->awardSkill(FS_SKILLS[i], creature, false, false, true))
					anyGranted = true;
			}
		}
	}

	// Step 4: VillageJediProgression — required for Force Progression tree to render
	creature->setScreenPlayState("VillageJediProgression", 32);

	// Step 5: Jedi title ranks
	if (!creature->hasSkill("force_title_jedi_rank_01"))
		skillManager->awardSkill("force_title_jedi_rank_01", creature, false, false, true);
	if (!creature->hasSkill("force_title_jedi_rank_02"))
		skillManager->awardSkill("force_title_jedi_rank_02", creature, false, false, true);
}

// ============================================================
// PRIVATE HELPER: Call a Lua function with (pSceneObject, pCreature, pGhost)
// Used by both "Use for Studies" and "Speak to the Gatekeeper"
// ============================================================

void HolocronMenuComponent::callLuaHolocronFunction(SceneObject* sceneObject, CreatureObject* creature, const String& functionName) const {

	ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();
	if (ghost == nullptr)
		return;

	Lua* lua = DirectorManager::instance()->getLuaInstance();
	if (lua == nullptr)
		return;

	// Use LuaFunction with << operator so objects are SWIG-wrapped correctly.
	// lua_pushlightuserdata pushes raw pointers that Lua cannot cast with SceneObject()/CreatureObject().
	Reference<LuaFunction*> luaFunc = lua->createFunction(functionName, 0);
	if (luaFunc == nullptr) {
		error("HolocronMenuComponent: Lua function not found: " + functionName);
		return;
	}

	*luaFunc << creature;    // pCreature
	*luaFunc << sceneObject; // pTarget (the holocron)
	*luaFunc << ghost.get(); // pGhost

	luaFunc->callFunction();
}