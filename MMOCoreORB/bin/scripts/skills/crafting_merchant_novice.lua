Skill:new {
    skillName = "crafting_merchant_novice",
    parentName = "crafting_artisan_master",
    skillPoints = 0,
    commands = {
        "vendor_status",
        "vendor_item_status"
    },
    skillsRequired = {
        "crafting_artisan_master"
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
    xpCost = 1000
}
