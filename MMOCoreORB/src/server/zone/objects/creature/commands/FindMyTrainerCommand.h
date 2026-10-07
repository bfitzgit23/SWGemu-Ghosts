/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef FINDMYTRAINERCOMMAND_H_
#define FINDMYTRAINERCOMMAND_H_

class FindMyTrainerCommand : public QueueCommand {
public:
	FindMyTrainerCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->isPlayerCreature())
			return GENERALERROR;

		auto ghost = creature->getPlayerObject();

		if (ghost == nullptr)
			return GENERALERROR;

		if (ghost->getJediState() < 2 || !creature->hasSkill("force_title_jedi_rank_02"))
			return GENERALERROR;

		auto zoneServer = server->getZoneServer();

		if (zoneServer == nullptr)
			return GENERALERROR;

		// Ghosts: the jedi trainer assignment is always a real jedi trainer
		// NPC (the nearest one in the player's current zone). If the stored
		// assignment is empty, stale, or points at a non-jedi trainer from
		// an older build, pick a fresh jedi trainer now.
		ManagedReference<SceneObject*> trainer = findStoredJediTrainer(zoneServer, ghost);

		if (trainer == nullptr) {
			trainer = pickJediTrainer(zoneServer, creature);

			if (trainer != nullptr)
				assignTrainer(ghost, trainer);
		}

		if (trainer == nullptr)
			return GENERALERROR;

		uint32 planetCRC = ghost->getTrainerZoneName().hashCode();

		Vector3 coords = ghost->getJediTrainerCoordinates();

		String name = "@jedi_spam:trainer_waypoint_name";

		ManagedReference<WaypointObject*> waypointObj = (zoneServer->createObject(0xc456e788, 1)).castTo<WaypointObject*>();

		Locker locker(waypointObj);

		waypointObj->setPlanetCRC(planetCRC);
		waypointObj->setPosition(coords.getX(), 0, coords.getY());
		waypointObj->setCustomObjectName(name, false);

		ghost->addWaypoint(waypointObj, true, true);

		creature->sendSystemMessage("@jedi_spam:waypoint_created_to_trainer");

		return SUCCESS;
	}

	// Returns the stored trainer NPC if it still exists and is a jedi
	// trainer. Matches by zone name + world x/y, the same identity the
	// conversation handler compares through PlayerObject::isJediTrainer.
	SceneObject* findStoredJediTrainer(ZoneServer* zoneServer, PlayerObject* ghost) const {
		if (ghost == nullptr || zoneServer == nullptr)
			return nullptr;

		String zoneName = ghost->getTrainerZoneName();

		if (zoneName.isEmpty())
			return nullptr;

		Zone* zone = zoneServer->getZone(zoneName);

		if (zone == nullptr)
			return nullptr;

		Vector3 coords = ghost->getJediTrainerCoordinates();

		SortedVector<ManagedReference<SceneObject*>> objectList = zone->getPlanetaryObjectList("trainer");

		for (int i = 0; i < objectList.size(); ++i) {
			ManagedReference<SceneObject*> trainer = objectList.get(i);

			if (trainer == nullptr)
				continue;

			if (trainer->getPlanetMapSubCategoryCRC() != STRING_HASHCODE("trainer_jedi"))
				continue;

			CreatureObject* trainerCreo = trainer->asCreatureObject();

			if (trainerCreo == nullptr)
				continue;

			Vector3 pos = trainerCreo->getWorldPosition();

			if (pos.getX() == coords.getX() && pos.getY() == coords.getY())
				return trainer;
		}

		return nullptr;
	}

	// Picks a jedi trainer NPC: the closest one in the player's current
	// zone, falling back to any jedi trainer in the galaxy (e.g. when the
	// player is on a wilderness planet without a jedi trainer).
	SceneObject* pickJediTrainer(ZoneServer* zoneServer, CreatureObject* creature) const {
		if (creature == nullptr || zoneServer == nullptr)
			return nullptr;

		ManagedReference<SceneObject*> closest = nullptr;
		ManagedReference<SceneObject*> fallback = nullptr;
		float closestDistSq = -1.f;

		String homeZoneName;
		Zone* homeZone = creature->getZone();

		if (homeZone != nullptr)
			homeZoneName = homeZone->getZoneName();

		Vector3 playerPos = creature->getWorldPosition();

		for (int i = 0; i < zoneServer->getZoneCount(); ++i) {
			auto zone = zoneServer->getZone(i);

			if (zone == nullptr)
				continue;

			SortedVector<ManagedReference<SceneObject*>> objectList = zone->getPlanetaryObjectList("trainer");

			for (int j = 0; j < objectList.size(); ++j) {
				ManagedReference<SceneObject*> trainer = objectList.get(j);

				if (trainer == nullptr)
					continue;

				if (trainer->getPlanetMapSubCategoryCRC() != STRING_HASHCODE("trainer_jedi"))
					continue;

				CreatureObject* trainerCreo = trainer->asCreatureObject();

				if (trainerCreo == nullptr)
					continue;

				if (!(trainerCreo->getOptionsBitmask() & OptionBitmask::CONVERSE))
					continue;

				ManagedReference<CityRegion*> city = trainerCreo->getCityRegion().get();

				// Make sure it's not a player-city trainer.
				if (city != nullptr && !city->isClientRegion())
					continue;

				if (fallback == nullptr)
					fallback = trainer;

				if (homeZoneName.isEmpty() || zone->getZoneName() != homeZoneName)
					continue;

				Vector3 pos = trainerCreo->getWorldPosition();
				float dx = pos.getX() - playerPos.getX();
				float dy = pos.getY() - playerPos.getY();
				float distSq = dx * dx + dy * dy;

				if (closest == nullptr || distSq < closestDistSq) {
					closest = trainer;
					closestDistSq = distSq;
				}
			}
		}

		if (closest != nullptr)
			return closest;

		return fallback;
	}

	void assignTrainer(PlayerObject* ghost, SceneObject* trainer) const {
		if (ghost == nullptr || trainer == nullptr)
			return;

		CreatureObject* trainerCreo = trainer->asCreatureObject();
		Zone* trainerZone = trainer->getZone();

		if (trainerCreo == nullptr || trainerZone == nullptr)
			return;

		String zoneName = trainerZone->getZoneName();

		ghost->setTrainerCoordinates(trainerCreo->getWorldPosition());
		ghost->setTrainerZoneName(zoneName);
	}
};

#endif // FINDMYTRAINERCOMMAND_H_
