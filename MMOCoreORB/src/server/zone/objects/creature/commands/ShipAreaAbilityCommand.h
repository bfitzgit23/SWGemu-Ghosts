/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef SHIPAREAABILITYCOMMAND_H_
#define SHIPAREAABILITYCOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/CloseObjectsVector.h"

// Ghosts 2026-11-19: Energy Pulse and Bomber Strike are area damage, not weapon
// shots, so they deliberately stay out of the projectile path in
// SpaceCombatManager: no projectile, no collision result, no refire. They drain
// the ship's capacitor and apply chassis damage directly to every attackable
// ship inside the radius. Damage never takes a ship below one point of chassis
// health, so the killing blow still comes from weapons and the ship destruction
// pipeline (crew, escape pods, POB interior) runs as usual.
//
// Tuning values are in metres, chassis damage points and a fraction of the
// ship's maximum capacitor. They are the knobs to change; nothing else here
// depends on the numbers.
class ShipAreaAbilityCommand : public QueueCommand {
public:
	ShipAreaAbilityCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->isPilotingShip())
			return INVALIDSTATE;

		SceneObject* rootParent = creature->getRootParent();

		if (rootParent == nullptr || !rootParent->isShipObject())
			return GENERALERROR;

		ManagedReference<ShipObject*> ship = rootParent->asShipObject();

		if (ship == nullptr || ship->isShipDestroyed())
			return GENERALERROR;

		String command = getName().toLowerCase();

		bool isPulse = command.beginsWith("epulse");
		bool isStrike = command.beginsWith("bstrike");

		if (!isPulse && !isStrike)
			return GENERALERROR;

		int tier = 1;

		if (!command.isEmpty()) {
			char last = command.charAt(command.length() - 1);

			if (last >= '1' && last <= '3')
				tier = last - '0';
		}

		float radius = 0.f;
		float damage = 0.f;
		float energyFraction = 0.f;

		if (isPulse) {
			// Energy Pulse: centred on the ship issuing it.
			if (tier == 1) {
				radius = 300.f;
				damage = 90.f;
				energyFraction = 0.20f;
			} else if (tier == 2) {
				radius = 450.f;
				damage = 180.f;
				energyFraction = 0.30f;
			} else {
				radius = 600.f;
				damage = 300.f;
				energyFraction = 0.45f;
			}
		} else {
			// Bomber Strike: centred on the targeted ship.
			if (tier == 1) {
				radius = 150.f;
				damage = 150.f;
				energyFraction = 0.25f;
			} else if (tier == 2) {
				radius = 220.f;
				damage = 300.f;
				energyFraction = 0.40f;
			} else {
				radius = 300.f;
				damage = 500.f;
				energyFraction = 0.60f;
			}
		}

		ManagedReference<ShipObject*> centerShip = ship;

		if (isStrike) {
			Zone* zone = creature->getZone();

			if (zone == nullptr)
				return GENERALERROR;

			ManagedReference<SceneObject*> object = zone->getZoneServer()->getObject(target);

			if (object == nullptr || !object->isShipObject() || object == ship)
				return INVALIDTARGET;

			centerShip = object->asShipObject();

			if (centerShip == nullptr)
				return INVALIDTARGET;
		}

		// Capacitor is the limiter, so the abilities cannot be spammed.
		{
			Locker slock(ship, creature);

			float maxEnergy = ship->getCapacitorMaxEnergy();

			if (maxEnergy > 0.f) {
				float cost = maxEnergy * energyFraction;

				if (ship->getCapacitorEnergy() < cost) {
					creature->sendSystemMessage("Not enough capacitor energy for that ability.");

					return GENERALERROR;
				}

				ship->setCapacitorEnergy(ship->getCapacitorEnergy() - cost);
			}
		}

		Vector3 center = centerShip->getCurrentTransform().getPosition();

		CloseObjectsVector* closeObjects = centerShip->getCloseObjects();

		if (closeObjects == nullptr)
			return GENERALERROR;

		SortedVector<TreeEntry*> nearbyObjects;
		closeObjects->safeCopyTo(nearbyObjects);

		for (int i = 0; i < nearbyObjects.size(); ++i) {
			SceneObject* object = static_cast<SceneObject*>(nearbyObjects.get(i));

			if (object == nullptr || object == ship || !object->isShipObject())
				continue;

			ManagedReference<ShipObject*> otherShip = object->asShipObject();

			if (otherShip == nullptr || otherShip->isShipDestroyed())
				continue;

			// Never catch the caster's own group or anything that cannot be
			// attacked by them in the first place.
			if (!otherShip->isAttackableBy(creature))
				continue;

			float distance = center.distanceTo(otherShip->getCurrentTransform().getPosition());

			if (distance > radius)
				continue;

			Locker olock(otherShip.get());

			float health = otherShip->getChassisCurrentHealth();

			if (health <= 0.f)
				continue;

			otherShip->setCurrentChassisHealth(Math::max(1.f, health - damage));
		}

		return SUCCESS;
	}

};

#endif //SHIPAREAABILITYCOMMAND_H_
