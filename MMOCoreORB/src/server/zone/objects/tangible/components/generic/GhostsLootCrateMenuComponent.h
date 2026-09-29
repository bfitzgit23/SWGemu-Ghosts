/*
 * GhostsLootCrateMenuComponent
 *
 * Rebuild (2026-09-29) of the custom Ghosts loot crate open-handler that was
 * lost in the Sep 28 script/source reversion. Registered in ComponentManager
 * under every crate alias (ArtifactMenuComponent, NewMemberMenuComponent,
 * WorldMenuComponent, EventMenuComponent, CollectionsilverMenuComponent,
 * CollectiongoldMenuComponent, CollectionplatinumMenuComponent,
 * DiamondMenuComponent, HeroicMenuComponent, FlurrypresentMenuComponent,
 * FlurrycoalMenuComponent) so the existing crate Lua templates work as-is.
 *
 * Radial "Activate" gives the crate's fixed tiered rewards, then destroys it.
 */

#ifndef GHOSTSLOOTCRATEMENUCOMPONENT_H_
#define GHOSTSLOOTCRATEMENUCOMPONENT_H_

#include "../TangibleObjectMenuComponent.h"

class GhostsLootCrateMenuComponent : public TangibleObjectMenuComponent {
public:
	virtual void fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const;
	virtual int handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const;
};

#endif /* GHOSTSLOOTCRATEMENUCOMPONENT_H_ */
