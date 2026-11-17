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


object_building_player_city_cantina_tatooine = object_building_player_city_shared_cantina_tatooine:new {
	lotSize = 5,
	baseMaintenanceRate = 50,
	allowedZones = {"dantooine", "lok", "tatooine"},
	length = 7,
	width = 7,
	planetMapCategory = "cantina",
	cityRankRequired = 2,
	limitToOnePerCity = 0,
	abilityRequired = "place_cantina",
	skillMods = {
		{"private_buff_mind", 100},
		{"private_medical_rating", 100},
		{"private_med_battle_fatigue", 5},
		{"private_safe_logout", 1}
	},
	groundZoneComponent = "StructureZoneComponent",
	childObjects = {
		{templateFile = "object/tangible/sign/municipal/municipal_sign_hanging_cantina.iff", x = 5, z = 3, y = 11.95, ox = 0, oy = 1, oz = 0, ow = 0, cellid = -1, containmentType = -1},
		{templateFile = "object/tangible/terminal/terminal_player_structure.iff", x = -4.1, z = 0.750001, y = 6.1, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		-- Ghosts cantina buffet: two tables, six chairs, and a varied food/drink spread.
		{templateFile = "object/static/worldbuilding/furniture/cantina_table_1.iff", x = 0, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cantina_table_2.iff", x = 3.4, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = -1.4, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = 1.4, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = 0, z = 0, y = 0.6, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = 0, z = 0, y = 3.4, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = 2.0, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/static/worldbuilding/furniture/cheap/frn_all_chep_chair_s01.iff", x = 4.8, z = 0, y = 2, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dish_teltier_noodles.iff", x = -0.55, z = 1.05, y = 1.55, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dish_braised_canron.iff", x = 0.55, z = 1.05, y = 1.55, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dish_fire_stew.iff", x = 0, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dessert_ewok_berry.iff", x = -0.55, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dessert_pastebread.iff", x = 0.55, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dish_ahrisa.iff", x = 3.0, z = 1.05, y = 1.55, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/dessert_corellian_fried_icecream.iff", x = 3.8, z = 1.05, y = 1.55, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/drink_blue_milk.iff", x = 3.0, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/drink_caf.iff", x = 3.4, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1},
		{templateFile = "object/tangible/food/generic/drink_tatooine_sunburn.iff", x = 3.8, z = 1.05, y = 2.45, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1}
	},
	shopSigns = {
		{templateFile = "object/tangible/sign/municipal/municipal_sign_hanging_cantina.iff", x = 5, z = 3, y = 11.95, ox = 0, oy = 1, oz = 0, ow = 0, cellid = -1, containmentType = -1, requiredSkill = "", suiItem = "@player_structure:house_address"},
		{templateFile = "object/tangible/sign/player/shop_sign_s01.iff", x = 10, z = 0.5, y = 15, ox = 0, oy = 0, oz = 0, ow =  1, cellid = -1, containmentType = -1, requiredSkill = "crafting_merchant_management_01", suiItem = "@player_structure:shop_sign1"},
		{templateFile = "object/tangible/sign/player/shop_sign_s02.iff", x = 10, z = 0.5, y = 15, ox = 0, oy = 0, oz = 0, ow =  1, cellid = -1, containmentType = -1, requiredSkill = "crafting_merchant_management_02", suiItem = "@player_structure:shop_sign2"},
		{templateFile = "object/tangible/sign/player/shop_sign_s03.iff", x = 10, z = 0.5, y = 15, ox = 0, oy = 0, oz = 0, ow =  1, cellid = -1, containmentType = -1, requiredSkill = "crafting_merchant_management_03", suiItem = "@player_structure:shop_sign3"},
		{templateFile = "object/tangible/sign/player/shop_sign_s04.iff", x = 10, z = 0.5, y = 15, ox = 0, oy = 0, oz = 0, ow =  1, cellid = -1, containmentType = -1, requiredSkill = "crafting_merchant_management_04", suiItem = "@player_structure:shop_sign4"},
	},
}

ObjectTemplates:addTemplate(object_building_player_city_cantina_tatooine, "object/building/player/city/cantina_tatooine.iff")
