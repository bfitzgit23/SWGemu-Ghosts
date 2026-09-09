object_weapon_melee_polearm_crafted_saber_sword_lightsaber_polearm_gen7_exar_kun = object_weapon_melee_polearm_crafted_saber_shared_sword_lightsaber_polearm_gen7_exar_kun:new {
	attackType = MELEEATTACK, damageType = LIGHTSABER, armorPiercing = MEDIUM,
	xpType = "jedi_general",
	certificationsRequired = { "cert_polearmlightsaber_gen4" },
	creatureAccuracyModifiers = { "polearmlightsaber_accuracy" },
	defenderDefenseModifiers = { "melee_defense" },
	defenderSecondaryDefenseModifiers = { "saber_block" },
	speedModifiers = { "polearmlightsaber_speed" },
	defenderToughnessModifiers = { "lightsaber_toughness" },
	gameObjectType = 131080,
	noTrade = 1,
	healthAttackCost = 0, actionAttackCost = 0, mindAttackCost = 0, forceCost = 0,
	pointBlankRange = 0, pointBlankAccuracy = 20,
	idealRange = 3, idealAccuracy = 15,
	maxRange = 5, maxRangeAccuracy = 5,
	minDamage = 225, maxDamage = 305, attackSpeed = 0, woundsRatio = 45,
	childObjects = {
		{templateFile = "object/tangible/inventory/lightsaber_inventory_7.iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
	},
}

ObjectTemplates:addTemplate(object_weapon_melee_polearm_crafted_saber_sword_lightsaber_polearm_gen7_exar_kun, "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen7_exar_kun.iff")
