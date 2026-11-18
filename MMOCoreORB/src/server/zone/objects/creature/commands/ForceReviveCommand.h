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

	void logStep(CreatureObject* caster, const String& message) const {
		caster->info("ForceRevive [" + caster->getDisplayedName() + "]: " + message, true);
	}

	bool reviveTarget(CreatureObject* caster, CreatureObject* target, int& buffsRestored) const {
		if (target == nullptr || !target->isPlayerCreature())
			return false;

		bool wasDead = target->isDead();
		bool wasIncapacitated = target->isIncapacitated();

		if (!wasDead && !wasIncapacitated)
			return false;

		Locker locker(target, caster);

		for (int i = 0; i < 3; ++i) {
			int max = target->getMaxHAM(i);

			target->healWound(caster, i, max, false);

			int missing = max - target->getHAM(i);

			if (missing > 0)
				target->healDamage(caster, i, missing, false);
		}

		target->setShockWounds(0);
		target->clearDots();
		target->setPosture(CreaturePosture::UPRIGHT);
		target->removeFeignedDeath();

		ManagedReference<PlayerObject*> targetGhost = target->getPlayerObject();

		// A dead player is parked on the clone request window. Without clearing
		// it the client keeps showing the death screen even though the HAM
		// pools are full again (this is what GmReviveCommand does).
		if (wasDead && targetGhost != nullptr)
			targetGhost->removeSuiBoxType(SuiWindowType::CLONE_REQUEST);

		buffsRestored += GhostsReviveBuffs::restore(target);

		target->notifyObservers(ObserverEventType::CREATUREREVIVED, caster, 0);
		target->broadcastPvpStatusBitmask();

		target->sendSystemMessage("You have been restored.");

		logStep(caster, "raised " + target->getDisplayedName()
				+ (wasDead ? " (dead)" : " (incapacitated)"));

		return true;
	}

public:

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const override {
		if (creature == nullptr || !creature->isPlayerCreature())
			return GENERALERROR;

		logStep(creature, "cast; forceCost=" + String::valueOf((int) forceCost)
				+ " range=" + String::valueOf((int) range)
				+ (target == 0 ? " target=none" : " target=set"));

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (creature->isDead()) {
			logStep(creature, "rejected: caster is dead");
			return GENERALERROR;
		}

		if (isWearingArmor(creature)) {
			logStep(creature, "rejected: wearing armor");
			creature->sendSystemMessage("@jedi_spam:no_jedi_armor");
			return NOJEDIARMOR;
		}

		// Granted only by Master Force Healing, but keep the ability honest if
		// it ever reaches a character through another box.
		if (!creature->hasSkill("force_discipline_healing_master")) {
			logStep(creature, "rejected: missing force_discipline_healing_master");
			creature->sendSystemMessage("Only a master of Force healing can call the fallen back.");
			return GENERALERROR;
		}

		int comResult = doCommonJediSelfChecks(creature);

		if (comResult != SUCCESS) {
			logStep(creature, "rejected: common jedi self checks " + String::valueOf(comResult));
			return comResult;
		}

		ManagedReference<PlayerObject*> playerObject = creature->getPlayerObject();

		if (playerObject == nullptr)
			return GENERALERROR;

		if (playerObject->getForcePower() < forceCost) {
			logStep(creature, "rejected: force power " + String::valueOf(playerObject->getForcePower())
					+ " < " + String::valueOf((int) forceCost));
			creature->sendSystemMessage("@jedi_spam:no_force_power");
			return GENERALERROR;
		}

		Vector<ManagedReference<CreatureObject*> > candidates;
		candidates.add(creature);

		if (target != 0 && target != creature->getObjectID()) {
			ManagedReference<SceneObject*> targetObject = server->getZoneServer()->getObject(target);

			if (targetObject != nullptr && targetObject->isCreatureObject()) {
				CreatureObject* targetCreature = targetObject->asCreatureObject();

				if (targetCreature != nullptr && targetCreature->isPlayerCreature()) {
					if (checkDistance(creature, targetCreature, range))
						candidates.add(targetCreature);
					else
						logStep(creature, "target " + targetCreature->getDisplayedName() + " out of range");
				} else {
					logStep(creature, "target is not a player creature");
				}
			} else {
				logStep(creature, "target object not found");
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
			logStep(creature, "rejected: nobody needing revival among " + String::valueOf(candidates.size()) + " candidates");
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

		logStep(creature, "done; revived=" + String::valueOf(revived)
				+ " buffs=" + String::valueOf(buffsRestored));

		return SUCCESS;
	}

};

#endif //FORCEREVIVECOMMAND_H_
