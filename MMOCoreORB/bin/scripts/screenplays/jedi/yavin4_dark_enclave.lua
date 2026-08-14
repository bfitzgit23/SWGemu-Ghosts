-- Coded by BoosterSteel 19-03-2026
local ObjectManager = require("managers.object.object_manager")
--Dark Jedi Enclave (5068, 310)
Yavin4DarkEnclaveScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	cellIds = {
	-- thm_yavn_jedi_enclave_dark
		outside = 3435626,
		ramp1 = 3435627,
		landing1 = 3435628,
		ramp2 = 3435629,
		landing2 = 3435630,
		ramp3 = 3435631,
		landing3 = 3435632,
		foyer = 3435633,
		antechamber = 3435634,
		cloning = 3435635,
		arenahall = 3435636,
		mainroom = 3435643,
		hallwayb0 = 3435648,
		hallwaya0 = 3435649,
		hallwaya1 = 3435637,
		hallwayb1 = 3435644,
		council1 = 3435650,
		hallwayb2 = 3435645,
		hallwayb3 = 3435646,
		council2 = 3435651,
		council3 = 3435652,
		hallwaya2 = 3435638,
		council4 = 3435653,
		hallwaya3 = 3435639,
		hallwaya4 = 3435640,
		hallwayb4 = 3435647,
		chamberramp = 3435641,
		chamber = 3435642,

	},

	targetItems = {
		{ "object/tangible/terminal/terminal_dark_enclave_voting.iff",
			"object/tangible/terminal/terminal_dark_enclave_challenge.iff" },
		{ "object/tangible/furniture/jedi/frn_all_dark_throne.iff" },
	},

	doorData = {
		{ worldX = 5055.4, worldZ = 74.5, worldY = 308.0, cellAccess = 3435627 }, -- Entrance
		{ worldX = 5019.8, worldZ = 31.6, worldY = 310.1, cellAccess = 3435636 }, -- arenahall (to mainroom)
		{ worldX = 5011.3, worldZ = 35.8, worldY = 337.5, cellAccess = 3435644 }, -- hallway1 (to council1)
		{ worldX = 4982.5, worldZ = 37.3, worldY = 333.0, cellAccess = 3435645 }, -- hallwaya2 (to council2)
		{ worldX = 5011.5, worldZ = 35.7, worldY = 282.9, cellAccess = 3435637 }, -- hallwaya1 (to council3)
		{ worldX = 4984.6, worldZ = 36.8, worldY = 287.0, cellAccess = 3435638 }, -- hallwaya2 (to council4)
		{ worldX = 4971.0, worldZ = 37.6, worldY = 291.3, cellAccess = 3435638 }, -- mainroom/hallwaya2 (to council3,4,chamber)
		{ worldX = 4958.0, worldZ = 39.6, worldY = 291.0, cellAccess = 3435640 }, -- hallwaya4 (to chamber)
		{ worldX = 4957.9, worldZ = 39.6, worldY = 329.4, cellAccess = 3435647 }, -- hallwayb4 (to chamber)
	},

	states = {
		2,--Enclave eligible
		4,--Enforcer rank
		8,--Templar rank
		16,--Oppressor rank
		32,--Dark Council Member
		64,--Dark Council Leader
		128--has cloned to Enclave
	},

	doorMessages = {
		{ unlock = "", lock = "@pvp_rating:enclave_deny_entry" }, -- "A strange force repels you and keeps you from entering."
		{ unlock = "", lock = "@pvp_rating:enclave_deny_pet_entry"} -- "As you are not permitted to bring any pets or hirelings into the enclave. They have been returned to your data pad for you."
	},

	buildingID = 3435626,

	forceEnergy = { x = 5087.7, z = 79.7, y = 306.2 },
	forcePush = { x = 0.1, z = -43.4, y = -31.1 },

	sensitive = "force_title_jedi_novice",
	initiate = "force_title_jedi_rank_01",
	padawan = "force_title_jedi_rank_02",
	knight = "force_title_jedi_rank_03",
	guardian = "force_title_jedi_rank_04",
	master = "force_title_jedi_master",
	rankings = "force_rank_dark",
	member = "force_rank_dark_novice",
	enforcerone = "force_rank_dark_rank_01",
	enforcertwo = "force_rank_dark_rank_02",
	enforcerthree = "force_rank_dark_rank_03",
	enforcerfour = "force_rank_dark_rank_04",
	templarone = "force_rank_dark_rank_05",
	templartwo = "force_rank_dark_rank_06",
	templarthree = "force_rank_dark_rank_07",
	oppressorone = "force_rank_dark_rank_08",
	oppressortwo = "force_rank_dark_rank_09",
	councilmember = "force_rank_dark_rank_10",
	councilleader = "force_rank_dark_master",
}

registerScreenPlay("Yavin4DarkEnclaveScreenPlay", true)

function Yavin4DarkEnclaveScreenPlay:start()
	if (isZoneEnabled("yavin4")) then

		self:spawnObjects()
	end
end

function Yavin4DarkEnclaveScreenPlay:spawnObjects()
	local spawnedSceneObject = LuaSceneObject(nil)
	local spawnedPointer

	local pActiveArea = spawnActiveArea("yavin4", "object/active_area.iff", 5055.4, 74.5, 308.0, 178, 3435627)
	if pActiveArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredEnclave", pActiveArea)
	end

	local pTieroneArea = spawnActiveArea("yavin4", "object/active_area.iff", 5011.3, 35.8, 337.5, -107, 3435644)
	if pTieroneArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierOneRoom", pTieroneArea)
	end

	local pTiertwoArea = spawnActiveArea("yavin4", "object/active_area.iff", 4982.5, 37.3, 333.0, -104, 3435645)
	if pTiertwoArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierTwoRoom", pTiertwoArea)
	end

	local pTierthreeArea = spawnActiveArea("yavin4", "object/active_area.iff", 5011.5, 35.7, 282.9, -86, 3435637)
	if pTierthreeArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierThreeRoom", pTierthreeArea)
	end

	local pTierfourArea = spawnActiveArea("yavin4", "object/active_area.iff", 4984.6, 36.8, 287.0, -83, 3435638)
	if pTierfourArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFourRoom", pTierfourArea)
	end

	local pTiertfcArea = spawnActiveArea("yavin4", "object/active_area.iff", 4971.0, 37.6, 291.3, -179, 3435638)
	if pTiertfcArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierThreeFourChmbrRoom", pTiertfcArea)
	end

	local pTierfiveArea = spawnActiveArea("yavin4", "object/active_area.iff", 4958.0, 39.6, 291.0, -85, 3435640)
	if pTierfiveArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFiveRoom", pTierfiveArea)
	end

	local pTierfivetooArea = spawnActiveArea("yavin4", "object/active_area.iff", 4957.9, 39.6, 329.4, -103, 3435647)
	if pTierfivetooArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFiveTooRoom", pTierfivetooArea)
	end

        --FRS Shrine
        spawnSceneObject("yavin4", "object/tangible/quest/col_jedi_robi_light_jedi_controller.iff", 17.0156, -43.4244, -37.6354, 3435634, 0.998624, 0, -0.0524352, 0)
	spawnSceneObject("yavin4", "object/tangible/quest/col_jedi_robi_light_jedi_controller.iff", -16.3213, -43.4244, -37.6518, 3435634, 0.99741, 0, -0.0719286, 0)

	-- Dark knight trial arena trigger — active area inside the mainroom (cell 3435643)

 
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredEnclave(pArea, pLifeform)
	return ObjectManager.withCreatureObject(pLifeform, function(lifeform)
	if (pLifeform == nil) then
		return 0
	end

	-- Boot wild NPCs and pets first
	if not SceneObject(pLifeform):isPlayerCreature() then
		if SceneObject(pLifeform):isAiAgent() then
			if AiAgent(pLifeform):isPet() then
				local pOwner = CreatureObject(pLifeform):getOwner()
				AiAgent(pLifeform):clearCombatState()
				AiAgent(pLifeform):doDespawn()
				if pOwner ~= nil then
					CreatureObject(pOwner):sendSystemMessage("@pvp_rating:enclave_deny_pet_entry")
				end
			else
				AiAgent(pLifeform):clearCombatState()
				AiAgent(pLifeform):leash()
			end
		end
		return 0
	end

	if (SceneObject(pLifeform):isPlayerCreature()) then
		-- Use HolocronJedi storage - matches holocron.lua system
		local status    = readScreenPlayData(pLifeform, "HolocronJedi", "jedi_status")
		local alignment = readScreenPlayData(pLifeform, "HolocronJedi", "jedi_alignment")
		if status == nil then status = "" end
		if alignment == nil then alignment = "" end

		-- Must be at least padawan
		if status ~= "padawan" and status ~= "knight" and status ~= "master" and status ~= "master_phase2" then
			CreatureObject(pLifeform):sendSystemMessage("\\#FF4444 You have not yet awakened to the Force. The enclave's power repels you.")
			CreatureObject(pLifeform):teleport(self.forceEnergy.x, self.forceEnergy.z, self.forceEnergy.y, 0)
		-- Only boot players who have EXPLICITLY chosen the light side.
		-- Players with no alignment (nil/"") are seeking the trial and are allowed in.
		elseif alignment == "light" then
			CreatureObject(pLifeform):sendSystemMessage("\\#FF4444 The darkness here recoils from the light within you. Seek the Light Jedi Enclave.")
			CreatureObject(pLifeform):teleport(self.forceEnergy.x, self.forceEnergy.z, self.forceEnergy.y, 0)
		else
			-- Determine rank label - Dark Lord progression takes priority
			local rank
			local creature = CreatureObject(pLifeform)
			if creature:hasSkill("jedi_dark_lord_novice") then
				rank = "Dark Lord"
			else
				rank = (status == "master" and "Master" or status == "knight" and "Knight" or "Padawan")
			end
			if alignment == "" or alignment == nil then
				CreatureObject(pLifeform):sendSystemMessage("\\#FF4444 The dark side stirs within you, " .. rank .. ". Seek the Challenge Terminal to begin your trial.")
			else
				CreatureObject(pLifeform):sendSystemMessage("\\#FF4444 The darkness welcomes you, " .. rank .. ". Enter.")
			end
		end
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierOneRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- If trial is pending (wave == -1), start it now that player has walked in
	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.enforcerfour)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierTwoRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.templarthree)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierThreeRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.oppressortwo)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you even further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierThreeFourChmbrRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.oppressortwo)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you even further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFourRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilmember)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you onto a greater path.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFiveRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilleader)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council beckons you, Sith Lord.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFiveTooRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilleader)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council beckons you, Sith Lord.")
	end

	return 0
    end)
end
local ObjectManager = require("managers.object.object_manager")
--Dark Jedi Enclave (5068, 310)
Yavin4DarkEnclaveScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	cellIds = {
	-- thm_yavn_jedi_enclave_dark
		outside = 3435626,
		ramp1 = 3435627,
		landing1 = 3435628,
		ramp2 = 3435629,
		landing2 = 3435630,
		ramp3 = 3435631,
		landing3 = 3435632,
		foyer = 3435633,
		antechamber = 3435634,
		cloning = 3435635,
		arenahall = 3435636,
		mainroom = 3435643,
		hallwayb0 = 3435648,
		hallwaya0 = 3435649,
		hallwaya1 = 3435637,
		hallwayb1 = 3435644,
		council1 = 3435650,
		hallwayb2 = 3435645,
		hallwayb3 = 3435646,
		council2 = 3435651,
		council3 = 3435652,
		hallwaya2 = 3435638,
		council4 = 3435653,
		hallwaya3 = 3435639,
		hallwaya4 = 3435640,
		hallwayb4 = 3435647,
		chamberramp = 3435641,
		chamber = 3435642,

	},

	targetItems = {
		{ "object/tangible/terminal/terminal_dark_enclave_voting.iff",
			"object/tangible/terminal/terminal_dark_enclave_challenge.iff" },
		{ "object/tangible/furniture/jedi/frn_all_dark_throne.iff" },
	},

	doorData = {
		{ worldX = 5055.4, worldZ = 74.5, worldY = 308.0, cellAccess = 3435627 }, -- Entrance
		{ worldX = 5019.8, worldZ = 31.6, worldY = 310.1, cellAccess = 3435636 }, -- arenahall (to mainroom)
		{ worldX = 5011.3, worldZ = 35.8, worldY = 337.5, cellAccess = 3435644 }, -- hallway1 (to council1)
		{ worldX = 4982.5, worldZ = 37.3, worldY = 333.0, cellAccess = 3435645 }, -- hallwaya2 (to council2)
		{ worldX = 5011.5, worldZ = 35.7, worldY = 282.9, cellAccess = 3435637 }, -- hallwaya1 (to council3)
		{ worldX = 4984.6, worldZ = 36.8, worldY = 287.0, cellAccess = 3435638 }, -- hallwaya2 (to council4)
		{ worldX = 4971.0, worldZ = 37.6, worldY = 291.3, cellAccess = 3435638 }, -- mainroom/hallwaya2 (to council3,4,chamber)
		{ worldX = 4958.0, worldZ = 39.6, worldY = 291.0, cellAccess = 3435640 }, -- hallwaya4 (to chamber)
		{ worldX = 4957.9, worldZ = 39.6, worldY = 329.4, cellAccess = 3435647 }, -- hallwayb4 (to chamber)
	},

	states = {
		2,--Enclave eligible
		4,--Enforcer rank
		8,--Templar rank
		16,--Oppressor rank
		32,--Dark Council Member
		64,--Dark Council Leader
		128--has cloned to Enclave
	},

	doorMessages = {
		{ unlock = "", lock = "@pvp_rating:enclave_deny_entry" }, -- "A strange force repels you and keeps you from entering."
		{ unlock = "", lock = "@pvp_rating:enclave_deny_pet_entry"} -- "As you are not permitted to bring any pets or hirelings into the enclave. They have been returned to your data pad for you."
	},

	buildingID = 3435626,

	forceEnergy = { x = 5087.7, z = 79.7, y = 306.2 },
	forcePush = { x = 0.1, z = -43.4, y = -31.1 },

	sensitive = "force_title_jedi_novice",
	initiate = "force_title_jedi_rank_01",
	padawan = "force_title_jedi_rank_02",
	knight = "force_title_jedi_rank_03",
	guardian = "force_title_jedi_rank_04",
	master = "force_title_jedi_master",
	rankings = "force_rank_dark",
	member = "force_rank_dark_novice",
	enforcerone = "force_rank_dark_rank_01",
	enforcertwo = "force_rank_dark_rank_02",
	enforcerthree = "force_rank_dark_rank_03",
	enforcerfour = "force_rank_dark_rank_04",
	templarone = "force_rank_dark_rank_05",
	templartwo = "force_rank_dark_rank_06",
	templarthree = "force_rank_dark_rank_07",
	oppressorone = "force_rank_dark_rank_08",
	oppressortwo = "force_rank_dark_rank_09",
	councilmember = "force_rank_dark_rank_10",
	councilleader = "force_rank_dark_master",
}

registerScreenPlay("Yavin4DarkEnclaveScreenPlay", true)

function Yavin4DarkEnclaveScreenPlay:start()
	if (isZoneEnabled("yavin4")) then

		self:spawnObjects()
	end
end

function Yavin4DarkEnclaveScreenPlay:spawnObjects()
	local spawnedSceneObject = LuaSceneObject(nil)
	local spawnedPointer

	local pActiveArea = spawnActiveArea("yavin4", "object/active_area.iff", 5055.4, 74.5, 308.0, 178, 3435627)
	if pActiveArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredEnclave", pActiveArea)
	end

	local pTieroneArea = spawnActiveArea("yavin4", "object/active_area.iff", 5011.3, 35.8, 337.5, -107, 3435644)
	if pTieroneArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierOneRoom", pTieroneArea)
	end

	local pTiertwoArea = spawnActiveArea("yavin4", "object/active_area.iff", 4982.5, 37.3, 333.0, -104, 3435645)
	if pTiertwoArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierTwoRoom", pTiertwoArea)
	end

	local pTierthreeArea = spawnActiveArea("yavin4", "object/active_area.iff", 5011.5, 35.7, 282.9, -86, 3435637)
	if pTierthreeArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierThreeRoom", pTierthreeArea)
	end

	local pTierfourArea = spawnActiveArea("yavin4", "object/active_area.iff", 4984.6, 36.8, 287.0, -83, 3435638)
	if pTierfourArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFourRoom", pTierfourArea)
	end

	local pTiertfcArea = spawnActiveArea("yavin4", "object/active_area.iff", 4971.0, 37.6, 291.3, -179, 3435638)
	if pTiertfcArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierThreeFourChmbrRoom", pTiertfcArea)
	end

	local pTierfiveArea = spawnActiveArea("yavin4", "object/active_area.iff", 4958.0, 39.6, 291.0, -85, 3435640)
	if pTierfiveArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFiveRoom", pTierfiveArea)
	end

	local pTierfivetooArea = spawnActiveArea("yavin4", "object/active_area.iff", 4957.9, 39.6, 329.4, -103, 3435647)
	if pTierfivetooArea ~= nil then
		createObserver(ENTEREDAREA, "Yavin4DarkEnclaveScreenPlay", "notifyEnteredTierFiveTooRoom", pTierfivetooArea)
	end

        --FRS Shrine
        spawnSceneObject("yavin4", "object/tangible/quest/col_jedi_robi_light_jedi_controller.iff", 17.0156, -43.4244, -37.6354, 3435634, 0.998624, 0, -0.0524352, 0)
	spawnSceneObject("yavin4", "object/tangible/quest/col_jedi_robi_light_jedi_controller.iff", -16.3213, -43.4244, -37.6518, 3435634, 0.99741, 0, -0.0719286, 0)

	-- Dark knight trial arena trigger — active area inside the mainroom (cell 3435643)

 
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierOneRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- If trial is pending (wave == -1), start it now that player has walked in
	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.enforcerfour)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierTwoRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.templarthree)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierThreeRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.oppressortwo)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you even further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierThreeFourChmbrRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.oppressortwo)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you even further.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFourRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilmember)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council seduces you onto a greater path.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFiveRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilleader)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council beckons you, Sith Lord.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredTierFiveTooRoom(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	-- Skip rank check if trial is running
	local trialWave = readData("DarkKnightTrial:" .. SceneObject(pJedi):getObjectID() .. ":wave")
	if trialWave ~= nil and trialWave > 0 then return 0 end

	if (not CreatureObject(pJedi):hasSkill(self.councilleader)) then
		CreatureObject(pJedi):sendSystemMessage("@pvp_rating:enclave_deny_entry")
		CreatureObject(pJedi):teleport(self.forcePush.x, self.forcePush.z, self.forcePush.y, 3435634)
	else
		CreatureObject(pJedi):sendSystemMessage("The Dark Council beckons you, Sith Lord.")
	end

	return 0
    end)
end

function Yavin4DarkEnclaveScreenPlay:notifyEnteredArena(pArea, pJedi)
	return ObjectManager.withCreaturePlayerObject(pJedi, function(playerObject)

	local id = SceneObject(pJedi):getObjectID()
	local trialWave = readData("DarkKnightTrial:" .. id .. ":wave")

	-- Start the trial if player accepted it and has now walked in (wave == -1)
	if trialWave ~= nil and trialWave == -1 then
		writeData("DarkKnightTrial:" .. id .. ":wave", 1)
		writeData("DarkKnightTrial:" .. id .. ":mob_id", 0)
		createEvent(500, "DarkEnclaveKnight", "doSpawnWave", pJedi, "1")
	end

	return 0
    end)
end