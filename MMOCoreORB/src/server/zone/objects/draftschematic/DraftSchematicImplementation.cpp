/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#include "server/zone/objects/draftschematic/DraftSchematic.h"

#include "server/zone/ZoneServer.h"

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/manufactureschematic/ManufactureSchematic.h"
#include "server/zone/objects/intangible/IntangibleObject.h"

void DraftSchematicImplementation::initializeTransientMembers() {
	IntangibleObjectImplementation::initializeTransientMembers();

	setGlobalLogging(true);
	setLogging(false);

	setLoggingName("DraftSchematic");
}

void DraftSchematicImplementation::loadTemplateData(SharedObjectTemplate* templateData) {
	IntangibleObjectImplementation::loadTemplateData(templateData);

	schematicTemplate = dynamic_cast<DraftSchematicObjectTemplate*>(templateData);
}

void DraftSchematicImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {


}

void DraftSchematicImplementation::sendBaselinesTo(SceneObject* player) {
	if (!player->isPlayerCreature())
		return;

	error("Trying to send DraftSchematic baselines, should not be sending");
}

void DraftSchematicImplementation::sendDraftSlotsTo(CreatureObject* player) {
	if (schematicTemplate == nullptr)
		return;
	CreatureObject* playerCreature = cast<CreatureObject*>( player);

	ObjectControllerMessage* msg = new ObjectControllerMessage(player->getObjectID(), 0x0B, 0x01BF);

	msg->insertInt(clientObjectCRC);
	msg->insertInt(clientObjectCRC);

	msg->insertInt(schematicTemplate->getComplexity()); // ex: 3
	msg->insertInt(schematicTemplate->getSize()); // ex: 1
	msg->insertByte(2);

	insertIngredients(msg);

	player->sendMessage(msg);

}

void DraftSchematicImplementation::insertIngredients(ObjectControllerMessage* msg) {
	if (schematicTemplate == nullptr)
		return;
	const Vector<Reference<DraftSlot* > >* draftSlots = schematicTemplate->getDraftSlots();

	msg->insertInt(draftSlots->size());

	for(int i = 0; i < draftSlots->size(); ++i) {
		draftSlots->get(i)->insertToMessage(msg);
	}

	msg->insertShort(0);
}

void DraftSchematicImplementation::sendResourceWeightsTo(CreatureObject* player) {
	if (schematicTemplate == nullptr)
		return;
	const Vector<Reference<ResourceWeight* > >* resourceWeights = schematicTemplate->getResourceWeights();

	if (resourceWeights == nullptr)
		return;

	ObjectControllerMessage* msg = new ObjectControllerMessage(player->getObjectID(), 0x0B, 0x0207);

	if (msg == nullptr)
		return;

	msg->insertInt(clientObjectCRC);
	msg->insertInt(clientObjectCRC);

	int weightsSize = resourceWeights->size();

	msg->insertByte((byte)weightsSize);

	//Send all the resource batch property data
	for (int i = 0; i < weightsSize; i++)
		resourceWeights->get(i)->insertBatchToMessage(msg);

	msg->insertByte((byte)weightsSize);

	//Send all the resource property data
	for (int i = 0; i < weightsSize; i++)
		resourceWeights->get(i)->insertToMessage(msg);

	player->sendMessage(msg);
}

Reference<SceneObject*> DraftSchematicImplementation::createManufactureSchematic(SceneObject* craftingTool) {
	Reference<ManufactureSchematic*> manuSchematic =
			 (getZoneServer()->createObject(0xF75E04C2, 0)).castTo<ManufactureSchematic* >();

	if(manuSchematic == nullptr) {
		error("Could not create ManufactureSchematic for " + getObjectNameStringIdName());
		return nullptr;
	}

	Locker locker(manuSchematic);

	manuSchematic->createChildObjects();

	manuSchematic->setDraftSchematic(_this.getReferenceUnsafeStaticCast());

	return Reference<SceneObject*>(manuSchematic.get());
}

int DraftSchematicImplementation::getDraftSlotCount() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getDraftSlots()->size();
}

DraftSlot* DraftSchematicImplementation::getDraftSlot(int i) {
	if (schematicTemplate == nullptr)
		return nullptr;

	return schematicTemplate->getDraftSlots()->get(i);
}

int DraftSchematicImplementation::getResourceWeightCount() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getResourceWeights()->size();
}

ResourceWeight* DraftSchematicImplementation::getResourceWeight(int i) {
	if (schematicTemplate == nullptr)
		return nullptr;

	return schematicTemplate->getResourceWeights()->get(i);
}


float DraftSchematicImplementation::getComplexity() {
	if (schematicTemplate == nullptr)
		return 0.f;

	return (float)schematicTemplate->getComplexity();
}

uint32 DraftSchematicImplementation::getToolTab() {
	if (schematicTemplate == nullptr)
		return 0;

	return (uint32)schematicTemplate->getCraftingToolTab();
}

float DraftSchematicImplementation::getSize() {
	if (schematicTemplate == nullptr)
		return 0.f;

	return (float)schematicTemplate->getSize();
}

String DraftSchematicImplementation::getXpType() {
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getXpType();
}

int DraftSchematicImplementation::getXpAmount() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getXp();
}

bool DraftSchematicImplementation::getIsMagic() {
	if (schematicTemplate == nullptr)
		return false;

	return schematicTemplate->getIsMagic();
}

String DraftSchematicImplementation::getAssemblySkill() {
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getAssemblySkill();
}

String DraftSchematicImplementation::getExperimentationSkill() {
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getExperimentingSkill();
}

String DraftSchematicImplementation::getCustomizationSkill() {
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getCustomizationSkill();
}

String DraftSchematicImplementation::getCustomName() {
	// Ghosts: schematics restored without a template crash here during login-time
	// skill awards (SchematicList::contains -> getCustomName). Treat as unnamed.
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getCustomObjectName();
}

uint32 DraftSchematicImplementation::getTanoCRC() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getTanoCRC();
}

int DraftSchematicImplementation::getLabratory() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getLabratory();
}

int DraftSchematicImplementation::getFactoryCrateSize() {
	if (schematicTemplate == nullptr)
		return 0;

	return schematicTemplate->getFactoryCrateSize();
}

String DraftSchematicImplementation::getFactoryCrateType() {
	if (schematicTemplate == nullptr)
		return String();

	return schematicTemplate->getFactoryCrateType();
}
