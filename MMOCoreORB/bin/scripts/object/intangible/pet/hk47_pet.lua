-- The supplied shared_hk47.iff is a creature template (SCOT), not an
-- intangible control-device template. Reuse a stock droid control device
-- appearance while retaining the HK-47 server object and creature template.
object_intangible_pet_hk47_pet = object_intangible_pet_shared_r2:new {
    creatureTemplate = "hk47_pet"
}

ObjectTemplates:addTemplate(object_intangible_pet_hk47_pet, "object/intangible/pet/hk47_pet.iff")
