/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef ELECTRICJUDGMENTSINGLE1COMMAND_H_
#define ELECTRICJUDGMENTSINGLE1COMMAND_H_

#include "ForcePowersQueueCommand.h"

class ElectricJudgmentSingle1Command : public ForcePowersQueueCommand {
public:

	ElectricJudgmentSingle1Command(const String& name, ZoneProcessServer* server)
		: ForcePowersQueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (isWearingArmor(creature)) {
			return NOJEDIARMOR;
		}

		return doCombatAction(creature, target);
	}

};

#endif //ELECTRICJUDGMENTSINGLE1COMMAND_H_
