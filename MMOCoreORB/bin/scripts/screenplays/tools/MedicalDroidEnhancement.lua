MedicalDroidEnhancement = ScreenPlay:new {
	numberOfActs = 1,
	droidTemplate = "surgical_droid_21b",
	droidName = "2-1B Medical Enhancement Droid",
	buffAmount = 2200,
	buffDuration = 7200,
	interactionRange = 16,
	locations = {
		-- Corellia
		{"corellia", -180.496, 28, -4845.4},
		{"corellia", -5049.64, 21, -2304.52},
		{"corellia", 3330.38, 308, 5517.14},
		{"corellia", -3128.1, 31, 2809.5},

		-- Dantooine
		{"dantooine", 1585.68, 4, -6368.95},
		{"dantooine", -629.417, 3, 2481.24},
		{"dantooine", -4221, 3, -2357},

		-- Dathomir
		{"dathomir", 592.612, 6, 3089.84},
		{"dathomir", -67.6585, 18, -1595.3},

		-- Endor
		{"endor", -963.537, 73, 1556.86},
		{"endor", 3240.5, 24, -3484.79},

		-- Lok
		{"lok", 464.677, 8.75806, 5506.49},

		-- Naboo
		{"naboo", 4824.53, 4.17, -4704.9},
		{"naboo", -4860.75, 6.48, 4179.6},
		{"naboo", 5193.14, -192, 6680.25},
		{"naboo", 1442.51, 13, 2782.89},

		-- Rori
		{"rori", -5307.37, 80.1274, -2216.91},
		{"rori", 5370.22, 80, 5666.04},
		{"rori", 3672.91, 96, -6441.07},

		-- Talus
		{"talus", 4447.08, 2, 5286.96},
		{"talus", 329.666, 6, -2924.69},
		{"talus", -2223, 20, 2310},

		-- Tatooine
		{"tatooine", 1271.4, 7.70605, 2960.54},
		{"tatooine", 1326.88, 7, 3466.45},
		{"tatooine", 1716.57, 7, 3187.24},
		{"tatooine", 1538.29, 7, 3460.2},
		{"tatooine", 1139.77, 7, 3019.46},
		{"tatooine", 3533.45, 5, -4792.05},
		{"tatooine", 43.8562, 52, -5352.49},
		{"tatooine", -5222.83, 75, -6585.29},
		{"tatooine", -1273, 12, -3592},
		{"tatooine", -2904, 5, 2119},

		-- Yavin 4
		{"yavin4", -6917.18, 73, -5732.25},
		{"yavin4", 4069.07, 37, -6216.48},
		{"yavin4", -293.367, 35, 4854.52},
	}
}

registerScreenPlay("MedicalDroidEnhancement", true)

function MedicalDroidEnhancement:start()
	for i = 1, #self.locations do
		local location = self.locations[i]
		local pDroid = spawnMobile(location[1], self.droidTemplate, 60,
			location[2], location[3], location[4], 0, 0)

		if pDroid ~= nil then
			SceneObject(pDroid):setCustomObjectName(self.droidName)
			SceneObject(pDroid):setObjectMenuComponent("MedicalDroidEnhancementMenuComponent")
		else
			print("MedicalDroidEnhancement: failed to spawn medical droid on " .. location[1] ..
				" at " .. location[2] .. ", " .. location[4])
		end
	end
end

function MedicalDroidEnhancement:canEnhance(pPlayer, pDroid)
	if pPlayer == nil or pDroid == nil then
		return false
	end

	if not SceneObject(pPlayer):isPlayerCreature() then
		return false
	end

	if SceneObject(pPlayer):getDistanceTo(pDroid) > self.interactionRange then
		CreatureObject(pPlayer):sendSystemMessage("You are too far away from the medical droid.")
		return false
	end

	if CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() then
		CreatureObject(pPlayer):sendSystemMessage("Medical enhancement is unavailable in your current condition.")
		return false
	end

	if CreatureObject(pPlayer):isInCombat() then
		CreatureObject(pPlayer):sendSystemMessage("Medical enhancement is unavailable while you are in combat.")
		return false
	end

	return true
end

function MedicalDroidEnhancement:applyEnhancement(pPlayer, pDroid)
	if not self:canEnhance(pPlayer, pDroid) then
		return
	end

	spatialChat(pDroid, "Greetings. Medical enhancement protocols are available.")
	spatialChat(pDroid, "Medical enhancement sequence initiated. Please remain still.")

	-- Use the established nine-buff service path so the client receives the
	-- normal medical/performance buff CRCs, icons and remaining-time displays.
	-- A single custom CRC applies the statistics server-side, but has no client
	-- presentation data and therefore appears to have no visible buff timer.
	CreatureObject(pPlayer):applyMedicalServiceBuff(
		self.buffDuration,
		self.buffAmount, self.buffAmount, self.buffAmount,
		self.buffAmount, self.buffAmount, self.buffAmount,
		self.buffAmount, self.buffAmount, self.buffAmount)

	spatialChat(pDroid, "Enhancement complete. Your vital systems have been reinforced.")
	CreatureObject(pPlayer):sendSystemMessage("Medical Droid Enhancement applied: +2200 to all nine HAM attributes for 2 hours.")
end

MedicalDroidEnhancementMenuComponent = {}

function MedicalDroidEnhancementMenuComponent:fillObjectMenuResponse(pObject, pMenuResponse, pPlayer)
	if pObject == nil or pPlayer == nil then
		return
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "Request Medical Enhancement")
	menuResponse:addRadialMenuItem(21, 3, "Never mind.")
end

function MedicalDroidEnhancementMenuComponent:handleObjectMenuSelect(pObject, pPlayer, selectedID)
	if pObject == nil or pPlayer == nil then
		return 0
	end

	if selectedID == 20 then
		MedicalDroidEnhancement:applyEnhancement(pPlayer, pObject)
	elseif selectedID == 21 then
		spatialChat(pObject, "Very well. Medical enhancement protocols remain available.")
	end

	return 0
end
