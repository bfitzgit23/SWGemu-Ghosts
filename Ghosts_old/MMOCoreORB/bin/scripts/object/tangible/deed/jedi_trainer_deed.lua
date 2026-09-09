-- =============================================================================
-- Ghosts of the Old Republic
-- Jedi Trainer Deed (Spawn Egg)
-- File: jedi_trainer_deed.lua
-- Place in: scripts/object/tangible/deed/
-- =============================================================================
--
-- USAGE:
--   Give to a player or admin via:
--     /object give <playerName> object/tangible/deed/jedi_trainer_deed
--   Player double-clicks the deed in their inventory while in a city/structure
--   to place the trainer NPC.
--
-- =============================================================================

object_tangible_deed_jedi_trainer_deed = object_tangible_deed_shared_deed:new {

	gameObjectType = GOT_DEED,

	-- Display name shown in inventory and examine window
	objectName = "@deed_n:jedi_trainer_deed",        -- STF key (see below)
	customName  = "Jedi Trainer Deed",               -- fallback if STF missing

	-- Template of the NPC this deed spawns
	npcTemplate = "mobile/jedi_trainer_combined",

	-- The building / structure type string the client uses for placement
	-- Use "npc" for generic outdoor NPC placement
	structureType = "npc",

	-- How long (seconds) the spawned NPC persists if the deed is revoked
	-- 0 = permanent until deed owner removes it
	persistTime = 0,

	-- Condition / decay — deeds don't degrade
	maxCondition = 1000,
	condition    = 0,

	-- Complexity / crafting irrelevant — this is a GM-granted item
	complexity   = 1,
	volume       = 1,

	-- Item level requirement (0 = no restriction)
	useRestriction = 0,

	-- Loot group — not used, but required field
	lootGroups = {},

	-- Faction restriction — 0 = any faction can use
	factionRestriction = 0,

	-- Placement restrictions
	-- true  = can ONLY be placed inside player structures
	-- false = can be placed outdoors in player cities too
	mustBeInStructure = false,

	-- Description shown in examine window
	--   Maps to deed_d:jedi_trainer_deed in your STF file
	customDescription = "A holographic deed encoding the presence of a Jedi Trainer. Place this in your city or structure to summon a trainer capable of instructing both Jedi and Grey Jedi disciples.",
}

ObjectTemplates:addTemplate(
	object_tangible_deed_jedi_trainer_deed,
	"object/tangible/deed/jedi_trainer_deed"
)
