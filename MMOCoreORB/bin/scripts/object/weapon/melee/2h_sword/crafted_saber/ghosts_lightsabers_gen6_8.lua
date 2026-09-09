-- High-generation two-handed hilts supplied by Lightsabers.tre.
-- The already-established Gen 6 Mustafarian and Gen 7 Sith templates remain
-- in their dedicated files and are intentionally omitted here.
local variants = {
	{ "sword_lightsaber_two_handed_gen6", 6 },
	{ "sword_lightsaber_two_handed_gen6_eow", 6 },
	{ "sword_lightsaber_two_handed_gcw_s01_gen6", 6 },
	{ "sword_lightsaber_two_handed_gen6_sith", 6 },
	{ "sword_lightsaber_two_handed_pvp_bf_gen6", 6 },
	{ "sword_lightsaber_two_handed_gen7", 7 },
	{ "sword_lightsaber_two_handed_gen7_eow", 7 },
	{ "sword_lightsaber_two_handed_gcw_s01_gen7", 7 },
	{ "sword_lightsaber_two_handed_gen7_must", 7 },
	{ "sword_lightsaber_two_handed_pvp_bf_gen7", 7 },
	{ "sword_lightsaber_two_handed_gen8", 8 },
	{ "sword_lightsaber_two_handed_gen8_eow", 8 },
	{ "sword_lightsaber_two_handed_gcw_s01_gen8", 8 },
	{ "sword_lightsaber_two_handed_gen8_must", 8 },
	{ "sword_lightsaber_two_handed_gen8_sith", 8 },
	{ "sword_lightsaber_two_handed_pvp_bf_gen8", 8 },
}

for _, variant in ipairs(variants) do
	local templateName = variant[1]
	local generation = variant[2]
	local shared = _G["object_weapon_melee_2h_sword_crafted_saber_shared_" .. templateName]
	local object = shared:new {
		attackType = MELEEATTACK,
		damageType = LIGHTSABER,
		armorPiercing = MEDIUM,
		xpType = "jedi_general",
		certificationsRequired = { "cert_twohandlightsaber_gen4" },
		creatureAccuracyModifiers = { "twohandlightsaber_accuracy" },
		defenderDefenseModifiers = { "melee_defense" },
		defenderSecondaryDefenseModifiers = { "saber_block" },
		speedModifiers = { "twohandlightsaber_speed" },
		defenderToughnessModifiers = { "lightsaber_toughness" },
		gameObjectType = 131080,
		noTrade = 1,
		healthAttackCost = 105,
		actionAttackCost = 50,
		mindAttackCost = 55,
		forceCost = 60,
		pointBlankRange = 0,
		pointBlankAccuracy = 20,
		idealRange = 3,
		idealAccuracy = 15,
		maxRange = 5,
		maxRangeAccuracy = 5,
		minDamage = 195,
		maxDamage = 275,
		attackSpeed = 4.8,
		woundsRatio = 45,
		childObjects = {
			{templateFile = "object/tangible/inventory/lightsaber_inventory_" .. generation .. ".iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
		},
	}

	_G["object_weapon_melee_2h_sword_crafted_saber_" .. templateName] = object
	ObjectTemplates:addTemplate(object, "object/weapon/melee/2h_sword/crafted_saber/" .. templateName .. ".iff")
end
