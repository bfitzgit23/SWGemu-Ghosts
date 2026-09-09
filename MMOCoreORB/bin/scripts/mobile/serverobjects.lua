-- Conversations
includeFile("conversations.lua")

-- Dress Groups - Must be loaded before mobiles
includeFile("dressgroup/serverobjects.lua") 

-- Creatures
includeFile("corellia/serverobjects.lua")
includeFile("dantooine/serverobjects.lua")
includeFile("dathomir/serverobjects.lua")
includeFile("endor/serverobjects.lua")
includeFile("event/serverobjects.lua")
includeFile("herald/serverobjects.lua")
includeFile("jedi/serverobjects.lua")
includeFile("lok/serverobjects.lua")
includeFile("misc/serverobjects.lua")
includeFile("naboo/serverobjects.lua")
includeFile("pet/serverobjects.lua")
includeFile("quest/serverobjects.lua")
includeFile("rori/serverobjects.lua")
includeFile("space/serverobjects.lua")
includeFile("talus/serverobjects.lua")
includeFile("tatooine/serverobjects.lua")
includeFile("thug/serverobjects.lua")
includeFile("townsperson/serverobjects.lua")
includeFile("tutorial/serverobjects.lua")
includeFile("yavin4/serverobjects.lua")

includeFile("faction/serverobjects.lua")
includeFile("dungeon/serverobjects.lua") 

-- Weapons
includeFile("weapon/serverobjects.lua") 

-- Spawn Groups
includeFile("spawn/serverobjects.lua")

-- Trainer
includeFile("trainer/serverobjects.lua")

-- Mission
includeFile("mission/serverobjects.lua")

-- Lairs
includeFile("lair/serverobjects.lua")

-- Outfits
includeFile("outfits/serverobjects.lua")

includeFile("chandrila/serverobjects.lua")

-- Custom content - Loads last to allow for overrides
includeFile("geonosis/serverobjects.lua")
includeFile("hoth/serverobjects.lua")
includeFile("hutta/serverobjects.lua")
includeFile("kaas/serverobjects.lua")
includeFile("korriban/serverobjects.lua")
includeFile("lothal/serverobjects.lua")
includeFile("mandalore/serverobjects.lua")
includeFile("moraband/serverobjects.lua")
includeFile("taanab/serverobjects.lua")
includeFile("nalhutta/serverobjects.lua")
includeFile("mustafar/serverobjects.lua")

includeFile("heroics/serverobjects.lua")
includeFile("chandriltech/serverobjects.lua")

-- Additional custom content directories
includeFile("custom_content/serverobjects.lua")
includeFile("worldboss/serverobjects.lua")
includeFile("custom_vendors/serverobjects.lua")
includeFile("merchants/serverobjects.lua")

includeFile("../custom_scripts/mobile/serverobjects.lua")
