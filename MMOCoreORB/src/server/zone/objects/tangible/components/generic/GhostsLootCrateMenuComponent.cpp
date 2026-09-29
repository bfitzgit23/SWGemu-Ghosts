/*
 * GhostsLootCrateMenuComponent.cpp
 *
 * Rebuild (2026-09-29). Fixed tiered rewards per crate template.
 * Reward items are existing, verified loot item templates:
 *   attachment_armor, attachment_clothing, jedi_holocron_dark,
 *   krayt_dragon_pearl_premium, force_crystal_mauls_vengence
 */

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/tangible/TangibleObject.h"
#include "server/zone/Zone.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "GhostsLootCrateMenuComponent.h"

namespace {
	struct CrateReward {
		const char* item;
		int count;
	};

	struct CrateTier {
		const char* templatePath;
		const CrateReward* rewards;
		int rewardCount;
	};

	const CrateReward REWARDS_BASE[] = {{"jedi_holocron_dark", 1}};
	const CrateReward REWARDS_BASE_01[] = {{"attachment_armor", 1}, {"attachment_clothing", 1}};
	const CrateReward REWARDS_BASE_02[] = {{"attachment_armor", 2}};
	const CrateReward REWARDS_BASE_03[] = {{"attachment_clothing", 2}};
	const CrateReward REWARDS_SILVER[] = {{"attachment_armor", 2}, {"jedi_holocron_dark", 1}};
	const CrateReward REWARDS_GOLD[] = {{"attachment_armor", 2}, {"attachment_clothing", 2}, {"jedi_holocron_dark", 1}};
	const CrateReward REWARDS_PLAT[] = {{"attachment_armor", 3}, {"attachment_clothing", 2}, {"krayt_dragon_pearl_premium", 1}};
	const CrateReward REWARDS_DIAMOND[] = {{"attachment_armor", 4}, {"attachment_clothing", 3}, {"force_crystal_mauls_vengence", 1}};
	const CrateReward REWARDS_HEROIC[] = {{"attachment_armor", 3}, {"attachment_clothing", 3}, {"jedi_holocron_dark", 1}, {"krayt_dragon_pearl_premium", 1}};
	const CrateReward REWARDS_XMAS[] = {{"attachment_clothing", 3}, {"jedi_holocron_dark", 1}};
	const CrateReward REWARDS_COAL[] = {{"attachment_armor", 1}};

	const CrateTier TIERS[] = {
		{"object/tangible/item/loot_crates/base_crate.iff", REWARDS_BASE, 1},
		{"object/tangible/item/loot_crates/base_crate_01.iff", REWARDS_BASE_01, 2},
		{"object/tangible/item/loot_crates/base_crate_02.iff", REWARDS_BASE_02, 1},
		{"object/tangible/item/loot_crates/base_crate_03.iff", REWARDS_BASE_03, 1},
		{"object/tangible/item/loot_crates/silver_crate.iff", REWARDS_SILVER, 2},
		{"object/tangible/item/loot_crates/gold_crate.iff", REWARDS_GOLD, 3},
		{"object/tangible/item/loot_crates/plat_crate.iff", REWARDS_PLAT, 3},
		{"object/tangible/item/loot_crates/diamond_crate.iff", REWARDS_DIAMOND, 3},
		{"object/tangible/item/loot_crates/heroic_crate.iff", REWARDS_HEROIC, 4},
		{"object/tangible/item/loot_crates/xmas_crate.iff", REWARDS_XMAS, 2},
		{"object/tangible/item/loot_crates/xmas_coal.iff", REWARDS_COAL, 1},
	};
}

void GhostsLootCrateMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	if (sceneObject == nullptr || player == nullptr || menuResponse == nullptr)
		return;

	if (!sceneObject->isASubChildOf(player))
		return;

	menuResponse->addRadialMenuItem(20, 3, "@ui_radial:item_activate"); // Open the crate
}

int GhostsLootCrateMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	if (sceneObject == nullptr || !sceneObject->isTangibleObject())
		return 0;

	if (player == nullptr || !player->isPlayerCreature())
		return 0;

	if (selectedID != 20)
		return TangibleObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);

	if (!sceneObject->isASubChildOf(player))
		return 0;

	uint32 crc = sceneObject->getServerObjectCRC();
	const CrateReward* rewards = nullptr;
	int rewardCount = 0;

	for (unsigned int i = 0; i < sizeof(TIERS) / sizeof(TIERS[0]); ++i) {
		if (String(TIERS[i].templatePath).hashCode() == crc) {
			rewards = TIERS[i].rewards;
			rewardCount = TIERS[i].rewardCount;
			break;
		}
	}

	if (rewards == nullptr || rewardCount < 1)
		return 0;

	ManagedReference<LootManager*> lootManager = sceneObject->getZone()->getZoneServer()->getLootManager();
	if (lootManager == nullptr)
		return 0;

	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");
	if (inventory == nullptr)
		return 0;

	int given = 0;
	TransactionLog trx(TrxCode::NPCLOOTCLAIM, player);

	for (int i = 0; i < rewardCount; ++i) {
		for (int n = 0; n < rewards[i].count; ++n) {
			if (lootManager->createLoot(trx, inventory, rewards[i].item, 0) > 0) {
				given++;
			} else {
				trx.abort() << "GhostsLootCrate: createLoot " << rewards[i].item << " failed";
			}
		}
	}

	if (given > 0) {
		trx.commit(true);
		player->sendSystemMessage("You open the crate and collect its contents.");
		sceneObject->destroyObjectFromWorld(true);
		sceneObject->destroyObjectFromDatabase(true);
	}

	return 0;
}
