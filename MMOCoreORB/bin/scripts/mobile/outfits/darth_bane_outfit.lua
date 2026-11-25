-- Darth Bane's custom look: black Sith robe over a bald dark jedi elder
-- body, dark gauntlets, boots and belt. Used by darth_bane_korriban.
darth_bane_outfit = {
	{
		{objectTemplate = "object/tangible/wearables/robe/robe_jedi_black_01.iff", customizationVariables = {} },
		{objectTemplate = "object/tangible/wearables/gloves/gloves_s02.iff", customizationVariables = {{"/private/index_color_1", 1}} },
		{objectTemplate = "object/tangible/wearables/belt/belt_s01.iff", customizationVariables = {{"/private/index_color_1", 1}} },
		{objectTemplate = "object/tangible/wearables/boots/boots_s22.iff", customizationVariables = {{"/private/index_color_2", 31}, {"/private/index_color_1", 87}} },
	}
}

addOutfitGroup("darth_bane_outfit", darth_bane_outfit)
