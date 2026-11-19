/*
					Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef WEAPONGROUPCOMMAND_H_
#define WEAPONGROUPCOMMAND_H_

#include "QueueCommand.h"

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/ship/ShipObject.h"
#include "server/zone/objects/ship/ShipProjectileData.h"
#include "server/zone/objects/ship/ComponentSlots.h"
#include "server/zone/managers/ship/ShipManager.h"
#include "server/zone/managers/spacecombat/SpaceCombatManager.h"
#include "server/zone/managers/spacecombat/projectile/ShipProjectile.h"

// Ghosts 2026-11-19: the client sends WeaponGroup with a subcommand when it
// fires ship weapons (fireProjectile / fireProjectileStop). The core had no
// handler at all, so every player ship shot was rejected as an unregistered
// queue command. Shots are paced by the client, so the server just validates
// the ship, weapon slot and target and launches the projectile.
class WeaponGroupCommand : public QueueCommand {
public:
	WeaponGroupCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (creature == nullptr)
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		auto root = creature->getRootParent();
		auto ship = root != nullptr ? root->asShipObject() : nullptr;

		if (ship == nullptr || !ship->isShipLaunched())
			return GENERALERROR;

		String argumentString = arguments.toString().toLowerCase().trim();

		// Releasing the trigger. Nothing is held open server side yet.
		if (argumentString.contains("stop"))
			return SUCCESS;

		if (!argumentString.contains("fire") && !argumentString.contains("projectile"))
			return GENERALERROR;

		return fireWeapon(ship, creature, target, getWeaponIndex(argumentString));
	}

private:
	static uint32 getWeaponIndex(const String& argumentString) {
		int index = -1;

		for (int i = 0; i < argumentString.length(); ++i) {
			char character = argumentString.charAt(i);

			if (character < '0' || character > '9')
				continue;

			if (index < 0)
				index = 0;

			index = index * 10 + (character - '0');
		}

		if (index < 0)
			return 0;

		return (uint32) index;
	}

	int fireWeapon(ShipObject* ship, CreatureObject* pilot, const uint64& target, uint32 weaponIndex) const {
		auto zoneServer = pilot->getZoneServer();

		if (zoneServer == nullptr)
			return GENERALERROR;

		if (weaponIndex > (uint32) (Components::CAPITALSLOTMAX - Components::WEAPON_START))
			return GENERALERROR;

		auto targetObject = zoneServer->getObject(target);

		if (targetObject == nullptr)
			return INVALIDTARGET;

		auto targetShip = targetObject->asShipObject();

		if (targetShip == nullptr || targetShip == ship)
			return INVALIDTARGET;

		auto componentMap = ship->getShipComponentMap();

		if (componentMap == nullptr)
			return GENERALERROR;

		uint32 slot = Components::WEAPON_START + weaponIndex;
		uint32 componentCRC = componentMap->get(slot);

		if (componentCRC == 0)
			return GENERALERROR;

		auto projectileData = ShipManager::instance()->getProjectileData(componentCRC);

		if (projectileData == nullptr)
			return GENERALERROR;

		// Missiles, countermeasures and utility emitters have their own commands.
		if (projectileData->isMissile() || projectileData->isCountermeasure() ||
				projectileData->isTractorBeam() || projectileData->isMiningLaser())
			return GENERALERROR;

		const Vector3& position = ship->getWorldPosition();

		auto transform = ship->getCurrentTransform();
		Vector3 direction = transform.getVelocity();

		auto projectile = new ShipProjectile(ship, (uint8) weaponIndex, (uint8) projectileData->getIndex(), 0, position,
				direction * ShipProjectile::positionScale, 0.f, 0.f, 1.f, System::getMiliTime());

		projectile->readProjectileData(projectileData);

		SpaceCombatManager::instance()->addProjectile(ship, projectile, pilot);

		return SUCCESS;
	}
};

#endif // WEAPONGROUPCOMMAND_H_
