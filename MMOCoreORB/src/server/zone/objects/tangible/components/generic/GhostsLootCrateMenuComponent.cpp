/*
 * GhostsLootCrateMenuComponent.cpp
 *
 * Rebuild (2026-09-29). Fixed tiered rewards per crate template.
 * Reward items are existing, verified loot item templates/groups:
 *   attachment_armor, attachment_clothing, jedi_holocron_dark,
 *   jedi_holocron_light, krayt_dragon_pearl_premium,
 *   force_crystal_mauls_vengence, ls_gen5_group (5th-gen saber materials)
 *
 * 2026-10-10: the Ancient Jedaii holocron furniture (cube, dode, triangle)
 * is now a fixed reward of the artifact, premium (silver), gold, platinum and
 * diamond crates, alongside what they already drop.
 *
 * 2026-10-12: the Rare Artifact (object/tangible/loot/misc/artifact_rare_s01)
 * is now a fixed reward of the artifact, premium (silver), gold, platinum
 * and diamond crates as well.
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

	// Note: the in-game "Ancient" crate is base_crate (ArtifactMenuComponent).
	const CrateReward REWARDS_BASE[] = {{"attachment_armor", 1}, {"attachment_clothing", 1}, {"jedi_holocron_dark", 1}, {"ls_gen5_group", 1}, {"ancient_jedaii_holocron_cube", 1}, {"ancient_jedaii_holocron_dode", 1}, {"ancient_jedaii_holocron_triangle", 1}, {"rare_artifact", 1}};
	const CrateReward REWARDS_BASE_01[] = {{"attachment_armor", 1}, {"attachment_clothing", 1}, {"jedi_holocron_light", 1}};
	const CrateReward REWARDS_BASE_02[] = {{"attachment_armor", 2}, {"jedi_holocron_dark", 1}};
	const CrateReward REWARDS_BASE_03[] = {{"attachment_clothing", 2}, {"jedi_holocron_light", 1}};
	const CrateReward REWARDS_SILVER[] = {{"attachment_armor", 2}, {"attachment_clothing", 1}, {"jedi_holocron_dark", 1}, {"ls_gen5_group", 1}, {"ancient_jedaii_holocron_cube", 1}, {"ancient_jedaii_holocron_dode", 1}, {"ancient_jedaii_holocron_triangle", 1}, {"rare_artifact", 1}};
	const CrateReward REWARDS_GOLD[] = {{"attachment_armor", 2}, {"attachment_clothing", 2}, {"jedi_holocron_dark", 1}, {"ls_gen5_group", 1}, {"ancient_jedaii_holocron_cube", 1}, {"ancient_jedaii_holocron_dode", 1}, {"ancient_jedaii_holocron_triangle", 1}, {"rare_artifact", 1}};
	const CrateReward REWARDS_PLAT[] = {{"attachment_armor", 3}, {"attachment_clothing", 2}, {"krayt_dragon_pearl_premium", 1}, {"ls_gen5_group", 1}, {"jedi_holocron_light", 1}, {"ancient_jedaii_holocron_cube", 1}, {"ancient_jedaii_holocron_dode", 1}, {"ancient_jedaii_holocron_triangle", 1}, {"rare_artifact", 1}};
	const CrateReward REWARDS_DIAMOND[] = {{"attachment_armor", 4}, {"attachment_clothing", 3}, {"force_crystal_mauls_vengence", 1}, {"ls_gen5_group", 1}, {"jedi_holocron_dark", 1}, {"ancient_jedaii_holocron_cube", 1}, {"ancient_jedaii_holocron_dode", 1}, {"ancient_jedaii_holocron_triangle", 1}, {"rare_artifact", 1}};
	const CrateReward REWARDS_HEROIC[] = {{"attachment_armor", 3}, {"attachment_clothing", 3}, {"jedi_holocron_dark", 1}, {"jedi_holocron_light", 1}, {"krayt_dragon_pearl_premium", 1}, {"ls_gen5_group", 2}};
	const CrateReward REWARDS_XMAS[] = {{"attachment_clothing", 3}, {"jedi_holocron_light", 1}, {"ls_gen5_group", 1}};
	const CrateReward REWARDS_COAL[] = {{"attachment_armor", 1}};

	const CrateTier TIERS[] = {
		{"object/tangible/item/loot_crates/base_crate.iff", REWARDS_BASE, 8},
		{"object/tangible/item/loot_crates/base_crate_01.iff", REWARDS_BASE_01, 3},
		{"object/tangible/item/loot_crates/base_crate_02.iff", REWARDS_BASE_02, 2},
		{"object/tangible/item/loot_crates/base_crate_03.iff", REWARDS_BASE_03, 2},
		{"object/tangible/item/loot_crates/silver_crate.iff", REWARDS_SILVER, 8},
		{"object/tangible/item/loot_crates/gold_crate.iff", REWARDS_GOLD, 8},
		{"object/tangible/item/loot_crates/plat_crate.iff", REWARDS_PLAT, 9},
		{"object/tangible/item/loot_crates/diamond_crate.iff", REWARDS_DIAMOND, 9},
		{"object/tangible/item/loot_crates/heroic_crate.iff", REWARDS_HEROIC, 6},
		{"object/tangible/item/loot_crates/xmas_crate.iff", REWARDS_XMAS, 3},
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
		// Ghosts: attachments roll at the maximum loot level so their skill-mod bonus
		// reaches the +25 cap instead of the +1 from a level-0 roll, and crystals and
		// krayt pearls do too: a crystal's whole stat roll and its quality tier come
		// from that level, so a level-0 roll handed out a POOR crystal with minimum
		// stats.  The pearl reward is krayt_dragon_pearl_premium.
		String rewardName(rewards[i].item);
		int rewardLevel = (rewardName.beginsWith("attachment_")
				|| rewardName.beginsWith("krayt_dragon_pearl")
				|| rewardName.beginsWith("force_crystal")) ? 350 : 0;

		for (int n = 0; n < rewards[i].count; ++n) {
			if (lootManager->createLoot(trx, inventory, rewards[i].item, rewardLevel) > 0) {
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
