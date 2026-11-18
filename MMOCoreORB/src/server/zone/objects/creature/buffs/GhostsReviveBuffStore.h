/*
			Copyright <SWGEmu>
	See file COPYING for copying conditions.*/

#ifndef GHOSTSREVIVEBUFFSTORE_H_
#define GHOSTSREVIVEBUFFSTORE_H_

#include "engine/engine.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/buffs/Buff.h"
#include "server/zone/objects/creature/buffs/BuffList.h"

/**
 * Doctor, entertainer and other timed buffs are cleared the moment a player
 * dies, so a Force Revive would have nothing to hand back. Snapshot the timers
 * at death and re-apply them when the player is raised.
 *
 * Each buff is packed into one 64 bit value (crc | type | seconds) so the store
 * only holds containers the engine can serialize.
 */
namespace GhostsReviveBuffs {

inline Mutex& storeMutex() {
	static Mutex mutex;
	return mutex;
}

inline VectorMap<uint64, Vector<uint64> >& store() {
	static VectorMap<uint64, Vector<uint64> > saved;
	return saved;
}

inline uint64 packBuff(uint32 crc, int type, float duration) {
	uint64 seconds = duration > 0 ? (uint64) duration : 0;

	if (seconds > 0xFFFFFF)
		seconds = 0xFFFFFF;

	return ((uint64) crc << 32) | ((uint64) (type & 0xFF) << 24) | seconds;
}

inline void unpackBuff(uint64 packed, uint32& crc, int& type, float& duration) {
	crc = (uint32) (packed >> 32);
	type = (int) ((packed >> 24) & 0xFF);
	duration = (float) (packed & 0xFFFFFF);
}

inline void save(CreatureObject* creature) {
	if (creature == nullptr || !creature->isPlayerCreature())
		return;

	const BuffList* buffList = creature->getBuffList();

	if (buffList == nullptr)
		return;

	Vector<uint64> buffs;

	for (int i = 0; i < buffList->getBuffListSize(); ++i) {
		ManagedReference<Buff*> buff = buffList->getBuffByIndex(i);

		if (buff == nullptr)
			continue;

		Locker locker(buff);

		float duration = buff->getBuffDuration();

		if (duration <= 0)
			continue;

		buffs.add(packBuff(buff->getBuffCRC(), buff->getBuffType(), duration));
	}

	Locker locker(&storeMutex());

	store().put(creature->getObjectID(), buffs);
}

inline int restore(CreatureObject* creature) {
	if (creature == nullptr || !creature->isPlayerCreature())
		return 0;

	Vector<uint64> buffs;

	{
		Locker locker(&storeMutex());

		int index = store().find(creature->getObjectID());

		if (index == -1)
			return 0;

		buffs = store().get(index);
		store().remove(index);
	}

	int restored = 0;

	for (int i = 0; i < buffs.size(); ++i) {
		uint32 crc = 0;
		int type = 0;
		float duration = 0;

		unpackBuff(buffs.get(i), crc, type, duration);

		if (crc == 0 || duration <= 0)
			continue;

		ManagedReference<Buff*> buff = new Buff(creature, crc, duration, type);

		if (buff == nullptr)
			continue;

		Locker locker(buff);

		creature->addBuff(buff);

		++restored;
	}

	return restored;
}

}

#endif //GHOSTSREVIVEBUFFSTORE_H_
