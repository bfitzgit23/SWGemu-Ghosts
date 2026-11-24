/*
 * RareLootCrateMenuComponent.h
 *
 * Handler for the three "Rare Loot Crate" items that drop from the rare loot
 * pool (loot group "rarelootsystem").
 *
 * Their object templates name Rarelootcrate1/2/3MenuComponent, the classes that
 * lived here before afc95d435 ("removed excess/large files") deleted them. With
 * no component to resolve, the template fell back to the default menu, which is
 * why the crate showed a dead "Use" option instead of opening.
 *
 * One handler serves all three tiers; it finds the tier from the crate's
 * template path.
 */

#ifndef RARELOOTCRATEMENUCOMPONENT_H_
#define RARELOOTCRATEMENUCOMPONENT_H_

#include "../TangibleObjectMenuComponent.h"

class RareLootCrateMenuComponent : public TangibleObjectMenuComponent {
public:
	virtual void fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const;
	virtual int handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const;
};

#endif /* RARELOOTCRATEMENUCOMPONENT_H_ */
