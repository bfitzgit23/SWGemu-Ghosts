/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef BOOSTERTOGGLECOMMAND_H_
#define BOOSTERTOGGLECOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/objects/ship/ComponentSlots.h"
#include "server/zone/objects/ship/ShipComponentFlag.h"

// Ghosts 2026-11-19: the client space command table sends boosterToggle, but the
// core only had the separate boosterOn and boosterOff commands, so the toggle
// every player actually presses had no route. This runs the same validation as
// the one-way commands and flips the booster's ACTIVE flag.
class BoosterToggleCommand : public QueueCommand {
public:
	BoosterToggleCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
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

		ManagedReference<CreatureObject*> pilot = ship->getPilot();

		if (pilot == nullptr || pilot != creature) {
			creature->sendSystemMessage("@space/space_interaction:booster_pilot_only");
			return GENERALERROR;
		}

		if (!ship->isComponentInstalled(Components::BOOSTER)) {
			creature->sendSystemMessage("@space/space_interaction:no_booster");
			return GENERALERROR;
		}

		if (!ship->isComponentFunctional(Components::BOOSTER)) {
			creature->sendSystemMessage("@space/space_interaction:booster_disabled");
			return GENERALERROR;
		}

		if (ship->isBoosterActive()) {
			Locker slock(ship, creature);

			ship->removeComponentFlag(Components::BOOSTER, ShipComponentFlag::ACTIVE, true);
			ship->restartBooster();

			return SUCCESS;
		}

		if (!ship->isReadyToBoost()) {
			creature->sendSystemMessage("@space/space_interaction:booster_not_ready");
			return GENERALERROR;
		}

		float boosterEfficiency = Math::clamp(0.1f, ship->getComponentEfficiency(Components::BOOSTER), 10.f);
		float boosterConsumption = ship->getBoosterConsumptionRate() / boosterEfficiency;

		if (ship->getBoosterEnergy() < boosterConsumption) {
			creature->sendSystemMessage("@space/space_interaction:booster_low_energy");
			return GENERALERROR;
		}

		Locker slock(ship, creature);

		ship->addComponentFlag(Components::BOOSTER, ShipComponentFlag::ACTIVE, true);

		return SUCCESS;
	}

};

#endif //BOOSTERTOGGLECOMMAND_H_
