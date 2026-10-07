#ifndef ENCLAVETERMINALMENUCOMPONENT_H_
#define ENCLAVETERMINALMENUCOMPONENT_H_


#include "engine/engine.h"
#include "server/zone/objects/scene/components/ObjectMenuComponent.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/creature/CreatureObject.h"

class EnclaveTerminalMenuComponent : public ObjectMenuComponent {

public:

	enum { VOTING = 1, LIGHT_CHALLENGE, DARK_CHALLENGE };

	virtual void fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const;
	virtual int handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const;

private:
	int getEnclaveType(BuildingObject* building) const;
	int getTerminalType(SceneObject* terminal) const;
	void syncFrsDataFromSkills(CreatureObject* player) const;
	void callEnclaveTerminalLua(CreatureObject* player, SceneObject* terminal, const String& functionName, int branchIndex) const;

};

#endif /* ENCLAVETERMINALMENUCOMPONENT_H_ */
