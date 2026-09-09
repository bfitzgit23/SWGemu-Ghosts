-- High-generation one-handed hilts supplied by Lightsabers.tre.
local variants = {
	{ "sword_lightsaber_one_handed_gen6", 6 },
	{ "sword_lightsaber_mandaloriangen6", 6 },
	{ "sword_lightsaber_one_handed_gen7", 7 },
	{ "sword_lightsaber_mandaloriangen7", 7 },
	{ "sword_lightsaber_one_handed_gen8", 8 },
	{ "sword_lightsaber_mandaloriangen8", 8 },
}

for _, variant in ipairs(variants) do
	local templateName = variant[1]
	local generation = variant[2]
	local shared = _G["object_weapon_melee_sword_crafted_saber_shared_" .. templateName]
	local object = shared:new {
		attackType = MELEEATTACK,
		damageType = LIGHTSABER,
		armorPiercing = MEDIUM,
		xpType = "jedi_general",
		certificationsRequired = { "cert_onehandlightsaber_gen4" },
		creatureAccuracyModifiers = { "onehandlightsaber_accuracy" },
		defenderDefenseModifiers = { "melee_defense" },
		defenderSecondaryDefenseModifiers = { "saber_block" },
		speedModifiers = { "onehandlightsaber_speed" },
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
		attackSpeed = 4.5,
		woundsRatio = 45,
		childObjects = {
			{templateFile = "object/tangible/inventory/lightsaber_inventory_" .. generation .. ".iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
		},
	}

	_G["object_weapon_melee_sword_crafted_saber_" .. templateName] = object
	ObjectTemplates:addTemplate(object, "object/weapon/melee/sword/crafted_saber/" .. templateName .. ".iff")
end
