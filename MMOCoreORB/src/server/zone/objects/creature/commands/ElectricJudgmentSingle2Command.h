/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef ELECTRICJUDGMENTSINGLE2COMMAND_H_
#define ELECTRICJUDGMENTSINGLE2COMMAND_H_

#include "ForcePowersQueueCommand.h"

class ElectricJudgmentSingle2Command : public ForcePowersQueueCommand {
public:

	ElectricJudgmentSingle2Command(const String& name, ZoneProcessServer* server)
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

#endif //ELECTRICJUDGMENTSINGLE2COMMAND_H_
