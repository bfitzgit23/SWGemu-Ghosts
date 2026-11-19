/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef KICKFROMSHIPCOMMAND_H_
#define KICKFROMSHIPCOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/objects/ship/PobShipObject.h"

// Ghosts 2026-11-19: the pilot command list has kickFromShip but the core never
// registered it, and PobShipObject could only eject everyone at once. The pilot
// can now put one passenger off their ship, which sends that player back to the
// ship's launch point the same way a full unboarding does.
class KickFromShipCommand : public QueueCommand {
public:
	KickFromShipCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->hasState(CreatureState::PILOTINGPOBSHIP))
			return INVALIDSTATE;

		SceneObject* rootParent = creature->getRootParent();

		if (rootParent == nullptr)
			return GENERALERROR;

		ManagedReference<PobShipObject*> pob = cast<PobShipObject*>(rootParent);

		if (pob == nullptr || !pob->isPobShip())
			return GENERALERROR;

		Zone* zone = creature->getZone();

		if (zone == nullptr)
			return GENERALERROR;

		ManagedReference<SceneObject*> object = zone->getZoneServer()->getObject(target);

		if (object == nullptr)
			return INVALIDTARGET;

		ManagedReference<CreatureObject*> passenger = cast<CreatureObject*>(object.get());

		if (passenger == nullptr || !passenger->isPlayerCreature() || passenger == creature)
			return INVALIDTARGET;

		if (!pob->removePlayerFromShip(passenger)) {
			creature->sendSystemMessage("That player is not a passenger on your ship.");

			return GENERALERROR;
		}

		return SUCCESS;
	}

};

#endif //KICKFROMSHIPCOMMAND_H_
