/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef RESETJEDICOMMAND_H_
#define RESETJEDICOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"

class ResetJediCommand : public QueueCommand {
public:

	ResetJediCommand(const String& name, ZoneProcessServer* server)
		: QueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		ManagedReference<SceneObject*> object = server->getZoneServer()->getObject(target);

		if (object == nullptr || !object->isCreatureObject())
			return INVALIDTARGET;

		CreatureObject* targetCreature = cast<CreatureObject*>( object.get());

		Locker clocker(targetCreature, creature);

		const SkillList* skillList = targetCreature->getSkillList();
		Vector<String> forceSkills;
		bool hadForceProgression = false;

		for (int i = 0; i < skillList->size(); ++i) {
			Skill* skill = skillList->get(i);
			String skillName = skill->getSkillName();

			if (skillName.indexOf("force_") != -1) {
				hadForceProgression = true;
				forceSkills.add(skillName);
			}
		}

		for (int i = 0; i < forceSkills.size(); ++i) {
			SkillManager::instance()->surrenderSkill(forceSkills.get(i), targetCreature, true);
		}

		ManagedReference<PlayerObject*> targetGhost = targetCreature->getPlayerObject();

		if (targetGhost == nullptr)
			return GENERALERROR;

		if (hadForceProgression) {
			// Jedi titles require state 1; set Padawan state before granting.
			targetGhost->setJediState(2);

			const bool rank02Awarded = SkillManager::instance()->awardSkill(
					"force_title_jedi_rank_02", targetCreature, true, true, true);

			if (!rank02Awarded)
				targetGhost->setJediState(0);
		} else {
			targetGhost->setJediState(0);
		}

		return SUCCESS;
	}

};

#endif //RESETJEDICOMMAND_H_
