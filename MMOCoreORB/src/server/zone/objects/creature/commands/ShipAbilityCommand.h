/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef SHIPABILITYCOMMAND_H_
#define SHIPABILITYCOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/objects/ship/ComponentSlots.h"
#include "server/zone/objects/ship/ShipComponentFlag.h"

// Ghosts 2026-11-19: the pilot profession abilities jstart1-3, epulse1-3 and
// bstrike1-3 were never registered, so issuing them came back as an unknown
// command. Jump Start maps onto real ship state and is implemented here: it
// clears the DISABLED flag on the ship's systems and refills the capacitor,
// scaled by tier. Energy Pulse and Bomber Strike need capital ship ordnance,
// which this core has no model for, so they validate the pilot and ship and
// tell the player the ability is not available rather than silently doing
// nothing or firing a normal weapon shot.
class ShipAbilityCommand : public QueueCommand {
public:
	ShipAbilityCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
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

		if (ship == nullptr || ship->isShipDestroyed())
			return GENERALERROR;

		String command = getName().toLowerCase();

		int tier = 1;

		if (!command.isEmpty()) {
			char last = command.charAt(command.length() - 1);

			if (last >= '1' && last <= '3')
				tier = last - '0';
		}

		if (!command.beginsWith("jstart")) {
			creature->sendSystemMessage("That pilot ability is not available on this server yet.");

			return GENERALERROR;
		}

		Locker slock(ship, creature);

		float maxEnergy = ship->getCapacitorMaxEnergy();

		if (maxEnergy > 0.f) {
			float restore = maxEnergy * (0.25f * tier);
			float newEnergy = Math::min(maxEnergy, ship->getCapacitorEnergy() + restore);

			ship->setCapacitorEnergy(newEnergy);
		}

		for (int slot = Components::REACTOR; slot <= Components::BOOSTER; ++slot) {
			if (!ship->hasComponentFlag(slot, ShipComponentFlag::DISABLED))
				continue;

			ship->removeComponentFlag(slot, ShipComponentFlag::DISABLED, true);

			if (ship->hasComponentFlag(slot, ShipComponentFlag::DEMOLISHED))
				ship->removeComponentFlag(slot, ShipComponentFlag::DEMOLISHED, true);
		}

		return SUCCESS;
	}

};

#endif //SHIPABILITYCOMMAND_H_
