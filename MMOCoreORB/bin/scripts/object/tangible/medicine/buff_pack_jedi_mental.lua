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

--Linking Engine3 statically or dynamically with other modules
--is making a combined work based on Engine3.
--Thus, the terms and conditions of the GNU Lesser General Public License
--cover the whole combination.

--In addition, as a special exception, the copyright holders of Engine3
--give you permission to combine Engine3 program with free software
--programs or libraries that are released under the GNU LGPL and with
--code included in the standard release of Core3 under the GNU LGPL
--license (or modified versions of such code, with unchanged license).
--You may copy and distribute such a system following the terms of the
--GNU LGPL for Engine3 and the licenses of the other code concerned,
--provided that you include the source code of that other code when
--and as the GNU LGPL requires distribution of source code.

--Note that people who make modified versions of Engine3 are not obligated
--to grant this special exception for their modified versions;
--it is their choice whether to do so. The GNU Lesser General Public License
--gives permission to release a modified version without this exception;
--this exception also makes it possible to release a modified version
--which carries forward this exception.

-- Using stock medpack_dizzy IFF file (no custom IFF needed)
object_tangible_medicine_buff_pack_jedi_mental = object_tangible_medicine_shared_medpack_dizzy:new {

	templateType = CONSUMABLE,
	
	useCount = 250, -- Stack of 250 uses
	
	medicineUse = 280, -- Doctor skill required to use

	buffName = "jedi_mental",
	buffCRC = 0, -- Will be set automatically
	
	modifiers = {
		{"mind", 10000, 57600}, -- Mind +10000 for 16 hours
		{"focus", 10000, 57600}, -- Focus +10000 for 16 hours  
		{"willpower", 10000, 57600}, -- Willpower +10000 for 16 hours
	},

	numberExperimentalProperties = {1, 1, 2, 2, 2, 2},
	experimentalProperties = {"XX", "XX", "OQ", "PE", "OQ", "UT", "OQ", "PE", "OQ", "UT"},
	experimentalWeights = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	experimentalGroupTitles = {"null", "null", "expEffectiveness", "expDuration", "expCharges", "expRange"},
	experimentalSubGroupTitles = {"null", "null", "hitpoint_modification", "duration", "charges", "range"},
	experimentalMin = {0, 0, 1000, 10000, 250, 1},
	experimentalMax = {0, 0, 10000, 57600, 250, 1},
	experimentalPrecision = {0, 0, 0, 0, 0, 0},
	experimentalCombineType = {0, 0, 1, 1, 1, 1},
}

ObjectTemplates:addTemplate(object_tangible_medicine_buff_pack_jedi_mental, "object/tangible/medicine/medpack_dizzy.iff")
