GatekeeperTrialConvoHandler = conv_handler:new {}

function GatekeeperTrialConvoHandler:getInitialScreen(pPlayer, pNpc, pConvoTemplate)
    if pPlayer == nil or pNpc == nil or pConvoTemplate == nil then return nil end
    local convoTemplate = LuaConversationTemplate(pConvoTemplate)
    local expectedID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "gatekeeper_ghost_id")) or 0
    local ready = readScreenPlayData(pPlayer, "HolocronJedi", "gatekeeper_conversation_ready")

    if expectedID ~= SceneObject(pNpc):getObjectID() or ready ~= "padawan_trial" then
        return convoTemplate:getScreen("not_ready")
    end

    return convoTemplate:getScreen("intro")
end

function GatekeeperTrialConvoHandler:runScreenHandlers(pConvoTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
    if pPlayer == nil or pNpc == nil or pConvScreen == nil then return pConvScreen end
    local screenID = LuaConversationScreen(pConvScreen):getScreenID()

    if screenID == "accept_trial" then
        local expectedID = tonumber(readScreenPlayData(pPlayer, "HolocronJedi", "gatekeeper_ghost_id")) or 0
        local ready = readScreenPlayData(pPlayer, "HolocronJedi", "gatekeeper_conversation_ready")
        local status = readScreenPlayData(pPlayer, "HolocronJedi", "jedi_status")
        local active = readScreenPlayData(pPlayer, "HolocronJedi", "padawan_test_active")
        local mobSpawned = readScreenPlayData(pPlayer, "HolocronJedi", "padawan_mob_spawned")
        if expectedID == SceneObject(pNpc):getObjectID() and ready == "padawan_trial" and
                status ~= "padawan" and status ~= "knight" and status ~= "master" and
                active ~= "1" and mobSpawned ~= "1" then
            writeScreenPlayData(pPlayer, "HolocronJedi", "gatekeeper_conversation_ready", "")
            writeScreenPlayData(pPlayer, "HolocronJedi", "padawan_test_done", "1")
            CreatureObject(pPlayer):sendSystemMessage("\\#FFFF00[The Force] \\#FFFFFFA dark presence answers the Gatekeeper's call. Your trial is beginning.")
            local firstName = CreatureObject(pPlayer):getFirstName()
            sendMail("The Gatekeeper", "Your Trial Awaits",
                "Seeker,\n\nYou have studied enough. The Force stirs within you, but knowledge alone does not make a Jedi.\n\nA dark presence has been drawn to your awakening. A waypoint will be placed in your datapad marking its location.\n\nFind it. Destroy it. Only then will you have proven yourself worthy of the title of Padawan.\n\nDo not hesitate. Do not fail.\n\n- The Gatekeeper",
                firstName)
            GatekeeperConversation:despawnGatekeeperNow(pPlayer)
            createEvent(1500, "GatekeeperConversation", "spawnTrialMob", pPlayer, "")
        end
    elseif screenID == "decline" then
        -- Keep the ready state so using a holocron can summon a fresh,
        -- independently randomized hologram for the next attempt.
        GatekeeperConversation:despawnGatekeeperNow(pPlayer)
    end

    return pConvScreen
end
