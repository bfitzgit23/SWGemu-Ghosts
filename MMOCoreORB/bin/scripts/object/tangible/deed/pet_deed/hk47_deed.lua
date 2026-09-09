-- shared_hk47.iff is incorrectly compiled as a creature template. Use a
-- known-good stock deed appearance; the generated HK-47 objects remain custom.
object_tangible_deed_pet_deed_hk47_deed = object_tangible_deed_pet_deed_shared_angler_deed:new {
    templateType = PETDEED,
    objectName = "HK-47 Pet Deed",
    customName = "HK-47 Pet Deed",
    generatedObjectTemplate = "object/intangible/pet/hk47_pet.iff",
    controlDeviceObjectTemplate = "object/intangible/pet/hk47_pet.iff",
    mobileTemplate = "hk47_pet"
}

ObjectTemplates:addTemplate(object_tangible_deed_pet_deed_hk47_deed, "object/tangible/deed/pet_deed/hk47_deed.iff")
