--Copyright (C) 2010 <SWGEmu>

--This File is part of Core3.

--This program is free software; you can redistribute
--it and/or modify it under the terms of the GNU Lesser
--General Public License as published by the Free Software
--Foundation; either version 2 of the License,
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

object_weapon_melee_2h_sword_crafted_saber_sword_lightsaber_two_handed_gen6_must = object_weapon_melee_2h_sword_crafted_saber_shared_sword_lightsaber_two_handed_gen6_must:new {
	armorPiercing = HEAVY,
	xpType = "jedi_general",

	certificationsRequired = { "cert_2hsaber" },
	creatureAccuracyModifiers = { "2hsaber_accuracy" },
	defenderDefenseModifiers = { "melee_defense" },
	defenderSecondaryDefenseModifiers = { "saber_block" },
	speedModifiers = { "2hsaber_speed" },
	damageModifiers = { },

	healthAttackCost = 76,
	actionAttackCost = 40,
	mindAttackCost = 36,
	forceCost = 38,

	pointBlankRange = 0,
	pointBlankAccuracy = 25,

	idealRange = 3,
	idealAccuracy = 18,

	maxRange = 5,
	maxRangeAccuracy = 8,

	minDamage = 222,
	maxDamage = 388,

	attackSpeed = 4.0,
	woundsRatio = 44,

	defenderToughnessModifiers = { "lightsaber_toughness" },

	noTrade = 1,

	childObjects = {
		{templateFile = "object/tangible/inventory/shared_lightsaber_inventory_6.iff", x = 0, z = 0, y = 0, ox = 0, oy = 0, oz = 0, ow = 0, cellid = -1, containmentType = 4}
	},

	skillMods = {
		{"force_regen", 25},
		{"saber_block", 25},
		{"2hsaber_speed", 25},
	},
}

ObjectTemplates:addTemplate(object_weapon_melee_2h_sword_crafted_saber_sword_lightsaber_two_handed_gen6_must, "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_gen6_must.iff")
