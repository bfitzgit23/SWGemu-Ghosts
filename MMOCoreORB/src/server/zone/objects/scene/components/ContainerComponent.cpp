/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.
*/

#include "ContainerComponent.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/Zone.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sessions/SlicingSession.h"

// ---------------------------------------------------------------------------
// Stale equipment slot keys.
//
// An arrangement descriptor (abstract/slot/arrangement/wearables/*.iff) lists the slot
// names a wearable claims while worn. When that data changes (arrangement override in a
// patch TRE), items that are already worn keep the keys they were handed under the old
// arrangement, and canAddObject() then refuses everything that wants one of those names
// ("This slot is already occupied"): a robe that used to claim chest1/chest2/pants/back
// keeps blocking shirt, vest, pants and backpacks even though its current arrangement
// only claims `cloak`.
//
// releaseStaleSlotKey() recognises that case - the key points at an item whose current
// arrangement does not claim the name. The item is re-keyed under the names it does
// claim (worn equipment has no other anchor) and every key it no longer owns is dropped,
// so the equip can proceed. Returns true when the key was released.
// ---------------------------------------------------------------------------
static bool releaseStaleSlotKey(SceneObject* container, SceneObject* blocker, const String& slotKey) {
	if (container == nullptr || blocker == nullptr)
		return false;

	// Creatures (a player riding a vehicle or sitting in a ship seat) and non-tangible
	// containers are anchored by keys that are not equipment arrangements.
	if (blocker->isCreatureObject() || !blocker->isTangibleObject())
		return false;

	const int groups = blocker->getArrangementDescriptorSize();

	if (groups == 0)
		return false;

	int group = blocker->getContainmentType() - 4;

	if (group < 0 || group >= groups)
		group = 0;

	const Vector<String>* descriptors = blocker->getArrangementDescriptor(group);

	if (descriptors == nullptr || descriptors->size() == 0)
		return false;

	for (int i = 0; i < descriptors->size(); ++i) {
		if (descriptors->get(i) == slotKey)
			return false; // genuinely claimed -> a real conflict, keep refusing
	}

	VectorMap<String, ManagedReference<SceneObject*> >* slottedObjects = container->getSlottedObjects();

	if (slottedObjects == nullptr)
		return false;

	// Anchor the item under one of the names its current arrangement claims before any key
	// is dropped, otherwise it could become unreachable and never be sent to the client.
	bool anchored = false;

	for (int i = 0; i < descriptors->size() && !anchored; ++i) {
		const String& name = descriptors->get(i);
		ManagedReference<SceneObject*> other = slottedObjects->get(name);

		if (other != nullptr && other->getObjectID() != blocker->getObjectID())
			continue; // that name belongs to a different item

		slottedObjects->put(name, blocker);
		anchored = true;
	}

	if (!anchored)
		return false;

	Vector<String> staleKeys;

	for (int i = 0; i < slottedObjects->size(); ++i) {
		const String& key = slottedObjects->elementAt(i).getKey();
		ManagedReference<SceneObject*> held = slottedObjects->get(i);

		if (held == nullptr || held->getObjectID() != blocker->getObjectID())
			continue;

		bool claimed = false;

		for (int j = 0; j < descriptors->size(); ++j) {
			if (descriptors->get(j) == key) {
				claimed = true;

				break;
			}
		}

		if (!claimed)
			staleKeys.add(key);
	}

	for (int i = 0; i < staleKeys.size(); ++i)
		slottedObjects->drop(staleKeys.get(i));

	container->info(true) << "[EquipSlots] re-keyed '" << blocker->getDisplayedName() << "' ID: " << blocker->getObjectID()
			<< " to its current arrangement on " << container->getDisplayedName() << " ID: " << container->getObjectID()
			<< " - released stale slot '" << slotKey << "'";

	return true;
}


// ---------------------------------------------------------------------------
// The cloak layer holds two items.
//
// Robes and cloaks are both authored against the single `cloak` slot (see the
// arrangement overrides in patch_zzz_01.tre) and `cloak` is also the skeleton
// hardpoint their meshes attach to, so there is no second slot name that would
// render.  slottedObjects is keyed by slot name, so a second occupant would
// overwrite the first one; it is anchored as `cloak2` instead.  Nothing else in
// the server reads either name (there is no getSlottedObject("cloak") call) and
// removeObject() drops keys by object identity, so the extra key is invisible to
// every other system, including the notifyLoadFromDatabase() re-key sweep, which
// keeps `cloak2` when `cloak` belongs to the other item and folds it back into
// `cloak` when that item is gone.
// ---------------------------------------------------------------------------
static const String CLOAK_LAYER_SLOT = "cloak";
static const String CLOAK_LAYER_EXTRA = "cloak2";

// True for a wearable whose whole claim set is the cloak layer - a robe or a
// cloak as they are arranged today.  Anything that claims `cloak` together with
// other slots (a jumpsuit, say) is deliberately excluded: those keep the
// original one-item-per-slot behaviour.
static bool isCloakLayerItem(SceneObject* object) {
	if (object == nullptr || !object->isTangibleObject() || object->isCreatureObject())
		return false;

	const int groups = object->getArrangementDescriptorSize();

	if (groups == 0)
		return false;

	int group = object->getContainmentType() - 4;

	if (group < 0 || group >= groups)
		group = 0;

	const Vector<String>* descriptors = object->getArrangementDescriptor(group);

	if (descriptors == nullptr || descriptors->size() != 1)
		return false;

	return descriptors->get(0) == CLOAK_LAYER_SLOT;
}

// The slot key `object` should be anchored under, or an empty String when the
// name is a real conflict.  Only the robe/cloak pair may share the layer, and
// only two of them.
static String resolveCloakLayerKey(SceneObject* container, SceneObject* object, const String& slotKey) {
	if (container == nullptr || slotKey != CLOAK_LAYER_SLOT)
		return slotKey;

	VectorMap<String, ManagedReference<SceneObject*> >* slottedObjects = container->getSlottedObjects();

	if (slottedObjects == nullptr || !slottedObjects->contains(CLOAK_LAYER_SLOT))
		return slotKey;

	ManagedReference<SceneObject*> held = slottedObjects->get(CLOAK_LAYER_SLOT);

	if (held == nullptr || held->getObjectID() == object->getObjectID())
		return slotKey;

	if (!isCloakLayerItem(object) || !isCloakLayerItem(held))
		return String(); // not the robe/cloak pair -> keep refusing

	if (slottedObjects->contains(CLOAK_LAYER_EXTRA))
		return String(); // the layer already holds two items

	return CLOAK_LAYER_EXTRA;
}

int ContainerComponent::canAddObject(SceneObject* sceneObject, SceneObject* object, int containmentType, String& errorDescription) const {
	if (sceneObject == object) {
		errorDescription = "@container_error_message:container02"; //You cannot add something to itself.

		return TransferErrorCode::CANTADDTOITSELF;
	}

	if ((object->isNoTrade() || object->containsNoTradeObjectRecursive()) && !object->isVendor()) {
		ManagedReference<SceneObject*> containerPlayerParent = sceneObject->getParentRecursively(SceneObjectType::PLAYERCREATURE);
		ManagedReference<SceneObject*> containerBuildingParent = sceneObject->getParentRecursively(SceneObjectType::BUILDING);
		ManagedReference<SceneObject*> containerFactoryParent = sceneObject->getParentRecursively(SceneObjectType::FACTORY);
		ManagedReference<SceneObject*> objPlayerParent = object->getParentRecursively(SceneObjectType::PLAYERCREATURE);
		ManagedReference<SceneObject*> objCreatureParent = object->getParentRecursively(SceneObjectType::CREATURE);
		ManagedReference<SceneObject*> objNpcCreatureParent = object->getParentRecursively(SceneObjectType::NPCCREATURE);
		ManagedReference<SceneObject*> objBuildingParent = object->getParentRecursively(SceneObjectType::BUILDING);


		if (containerFactoryParent != nullptr) {
			errorDescription = "@container_error_message:container28";
			return TransferErrorCode::CANTADD;
		} else if (objPlayerParent == nullptr && objCreatureParent == nullptr && objNpcCreatureParent == nullptr && objBuildingParent != nullptr) {
			ManagedReference<BuildingObject*> buio = cast<BuildingObject*>( objBuildingParent.get());

			if (buio != nullptr ) {
				uint64 bid = buio->getOwnerObjectID();

				if ((containerPlayerParent != nullptr && bid != containerPlayerParent->getObjectID()) || (sceneObject->isPlayerCreature() && bid != sceneObject->getObjectID())) {
					errorDescription = "@container_error_message:container27";
					return TransferErrorCode::CANTREMOVE;
				}
			}
		} else if (objPlayerParent != nullptr && containerPlayerParent == nullptr && containerBuildingParent != nullptr && !sceneObject->isPlayerCreature()) {
			ManagedReference<BuildingObject*> buio = cast<BuildingObject*>( containerBuildingParent.get());

			if (buio != nullptr && (buio->getOwnerObjectID() != objPlayerParent->getObjectID() || buio->isCivicStructure())) {
				errorDescription = "@container_error_message:container28";
				return TransferErrorCode::CANTADD;
			}
		}

	} else if (object->isVendor()) {
		ManagedReference<SceneObject*> containerPlayerParent = sceneObject->getParentRecursively(SceneObjectType::PLAYERCREATURE);

		if (!sceneObject->isCellObject() && (!sceneObject->hasArrangementDescriptor("inventory") || containerPlayerParent == nullptr)) {
			return TransferErrorCode::CANTADD;
		}
	}

	String validationError;

	switch (sceneObject->getContainerType()) {
	case ContainerType::NONE: // Nothing allowed
		validationError = "ContainerType is NONE";
		break;

	case ContainerType::SLOTTED: // Only slot transfer allowed
		if (containmentType < 4) {
			validationError = "ContainerType is SLOTTED but ContainerType < 4";
		}
		break;

	case ContainerType::VOLUME: // Only container transfer allowed of tangible object
		if (containmentType != -1 || !object->isTangibleObject()) {
			validationError = "ContainerType is VOLUME but !isTangibleObject()";
		}
		break;

	case ContainerType::INTANGIBLE: // Only intagible objects allowed
		if (containmentType != -1 || object->isTangibleObject()) {
			validationError = "ContainerType is INTANGIBLE but isTangibleObject()";
		}
		break;

	case ContainerType::GENERIC: // Generic container transfer
		if (containmentType != -1) {
			validationError = "ContainerType is GENERIC but containmentType != -1";
		}
		break;

	case ContainerType::RIDABLE: // Rideable
		if (containmentType < 4) {
			validationError = "ContainerType is RIDABLE but containmentType < 4";
		} else if (!(object->isVehicleObject() || object->isMount())) {
			validationError = "ContainerType is RIDABLE but not (isVehicleObject or isMount)";
		}
		break;
	}

	if (validationError.isEmpty()) {
		// Check for any parent that is containerType == NONE
		for (auto parent = sceneObject->getParent().get(); parent != nullptr; parent = parent->getParent().get()) {
			Locker lock(parent);

			if (parent->getContainerType() == ContainerType::NONE) {
				validationError = "ContainerType==NONE: oid " + String::valueOf(parent->getObjectID());
				break;
			}
		}
	}

	if (!validationError.isEmpty()) {
		sceneObject->error()
			<< "canAddObject: invalid attempt for containmentType "
			<< containmentType << " to add " << object->getObjectID()
			<< " into " << sceneObject->getObjectID() << " (ContainerType " << sceneObject->getContainerType() << ") - "
			<< validationError
			;
		errorDescription = "@container_error_message:container28";
		return TransferErrorCode::CANTADD;
	}

	Locker contLocker(sceneObject->getContainerLock());

	const VectorMap<String, ManagedReference<SceneObject*> >* slottedObjects = sceneObject->getSlottedObjects();
	VectorMap<uint64, ManagedReference<SceneObject*> >* containerObjects = sceneObject->getContainerObjects();

	if (containmentType >= 4) {
		int arrangementGroup = containmentType - 4;

		if (object->getArrangementDescriptorSize() > arrangementGroup) {
			const Vector<String>* descriptors = object->getArrangementDescriptor(arrangementGroup);

			for (int i = 0; i < descriptors->size(); ++i){
				const String& childArrangement = descriptors->get(i);

				if (slottedObjects->contains(childArrangement)) {
					ManagedReference<SceneObject*> blocker = slottedObjects->get(childArrangement);

					// A key held by an item that no longer claims this slot under its current
					// arrangement is stale, not a conflict: re-key it and retry.
					if (blocker != nullptr && releaseStaleSlotKey(sceneObject, blocker, childArrangement)) {
						if (!slottedObjects->contains(childArrangement))
							continue;
					}

					// A robe and a cloak share the cloak layer: the second occupant is
					// anchored as cloak2 by transferObject().
					if (childArrangement == CLOAK_LAYER_SLOT && !resolveCloakLayerKey(sceneObject, object, childArrangement).isEmpty())
						continue;

					if (sceneObject->isPlayerCreature()) {
						String blockerText = "(null)";

						if (blocker != nullptr) {
							blockerText = blocker->getDisplayedName();
							blockerText += " (claiming: ";

							int blockerGroup = blocker->getContainmentType() - 4;

							if (blockerGroup < 0 || blockerGroup >= blocker->getArrangementDescriptorSize())
								blockerGroup = 0;

							const Vector<String>* blockerDescriptors = blocker->getArrangementDescriptorSize() > 0
									? blocker->getArrangementDescriptor(blockerGroup) : nullptr;

							if (blockerDescriptors != nullptr) {
								for (int j = 0; j < blockerDescriptors->size(); ++j)
									blockerText += (j == 0 ? String("") : String(",")) + blockerDescriptors->get(j);
							} else {
								blockerText += "no arrangement";
							}

							blockerText += ")";
						}

						sceneObject->info(true) << "[EquipSlots] refused item '" << object->getDisplayedName() << "' ID: " << object->getObjectID()
								<< " containment: " << containmentType << " group: " << arrangementGroup
								<< " slot: '" << childArrangement << "' held by: " << blockerText;
					}

					errorDescription = "@container_error_message:container04"; //This slot is already occupied.
					return TransferErrorCode::SLOTOCCUPIED;
				}
			}
		}
	} else if (containmentType == -1) {
		if (containerObjects->size() >= sceneObject->getContainerVolumeLimit()) {
			errorDescription = "@container_error_message:container03"; //This container is full.

			return TransferErrorCode::CONTAINERFULL;
		}
	} else {
		sceneObject->error("unknown containmentType in canAddObject type " + String::valueOf(containmentType));
		errorDescription = "DEBUG: cant move item unknown containmentType type";
		return TransferErrorCode::UNKNOWNCONTAIMENTTYPE;
	}

	return 0;
}

bool ContainerComponent::checkContainerPermission(SceneObject* sceneObject, CreatureObject* creature, uint16 permission) const {
	auto permissions = sceneObject->getContainerPermissions();

	// creature->info(true) << "ContainerComponent::checkContainerPermission -- Perm: " << permission << " Object ID: " << sceneObject->getObjectID();

	if (permissions->getOwnerID() == creature->getObjectID()) {
		return permissions->hasOwnerPermission(permission);
	}

	PlayerObject* ghost = creature->getPlayerObject();

	if (ghost == nullptr) {
		return false;
	}

	if ((permission == ContainerPermissions::OPEN || permission == ContainerPermissions::WALKIN) && ghost->isPrivileged()) {
		return true;
	}

	ManagedReference<SceneObject*> parent = sceneObject->getParent().get();

	if (permission != ContainerPermissions::MOVECONTAINER && permissions->hasInheritPermissionsFromParent() && parent != nullptr && parent != sceneObject) {
		return parent->checkContainerPermission(creature, permission);
	} else if (permission == ContainerPermissions::MOVECONTAINER && sceneObject->isClientObject()) {
		return false;
	}

	SortedVector<String>* groups = ghost->getPermissionGroups();

	uint16 allowPermissions = 0, denyPermissions = 0;

	for (int i = 0; i < groups->size(); ++i) {
		const String& group = groups->get(i);

		uint16 allow = permissions->getAllowPermissions(group);

		allowPermissions |= allow;

		uint16 deny = permissions->getDenyPermissions(group);

		denyPermissions |= deny;
	}

	return permission & (allowPermissions & ~denyPermissions);
}

bool ContainerComponent::transferObject(SceneObject* sceneObject, SceneObject* object, int containmentType, bool notifyClient, bool allowOverflow, bool notifyRoot) const {
	if (sceneObject == object) {
		return false;
	}

#ifdef DEBUG_CONTAINER_TRANSFER
	if (object->isPlayerCreature()) {
		object->info(true) << "---------- " << object->getDisplayedName() << " --- STARTING container Transfer into new Parent - ID: " << sceneObject->getObjectID() << " ---------- ";
	}
#endif // DEBUG_CONTAINER_TRANSFER

	if (!object->canBeTransferred(sceneObject)) {
		return false;
	}

	// Terminate any active slicing sessions on the object being transferred
	if (object->containsActiveSession(SessionFacadeType::SLICING)) {
		ManagedReference<Facade*> facade = object->getActiveSession(SessionFacadeType::SLICING);
		ManagedReference<SlicingSession*> session = dynamic_cast<SlicingSession*>(facade.get());

		if (session != nullptr) {
			session->cancelSession();
		}
	}

	ManagedReference<SceneObject*> objParent = object->getParent().get();

	ManagedReference<Zone*> objZone = object->getLocalZone();
	ManagedReference<Zone*> oldRootZone = object->getZone();

	if (objParent != nullptr || objZone != nullptr) {
		bool nullifyParent = (sceneObject == nullptr);

		if (objParent != nullptr) {
			/*	Call the previous parent to remove
			*	Don't notify client yet, if you do here it confuses the client and drops tiems from toolbar etc
			*	Only nullify the object being transferreds' parent if the new parent is null, or it causes an issue during transitions for out of range object removal
			*/
			objParent->removeObject(object, sceneObject, false, nullifyParent);
		}

		if (nullifyParent && object->getParent() != nullptr) {
			object->error() << "Failed to remove object from old parent: " << object->getDisplayedName() << " ID: " << object->getObjectID() << " to container: " << sceneObject->getDisplayedName() << " ID: " << sceneObject->getObjectID();

			return false;
		}

		if (objZone != nullptr) {
			objZone->remove(object);
		}

		object->setZone(nullptr);

		if (objParent == nullptr) {
			objParent = objZone;
		}
	}

	// Lock the container
	Locker contLocker(sceneObject->getContainerLock());

	VectorMap<String, ManagedReference<SceneObject*> >* slottedObjects = sceneObject->getSlottedObjects();
	VectorMap<uint64, ManagedReference<SceneObject*> >* containerObjects = sceneObject->getContainerObjects();

	bool update = true;

	if (containmentType >= 4) {
		int arrangementGroup = containmentType - 4;

		if (object->getArrangementDescriptorSize() > arrangementGroup) {
			const Vector<String>* descriptors = object->getArrangementDescriptor(arrangementGroup);

			for (int i = 0; i < descriptors->size(); ++i){
				const String& childArrangement = descriptors->get(i);

				if (slottedObjects->contains(childArrangement)) {
					ManagedReference<SceneObject*> holder = slottedObjects->get(childArrangement);

					if (holder == nullptr || holder->getObjectID() == object->getObjectID())
						continue;

					if (releaseStaleSlotKey(sceneObject, holder, childArrangement)) {
						if (!slottedObjects->contains(childArrangement))
							continue;
					}

					// transferObject(): the robe/cloak pair shares this layer - the second
					// occupant is anchored as cloak2 below.
					if (childArrangement == CLOAK_LAYER_SLOT && !resolveCloakLayerKey(sceneObject, object, childArrangement).isEmpty())
						continue;

					return false;
				}
			}

			for (int i = 0; i < descriptors->size(); ++i)	{
				String cloakKey = resolveCloakLayerKey(sceneObject, object, descriptors->get(i));
				
				if (cloakKey.isEmpty())
					return false; // canAddObject() should have refused: a real slot conflict
				
				slottedObjects->put(cloakKey, object);
			}
		} else {
			return false;
		}

		// Set the new parent
		object->setParent(sceneObject);
		object->setContainmentType(containmentType);
	} else if (containmentType == -1) {
#ifdef DEBUG_CONTAINER_TRANSFER
		if (object->isPlayerCreature()) {
			object->info(true) << object->getDisplayedName() << " --- container transfer will be using containment type -1";
		}
#endif // DEBUG_CONTAINER_TRANSFER

		// Check for volume limit if overflow is not allowed
		if (!allowOverflow && containerObjects->size() >= sceneObject->getContainerVolumeLimit()){
			return false;
		}

		// Attempt to add the object in the container
		if (containerObjects->put(object->getObjectID(), object) == -1) {
			update = false;
		}

		// Set the new parent
		object->setParent(sceneObject);
		object->setContainmentType(containmentType);

#ifdef DEBUG_CONTAINER_TRANSFER
		if (object->isPlayerCreature()) {
			object->info(true) << object->getDisplayedName() << " --- new parent succesfully set!";
		}
#endif // DEBUG_CONTAINER_TRANSFER

		ManagedReference<Zone*> newRootZone = object->getZone();

		if (newRootZone != nullptr && newRootZone != oldRootZone && newRootZone->isGroundZone()) {
			bool shouldRegister = true;

			// Prevent GCW PvE Base Terminals Registering when inserted in cell container
			if (object->isTerminal() && sceneObject->getParent().get() != nullptr) {
				SceneObject* containerParent = sceneObject->getParent().get();

				if (containerParent != nullptr && containerParent->isBuildingObject()) {
					BuildingObject* building = containerParent->asBuildingObject();

					if (building != nullptr && building->isGCWBase() && !(building->getPvpStatusBitmask() & ObjectFlag::OVERT)) {
						shouldRegister = false;
					}
				}
			}

			if (shouldRegister) {
				newRootZone->registerObjectWithPlanetaryMap(object);
			}
		}
	} else {
		object->error() << "transferObject - Failed to assign: " << object->getDisplayedName() << " ID: " << object->getObjectID() << " to container: " << sceneObject->getDisplayedName() << " ID: " << sceneObject->getObjectID() << " - unknown containment type: " <<containmentType;

		StackTrace::printStackTrace();
		return false;
	}

	contLocker.release();

	if ((containmentType >= 4) && (objZone == nullptr)) {
		sceneObject->broadcastObject(object, true);
	} else if (notifyClient) {
		sceneObject->broadcastMessage(object->link(sceneObject->getObjectID(), containmentType), true);
	}

	notifyObjectInserted(sceneObject, object);

	if (update) {
		sceneObject->updateToDatabase();
	}

	ManagedReference<SceneObject*> rootParent = object->getRootParent();

	if (rootParent != nullptr && notifyRoot) {
		rootParent->notifyObjectInsertedToChild(object, sceneObject, objParent);
	}

	object->notifyObservers(ObserverEventType::PARENTCHANGED, sceneObject);

#ifdef DEBUG_CONTAINER_TRANSFER
	if (object->isPlayerCreature()) {
		object->info(true) << "---------- " << object->getDisplayedName() << " COMPLETED container transfer into new Parent ID: " << sceneObject->getObjectID() << " ----------";
	}
#endif // DEBUG_CONTAINER_TRANSFER

	return true;
}

bool ContainerComponent::removeObject(SceneObject* sceneObject, SceneObject* object, SceneObject* destination, bool notifyClient, bool nullifyParent) const {
#ifdef DEBUG_CONTAINER_TRANSFER
	if (object->isPlayerCreature()) {
		object->info(true) << object->getDisplayedName() << " --- removeObject function START";
	}
#endif // DEBUG_CONTAINER_TRANSFER

	Locker contLocker(sceneObject->getContainerLock());

	VectorMap<String, ManagedReference<SceneObject*> >* slottedObjects = sceneObject->getSlottedObjects();
	VectorMap<uint64, ManagedReference<SceneObject*> >* containerObjects = sceneObject->getContainerObjects();

	ManagedReference<SceneObject*> objectKeeper = object;

	if (object->getParent() != nullptr && object->getParent() != sceneObject) {
		ManagedReference<SceneObject*> objParent = object->getParent();

		containerObjects->drop(object->getObjectID());

		if (objParent->hasObjectInContainer(object->getObjectID()) || objParent->hasObjectInSlottedContainer(object)) {
			sceneObject->error() << "Trying to remove an object that is contained in a different object -- " << sceneObject->_getClassName() << " ID: " << sceneObject->getObjectID() << " Object to Remove: " << object->getDisplayedName() << " Class: " << object->_getClassName() << " ID: " << object->getObjectID() <<
			"Current Parent: " << objParent->_getClassName() << " ID: " << objParent->getObjectID();

			return false;
		} else if (nullifyParent) {
			object->setParent(nullptr);
		}
	}

	// Drop every slot key that still points at this object.
	// A wearable's slot keys are written from its arrangement descriptor when it
	// is equipped, but this used to drop only the names of the item's *current*
	// arrangement group. A later arrangement change (patch/TRE update) therefore
	// stranded the old keys on the container, and canAddObject() then rejected
	// every item claiming those slots (container04, "slot already occupied").
	{
		Vector<String> ownSlotKeys;

		for (int i = 0; i < slottedObjects->size(); ++i) {
			ManagedReference<SceneObject*> slottedObj = slottedObjects->get(i);

			if (slottedObj != nullptr && slottedObj->getObjectID() == object->getObjectID())
				ownSlotKeys.add(slottedObjects->elementAt(i).getKey());
		}

		for (int i = 0; i < ownSlotKeys.size(); ++i)
			slottedObjects->drop(ownSlotKeys.get(i));
	}

	if (containerObjects->contains(object->getObjectID()) && !containerObjects->drop(object->getObjectID())) {
		sceneObject->error() << sceneObject->_getClassName() << " ID: " << sceneObject->getObjectID() << " Failed to drop container object: " << object->getDisplayedName() << " Class: " << object->_getClassName() << " ID: " << object->getObjectID();
	}

	if (nullifyParent) {
		object->setParent(nullptr);
	}

	contLocker.release();

	if (notifyClient) {
		sceneObject->broadcastMessage(object->link((uint64) 0, 0xFFFFFFFF), true);
	}

	notifyObjectRemoved(sceneObject, object, destination);

	sceneObject->updateToDatabase();
	object->updateToDatabase();

	if (sceneObject->getParent() == nullptr) {
		sceneObject->notifyObjectRemovedFromChild(object, sceneObject);
	} else {
		ManagedReference<SceneObject*> rootParent = sceneObject->getRootParent();

		if (rootParent != nullptr) {
			rootParent->notifyObjectRemovedFromChild(object, sceneObject);
		} else {
			sceneObject->notifyObjectRemovedFromChild(object, sceneObject);
		}
	}

#ifdef DEBUG_CONTAINER_TRANSFER
	if (object->isPlayerCreature()) {
		object->info(true) << object->getDisplayedName() << " --- removeObject function COMPLETE";
	}
#endif // DEBUG_CONTAINER_TRANSFER

	return true;
}

/**
 * Is called when this object has been inserted with an object
 * @param object object that has been inserted
 */
int ContainerComponent::notifyObjectInserted(SceneObject* sceneObject, SceneObject* object) const {
	return sceneObject->notifyObjectInserted(object);
}

/**
 * Is called when an object was removed
 * @param object object that has been inserted
 */
int ContainerComponent::notifyObjectRemoved(SceneObject* sceneObject, SceneObject* object, SceneObject* destination) const {
	return sceneObject->notifyObjectRemoved(object);
}

