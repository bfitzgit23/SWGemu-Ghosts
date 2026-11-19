/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef SHIPAREAABILITYCOMMAND_H_
#define SHIPAREAABILITYCOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/CloseObjectsVector.h"
#include "server/zone/objects/ship/ShipDeltaVector.h"
#include "server/zone/objects/ship/events/DestroyShipTask.h"

// Ghosts 2026-11-19: Energy Pulse and Bomber Strike are area damage, not weapon
// shots, so they deliberately stay out of the projectile path in
// SpaceCombatManager: no projectile, no collision result, no refire. They drain
// the ship's capacitor and apply chassis damage directly to every attackable
// ship inside the radius.
//
// Every changed value goes through a ShipDeltaVector and is flushed with
// sendMessages, the same way SpaceCombatManager ships damage deltas, so the
// client sees one coalesced update per ship instead of a loose notifyClient
// write under a lock.
//
// They can destroy a ship. When the sweep takes a ship to zero chassis health
// the same DestroyShipTask and destruction observer notification that
// SpaceCombatManager uses for a killing weapon hit are run for it, after the
// lock is released, so crew, escape pods and POB interior handling still run.
//
// The caster gets a summary of how many ships were hit and every player pilot
// that was damaged is told what hit them and by whom.
//
// Tuning values are in metres, chassis damage points and a fraction of the
// ship's maximum capacitor. They are the knobs to change; nothing else here
// depends on the numbers. For scale, a stock x-wing has 519 chassis hitpoints,
// xwing_tier1 264, xwing_tier3 1320.
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
				damage = 120.f;
				energyFraction = 0.20f;
			} else if (tier == 2) {
				radius = 450.f;
				damage = 240.f;
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
				damage = 180.f;
				energyFraction = 0.25f;
			} else if (tier == 2) {
				radius = 220.f;
				damage = 380.f;
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

				ShipDeltaVector shipDelta(ship.get());

				ship->setCapacitorEnergy(ship->getCapacitorEnergy() - cost, false, nullptr, &shipDelta);
				shipDelta.sendMessages(ship.get());
			}
		}

		Vector3 center = centerShip->getCurrentTransform().getPosition();

		CloseObjectsVector* closeObjects = centerShip->getCloseObjects();

		if (closeObjects == nullptr)
			return GENERALERROR;

		SortedVector<TreeEntry*> nearbyObjects;
		closeObjects->safeCopyTo(nearbyObjects);

		Vector<ManagedReference<CreatureObject*>> hitPilots;
		Vector<ManagedReference<ShipObject*>> shipsToDestroy;
		int hitCount = 0;

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

			{
				Locker olock(otherShip.get());

				float health = otherShip->getChassisCurrentHealth();

				if (health <= 0.f)
					continue;

				float newHealth = Math::max(0.f, health - damage);

				if (newHealth != health) {
					ShipDeltaVector deltaVector(otherShip.get());

					otherShip->setCurrentChassisHealth(newHealth, false, nullptr, &deltaVector);
					deltaVector.sendMessages(otherShip.get());
				}

				if (newHealth <= 0.f)
					shipsToDestroy.add(otherShip);
			}

			++hitCount;

			auto pilot = otherShip->getPilot();

			if (pilot != nullptr && pilot->isPlayerCreature())
				hitPilots.add(pilot);
		}

		String abilityLabel = isPulse ? "Energy Pulse " : "Bomber Strike ";
		abilityLabel += String::valueOf(tier);

		if (hitCount == 0) {
			creature->sendSystemMessage(abilityLabel + ": no ships in range.");
		} else {
			creature->sendSystemMessage(abilityLabel + ": hit " + String::valueOf(hitCount) + (hitCount == 1 ? " ship." : " ships."));
		}

		String attackerName = creature->getDisplayedName();

		for (int i = 0; i < hitPilots.size(); ++i) {
			ManagedReference<CreatureObject*> pilot = hitPilots.get(i);

			if (pilot == nullptr)
				continue;

			pilot->sendSystemMessage("You were hit by " + abilityLabel + " from " + attackerName + ".");
		}

		// Destroyed outside the loop so no ship lock is held while the task
		// takes its own.
		for (int i = 0; i < shipsToDestroy.size(); ++i) {
			ManagedReference<ShipObject*> destroyedShip = shipsToDestroy.get(i);

			if (destroyedShip == nullptr || !destroyedShip->isShipDestroyed())
				continue;

			auto destroyTask = new DestroyShipTask(destroyedShip);
			destroyTask->execute();

			Reference<ShipObject*> refTarget = destroyedShip;
			Reference<ShipObject*> attackerRef = ship.get();

			Core::getTaskManager()->scheduleTask([refTarget, attackerRef]() {
				if (refTarget == nullptr || attackerRef == nullptr)
					return;

				Locker lock(refTarget);
				Locker clocker(attackerRef, refTarget);

				refTarget->notifyObjectDestructionObservers(attackerRef, 0, true);
			}, "notifyShipDestroyLambda", 200);
		}

		return SUCCESS;
	}

};

#endif //SHIPAREAABILITYCOMMAND_H_
