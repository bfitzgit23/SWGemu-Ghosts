/*
 * InsertPilotIntoShipTask.h
 */

#ifndef INSERTPILOTINTOSHIPTASK_H_
#define INSERTPILOTINTOSHIPTASK_H_

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/SpaceZone.h"
#include "server/zone/objects/ship/PobShipObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "templates/params/creature/PlayerArrangement.h"

class InsertPilotIntoShipTask : public Task, public Logger {
	ManagedWeakReference<CreatureObject*> play;
	ManagedWeakReference<ShipObject*> shipObject;

	int attempt;

public:
	InsertPilotIntoShipTask(CreatureObject* creo, ShipObject* shipObj, int attemptNumber = 0) : play(creo), shipObject(shipObj), attempt(attemptNumber) {
		setLoggingName("InsertPlayerToShipTask");
	}

	void run() {
		ManagedReference<CreatureObject*> player = play.get();
		ManagedReference<ShipObject*> ship = shipObject.get();

		if (player == nullptr || ship == nullptr) {
			return;
		}

		auto zone = ship->getLocalZone();

		if (zone == nullptr) {
			return;
		}

		// Lock the ship
		Locker lock(ship);

		// Cross lock the player to be inserted as the pilot
		Locker clock(player, ship);

		info(true) << "SZDBG InsertPilot player=" << player->getDisplayedName() << " ship=" << ship->getDisplayedName() << " shipOid=" << ship->getObjectID() << " pob=" << ship->isPobShip() << " shipZone=" << (ship->getZone() != nullptr ? ship->getZone()->getZoneName() : String("null")) << " playerZone=" << (player->getZone() != nullptr ? player->getZone()->getZoneName() : String("null")) << " playerParent=" << player->getParentID() << " attempt=" << attempt;

		// Update the players group
		if (player->isGrouped()) {
			auto group = player->getGroup();

			if (group == nullptr)
				return;

			Locker glocker(group, ship);

			group->updateMemberShip(player, ship);
		}

		if (ship->isPobShip()) {
			auto pilotChair = ship->getPilotChair().get();

			// The ship interior can still be initialising right after the ship is
			// transferred into the space zone, and pilotChair is not persisted, so a
			// ship restored from the database may not have resolved it yet.
			if (pilotChair == nullptr || pilotChair->getZone() == nullptr) {
				if (attempt < 10) {
					auto retryTask = new InsertPilotIntoShipTask(player, ship, attempt + 1);
					retryTask->schedule(250);

					return;
				}

				error() << "InsertPilotIntoShipTask - " << ship->getDisplayedName() << " has no usable pilot chair after " << attempt << " attempts";

				return;
			}

			// Must send the cell permissions prior to player inserting or it will crash the client
			ship->sendContainerObjectsTo(player, true);

			// Always apply the piloting state
			player->setState(CreatureState::PILOTINGPOBSHIP);

			// set pob pilot to the same direction as the chair
			player->setDirection(*ship->getDirection());

			player->switchZone(zone->getZoneName(), 0.0f, 0.5f, 0.0f, pilotChair->getObjectID(), false, PlayerArrangement::SHIP_PILOT_POB);

			// switchZone can reset the creature state while moving the player into the chair.
			// Reapply it after the transfer so the client enters the cockpit instead of standing.
			if (player->getParentID() == pilotChair->getObjectID()) {
				player->setState(CreatureState::PILOTINGPOBSHIP);
			} else if (attempt < 10) {
				error() << "InsertPilotIntoShipTask - failed to insert " << player->getDisplayedName() << " into chair " << pilotChair->getObjectID() << " (parent " << player->getParentID() << "), retrying";

				auto retryTask = new InsertPilotIntoShipTask(player, ship, attempt + 1);
				retryTask->schedule(250);

				return;
			} else {
				error() << "InsertPilotIntoShipTask - failed to insert " << player->getDisplayedName() << " into chair " << pilotChair->getObjectID() << " (parent " << player->getParentID() << ")";

				player->clearState(CreatureState::PILOTINGPOBSHIP);
			}
		} else {
			ship->populateDroidCommands(player);

			player->setState(CreatureState::PILOTINGSHIP);

			// Set the pilots direction to the same as the ship
			player->setDirection(*ship->getDirection());

			player->switchZone(zone->getZoneName(), ship->getPositionX(), ship->getPositionZ(), ship->getPositionY(), ship->getObjectID(), false, PlayerArrangement::SHIP_PILOT);
		}

		info(true) << "SZDBG InsertPilot done playerParent=" << player->getParentID() << " containment=" << player->getContainmentType() << " zone=" << (player->getZone() != nullptr ? player->getZone()->getZoneName() : String("null")) << " rootParent=" << (player->getRootParent() != nullptr ? player->getRootParent()->getDisplayedName() : String("null"));

		ship->addPlayerOnBoard(player);
	}
};

#endif /* INSERTPILOTINTOSHIPTASK_H_ */
