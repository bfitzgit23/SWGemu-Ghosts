-- ============================================================
-- ADD THIS to your holocron object Lua template
-- e.g. object/tangible/loot/misc/holocron_sith.lua (or whichever
-- .lua file registers your holocron object template)
--
-- Find the ObjectTemplates:addTemplate line at the bottom and
-- add the addObserver call BEFORE it, like this:
-- ============================================================

-- Example of what the bottom of your holocron template should look like:

object_tangible_loot_misc_holocron_sith = object_tangible_loot_misc_shared_holocron_sith:new {
    -- ... your existing template fields ...
}

-- Register the PICKUP observer so HolocronJedi:onPickUp fires
-- when any player loots or receives this holocron into inventory.
addObserver(OBJECTINCONTAINER, "HolocronJedi", "onPickUp", "object/tangible/loot/misc/holocron_sith.iff")

ObjectTemplates:addTemplate(object_tangible_loot_misc_holocron_sith, "object/tangible/loot/misc/holocron_sith.iff")

-- ============================================================
-- If you have multiple holocron templates (sith, jedi, etc.)
-- add the addObserver line for EACH one, e.g.:
--
-- addObserver(OBJECTINCONTAINER, "HolocronJedi", "onPickUp", "object/tangible/loot/misc/holocron_jedi.iff")
-- addObserver(OBJECTINCONTAINER, "HolocronJedi", "onPickUp", "object/tangible/loot/misc/holocron_dark_jedi.iff")
--
-- The screenplay state check (HolocronFirstSeen == 1) means
-- the SUI only ever fires once regardless of how many holocrons
-- the player picks up or which template triggers it.
-- ============================================================
