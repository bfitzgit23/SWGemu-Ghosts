GatekeeperTrialConvoTemplate = ConvoTemplate:new {
    initialScreen = "intro",
    templateType = "Lua",
    luaClassHandler = "GatekeeperTrialConvoHandler",
    screens = {}
}

local intro = ConvoScreen:new {
    id = "intro",
    leftDialog = "",
    customDialogText = "You have listened. You have studied. You have reached beyond what you once believed possible and touched the currents of the Force.\n\nBut knowledge alone does not make a Jedi.",
    stopConversation = "false",
    options = {{"Then what must I do?", "threshold"}}
}
GatekeeperTrialConvoTemplate:addScreen(intro)

local threshold = ConvoScreen:new {
    id = "threshold",
    leftDialog = "",
    customDialogText = "You stand at the threshold between knowing of the Force and beginning to live by it. What comes next cannot be taught by a holocron.\n\nThe Force will not always find you in moments of peace. Fear may cloud your judgement, pain may weaken your resolve, and an enemy may stand between you and your chosen path.",
    stopConversation = "false",
    options = {{"What must a Padawan possess?", "qualities"}}
}
GatekeeperTrialConvoTemplate:addScreen(threshold)

local qualities = ConvoScreen:new {
    id = "qualities",
    leftDialog = "",
    customDialogText = "A Padawan must possess more than knowledge.\n\nA Padawan must show discipline. Courage. Restraint. And the will to continue when the outcome is uncertain.",
    stopConversation = "false",
    options = {{"How do I prove that?", "trial"}}
}
GatekeeperTrialConvoTemplate:addScreen(qualities)

local trial = ConvoScreen:new {
    id = "trial",
    leftDialog = "",
    customDialogText = "Your final lesson is therefore not a lesson at all. It is a trial.\n\nAn adversary awaits you. You will face this challenge without further instruction from me.",
    stopConversation = "false",
    options = {{"How should I face this adversary?", "guidance"}}
}
GatekeeperTrialConvoTemplate:addScreen(trial)

local guidance = ConvoScreen:new {
    id = "guidance",
    leftDialog = "",
    customDialogText = "Do not fight merely to destroy your opponent.\n\nObserve. Adapt. Trust what you have learned. And above all, trust the Force.",
    stopConversation = "false",
    options = {{"And if I fail?", "failure"}}
}
GatekeeperTrialConvoTemplate:addScreen(guidance)

local failure = ConvoScreen:new {
    id = "failure",
    leftDialog = "",
    customDialogText = "If you fall, then you are not yet ready. Failure does not close the path before you. Learn from it. Return stronger, wiser, and better prepared.\n\nIf you prevail, you will have proven that you are ready to take your first true step along the Jedi path.",
    stopConversation = "false",
    options = {{"Will victory make me a Jedi?", "meaning"}}
}
GatekeeperTrialConvoTemplate:addScreen(failure)

local meaning = ConvoScreen:new {
    id = "meaning",
    leftDialog = "",
    customDialogText = "Victory will not make you a Jedi Master. It will not make you powerful. It will not mark the end of your training.\n\nIt will earn you the right to begin. To become a Padawan learner is to accept that there is still much you do not know. There is no shame in being a student. There is honour in choosing to become one.",
    stopConversation = "false",
    options = {{"I understand. What happens now?", "decision"}}
}
GatekeeperTrialConvoTemplate:addScreen(meaning)

local decision = ConvoScreen:new {
    id = "decision",
    leftDialog = "",
    customDialogText = "Beyond this moment, I can offer you no further guidance. The next step must be yours.\n\nWhen you are ready to face your final trial, acknowledge that you understand.",
    stopConversation = "false",
    options = {{"I Understand", "accept_trial"}, {"I am not ready yet.", "decline"}}
}
GatekeeperTrialConvoTemplate:addScreen(decision)

local acceptTrial = ConvoScreen:new {
    id = "accept_trial",
    leftDialog = "",
    customDialogText = "Very well. Face the dark presence that has answered your awakening. Your waypoint will reveal where it waits.",
    stopConversation = "true",
    options = {}
}
GatekeeperTrialConvoTemplate:addScreen(acceptTrial)

local decline = ConvoScreen:new {
    id = "decline",
    leftDialog = "",
    customDialogText = "Return when your resolve is equal to your knowledge. I will wait, but the Force will not wait forever.",
    stopConversation = "true",
    options = {}
}
GatekeeperTrialConvoTemplate:addScreen(decline)

local notReady = ConvoScreen:new {
    id = "not_ready",
    leftDialog = "",
    customDialogText = "The apparition regards you in silence. Your path has not yet brought you to this moment.",
    stopConversation = "true",
    options = {}
}
GatekeeperTrialConvoTemplate:addScreen(notReady)

addConversationTemplate("GatekeeperTrialConvoTemplate", GatekeeperTrialConvoTemplate)
