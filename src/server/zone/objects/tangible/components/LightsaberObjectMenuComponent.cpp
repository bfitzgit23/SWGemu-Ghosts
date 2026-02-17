/*
 * LightsaberObjectMenuComponent.cpp
 *
 *  Created on: 3/11/2012
 *      Author: kyle
 */

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "LightsaberObjectMenuComponent.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/sessions/SlicingSession.h"


void LightsaberObjectMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {

	if (!sceneObject->isTangibleObject())
		return;

	ManagedReference<WeaponObject*> weapon = cast<WeaponObject*>(sceneObject);

	if(weapon == nullptr)
		return;

//	if(weapon->isASubChildOf(player)) {
//
//		if(weapon->hasPowerup()) {
//			menuResponse->addRadialMenuItem(71, 3, "@powerup:mnu_remove_powerup"); // Remove Powerup
//		}
//
//		if(weapon->getConditionDamage() > 0 && weapon->canRepair(player)) {
//			menuResponse->addRadialMenuItem(70, 3, "@sui:repair"); // Slice
//		}
//	}

	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	String text = "@jedi_spam:open_saber";
	menuResponse->addRadialMenuItem(89, 3, text);

	if(player->hasSkill("combat_smuggler_slicing_02"))
		menuResponse->addRadialMenuItem(69, 3, "@slicing/slicing:slice"); // this makes it work forpre patch sabers


}

int LightsaberObjectMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {

	if (!sceneObject->isTangibleObject())
		return 0;

	Reference<PlayerObject*> playObject = player->getPlayerObject();

	// Admins should be able to open.
	if (!sceneObject->isASubChildOf(player) && !playObject->isPrivileged())
		return 0;

	ManagedReference<WeaponObject*> weapon = cast<WeaponObject*>(sceneObject);

	if (weapon == nullptr)
		return 1;

	// Handle opening sabers
	if (selectedID == 89) {

		ManagedReference<SceneObject*> parent = weapon->getParent().get();
		if (parent != nullptr && parent->isPlayerCreature()){
			player->sendSystemMessage("@jedi_spam:saber_not_while_equpped");
			return 0;
		}

		weapon->sendContainerTo(player);
	}

	if (selectedID == 69 && player->hasSkill("combat_smuggler_slicing_02")) {

		player->sendSystemMessage("saber slicing is currently disabled for testing");
		return 0;

		if (weapon->isSliced()) {
			player->sendSystemMessage("@slicing/slicing:already_sliced");
			return 0;
		}

//		if (sceneObject->getContainerObjectsSize() > 0){
//			player->sendSystemMessage("the lightsaber must be empty to slice");
//			return 0;
//		}

		ManagedReference<Facade*> facade = player->getActiveSession(SessionFacadeType::SLICING);
		ManagedReference<SlicingSession*> session = dynamic_cast<SlicingSession*>(facade.get());

		if (session != nullptr) {
			player->sendSystemMessage("@slicing/slicing:already_slicing");
			return 0;
		}

		//Create Session
		session = new SlicingSession(player);
		session->initalizeSlicingMenu(player, weapon);

		return 0;

	}


//	if(weapon->isASubChildOf(player)) {
//
//		if (selectedID == 69 && player->hasSkill("combat_smuggler_slicing_02")) {
//			if (weapon->isSliced()) {
//				player->sendSystemMessage("@slicing/slicing:already_sliced");
//				return 0;
//			}
//
//			ManagedReference<Facade*> facade = player->getActiveSession(SessionFacadeType::SLICING);
//			ManagedReference<SlicingSession*> session = dynamic_cast<SlicingSession*>(facade.get());
//
//			if (session != nullptr) {
//				player->sendSystemMessage("@slicing/slicing:already_slicing");
//				return 0;
//			}
//
//			//Create Session
//			session = new SlicingSession(player);
//			session->initalizeSlicingMenu(player, weapon);
//
//			return 0;
//
//		}
//
//		if(selectedID == 70) {
//
//			weapon->repair(player);
//			return 1;
//		}
//
//		if(selectedID == 71) {
//
//			ManagedReference<PowerupObject*> pup = weapon->removePowerup();
//			if(pup == nullptr)
//				return 1;
//
//			Locker locker(pup);
//
//			pup->destroyObjectFromWorld( true );
//			pup->destroyObjectFromDatabase( true );
//
//			StringIdChatParameter message("powerup", "prose_remove_powerup"); //You detach your powerup from %TT.
//			message.setTT(weapon->getDisplayedName());
//			player->sendSystemMessage(message);
//
//			return 1;
//		}
//	}

	return TangibleObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);
}
