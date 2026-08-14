--[[
    Aftermath Server - Jedi Point Sources
    Location: MMOCoreORB/bin/scripts/screenplays/jedi/jedi_point_sources.lua
    
    This script defines the point values for all activities that award
    Jedi unlock points and hooks into existing game event handlers.
    
    HOW TO HOOK THESE IN:
    - Crafting:  Add call in CraftingSessionImplementation.cpp  completeCraft()
    - Combat:    Add call in CreatureObjectImplementation.cpp   killedBy()
    - Dancing:   Add call in EntertainingSessionImplementation  tick()
    - Surveying: Add call in SurveyToolImplementation.cpp       surveyCB()
    - FS Kills:  Any mob tagged isForceSensitive = true in their .lua template
    
    Lua-side calls to make from C++ via Lua scripting bridge:
        holocron_award_points(pCreature, points, "crafting")
        holocron_award_points(pCreature, points, "combat")
        holocron_on_fs_kill(pCreature, pVictim)
--]]
-- Coded by BoosterSteel 19-03-2026



-- ============================================================
-- POINT VALUES PER ACTIVITY
-- ============================================================

JediPointSources = {

    -- Crafting (called on successful craft)
    crafting = {
        novice   = 5,    -- Simple crafted items
        standard = 15,   -- Normal crafted items  
        complex  = 40,   -- Complex schematics (factories, etc.)
        rare     = 100,  -- Rare/exceptional crafts (legendary quality)
    },
    
    -- Entertainer (per performance tick - fires every 30s while performing)
    dancing = {
        per_tick = 8,
    },
    
    -- Combat kills by mob CL range
    combat = {
        cl_1_10   = 2,
        cl_11_30  = 5,
        cl_31_60  = 10,
        cl_61_90  = 20,
        cl_91_120 = 40,
        cl_121_up = 60,
    },
    
    -- Surveying (per successful survey pulse)
    surveying = {
        per_survey = 12,
    },
    
    -- Holocron "Use for Studies" -- defined in holocron.lua
    -- HOLOCRON_POINTS_PADAWAN = 1000
}

-- ============================================================
-- COMBAT POINT HANDLER
-- Call this from the C++ killedBy or onKill event
-- pKiller = creature that made the kill
-- pVictim = the mob that died
-- ============================================================

function jedi_on_kill(pKiller, pVictim)
    if pKiller == nil or pVictim == nil then return end
    
    -- Must be a player
    local pGhost = CreatureObject(pKiller):getPlayerObject()
    if pGhost == nil then return end
    
    local victimCL = CreatureObject(pVictim):getLevel()
    local points = 0
    
    if victimCL <= 10 then
        points = JediPointSources.combat.cl_1_10
    elseif victimCL <= 30 then
        points = JediPointSources.combat.cl_11_30
    elseif victimCL <= 60 then
        points = JediPointSources.combat.cl_31_60
    elseif victimCL <= 90 then
        points = JediPointSources.combat.cl_61_90
    elseif victimCL <= 120 then
        points = JediPointSources.combat.cl_91_120
    else
        points = JediPointSources.combat.cl_121_up
    end
    
    if points > 0 then
        holocron_award_points(pKiller, points, "combat")
    end
    
    -- Check if this is a Force-sensitive NPC
    -- FS mobs should have isForceSensitive = true in their mobile .lua template
    local isForceSensitive = CreatureObject(pVictim):getCreatureFlag("forceSensitive")
    if isForceSensitive then
        holocron_on_fs_kill(pKiller, pVictim)
    end
end

-- ============================================================
-- CRAFTING POINT HANDLER
-- Call this from completion of a successful craft
-- pCreature = the crafter
-- complexity = "novice" / "standard" / "complex" / "rare"
-- ============================================================

function jedi_on_craft(pCreature, complexity)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    local points = JediPointSources.crafting[complexity] or JediPointSources.crafting.standard
    holocron_award_points(pCreature, points, "crafting")
end

-- ============================================================
-- DANCING / ENTERTAINING TICK HANDLER
-- Call this from the entertainer session tick (every 30s)
-- pCreature = the entertainer
-- ============================================================

function jedi_on_entertain_tick(pCreature)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    holocron_award_points(pCreature, JediPointSources.dancing.per_tick, "dancing")
end

-- ============================================================
-- SURVEYING HANDLER
-- Call this from a successful survey pulse
-- pCreature = the surveyor
-- ============================================================

function jedi_on_survey(pCreature)
    if pCreature == nil then return end
    local pGhost = CreatureObject(pCreature):getPlayerObject()
    if pGhost == nil then return end
    
    holocron_award_points(pCreature, JediPointSources.surveying.per_survey, "surveying")
end

-- ============================================================
-- FORCE SENSITIVE MOB FLAG HELPER
-- Add this to any mobile .lua you want to count as FS
-- Example usage in a mobile template:
--   isForceSensitive = true,
-- 
-- The following mobile templates are automatically FS tagged
-- by this system (override list - add any mobile template path here)
-- ============================================================

ForceSensitiveMobiles = {
    -- Korriban
    "object/mobile/dark_jedi_knight.iff",
    "object/mobile/dark_jedi_master.iff",
    "object/mobile/dark_jedi_apprentice.iff",
    "object/mobile/sith_inquisitor.iff",
    
    -- Kaas
    "object/mobile/sith_warrior.iff",
    "object/mobile/sith_apprentice.iff",
    
    -- Dathomir / other planets
    "object/mobile/nightsister_elder.iff",
    "object/mobile/nightsister_witch.iff",
    "object/mobile/nightsister.iff",
    "object/mobile/charal.iff",
    
    -- General FS mobs found across planets
    "object/mobile/dark_jedi.iff",
    "object/mobile/jedi_knight.iff",
    "object/mobile/jedi_padawan.iff",
    "object/mobile/force_adept.iff",
    "object/mobile/force_sensitive_adept.iff",
    
    -- Add any of your custom Aftermath FS mobs here
}

-- Build lookup table for fast checks
ForceSensitiveLookup = {}
for _, template in ipairs(ForceSensitiveMobiles) do
    ForceSensitiveLookup[template] = true
end

function isMobileForceSensitive(template)
    return ForceSensitiveLookup[template] == true
end
