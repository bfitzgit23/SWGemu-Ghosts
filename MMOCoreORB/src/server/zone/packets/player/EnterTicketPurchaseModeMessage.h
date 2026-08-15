/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef ENTERTICKETPURCHASEMODEMESSAGE_H_
#define ENTERTICKETPURCHASEMODEMESSAGE_H_

#include "engine/service/proto/BaseMessage.h"
#include "server/zone/managers/planet/PlanetTravelPoint.h"

class EnterTicketPurchaseModeMessage : public BaseMessage {
public:
    EnterTicketPurchaseModeMessage(PlanetTravelPoint* ptp) {
		insertShort(0x04);
		insertInt(0x904DAE1A);  // CRC
        String pointZone = ptp->getPointZone();
        String pointName = ptp->getPointName();
        if (pointZone.isEmpty())
            pointZone = "tatooine";
        if (pointName.isEmpty())
            pointName = "Mos Eisley Starport";
        insertAscii(pointZone);
        insertAscii(pointName);
        insertByte(0);
    }
};

#endif /*ENTERTICKETPURCHASEMODEMESSAGE_H_*/
