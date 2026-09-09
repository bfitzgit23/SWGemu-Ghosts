/*
 * TangibleObjectMenuComponent.cpp
 *
 *  Created on: 26/05/2011
 *      Author: victor
 */

#include "TangibleObjectMenuComponent.h"
#include "server/zone/objects/player/sessions/SlicingSession.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sui/colorbox/SuiColorBox.h"
#include "server/zone/objects/player/sui/inputbox/SuiInputBox.h"
#include "server/zone/objects/player/sui/callbacks/ColorArmorSuiCallback.h"
#include "server/zone/objects/player/sui/callbacks/RenameItemSuiCallback.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/managers/components/ComponentManager.h"
#include "templates/customization/AssetCustomizationManagerTemplate.h"

void TangibleObjectMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	ObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

	uint32 gameObjectType = sceneObject->getGameObjectType();

	if (!sceneObject->isTangibleObject())
		return;

	TangibleObject* tano = cast<TangibleObject*>( sceneObject);

	// Figure out what the object is and if its able to be Sliced.
	if(tano->isSliceable() && !tano->isSecurityTerminal()) { // Check to see if the player has the correct skill level

		bool hasSkill = true;
		ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

		if ((gameObjectType == SceneObjectType::PLAYERLOOTCRATE) && !player->hasSkill("combat_smuggler_novice"))
			hasSkill = false;
		else if (sceneObject->isContainerObject())
			hasSkill = false; // Let the container handle our slice menu
		else if (sceneObject->isMissionTerminal() && !player->hasSkill("combat_smuggler_slicing_01"))
			hasSkill = false;
		else if (sceneObject->isWeaponObject() && (!inventory->hasObjectInContainer(sceneObject->getObjectID()) || !player->hasSkill("combat_smuggler_slicing_02")))
			hasSkill = false;
		else if (sceneObject->isArmorObject() && (!inventory->hasObjectInContainer(sceneObject->getObjectID()) || !player->hasSkill("combat_smuggler_slicing_03")))
			hasSkill = false;

		if(hasSkill)
			menuResponse->addRadialMenuItem(69, 3, "@slicing/slicing:slice"); // Slice
	}

	if (player->getPlayerObject() != nullptr && player->getPlayerObject()->isPrivileged()) {
		/// Viewing components used to craft item, for admins
		ManagedReference<SceneObject*> container = tano->getSlottedObject("crafted_components");

		if (container != nullptr && container->getContainerObjectsSize() > 0) {
			SceneObject* satchel = container->getContainerObject(0);

			if (satchel != nullptr && satchel->getContainerObjectsSize() > 0) {
				menuResponse->addRadialMenuItem(79, 3, "@ui_radial:ship_manage_components"); // View Components
			}
		}
	}

	ManagedReference<SceneObject*> parent = tano->getParent().get();
	if (parent != nullptr && parent->getGameObjectType() == SceneObjectType::STATICLOOTCONTAINER) {
		menuResponse->addRadialMenuItem(10, 3, "@ui_radial:item_pickup"); //Pick up
	}

	// Ghosts: color change for every wearable with a palette (crafted or not)
	if (tano->isWearableObject() && sceneObject->getObjectMenuComponent() != ComponentManager::instance()->getComponent<ObjectMenuComponent*>("GogglesObjectMenuComponent")) {
		String appearanceFilename = sceneObject->getObjectTemplate()->getAppearanceFilename();

		if (!appearanceFilename.isEmpty()) {
			bool canColor = sceneObject->isASubChildOf(player);

			if (!canColor) {
				ManagedReference<SceneObject*> par = sceneObject->getParent().get();
				if (par != nullptr && par->isCellObject()) {
					ManagedReference<SceneObject*> obj = par->getParent().get();
					if (obj != nullptr && obj->isBuildingObject()) {
						ManagedReference<BuildingObject*> buio = cast<BuildingObject*>(obj.get());
						if (buio != nullptr && buio->isOnAdminList(player))
							canColor = true;
					}
				}
			}

			if (canColor)
				menuResponse->addRadialMenuItem(81, 3, "Color Change");
		}
	}

	// Ghosts: rename any item (owner, building admin, or privileged admin)
	{
		bool canRename = (player->getPlayerObject() != nullptr && player->getPlayerObject()->isPrivileged())
			|| sceneObject->isASubChildOf(player);

		if (!canRename) {
			ManagedReference<SceneObject*> par = sceneObject->getParent().get();
			if (par != nullptr && par->isCellObject()) {
				ManagedReference<SceneObject*> obj = par->getParent().get();
				if (obj != nullptr && obj->isBuildingObject()) {
					ManagedReference<BuildingObject*> buio = cast<BuildingObject*>(obj.get());
					if (buio != nullptr && buio->isOnAdminList(player))
						canRename = true;
				}
			}
		}

		if (canRename)
			menuResponse->addRadialMenuItem(80, 3, "Rename Item");
	}
}

int TangibleObjectMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	if (!sceneObject->isTangibleObject())
		return 0;

	TangibleObject* tano = cast<TangibleObject*>( sceneObject);


	if (selectedID == 69 && player->hasSkill("combat_smuggler_novice") ) { // Slice [PlayerLootCrate]
		if (player->containsActiveSession(SessionFacadeType::SLICING)) {
			player->sendSystemMessage("@slicing/slicing:already_slicing");
			return 0;
		}

		//Create Session
		ManagedReference<SlicingSession*> session = new SlicingSession(player);
		session->initalizeSlicingMenu(player, tano);

		return 0;
	} else if (selectedID == 79) { // See components (admin)
		if(player->getPlayerObject() != nullptr && player->getPlayerObject()->isPrivileged()) {

			SceneObject* container = tano->getSlottedObject("crafted_components");
			if(container != nullptr) {

				if(container->getContainerObjectsSize() > 0) {

					SceneObject* satchel = container->getContainerObject(0);

					if(satchel != nullptr) {

						satchel->sendWithoutContainerObjectsTo(player);
						satchel->openContainerTo(player);

					} else {
						player->sendSystemMessage("There is no satchel this container");
					}
				} else {
					player->sendSystemMessage("There are no items in this container");
				}
			} else {
				player->sendSystemMessage("There is no component container in this object");
			}
		}

		return 0;
	} else if (selectedID == 81) { // Ghosts: color change
		if (!tano->isWearableObject() || sceneObject->getObjectMenuComponent() == ComponentManager::instance()->getComponent<ObjectMenuComponent*>("GogglesObjectMenuComponent"))
			return 0;

		ManagedReference<SceneObject*> parent = sceneObject->getParent().get();
		if (parent != nullptr && parent->isPlayerCreature()) {
			player->sendSystemMessage("@armor_rehue:equipped");
			return 0;
		}

		ZoneServer* server = player->getZoneServer();
		if (server == nullptr)
			return 0;

		String appearanceFilename = sceneObject->getObjectTemplate()->getAppearanceFilename();
		if (appearanceFilename.isEmpty()) {
			player->sendSystemMessage("This item cannot be recolored.");
			return 0;
		}

		VectorMap<String, Reference<CustomizationVariable*> > variables;
		AssetCustomizationManagerTemplate::instance()->getCustomizationVariables(appearanceFilename.hashCode(), variables, false);

		if (variables.isEmpty()) {
			player->sendSystemMessage("This item cannot be recolored.");
			return 0;
		}

		int paletteIndex = (variables.size() > 1) ? 1 : 0;

		ManagedReference<SuiColorBox*> cbox = new SuiColorBox(player, SuiWindowType::COLOR_ARMOR);
		cbox->setCallback(new ColorArmorSuiCallback(server));
		cbox->setColorPalette(variables.elementAt(paletteIndex).getKey());
		cbox->setUsingObject(sceneObject);
		cbox->setSkillMod(255);

		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		if (ghost != nullptr) {
			ghost->addSuiBox(cbox);
			player->sendMessage(cbox->generateMessage());
		}

		return 0;
	} else if (selectedID == 80) { // Ghosts: rename item
		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		if (ghost == nullptr)
			return 0;

		bool canRename = ghost->isPrivileged() || sceneObject->isASubChildOf(player);

		if (!canRename) {
			ManagedReference<SceneObject*> par = sceneObject->getParent().get();
			if (par != nullptr && par->isCellObject()) {
				ManagedReference<SceneObject*> obj = par->getParent().get();
				if (obj != nullptr && obj->isBuildingObject()) {
					ManagedReference<BuildingObject*> buio = cast<BuildingObject*>(obj.get());
					if (buio != nullptr && buio->isOnAdminList(player))
						canRename = true;
				}
			}
		}

		if (!canRename)
			return 0;

		ManagedReference<SuiInputBox*> inputBox = new SuiInputBox(player, 1045 /* Ghosts: RENAME_ITEM */);
		inputBox->setCallback(new RenameItemSuiCallback(player->getZoneServer()));
		inputBox->setUsingObject(sceneObject);
		inputBox->setPromptTitle("Rename Item");
		inputBox->setPromptText("Enter the new name for this item.");
		inputBox->setCancelButton(true, "@cancel");
		inputBox->setMaxInputSize(60);

		ghost->addSuiBox(inputBox);
		player->sendMessage(inputBox->generateMessage());

		return 0;
	}else
		return ObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);

}

