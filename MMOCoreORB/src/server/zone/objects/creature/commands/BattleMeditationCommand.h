/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef BATTLEMEDITATIONCOMMAND_H_
#define BATTLEMEDITATIONCOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/creature/buffs/Buff.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/managers/visibility/VisibilityManager.h"
#include "ForceHealQueueCommand.h"

/**
 * Battle Meditation reaches the whole group: every member in range is healed
 * (wounds, HAM pools and battle fatigue, as configured in battleMeditation.lua)
 * and then receives the meditation buff.
 */
class BattleMeditationCommand : public ForceHealQueueCommand {
public:

	BattleMeditationCommand(const String& name, ZoneProcessServer* server) : ForceHealQueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const override {
		if (creature == nullptr || !creature->isPlayerCreature())
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (creature->isIncapacitated() || creature->isDead())
			return GENERALERROR;

		if (isWearingArmor(creature)) {
			creature->sendSystemMessage("@jedi_spam:no_jedi_armor");
			return NOJEDIARMOR;
		}

		int comResult = doCommonJediSelfChecks(creature);

		if (comResult != SUCCESS)
			return comResult;

		ManagedReference<PlayerObject*> playerObject = creature->getPlayerObject();

		if (playerObject == nullptr)
			return GENERALERROR;

		ManagedReference<GroupObject*> group = creature->getGroup();

		if (group == nullptr) {
			creature->sendSystemMessage("You are not in a group, so there is nobody to lead into battle meditation.");
			return GENERALERROR;
		}

		int meditators = 0;

		for (int i = 0; i < group->getGroupSize(); ++i) {
			ManagedReference<CreatureObject*> member = group->getGroupMember(i);

			if (member == nullptr || !member->isPlayerCreature() || member->isIncapacitated() || member->isDead())
				continue;

			if (range > 0 && !checkDistance(creature, member, range))
				continue;

			Locker crossLocker(member, creature);

			runCommand(creature, member);

			if (buffCRC != 0 && duration > 0) {
				ManagedReference<Buff*> buff = createJediSelfBuff(member);

				if (buff != nullptr) {
					Locker buffLocker(buff);
					member->addBuff(buff);
				}
			}

			checkForTef(creature, member);

			meditators++;
		}

		if (meditators == 0)
			return GENERALERROR;

		// The healing itself is charged per point by runCommand; charge the
		// base cost once for entering the meditation.
		int forcePower = playerObject->getForcePower();

		if (forcePower <= forceCost)
			playerObject->setForcePower(0);
		else
			playerObject->setForcePower(forcePower - forceCost);

		if (!clientEffect.isEmpty())
			creature->playEffect(clientEffect, "");

		VisibilityManager::instance()->increaseVisibility(creature, visMod);

		creature->sendSystemMessage("Your battle meditation reaches " + String::valueOf(meditators)
				+ (meditators == 1 ? " ally." : " allies."));

		return SUCCESS;
	}

};

#endif //BATTLEMEDITATIONCOMMAND_H_
