Skill:new {
    skillName = "crafting_merchant_advanced",
    parentName = "crafting_merchant_intermediate",
    skillPoints = 0,
    commands = {
        "vendor_remove_all",
        "vendor_set_item_limit"
    },
    skillsRequired = {
        "crafting_merchant_intermediate"
    },
    preclusionSkills = {},
    statMods = {
        { "private_vendor_limit", 3 }
    },
    skillMods = {
        { "vendor_discount", 5 },
        { "crafting_merchant", 25 }
    },
    xpType = "merchant",
    xpCost = 3000
}
