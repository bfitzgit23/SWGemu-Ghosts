/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef GRANTPADAWANTRIALSELIGIBILITYCOMMAND_H_
#define GRANTPADAWANTRIALSELIGIBILITYCOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/chat/ChatManager.h"
#include "server/zone/managers/player/PlayerMap.h"
#include "server/zone/managers/director/DirectorManager.h"

class GrantPadawanTrialsEligibilityCommand : public QueueCommand {
public:

	GrantPadawanTrialsEligibilityCommand(const String& name, ZoneProcessServer* server)
		: QueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (!creature->isPlayerCreature())
			return GENERALERROR;

		ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

		if (ghost == nullptr || ghost->getAdminLevel() < 5) {
			creature->sendSystemMessage("You do not have permission to use that command.");
			return GENERALERROR;
		}

		String argumentString = arguments.toString().trim();

		StringTokenizer tokenizer(argumentString);
		tokenizer.setDelimeter(" ");

		String mode;
		bool maxed = false;
		bool jediOnly = false;

		if (tokenizer.hasMoreTokens())
			tokenizer.getStringToken(mode);

		mode = mode.toLowerCase();

		if (mode == "max" || mode == "maxed") {
			maxed = true;
		} else if (mode == "jedi" || mode == "jedi-only" || mode == "jedionly" || mode == "maxjedi") {
			maxed = true;
			jediOnly = true;
		}

		// No "full"/"knight"/"max"/"jedi" keyword: preserve the original Padawan unlock.
		if (mode != "full" && mode != "knight" && !maxed) {
			ManagedReference<SceneObject*> object = server->getZoneServer()->getObject(target);

			if (object == nullptr || !object->isCreatureObject())
				return INVALIDTARGET;

			CreatureObject* targetCreature = cast<CreatureObject*>(object.get());

			if (targetCreature == nullptr || !targetCreature->isPlayerCreature())
				return INVALIDTARGET;

			Locker clocker(targetCreature, creature);

			PlayerManager* pman = server->getPlayerManager();

			if (pman == nullptr)
				return GENERALERROR;

			pman->finishHologrind(targetCreature);

			return SUCCESS;
		}

		// Instant Jedi Knight / maxed build. Syntax:
		//   @grantPadawanTrialsEligibility [full|max|jedi] [light|dark] [character name]
		String alignment;
		String requestedName;

		while (tokenizer.hasMoreTokens()) {
			String token;
			tokenizer.getStringToken(token);

			String lower = token.toLowerCase();

			if (lower == "light" || lower == "dark") {
				alignment = lower;
				continue;
			}

			if (lower == "max" || lower == "maxed") {
				maxed = true;
				continue;
			}

			if (lower == "jedi" || lower == "jedi-only" || lower == "jedionly" || lower == "maxjedi") {
				maxed = true;
				jediOnly = true;
				continue;
			}

			if (!requestedName.isEmpty())
				requestedName += " ";

			requestedName += token;
		}

		CreatureObject* targetCreature = nullptr;

		if (!requestedName.isEmpty()) {
			ChatManager* chatManager = server->getZoneServer()->getChatManager();

			if (chatManager == nullptr) {
				creature->sendSystemMessage("Instant Jedi: the player list is unavailable right now.");
				return GENERALERROR;
			}

			Locker chatLocker(chatManager);

			PlayerMap* playerMap = chatManager->getPlayerMap();

			if (playerMap == nullptr) {
				creature->sendSystemMessage("Instant Jedi: the player list is unavailable right now.");
				return GENERALERROR;
			}

			playerMap->resetIterator(false);

			ManagedReference<CreatureObject*> exactMatch = nullptr;
			ManagedReference<CreatureObject*> firstNameMatch = nullptr;
			int firstNameMatches = 0;

			String wanted = requestedName.toLowerCase();

			while (playerMap->hasNext(false)) {
				ManagedReference<CreatureObject*> player = playerMap->getNextValue(false);

				if (player == nullptr)
					continue;

				String displayedName = player->getDisplayedName().toLowerCase();
				String firstName = player->getFirstName().toLowerCase();

				if (displayedName == wanted) {
					exactMatch = player;
					break;
				}

				if (firstName == wanted) {
					firstNameMatch = player;
					++firstNameMatches;
				}
			}

			if (exactMatch != nullptr) {
				targetCreature = exactMatch.get();
			} else if (firstNameMatches == 1) {
				targetCreature = firstNameMatch.get();
			} else if (firstNameMatches > 1) {
				creature->sendSystemMessage("Instant Jedi: more than one online player matches '" + requestedName + "'. Use their full character name.");
				return INVALIDTARGET;
			}

			if (targetCreature == nullptr) {
				creature->sendSystemMessage("Instant Jedi: no online player named '" + requestedName + "'. They must be logged in.");
				return INVALIDTARGET;
			}
		} else {
			if (target == 0 || target == creature->getObjectID()) {
				creature->sendSystemMessage("Instant Jedi syntax: @grantPadawanTrialsEligibility [full|max|jedi] [light|dark] [character name]");
				creature->sendSystemMessage("Target the player, or put their character name after 'full', 'max' or 'jedi'.");
				return INVALIDTARGET;
			}

			ManagedReference<SceneObject*> object = server->getZoneServer()->getObject(target);

			if (object == nullptr || !object->isCreatureObject()) {
				creature->sendSystemMessage("Instant Jedi: target a player, or put their character name after 'full', 'max' or 'jedi'.");
				return INVALIDTARGET;
			}

			targetCreature = cast<CreatureObject*>(object.get());
		}

		if (targetCreature == nullptr || !targetCreature->isPlayerCreature()) {
			creature->sendSystemMessage("Instant Jedi: that target is not a player character.");
			return INVALIDTARGET;
		}

		Lua* lua = DirectorManager::instance()->getLuaInstance();

		if (lua == nullptr) {
			creature->sendSystemMessage("Instant Jedi: the Lua engine is unavailable.");
			return GENERALERROR;
		}

		Reference<LuaFunction*> grant = lua->createFunction("HolocronJedi", "instantGrantJedi", 0);

		if (grant == nullptr) {
			creature->sendSystemMessage("Instant Jedi: grant handler missing (HolocronJedi:instantGrantJedi).");
			return GENERALERROR;
		}

		*grant << targetCreature;
		*grant << alignment;
		*grant << maxed;
		*grant << jediOnly;

		grant->callFunction();

		String alignmentLabel = alignment.isEmpty() ? String("server default") : alignment;
		String buildLabel = maxed ? (jediOnly ? String(", JEDI-ONLY MAX build") : String(", MAX build")) : String("");

		creature->sendSystemMessage("Instant Jedi: processed " + targetCreature->getDisplayedName() + " (" + alignmentLabel + buildLabel + ").");

		return SUCCESS;
	}

};

#endif //GRANTPADAWANTRIALSELIGIBILITYCOMMAND_H_
