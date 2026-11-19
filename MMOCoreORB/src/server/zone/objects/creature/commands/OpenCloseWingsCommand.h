/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef OPENCLOSEWINGSCOMMAND_H_
#define OPENCLOSEWINGSCOMMAND_H_

#include "QueueCommand.h"

// Ghosts 2026-11-19: the client sends openCloseWings as a single toggle, while
// the core only had the one-way openWings/closeWings pair, so the toggle was
// rejected as an unregistered command. This flips the ship's wings state.
class OpenCloseWingsCommand : public QueueCommand {
public:
	OpenCloseWingsCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->hasState(CreatureState::PILOTINGSHIP) && !creature->hasState(CreatureState::PILOTINGPOBSHIP))
			return INVALIDSTATE;

		SceneObject* rootParent = creature->getRootParent();

		if (rootParent == nullptr || !rootParent->isShipObject())
			return GENERALERROR;

		ManagedReference<ShipObject*> ship = rootParent->asShipObject();

		if (ship == nullptr)
			return GENERALERROR;

		Locker lock(ship);

		if (ship->getOptionsBitmask() & OptionBitmask::WINGS_OPEN)
			ship->clearOptionBit(OptionBitmask::WINGS_OPEN);
		else
			ship->setOptionsBitmask(OptionBitmask::WINGS_OPEN);

		return SUCCESS;
	}

};

#endif //OPENCLOSEWINGSCOMMAND_H_
