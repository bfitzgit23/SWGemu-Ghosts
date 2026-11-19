/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef THROTTLECOMMAND_H_
#define THROTTLECOMMAND_H_

#include "QueueCommand.h"

// Ghosts 2026-11-19: throttle is in the client space command table but the core
// had no route for it. The client also just states the throttle it applied, so
// the server records it as the ship's current speed, which the transform sync
// pushes back out and the turn-rate calculation reads.
class ThrottleCommand : public QueueCommand {
public:
	ThrottleCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
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

		if (ship == nullptr)
			return GENERALERROR;

		if (ship->isShipDisabled() || ship->isShipDocking())
			return GENERALERROR;

		String args = arguments.toString();
		args = args.trim();

		if (args.isEmpty())
			return INVALIDPARAMETERS;

		float throttle = 0.f;

		try {
			throttle = Float::valueOf(args);
		} catch (Exception& e) {
			return INVALIDPARAMETERS;
		}

		// The client sends either a 0..1 fraction or a 0..100 percentage.
		if (throttle > 1.f)
			throttle /= 100.f;

		throttle = Math::clamp(0.f, throttle, 1.f);

		float maxSpeed = Math::max(0.f, ship->getEngineMaxSpeed());

		Locker slock(ship);

		ship->setCurrentSpeed(maxSpeed * throttle);

		return SUCCESS;
	}

};

#endif //THROTTLECOMMAND_H_
