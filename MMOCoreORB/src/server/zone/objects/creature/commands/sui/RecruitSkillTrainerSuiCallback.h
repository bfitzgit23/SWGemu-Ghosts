/*
 * RecruitSkillTrainer.h
 *
 *  Created on: Apr. 26 2012
 *      Author: TragD
 */

#ifndef RECRUITSKILLTRAINERCALLBACK_H_
#define RECRUITSKILLTRAINERCALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/managers/city/CityManager.h"
#include "server/zone/managers/city/CityRemoveAmenityTask.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "system/lang/Long.h"

class RecruitSkillTrainerSuiCallback : public SuiCallback {
public:
	RecruitSkillTrainerSuiCallback(ZoneServer* server)
		: SuiCallback(server) {
	}

	void run(CreatureObject* player, SuiBox* suiBox, uint32 eventIndex, Vector<UnicodeString>* args) {
		bool cancelPressed = (eventIndex == 1);

		if (cancelPressed)
			return;

		if (args->size() < 1)
			return;

		if (player->getParent() != nullptr)
			return;

		ManagedReference<CityRegion*> city = player->getCityRegion().get();
		CityManager* cityManager = player->getZoneServer()->getCityManager();
		if (city == nullptr || cityManager == nullptr)
			return;

		if (!city->isMayor(player->getObjectID()))
			return;

		Zone* zone = player->getZone();

		PlayerObject* ghost = player->getPlayerObject();
		if (ghost == nullptr)
			return;

		if (!ghost->hasAbility("recruitskilltrainer"))
			return;

		int option = Integer::valueOf(args->get(0).toString());

		//Removing these npcs has to work even when the city is already at its trainer cap.
		if (option == 37) {
			removeCityNpcs(player, city, "spynet_informant", "Spynet Informant");

			return;
		}

		if (option == 38) {
			removeCityNpcs(player, city, "imperial_recruiter", "Imperial Recruiter");

			return;
		}

		if (option == 39) {
			removeCityNpcs(player, city, "rebel_recruiter", "Rebel Recruiter");

			return;
		}

		if (!cityManager->canSupportMoreTrainers(city)) {
					player->sendSystemMessage("@city/city:no_more_trainers"); // Your city can't support any more trainers at its current rank!
					return;
		}

		String trainerTemplatePath = "";
		bool recruiterNpc = false;

		switch (option) {

		case 0: trainerTemplatePath = "trainer_architect";
				break;

		case 1: trainerTemplatePath = "trainer_armorsmith";
				break;

		case 2: trainerTemplatePath = "trainer_artisan";
				break;

		case 3: trainerTemplatePath = "trainer_bioengineer";
				break;

		case 4: trainerTemplatePath = "trainer_bountyhunter";
				break;

		case 5: trainerTemplatePath = "trainer_brawler";
				break;

		case 6: trainerTemplatePath = "trainer_carbine";
				break;

		case 7: trainerTemplatePath = "trainer_chef";
				break;

		case 8: trainerTemplatePath = "trainer_combatmedic";
				break;

		case 9: trainerTemplatePath = "trainer_commando";
				break;

		case 10: trainerTemplatePath = "trainer_creaturehandler";
				break;

		case 11: trainerTemplatePath = "trainer_dancer";
				break;

		case 12: trainerTemplatePath = "trainer_doctor";
				break;

		case 13: trainerTemplatePath = "trainer_droidengineer";
				break;

		case 14: trainerTemplatePath = "trainer_entertainer";
				break;

		case 15: trainerTemplatePath = "trainer_1hsword";
				break;

		case 16: trainerTemplatePath = "trainer_imagedesigner";
				break;

		case 17: trainerTemplatePath = "trainer_marksman";
				break;

		case 18: trainerTemplatePath = "trainer_medic";
				break;

		case 19: trainerTemplatePath = "trainer_merchant";
				break;

		case 20: trainerTemplatePath = "trainer_musician";
				break;

		case 21: trainerTemplatePath = "trainer_pistol";
				break;

		case 22: trainerTemplatePath = "trainer_polearm";
				break;

		case 23: trainerTemplatePath = "trainer_politician";
				break;

		case 24: trainerTemplatePath = "trainer_ranger";
				break;

		case 25: trainerTemplatePath = "trainer_rifleman";
				break;

		case 26: trainerTemplatePath = "trainer_scout";
				break;

		case 27: trainerTemplatePath = "trainer_smuggler";
				break;

		case 28: trainerTemplatePath = "trainer_squadleader";
				break;

		case 29: trainerTemplatePath = "trainer_2hsword";
				break;

		case 30: trainerTemplatePath = "trainer_tailor";
				break;

		case 31: trainerTemplatePath = "trainer_unarmed";
				break;

		case 32: trainerTemplatePath = "trainer_weaponsmith";
				break;

		case 33: trainerTemplatePath = "trainer_jedi";
			break;

		case 34: trainerTemplatePath = "imperial_recruiter";
				recruiterNpc = true;
				break;

		case 35: trainerTemplatePath = "rebel_recruiter";
				recruiterNpc = true;
				break;

		case 36: trainerTemplatePath = "spynet_informant";
				recruiterNpc = true;
				break;

		}

		if (trainerTemplatePath != "") {
			Locker clocker(city, player);

			if(city->getCityTreasury() < 1000) {
				StringIdChatParameter msg;
				msg.setStringId("@city/city:action_no_money");
				msg.setDI(1000);
				player->sendSystemMessage(msg); //"The city treasury must have %DI credits in order to perform that action.");
				return;

			}

			if(player->isSwimming() || player->isIncapacitated() || player->isDead()) {
				return;
			}

			CreatureObject* trainer = zone->getCreatureManager()->spawnCreature(trainerTemplatePath.hashCode(),0,player->getWorldPositionX(),player->getWorldPositionZ(),player->getWorldPositionY(),0,false);

			if (trainer == nullptr) {
				player->sendSystemMessage("@city/city:st_fail"); // Failed to create the skill trainer for some reason. Try again.
				return;
			}

			trainer->rotate(player->getDirectionAngle());

			// Recruiters have no trainer menu component of their own, so without
			// this the mayor would have no radial option to remove them again.
			if (recruiterNpc)
				trainer->setObjectMenuComponent("TrainerMenuComponent");
			city->subtractFromCityTreasury(1000);
			city->addSkillTrainer(trainer);

			//Remember the npc on the city so it is respawned when the city loads again.
			String npcRecord = trainerTemplatePath + "," + String::valueOf(trainer->getObjectID()) + "," + String::valueOf(player->getWorldPositionX()) + "," + String::valueOf(player->getWorldPositionZ()) + "," + String::valueOf(player->getWorldPositionY()) + "," + String::valueOf(trainer->getDirectionAngle());

			city->addCityNpc(npcRecord);

			if (!city->isRegistered()) {
				zone->unregisterObjectWithPlanetaryMap(trainer);
			}
		}
	}

protected:
	/**
	 * Removes every city npc whose template matches templateMatch, using the
	 * records the city keeps so the npcs can be respawned after a restart.
	 */
	void removeCityNpcs(CreatureObject* player, CityRegion* city, const String& templateMatch, const String& npcName) {
		Vector<uint64> npcs;
		int count = city->getCityNpcCount();

		for (int i = 0; i < count; ++i) {
			String record = city->getCityNpc(i);
			int templateEnd = record.indexOf(',');

			if (templateEnd == -1)
				continue;

			if (!record.subString(0, templateEnd).contains(templateMatch))
				continue;

			int objectIDEnd = record.indexOf(',', templateEnd + 1);

			if (objectIDEnd == -1)
				continue;

			npcs.add(UnsignedLong::valueOf(record.subString(templateEnd + 1, objectIDEnd)));
		}

		if (npcs.isEmpty()) {
			player->sendSystemMessage(String("There is no ") + npcName + " in this city.");
			return;
		}

		ZoneServer* zoneServer = player->getZoneServer();

		for (int i = 0; i < npcs.size(); ++i) {
			uint64 npcID = npcs.get(i);
			ManagedReference<SceneObject*> npc = zoneServer->getObject(npcID);

			if (npc == nullptr || !npc->isCreatureObject()) {
				//Already gone from the zone, so there is only the record left to drop.
				city->removeCityNpcByObjectID(npcID);
				continue;
			}

			CityRemoveAmenityTask* task = new CityRemoveAmenityTask(npc, city);
			task->execute();
		}

		player->sendSystemMessage(npcName + " has been removed from the city.");
	}
};

#endif /* RECRUITSKILLTRAINERCALLBACK_H_ */
