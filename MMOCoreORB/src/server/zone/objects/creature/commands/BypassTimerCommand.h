/*
                Copyright <SWGEmu>
        See file COPYING for copying conditions.
*/

#ifndef BYPASSTIMERCOMMAND_H_
#define BYPASSTIMERCOMMAND_H_

#include "QueueCommand.h"
#include "server/zone/managers/director/DirectorManager.h"

class BypassTimerCommand : public QueueCommand {
public:
    BypassTimerCommand(const String& name, ZoneProcessServer* server)
        : QueueCommand(name, server) {
    }

    int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
        if (!checkStateMask(creature))
            return INVALIDSTATE;

        if (!checkInvalidLocomotions(creature))
            return INVALIDLOCOMOTION;

        PlayerObject* ghost = creature->getPlayerObject().get();
        if (ghost == nullptr || ghost->getAdminLevel() < 15) {
            creature->sendSystemMessage("You must be administrator level 15 to use /bypasstimer.");
            return GENERALERROR;
        }

        Lua* lua = DirectorManager::instance()->getLuaInstance();
        Reference<LuaFunction*> function = lua->createFunction("HolocronJedi", "bypassProgressionTimers", 0);
        *function << creature;
        function->callFunction();

        return SUCCESS;
    }
};

#endif // BYPASSTIMERCOMMAND_H_
