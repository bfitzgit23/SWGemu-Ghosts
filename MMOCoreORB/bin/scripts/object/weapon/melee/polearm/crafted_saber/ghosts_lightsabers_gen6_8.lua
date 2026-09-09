-- High-generation polearm hilts supplied by Lightsabers.tre.
-- The established Gen 7 Exar Kun template remains in its dedicated file.
local variants = {
	{ "sword_lightsaber_polearm_gen6", 6 },
	{ "sword_lightsaber_polearm_gen6_exar_kun", 6 },
	{ "sword_lightsaber_polearm_gen6_single_blade", 6 },
	{ "sword_lightsaber_polearm_pvp_bf_gen6", 6 },
	{ "sword_lightsaber_polearm_gen7", 7 },
	{ "sword_lightsaber_polearm_gen7_single_blade", 7 },
	{ "sword_lightsaber_polearm_pvp_bf_gen7", 7 },
	{ "sword_lightsaber_polearm_gen8", 8 },
	{ "sword_lightsaber_polearm_gen8_single_blade", 8 },
	{ "sword_lightsaber_polearm_gen8exar_kun", 8 },
	{ "sword_lightsaber_polearm_pvp_bf_gen8", 8 },
}

for _, variant in ipairs(variants) do
	local templateName = variant[1]
	local generation = variant[2]
	local shared = _G["object_weapon_melee_polearm_crafted_saber_shared_" .. templateName]
	local object = shared:new {
		attackType = MELEEATTACK,
		damageType = LIGHTSABER,
		armorPiercing = MEDIUM,
		xpType = "jedi_general",
		certificationsRequired = { "cert_polearmlightsaber_gen4" },
		creatureAccuracyModifiers = { "polearmlightsaber_accuracy" },
		defenderDefenseModifiers = { "melee_defense" },
		defenderSecondaryDefenseModifiers = { "saber_block" },
		speedModifiers = { "polearmlightsaber_speed" },
		defenderToughnessModifiers = { "lightsaber_toughness" },
		gameObjectType = 131080,
		noTrade = 1,
		healthAttackCost = 0,
		actionAttackCost = 0,
		mindAttackCost = 0,
		forceCost = 0,
		pointBlankRange = 0,
		pointBlankAccuracy = 20,
		idealRange = 3,
		idealAccuracy = 15,
		maxRange = 5,
		maxRangeAccuracy = 5,
		minDamage = 225,
		maxDamage = 305,
		attackSpeed = 0,
		woundsRatio = 45,
		childObjects = {
			{templateFile = "object/tangible/inventory/lightsaber_inventory_" .. generation .. ".iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
		},
	}

	_G["object_weapon_melee_polearm_crafted_saber_" .. templateName] = object
	ObjectTemplates:addTemplate(object, "object/weapon/melee/polearm/crafted_saber/" .. templateName .. ".iff")
end
