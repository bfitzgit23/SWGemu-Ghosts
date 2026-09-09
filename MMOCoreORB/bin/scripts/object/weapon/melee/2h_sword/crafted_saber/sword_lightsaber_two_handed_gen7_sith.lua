object_weapon_melee_2h_sword_crafted_saber_sword_lightsaber_two_handed_gen7_sith = object_weapon_melee_2h_sword_crafted_saber_shared_sword_lightsaber_two_handed_gen7_sith:new {
	attackType = MELEEATTACK, damageType = LIGHTSABER, armorPiercing = MEDIUM,
	xpType = "jedi_general",
	certificationsRequired = { "cert_twohandlightsaber_gen4" },
	creatureAccuracyModifiers = { "twohandlightsaber_accuracy" },
	defenderDefenseModifiers = { "melee_defense" },
	defenderSecondaryDefenseModifiers = { "saber_block" },
	speedModifiers = { "twohandlightsaber_speed" },
	defenderToughnessModifiers = { "lightsaber_toughness" },
	gameObjectType = 131080,
	noTrade = 1,
	healthAttackCost = 105, actionAttackCost = 50, mindAttackCost = 55, forceCost = 60,
	pointBlankRange = 0, pointBlankAccuracy = 20,
	idealRange = 3, idealAccuracy = 15,
	maxRange = 5, maxRangeAccuracy = 5,
	minDamage = 195, maxDamage = 275, attackSpeed = 4.8, woundsRatio = 45,
	childObjects = {
		{templateFile = "object/tangible/inventory/lightsaber_inventory_7.iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
	},
}

ObjectTemplates:addTemplate(object_weapon_melee_2h_sword_crafted_saber_sword_lightsaber_two_handed_gen7_sith, "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_gen7_sith.iff")
