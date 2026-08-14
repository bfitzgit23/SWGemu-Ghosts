-- ============================================================
-- jedi_knight_poll.lua
-- bin/scripts/screenplays/jedi/jedi_knight_poll.lua
--
-- Scheduled poll that runs 10s after Knight grant.
-- If FRS rank skill is missing (C++ grant silently failed),
-- re-triggers the grant via screenplay state.
-- ============================================================

local ObjectManager = require("utils.ObjectManager")

JediKnightPoll = ScreenPlay:new {
    numberOfActs = 1,
}

registerScreenPlay("JediKnightPoll", true)

function JediKnightPoll:start()
    -- No init needed
end

-- Called by a delayed task from doGrantKnight
-- Usage in jedi_knight_trial.lua:
--   createEvent(10000, "JediKnightPoll", "pollFRSGrant", player, lightSide and "light" or "dark")
function JediKnightPoll:pollFRSGrant(player, alignment)
    if player == nil then return end

    local isLight = (alignment == "light")
    local rankSkill   = isLight and "force_rank_light_novice"  or "force_rank_dark_novice"
    local parentSkill = isLight and "force_rank_light"         or "force_rank_dark"

    if not player:hasSkill(rankSkill) then
        -- C++ grant did not persist — log and attempt Lua re-grant
        -- NOTE: This will also hit checkRequirements issues in Lua.
        -- If it fails again here, the player needs to use the radial fallback.
        -- The SUI message in doGrantKnight covers this case.
        player:sendSystemMessage("@jedi_trials:frs_recheck")  -- "Your rank is being verified..."
        
        -- Fire the C++ grant path again via screenplay state trick:
        -- Set a flag that HolocronMenuComponent checks on next radial open
        player:setScreenPlayState(1, "JediKnightFRSPending")
        
        player:sendSystemMessage("Please right-click your holocron and select 'Speak to the Gatekeeper' to confirm your Knight rank.")
        
        print("JediKnightPoll: FRS rank missing for " .. tostring(player:getFirstName()) .. " | alignment=" .. alignment)
    else
        print("JediKnightPoll: FRS confirmed for " .. tostring(player:getFirstName()))
    end
end

-- ============================================================
-- INTEGRATION: Add this to doGrantKnight() in jedi_knight_trial.lua
-- AFTER the C++ grantKnightSkills call:
--
--   -- Schedule FRS verification poll (10 seconds)
--   createEvent(10000, "JediKnightPoll", "pollFRSGrant", pCreature, 
--               isLight and "light" or "dark")
--
-- ============================================================
