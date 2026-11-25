/*
 * HolocronMenuComponent.cpp
 *
 *  Created on: 01/23/2012
 *      Author: xyborn
 */

#include "HolocronMenuComponent.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/managers/jedi/JediManager.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"

void HolocronMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	if (sceneObject == nullptr || menuResponse == nullptr || player == nullptr)
		return;

	// Ghosts: the client's own "Use" entry is cosmetic and never reaches the server
	// for a holocron, so the component has to offer the option itself.  Recharge
	// Force is the explicit way to trade a holocron for a full Force bar.
	menuResponse->addRadialMenuItem(20, 3, "@ui_radial:item_activate");
	menuResponse->addRadialMenuItem(21, 3, "Recharge Force");
}

int HolocronMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* creature, byte selectedID) const {
	if (selectedID != 20 && selectedID != 21)
		return 0;

	if (!sceneObject->isASubChildOf(creature))
		return 0;

	if (selectedID == 21) {
		JediManager::instance()->useItem(sceneObject, JediManager::ITEMHOLOCRONREFILL, creature);
		return 0;
	}

	JediManager::instance()->useItem(sceneObject, JediManager::ITEMHOLOCRON, creature);

	return 0;
}

