-- /checkjedi command handler (called from C++)
-- creature is a lightuserdata pointer to CreatureObject*

function checkjedi_command(creature)
    if creature == nil then return end

    -- Minimal example output (replace with your actual jedi point logic)
    -- If you already have holocron_debug_status() elsewhere, call it here.
    if holocron_debug_status ~= nil then
        holocron_debug_status(creature)
        return
    end

    -- Fallback
    creature:sendSystemMessage("checkjedi_command loaded, but holocron_debug_status() not found.")
end
