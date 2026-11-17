/*
 * WearableObjectImplementation.cpp
 *
 *  Created on: 02/08/2009
 *      Author: victor
 */

#include "server/zone/objects/tangible/wearables/WearableObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/manufactureschematic/craftingvalues/CraftingValues.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/draftschematic/DraftSchematic.h"
#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/managers/skill/SkillModManager.h"
#include "server/zone/objects/tangible/wearables/ModSortingHelper.h"
#include "server/zone/objects/transaction/TransactionLog.h"

void WearableObjectImplementation::initializeTransientMembers() {
	TangibleObjectImplementation::initializeTransientMembers();

	// Wearable has too many attachments on it for the allowed socket count
	while (usedSocketCount > socketCount && wearableSkillMods.size() > 0) {
		wearableSkillMods.removeElementAt(wearableSkillMods.size() - 1);

		usedSocketCount--;
	}

	// Ghosts (2026-11-17): every Jedi robe opens with the full socket count,
	// whether it was crafted, looted or handed out by a shrine.
	auto tpl = getObjectTemplate();

	if (tpl != nullptr && !socketsGenerated) {
		String path = tpl->getFullTemplateString();

		if (path.contains("/wearables/robe/robe_jedi")) {
			socketCount = MAXSOCKETS;
			usedSocketCount = 0;
			socketsGenerated = true;
		}
	}
}

void WearableObjectImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	TangibleObjectImplementation::fillAttributeList(alm, object);

	for(int i = 0; i < wearableSkillMods.size(); ++i) {
		String key = wearableSkillMods.elementAt(i).getKey();
		String statname = "cat_skill_mod_bonus.@stat_n:" + key;
		int value = wearableSkillMods.get(key);

		if (value > 0)
			alm->insertAttribute(statname, value);
	}

	//Anti Decay Kit
	if (hasAntiDecayKit() && !isArmorObject()){
		alm->insertAttribute("@veteran_new:antidecay_examine_title", "@veteran_new:antidecay_examine_text");
	}

}

bool WearableObjectImplementation::hasSeaRemovalTool(CreatureObject* player, bool removeItem) {
	if (player == nullptr) {
		return false;
	}

	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

	if (inventory == nullptr) {
		return false;
	}

	Locker inventoryLocker(inventory);

	for (int i = 0; i < inventory->getContainerObjectsSize(); ++i) {
		ManagedReference<SceneObject*> sceno = inventory->getContainerObject(i);

		if (sceno == nullptr || sceno->getObjectTemplate() == nullptr) {
			continue;
		}

		if (sceno->getObjectTemplate()->getFullTemplateString() == "object/tangible/item/clothing_sea_removal_tool.iff") {
			if (removeItem) {
				Locker locker(sceno);
				sceno->destroyObjectFromWorld(true);
				sceno->destroyObjectFromDatabase(true);
			}

			return true;
		}
	}

	return false;
}

void WearableObjectImplementation::updateCraftingValues(CraftingValues* values, bool initialUpdate) {
	/*
	 * Values available:	Range:
	 * sockets				0-0(novice artisan) (Don't use)
	 * hitpoints			1000-1000 (Don't Use)
	 */
	if (initialUpdate) {
		if(values->hasExperimentalAttribute("sockets") && values->getCurrentValue("sockets") >= 0)
			generateSockets(values);
	}

	// Ghosts (2026-11-17): crafted Jedi robes always come out with the full
	// socket count regardless of assembly skill, per the custom robe design.
	String craftTemplatePath = getObjectTemplate()->getFullTemplateString();
	if (craftTemplatePath.contains("robe_jedi") || craftTemplatePath.contains("robe_s32") || craftTemplatePath.contains("robe_s33")) {
		if (socketCount < 1) {
			usedSocketCount = 0;
			socketCount = MAXSOCKETS;
			socketsGenerated = true;
		}
	}

	// Ghosts (2026-11-17): crafted armor always comes out with the full socket
	// count, no crafter skill gate.
	if (craftTemplatePath.contains("/wearables/armor/") && socketCount < 1) {
		usedSocketCount = 0;
		socketCount = MAXSOCKETS;
		socketsGenerated = true;
	}
}

void WearableObjectImplementation::generateSockets(CraftingValues* craftingValues) {
	if (socketsGenerated) {
		return;
	}

	// BellumGero port (2026-11-17): every crafted wearable that exposes the
	// sockets attribute comes out fully socketed - no randomness and no
	// crafter skill gate. Covers all clothing, armor and Jedi robes.
	socketCount = MAXSOCKETS;
	usedSocketCount = 0;

	socketsGenerated = true;
}

void WearableObjectImplementation::generateEmptySockets(int count) {
	// Ghosts (2026-11-17): any wearable that is socketed outside crafting opens
	// with the full socket count as well.
	if (socketCount < 1 && count > 0) {
		usedSocketCount = 0;
		socketCount = MAXSOCKETS;
		socketsGenerated = true;
	}
}

void WearableObjectImplementation::applyAttachment(CreatureObject* player, Attachment* attachment) {
	if (attachment == nullptr || !isASubChildOf(player)) {
		return;
	}

	if (getRemainingSockets() < 1 || wearableSkillMods.size() >= MAXSOCKETS) {
		return;
	}

	if (isEquipped()) {
		removeSkillModsFrom(player);
	}

	Locker clocker(attachment, player);

	SortedVector<ModSortingHelper> sortedMods;
	VectorMap<String, int>* skillModifiers = attachment->getSkillMods();

	for (int i = 0; i < skillModifiers->size(); i++) {
		auto key = skillModifiers->elementAt(i).getKey();
		auto value = skillModifiers->elementAt(i).getValue();

		sortedMods.put(ModSortingHelper(key, value));
	}

	// Select the next mod in the SEA, sorted high-to-low. If that skill mod is already on the
	// wearable, with higher or equal value, don't apply and continue. Break once one mod
	// is applied.
	for (int i = 0; i < sortedMods.size(); i++) {
		String modName = sortedMods.elementAt(i).getKey();
		int modValue = sortedMods.elementAt(i).getValue();

		int existingValue = -26;

		if (wearableSkillMods.contains(modName)) {
			existingValue = wearableSkillMods.get(modName);
		}

		if (modValue > existingValue) {
			wearableSkillMods.put(modName, modValue);
			break;
		}
	}

	usedSocketCount++;
	addMagicBit(true);

	TransactionLog trx(player, asSceneObject(), attachment, TrxCode::APPLYATTACHMENT);

	if (trx.isVerbose()) {
		// Force a synchronous export because the object will be deleted before we can export it!
		trx.addRelatedObject(attachment, true);
		trx.setExportRelatedObjects(true);
		trx.exportRelated();
	}

	trx.addState("subjectSkillModMap", sortedMods);
	trx.addState("dstSkillModMap", wearableSkillMods);

	attachment->destroyObjectFromWorld(true);
	attachment->destroyObjectFromDatabase(true);

	if (isEquipped()) {
		applySkillModsTo(player);
	}
}

void WearableObjectImplementation::applySkillModsTo(CreatureObject* creature) const {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (!SkillModManager::instance()->isWearableModDisabled(name))
		{
			creature->addSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

void WearableObjectImplementation::removeSkillModsFrom(CreatureObject* creature) {
	if (creature == nullptr) {
		return;
	}

	for (int i = 0; i < wearableSkillMods.size(); ++i) {
		String name = wearableSkillMods.elementAt(i).getKey();
		int value = wearableSkillMods.get(name);

		if (!SkillModManager::instance()->isWearableModDisabled(name))
		{
			creature->removeSkillMod(SkillModManager::WEARABLE, name, value, true);
			creature->updateSpeedAndAccelerationMods();
		}
	}

	SkillModManager::instance()->verifyWearableSkillMods(creature);
}

bool WearableObjectImplementation::isEquipped() {
	ManagedReference<SceneObject*> parent = getParent().get();
	if (parent != nullptr && parent->isPlayerCreature())
		return true;

	return false;
}

String WearableObjectImplementation::repairAttempt(int repairChance) {
	String message = "@error_message:";

	if(repairChance < 25) {
		message += "sys_repair_failed";
		setMaxCondition(1, true);
		setConditionDamage(0, true);
	} else if(repairChance < 50) {
		message += "sys_repair_imperfect";
		setMaxCondition(getMaxCondition() * .65f, true);
		setConditionDamage(0, true);
	} else if(repairChance < 75) {
		setMaxCondition(getMaxCondition() * .80f, true);
		setConditionDamage(0, true);
		message += "sys_repair_slight";
	} else {
		setMaxCondition(getMaxCondition() * .95f, true);
		setConditionDamage(0, true);
		message += "sys_repair_perfect";
	}

	return message;
}
