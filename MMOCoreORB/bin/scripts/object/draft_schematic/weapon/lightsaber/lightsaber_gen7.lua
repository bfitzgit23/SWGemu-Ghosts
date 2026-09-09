local function createGen7Schematic(baseTemplate, displayName, targetTemplate)
	return baseTemplate:new {
		templateType = DRAFTSCHEMATIC,
		customObjectName = displayName,
		craftingToolTab = 2048, complexity = 19, size = 1,
		xpType = "jedi_general", xp = 0,
		assemblySkill = "jedi_saber_assembly",
		experimentingSkill = "jedi_saber_experimentation",
		customizationSkill = "jedi_customization",
		factoryCrateSize = 0,
		customizationOptions = {}, customizationStringNames = {}, customizationDefaults = {},
		ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
		ingredientTitleNames = {"emitter_shroud", "primary_crystal", "activator", "handgrip", "focusing_crystals", "power_field_insulator", "energizers"},
		ingredientSlotType = {0, 1, 0, 0, 1, 0, 0},
		resourceTypes = {"steel_duralloy", "object/tangible/component/weapon/lightsaber/shared_lightsaber_refined_crystal_pack.iff", "aluminum_titanium", "petrochem_inert_polymer", "object/tangible/component/weapon/lightsaber/shared_lightsaber_refined_crystal_pack.iff", "gas_inert_culsion", "copper_polysteel"},
		resourceQuantities = {40, 1, 22, 28, 1, 28, 28},
		contribution = {100, 100, 100, 100, 100, 100, 100},
		targetTemplate = targetTemplate,
		additionalTemplates = {},
	}
end

object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen7 = createGen7Schematic(object_draft_schematic_weapon_lightsaber_shared_lightsaber_one_hand_gen5, "Mandalorian Seventh Generation One-Handed Lightsaber", "object/weapon/melee/sword/crafted_saber/sword_lightsaber_mandaloriangen7.iff")
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen7, "object/draft_schematic/weapon/lightsaber/lightsaber_one_hand_gen7.iff")

object_draft_schematic_weapon_lightsaber_lightsaber_two_hand_gen7 = createGen7Schematic(object_draft_schematic_weapon_lightsaber_shared_lightsaber_two_hand_gen5, "Sith Seventh Generation Two-Handed Lightsaber", "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_gen7_sith.iff")
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_two_hand_gen7, "object/draft_schematic/weapon/lightsaber/lightsaber_two_hand_gen7.iff")

object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen7 = createGen7Schematic(object_draft_schematic_weapon_lightsaber_shared_lightsaber_polearm_gen5, "Exar Kun Seventh Generation Polearm Lightsaber", "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen7_exar_kun.iff")
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen7, "object/draft_schematic/weapon/lightsaber/lightsaber_polearm_gen7.iff")
