/*
 * SharedStructureObjectTemplate.cpp
 *
 *  Created on: May 22, 2010
 *      Author: crush
 */


#include "SharedStructureObjectTemplate.h"


void SharedStructureObjectTemplate::readObject(LuaObject* templateData) {
	SharedTangibleObjectTemplate::readObject(templateData);

	//lotSize = templateData->getByteField("lotSize");

	int newlotsize = templateData->getByteField("lotSize");

	if (newlotsize >= 1) newlotsize = 1;

	lotSize = newlotsize;

	baseMaintenanceRate = templateData->getIntField("baseMaintenanceRate");

	basePowerRate = templateData->getIntField("basePowerRate");

//	LuaObject allowzones = templateData->getObjectField("allowedZones");
//	allowedZones.removeAll(); //Make sure it's empty...
//
//	for (int i = 1; i <= allowzones.getTableSize(); ++i) {
//		allowedZones.put(allowzones.getStringAt(i));
//	}
//
//	allowzones.pop();

	allowedZones = {"corellia", "talus", "dathomir", "endor", "lok", "naboo", "rori", "tatooine", "yavin4", "dantooine"};

	//cityRankRequired = templateData->getByteField("cityRankRequired");

	int newcityrankreq = templateData->getByteField("cityRankRequired");

	if (newcityrankreq >= 1) newcityrankreq = 1;

	cityRankRequired = newcityrankreq;

	constructionMarkerTemplate = templateData->getStringField("constructionMarker");

	abilityRequired = "";//templateData->getStringField("abilityRequired");

	uniqueStructure = templateData->getBooleanField("uniqueStructure");

	cityMaintenanceBase = templateData->getIntField("cityMaintenanceBase");

	cityMaintenanceRate = templateData->getIntField("cityMaintenanceRate");
}
