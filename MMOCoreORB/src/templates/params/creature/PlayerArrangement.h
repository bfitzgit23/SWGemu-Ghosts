/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef PLAYERARRANGEMENT_H_
#define PLAYERARRANGEMENT_H_

class PlayerArrangement {
public:
	// The server and the client resolve a containment type to the player
	// arrangement group with (containmentType - 4), so these numbers must line
	// up with abstract/slot/arrangement/player.iff as shipped in ghosts10.tre
	// (rider, rider1..rider7, ship_pilot, ship_operations, ship_gunner0..7,
	// ship_pilot_pob, ship_operations_pob, ship_gunner0..7_pob).
	enum {
		RIDER			= 4,   // group 0  rider
		SHIP_PILOT		= 12,  // group 8  ship_pilot
		SHIP_OPERATIONS		= 13,  // group 9  ship_operations
		SHIP_GUNNER0		= 14,  // group 10 ship_gunner0
		SHIP_GUNNER1		= 15,
		SHIP_GUNNER2		= 16,
		SHIP_GUNNER3		= 17,
		SHIP_GUNNER4		= 18,
		SHIP_GUNNER5		= 19,
		SHIP_GUNNER6		= 20,
		SHIP_GUNNER7		= 21,
		SHIP_PILOT_POB		= 22,  // group 18 ship_pilot_pob
		SHIP_OPERATIONS_POB	= 23,  // group 19 ship_operations_pob
		SHIP_GUNNER0_POB	= 24,  // group 20 ship_gunner0_pob
		SHIP_GUNNER1_POB	= 25,
		SHIP_GUNNER2_POB	= 26,
		SHIP_GUNNER3_POB	= 27,
		SHIP_GUNNER4_POB	= 28,
		SHIP_GUNNER5_POB	= 29,
		SHIP_GUNNER6_POB	= 30,
		SHIP_GUNNER7_POB	= 31,
	};
};

#endif /* PLAYERARRANGEMENT_H_ */
