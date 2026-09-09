/*
 * TravelTerminalImplementation.cpp
 *
 *  Created on: 31/05/2010
 *      Author: victor
 *  Updated on: Thu Oct 13 08:34:42 PDT 2011 by lordkator - use getPlanetTravelPoint() instead of trying to resolve here
 */

#include "server/zone/objects/tangible/terminal/travel/TravelTerminal.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/planet/PlanetManager.h"
#include "server/zone/packets/player/EnterTicketPurchaseModeMessage.h"
#include "server/zone/objects/creature/CreatureObject.h"

int TravelTerminalImplementation::handleObjectMenuSelect(CreatureObject* player, byte selectedID) {
	if (selectedID != 20)
		return 0;

	Reference<PlanetTravelPoint*> ptp = nullptr;
	ManagedReference<SceneObject*> rootParent = getRootParent();
	Zone* zone = getZone();

	// A travel terminal inside a starport must resolve to an interplanetary
	// travel point. Using the unrestricted nearest-point lookup here can bind
	// the terminal to a nearby shuttleport after shuttle positions are updated.
	if (zone != nullptr && rootParent != nullptr && rootParent->getObjectTemplate() != nullptr) {
		const String& rootTemplate = rootParent->getObjectTemplate()->getFullTemplateString();

		if (rootTemplate.contains("starport"))
			ptp = zone->getPlanetManager()->getNearestPlanetTravelPoint(_this.getReferenceUnsafeStaticCast(), 16000.f, true);
	}

	if (ptp == nullptr)
		ptp = getPlanetTravelPoint();

	// Complain loudly if we failed to find a travel point for this terminal
	if(ptp == nullptr) {
		error("TravelTerminalImplementation::handleObjectMenuSelect(" + String::valueOf(getObjectID()) + " Could not determine related PlanetTravelPoint");
		return 0;
	}

	EnterTicketPurchaseModeMessage* etpm = new EnterTicketPurchaseModeMessage(ptp);
	player->sendMessage(etpm);

	return 0;
}

void TravelTerminalImplementation::notifyInsertToZone(Zone* zone) {
	TerminalImplementation::notifyInsertToZone(zone);
}
