ticket_collector = Creature:new {
	objectName = "@mob/creature_names:commoner",
	customName = "Ticket Collector",
	socialGroup = "townsperson",
	faction = "",
	level = 5,
	chanceHit = 0.1,
	damageMin = 5,
	damageMax = 10,
	baseXp = 100,
	baseHAM = 2000,
	baseHAMmax = 3000,
	armor = 0,
	resists = {5,5,5,5,5,5,5,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,
	scale = 1.0,

	templates = {"object/mobile/dressed_mand_bunker_technician.iff"},
	lootGroups = {
		{
			groups = {
				{group = "trash_common", chance = 10000000}
			}
		}
	},
	weapons = {},
	conversationTemplate = "",
	attacks = {}
}

CreatureTemplates:addCreatureTemplate(ticket_collector, "ticket_collector")
