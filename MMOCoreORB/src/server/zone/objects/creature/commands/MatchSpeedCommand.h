/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MATCHSPEEDCOMMAND_H_
#define MATCHSPEEDCOMMAND_H_

#include "QueueCommand.h"

// Ghosts 2026-11-19: matchSpeed is in the client space command table with no
// route in the core. It copies the current speed of the ship you have targeted,
// clamped to your own engine.
class MatchSpeedCommand : public QueueCommand {
public:
	MatchSpeedCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->isPilotingShip())
			return INVALIDSTATE;

		SceneObject* rootParent = creature->getRootParent();

		if (rootParent == nullptr || !rootParent->isShipObject())
			return GENERALERROR;

		ManagedReference<ShipObject*> ship = rootParent->asShipObject();

		if (ship == nullptr || ship->isShipDisabled() || ship->isShipDocking())
			return GENERALERROR;

		Zone* zone = creature->getZone();

		if (zone == nullptr)
			return GENERALERROR;

		ManagedReference<SceneObject*> object = zone->getZoneServer()->getObject(target);

		if (object == nullptr || !object->isShipObject())
			return INVALIDTARGET;

		ManagedReference<ShipObject*> targetShip = object->asShipObject();

		if (targetShip == nullptr || targetShip == ship)
			return INVALIDTARGET;

		float maxSpeed = Math::max(0.f, ship->getEngineMaxSpeed());
		float matchSpeed = Math::clamp(0.f, targetShip->getCurrentSpeed(), maxSpeed);

		Locker slock(ship);

		ship->setCurrentSpeed(matchSpeed);

		return SUCCESS;
	}

};

#endif //MATCHSPEEDCOMMAND_H_
