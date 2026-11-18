/*
			Copyright <SWGEmu>
	See file COPYING for copying conditions.*/

#ifndef FORCEREVIVECOMMAND_H_
#define FORCEREVIVECOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/creature/buffs/GhostsReviveBuffStore.h"
#include "ForceHealQueueCommand.h"

/**
 * Force Revive is the master Force healing capstone: it raises the fallen
 * (target, group members in range and the caster himself if he somehow needs
 * it), refills their HAM pools and wounds, and hands back the buffs death took.
 */
class ForceReviveCommand : public ForceHealQueueCommand {
public:

	ForceReviveCommand(const String& name, ZoneProcessServer* server) : ForceHealQueueCommand(name, server) {
	}

private:

	bool reviveTarget(CreatureObject* caster, CreatureObject* target, int& buffsRestored) const {
		if (target == nullptr || !target->isPlayerCreature())
			return false;

		if (!target->isDead() && !target->isIncapacitated())
			return false;

		Locker locker(target, caster);

		for (int i = 0; i < 3; ++i) {
			int max = target->getMaxHAM(i);

			target->healWound(caster, i, max, false);

			int missing = max - target->getHAM(i);

			if (missing > 0)
				target->healDamage(caster, i, missing, false);
		}

		target->setPosture(CreaturePosture::UPRIGHT);
		target->removeFeignedDeath();

		buffsRestored += GhostsReviveBuffs::restore(target);

		return true;
	}

public:

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const override {
		if (creature == nullptr || !creature->isPlayerCreature())
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (creature->isDead())
			return GENERALERROR;

		if (isWearingArmor(creature)) {
			creature->sendSystemMessage("@jedi_spam:no_jedi_armor");
			return NOJEDIARMOR;
		}

		// Granted only by Master Force Healing, but keep the ability honest if
		// it ever reaches a character through another box.
		if (!creature->hasSkill("force_discipline_healing_master")) {
			creature->sendSystemMessage("Only a master of Force healing can call the fallen back.");
			return GENERALERROR;
		}

		int comResult = doCommonJediSelfChecks(creature);

		if (comResult != SUCCESS)
			return comResult;

		ManagedReference<PlayerObject*> playerObject = creature->getPlayerObject();

		if (playerObject == nullptr)
			return GENERALERROR;

		if (playerObject->getForcePower() < forceCost) {
			creature->sendSystemMessage("@jedi_spam:no_force_power");
			return GENERALERROR;
		}

		Vector<ManagedReference<CreatureObject*> > candidates;
		candidates.add(creature);

		if (target != 0 && target != creature->getObjectID()) {
			ManagedReference<SceneObject*> targetObject = server->getZoneServer()->getObject(target);

			if (targetObject != nullptr && targetObject->isCreatureObject()) {
				CreatureObject* targetCreature = targetObject->asCreatureObject();

				if (targetCreature != nullptr && targetCreature->isPlayerCreature()
						&& checkDistance(creature, targetCreature, range))
					candidates.add(targetCreature);
			}
		}

		ManagedReference<GroupObject*> group = creature->getGroup();

		if (group != nullptr) {
			for (int i = 0; i < group->getGroupSize(); ++i) {
				ManagedReference<CreatureObject*> member = group->getGroupMember(i);

				if (member == nullptr || !member->isPlayerCreature())
					continue;

				if (member->getObjectID() == creature->getObjectID())
					continue;

				bool alreadyListed = false;

				for (int j = 0; j < candidates.size() && !alreadyListed; ++j) {
					ManagedReference<CreatureObject*> known = candidates.get(j);

					if (known != nullptr && known->getObjectID() == member->getObjectID())
						alreadyListed = true;
				}

				if (alreadyListed)
					continue;

				if (range > 0 && !checkDistance(creature, member, range))
					continue;

				candidates.add(member);
			}
		}

		int revived = 0;
		int buffsRestored = 0;

		for (int i = 0; i < candidates.size(); ++i) {
			ManagedReference<CreatureObject*> candidate = candidates.get(i);

			if (candidate == nullptr)
				continue;

			if (reviveTarget(creature, candidate, buffsRestored))
				++revived;
		}

		if (revived == 0) {
			creature->sendSystemMessage("There is nobody within reach of the Force who needs reviving.");
			return GENERALERROR;
		}

		int forcePower = playerObject->getForcePower();

		if (forcePower <= forceCost)
			playerObject->setForcePower(0);
		else
			playerObject->setForcePower(forcePower - forceCost);

		if (!clientEffect.isEmpty())
			creature->playEffect(clientEffect, "");

		VisibilityManager::instance()->increaseVisibility(creature, visMod);

		creature->sendSystemMessage("The Force answers you: " + String::valueOf(revived)
				+ (revived == 1 ? " ally returns" : " allies return") + " to the living"
				+ (buffsRestored > 0 ? ", their blessings restored." : "."));

		return SUCCESS;
	}

};

#endif //FORCEREVIVECOMMAND_H_
