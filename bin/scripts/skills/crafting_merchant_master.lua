Skill:new {
    skillName = "crafting_merchant_master",
    parentName = "crafting_merchant_advanced",
    skillPoints = 0, -- Override: costs 0 skill points
    commands = {
        "vendor_restock",
        "vendor_status",
        "vendor_set_item_limit",
        "vendor_reverse_item",
        "vendor_remove_all",
        "vendor_remove",
        "vendor_item_status",
        "vendor_item_limit",
        "vendor_destroy",
        "vendor_credit_item",
        "vendor_bounce_item"
    },
    skillsRequired = {
        "crafting_merchant_advanced"
    },
    preclusionSkills = {},
    statMods = {
        { "private_vendor_limit", 15 },
        { "vendor_item_limit", 75 }
    },
    skillMods = {
        { "vendor_discount", 10 },
        { "bargain", 10 },
        { "private_vendor_discount", 10 },
        { "crafting_merchant", 100 }
    },
    xpType = "merchant",
    xpCost = 15000
}
