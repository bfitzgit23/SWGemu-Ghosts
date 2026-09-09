--/////////////////////////////////////////////////////////
--//		  World Boss Spawn System					//
--//			Created By TOXIC:11/20/2019				//
--////////////////////////////////////////////////////////
--//		Change your world boss under WORLDBOSS		//
--//Spawn Points Will Determain The Boss Spawn location //
--////////////////////////////////////////////////////////
--//		Current World Boss Planet Tatooinw			//
--//		Current World Boss Type CREATURE			//
--///////////////////////////////////////////////////////
worldboss_oneScreenplay = ScreenPlay:new {
	numberOfActs = 1,
  	planet = "tatooine",
}
registerScreenPlay("worldboss_oneScreenplay", true)
-----------------------------
--Start World Boss ScreenPlay
-----------------------------
local function _trim(s)
    if s == nil then return "" end
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Safe wrapper: prevents nil/blank template from turning into CRC 0x0 spam,
-- and prevents Lua stack traces from pcall-safe spawning.
local function safeSpawnMobile(zone, template, respawn, x, y, z, heading, cell)
    if template == nil then
        print("[safeSpawnMobile] nil template zone=" .. tostring(zone))
        return nil
    end

    if type(template) == "string" then
        template = _trim(template)
    end

    if template == "" then
        print("[safeSpawnMobile] empty template zone=" .. tostring(zone))
        return nil
    end

    local ok, result = pcall(spawnMobile, zone, template, respawn, x, y, z, heading, cell)
    if not ok then
        print("[safeSpawnMobile] spawnMobile error zone=" .. tostring(zone) ..
            " template=" .. tostring(template) .. " err=" .. tostring(result))
        return nil
    end

    if result == nil then
        print("[safeSpawnMobile] spawnMobile failed (nil) zone=" .. tostring(zone) ..
            " template=" .. tostring(template))
    end

    return result
end

function worldboss_oneScreenplay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		print("World Boss One Loaded")
	end
end
-----------------------
--The Boss Has Spawned
-----------------------
function worldboss_oneScreenplay:spawnMobiles()
		local pBoss = safeSpawnMobile("tatooine", "worldboss_1", -1, 6617.49, 21.3744, 4249.5, 326, 0)--Spawn World Boss
		local creature = CreatureObject(pBoss)
		print("World Boss One Spawned")
		createObserver(OBJECTDESTRUCTION, "worldboss_oneScreenplay", "bossDead", pBoss)--World Boss Has Died Trigger Respawn Function
end
---------------------------------------------------------------
--The Boss Has Died Respawn WorldBoss With A New Dynamic Spawn
---------------------------------------------------------------
function worldboss_oneScreenplay:bossDead(pBoss)
	print("World Boss One Has Died")
	local creature = CreatureObject(pBoss)
	createEvent(120 * 1000, "worldboss_oneScreenplay", "KillBoss", pBoss, "")--Despawn Corpse
	createEvent(10800 * 1000, "worldboss_oneScreenplay", "KillSpawn", pBoss, "")--Respawn Boss In 3 Hours
	createEvent(1 * 1000, "worldboss_oneScreenplay", "BroadcastDead", pBoss, "")--Broadcast Dead
	createEvent(10800 * 1000, "worldboss_oneScreenplay", "KillSpawnCast3", pBoss, "")--Broadcast Respawn 1
	return 0
end
-----------------------
--Respawn World Boss
-----------------------
function worldboss_oneScreenplay:KillSpawn()
		local pBoss = safeSpawnMobile("tatooine", "worldboss_1", -1, 6617.49, 21.3744, 4249.5, 326, 0)--Spawn WorldBoss After Death 3 Hour Timer
		local creature = CreatureObject(pBoss)
		print("World Boss Spawned 1")
		createObserver(OBJECTDESTRUCTION, "worldboss_oneScreenplay", "bossDead", pBoss)
end
-----------------------------------------------------------------------------
--The Boss Has Died Without Being Looted, "Abandon" Destroy NPC, Destroy Loot
-----------------------------------------------------------------------------
function worldboss_oneScreenplay:KillBoss(pBoss)
	dropObserver(pBoss, OBJECTDESTRUCTION)
	if SceneObject(pBoss) then
		print("Unlooted World Boss One Destroyed")
		SceneObject(pBoss):destroyObjectFromWorld()
	end
	return 0
end
----------------------------
--Broadcast Dead
----------------------------
function worldboss_oneScreenplay:BroadcastDead(bossObject)
		local boss = LuaCreatureObject(bossObject)
		CreatureObject(bossObject):broadcastToServer("\\#63C8F9 Draco World Boss Has Died.")
		CreatureObject(bossObject):broadcastToDiscord("Draco World Boss Has Died.")
end
-----------------------
--Broadcast Respawn 1
-----------------------
function worldboss_oneScreenplay:KillSpawnCast3(bossObject)
		local boss = LuaCreatureObject(bossObject)
		CreatureObject(bossObject):broadcastToServer("\\#63C8F9 Draco World Boss Respawning.")
		CreatureObject(bossObject):broadcastToDiscord("Draco World Boss Respawning.")
end