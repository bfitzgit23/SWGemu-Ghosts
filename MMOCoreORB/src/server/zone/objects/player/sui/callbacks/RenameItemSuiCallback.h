/*
 * RenameItemSuiCallback.h
 *
 *  Ghosts: rename any tangible item via radial menu.
 */

#ifndef RENAMEITEMSUICALLBACK_H_
#define RENAMEITEMSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"

class RenameItemSuiCallback : public SuiCallback {
public:
	RenameItemSuiCallback(ZoneServer* server) : SuiCallback(server) {
	}

	void run(CreatureObject* player, SuiBox* suiBox, uint32 eventIndex, Vector<UnicodeString>* args) {
		bool cancelPressed = (eventIndex == 1);

		if (!suiBox->isInputBox() || cancelPressed || args->size() < 1)
			return;

		ManagedReference<SceneObject*> obj = suiBox->getUsingObject().get();

		if (obj == nullptr || !obj->isTangibleObject())
			return;

		String name = args->get(0).toString();
		name = name.replaceAll("\n", " ").replaceAll("\r", " ");

		if (name.isEmpty()) {
			player->sendSystemMessage("You must enter a name for the item.");
			return;
		}

		if (name.length() > 60)
			name = name.subString(0, 60);

		Locker locker(obj, player);

		obj->setCustomObjectName(name, true);

		player->sendSystemMessage("Item renamed to: " + name);
	}
};

#endif /* RENAMEITEMSUICALLBACK_H_ */
