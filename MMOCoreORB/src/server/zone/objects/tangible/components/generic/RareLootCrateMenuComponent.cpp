/*
 * RareLootCrateMenuComponent.cpp
 *
 * The three "Rare Loot Crate" items are dropped by the rare loot pool ("rarelootsystem",
 * 2% on level 50+ creatures). Their templates name Rarelootcrate1/2/3MenuComponent,
 * the classes that afc95d435 ("removed excess/large files") deleted. With nothing to
 * resolve, the template fell back to the default menu, which is why the crate showed
 * a dead "Use" option instead of opening.
 *
 * The original handlers gave these rewards:
 *
 *   Rare Loot Crate             lootcollectiontierthree x3, boss_rare x1
 *   Rare Loot Crate Exceptional lootcollectiontierdiamond x5, boss_rare x2
 *   Rare Loot Crate Legendary   jedi_belt_group, resource_deed_loot,
 *                               resource_crate_loot, jedi_comp_group,
 *                               legendary_comp_group, lootcollectiontierdiamond x3
 *
 * Those loot groups are no longer registered when the server starts (their files
 * survive as orphans, but the item templates they name -- jedi_belt_01,
 * legendary_tissue, resource_deed -- were dropped with them), so handing out those
 * names today would open the crate and deliver nothing. The rewards below keep the
 * same three-tier shape using loot that is registered: attachments, holocrons, the
 * fifth-generation saber group, a premium krayt pearl, Maul's crystal and the rare
 * artifact. Attachments, pearls and crystals roll at level 350 so their skill bonus
 * and quality land at the top of their range instead of the minimum.
 *
 * The rolls share one TransactionLog; the crate is only consumed when at least one
 * item was actually created.
 */

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/tangible/TangibleObject.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/objects/transaction/TransactionLog.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "RareLootCrateMenuComponent.h"

namespace {
	struct CrateLoot {
		const char* name;
		int rolls;
	};

	struct CrateTier {
		const char* templatePath;
		const char* menuLabel;
		const CrateLoot* loot;
		int lootCount;
	};

	const CrateLoot LOOT_RARE[] = {
		{"attachment_armor", 1},
		{"attachment_clothing", 1},
		{"jedi_holocron_light", 1}
	};

	const CrateLoot LOOT_EXCEPTIONAL[] = {
		{"attachment_armor", 2},
		{"attachment_clothing", 2},
		{"jedi_holocron_dark", 1},
		{"ls_gen5_group", 1}
	};

	const CrateLoot LOOT_LEGENDARY[] = {
		{"attachment_armor", 3},
		{"attachment_clothing", 3},
		{"krayt_dragon_pearl_premium", 1},
		{"force_crystal_mauls_vengence", 1},
		{"ls_gen5_group", 1},
		{"rare_artifact", 1}
	};

	const CrateTier TIERS[] = {
		{"object/tangible/item/rare_loot_chest_1.iff", "Open Rare Loot Crate", LOOT_RARE, 3},
		{"object/tangible/item/rare_loot_chest_2.iff", "Open Rare Loot Crate Exceptional", LOOT_EXCEPTIONAL, 4},
		{"object/tangible/item/rare_loot_chest_3.iff", "Open Rare Loot Crate Legendary", LOOT_LEGENDARY, 6}
	};

	const CrateTier* tierFor(SceneObject* sceneObject) {
		uint32 crc = sceneObject->getServerObjectCRC();

		for (unsigned int i = 0; i < sizeof(TIERS) / sizeof(TIERS[0]); ++i) {
			if (String(TIERS[i].templatePath).hashCode() == crc)
				return &TIERS[i];
		}

		return nullptr;
	}

	int levelFor(const String& name) {
		if (name.beginsWith("attachment_") || name.beginsWith("krayt_dragon_pearl")
				|| name.beginsWith("force_crystal"))
			return 350;

		return 0;
	}
}

void RareLootCrateMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	if (sceneObject == nullptr || player == nullptr || menuResponse == nullptr)
		return;

	// Only the player holding the crate may open it.
	if (!sceneObject->isASubChildOf(player))
		return;

	const CrateTier* tier = tierFor(sceneObject);

	if (tier == nullptr)
		return;

	menuResponse->addRadialMenuItem(20, 3, tier->menuLabel);
}

int RareLootCrateMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	if (sceneObject == nullptr || !sceneObject->isTangibleObject())
		return 0;

	if (player == nullptr || !player->isPlayerCreature())
		return 0;

	if (selectedID != 20)
		return TangibleObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);

	if (!sceneObject->isASubChildOf(player))
		return 0;

	const CrateTier* tier = tierFor(sceneObject);

	if (tier == nullptr)
		return 0;

	ManagedReference<LootManager*> lootManager = player->getZoneServer()->getLootManager();

	if (lootManager == nullptr)
		return 0;

	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

	if (inventory == nullptr)
		return 0;

	int given = 0;
	TransactionLog trx(TrxCode::NPCLOOTCLAIM, player);

	for (int i = 0; i < tier->lootCount; ++i) {
		String rewardName(tier->loot[i].name);
		int rewardLevel = levelFor(rewardName);

		for (int n = 0; n < tier->loot[i].rolls; ++n) {
			if (lootManager->createLoot(trx, inventory, rewardName, rewardLevel) > 0) {
				++given;
			} else {
				trx.abort() << "RareLootCrate: createLoot " << rewardName << " failed";
			}
		}
	}

	if (given < 1) {
		player->sendSystemMessage("The crate resists your attempts to open it.");
		return 0;
	}

	trx.commit(true);

	player->sendSystemMessage("You open the crate and collect its contents.");
	player->playEffect("clienteffect/rare_loot.cef", "");

	sceneObject->destroyObjectFromWorld(true);
	sceneObject->destroyObjectFromDatabase(true);

	return 0;
}
