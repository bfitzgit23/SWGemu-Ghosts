--Ghosts 2026-11-19: server template was never registered, so spawns referencing this path failed.
object_mobile_kimogila_sith = object_mobile_shared_kimogila_sith:new {
}

ObjectTemplates:addTemplate(object_mobile_kimogila_sith, "object/mobile/kimogila_sith.iff")
