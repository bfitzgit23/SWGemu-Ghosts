Skill:new {
    skillName = "crafting_merchant_intermediate",
    parentName = "crafting_merchant_novice",
    skillPoints = 0,
    commands = {
        "vendor_remove",
        "vendor_bounce_item"
    },
    skillsRequired = {
        "crafting_merchant_novice"
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
    xpCost = 2000
}
