/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef SPACEUTILITYCOMMAND_H_
#define SPACEUTILITYCOMMAND_H_

#include "QueueCommand.h"

// Ghosts 2026-11-19: a batch of space commands the client sends had no route in
// the core at all, so they came back as unregistered queue commands even though
// the client does the actual work for them: map and journal windows, waypoint
// autopilot, component detail, weapon group assignment and squadron formations.
// There is no server-side state to change for these, but they still have to be
// accepted while the player is flying, otherwise the client reports a failure.
class SpaceUtilityCommand : public QueueCommand {
public:
	SpaceUtilityCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		// Only meaningful while actually flying; otherwise the client is out of
		// sync and the command should fail.
		if (!creature->hasState(CreatureState::PILOTINGSHIP) && !creature->hasState(CreatureState::PILOTINGPOBSHIP))
			return INVALIDSTATE;

		SceneObject* rootParent = creature->getRootParent();

		if (rootParent == nullptr || !rootParent->isShipObject())
			return GENERALERROR;

		return SUCCESS;
	}

};

#endif //SPACEUTILITYCOMMAND_H_
