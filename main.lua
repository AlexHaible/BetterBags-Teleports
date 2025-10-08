-- Variables --
---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
assert(BetterBags, "BetterBags - Teleports requires BetterBags")

---@class Categories: AceModule
local Categories = BetterBags:GetModule('Categories')

---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

---@class Teleporters: AceModule
local Teleporters = BetterBags:NewModule('Teleporters')

---@class AceDB-3.0: AceModule
local AceDB = LibStub("AceDB-3.0")

---@class Config: AceModule
local Config = BetterBags:GetModule('Config')

---@class Context: AceModule
local Context = BetterBags:GetModule('Context')

---@class Events: AceModule
local Events = BetterBags:GetModule('Events')

---@type string, AddonNS
local _, addon = ...

local _, _, _, interfaceVersion = GetBuildInfo()

local db
local defaults = {
    profile = {}
}
local configOptions

-- Get the game version
local isRetail  = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local isTBC     = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local isWotLK   = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
local isCata    = WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC
local isMists   = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC

-- “Or above” helpers for gating
local isMistsOrAbove   = isMists   or isRetail
local isCataOrAbove    = isCata    or isMists or isRetail
local isWotLKOrAbove   = isWotLK   or isCata  or isMists or isRetail
local isTBCOrAbove     = isTBC     or isWotLK or isCata  or isMists or isRetail
local isClassicOrAbove = isClassic or isTBC   or isWotLK or isCata  or isMists or isRetail

-- Kill the category from different plugin.
Categories:WipeCategory(Context:New('BBTeleporters_DeleteCategory'),TUTORIAL_TITLE31)

-- Make an empty table to store item data in...
local teleporters = {}

local function refreshTeleports()
    Teleporters:clearTeleportCategory()
    Teleporters:hydrateTeleportersTable()
    Teleporters:addTeleportersToCategory()
    local ctx = Context:New('BBTeleporters_RefreshAll')
    Events:SendMessage(ctx, 'bags/FullRefreshAll')
end

local isClassicEra = isClassic or isTBC or isWotLK or isCata

if isClassicEra then
    defaults.profile = {
        enablePortalReagents = false,
    }
end

local args = {
    forceRefreshTeleports = {
        type = "execute",
        name = "Force Refresh",
        desc = "This will forcibly refresh the Teleporters category.",
        func = refreshTeleports,
    },
}

if isClassicEra then
    args.addReagentsToCategory = {
        type = "toggle",
        name = "Add Reagents",
        desc = "This will add the mage reagents for portals to the Teleporters category.",
        get = function()
            return Teleporters.db.profile.enablePortalReagents
        end,
        set = function(_, value)
            Teleporters.db.profile.enablePortalReagents = value
            refreshTeleports()
        end,
    }

    configOptions = {
        classicOptions = {
            name = L:G("Classic Options"),
            type = "group",
            order = 1,
            inline = true,
            args = args,
        },
    }
else
    configOptions = {
        retailOptions = {
            name = L:G("Options"),
            type = "group",
            order = 1,
            inline = true,
            args = args,
        },
    }
end

function Teleporters:addTeleportersConfig()
    if not Config or not configOptions then
        print("Failed to load configurations for Teleporters plugin.")
        return
    end

    Config:AddPluginConfig("Teleporters", configOptions)
end

function Teleporters:clearTeleportCategory()
    Categories:WipeCategory(Context:New('BBTeleporters_DeleteCategory'),L:G("Teleporters"))
end

function Teleporters:hydrateTeleportersTable()
    table.wipe(teleporters)

    if isTBCOrAbove then loadSet(self.data.tbc) end
    if isWotLKOrAbove then loadSet(self.data.wotlk) end
    if isCataOrAbove then loadSet(self.data.cata) end
    if isMistsOrAbove then loadSet(self.data.mists) end
    if isRetail then loadSet(self.data.retail) end
end

function Teleporters:hydrateTeleportersTable()
    -- Clear the table of items if needed.
    table.wipe(teleporters)

    -- Helper for batch insert
    local function loadSet(data)
        for _, v in ipairs(data) do
            if not v.condition or v.condition() then
                table.insert(teleporters, { itemID = v[1], itemName = v[2] })
            end
        end
    end

    if (isClassic or isTBC or isWotLK or isCata) and db.enablePortalReagents then
        -- Add the reagents for mage portals to the teleporters category.
        loadSet(self.data.enablePortalReagents)
    end

    -- Section Vanilla
    if isClassicOrAbove then
        loadSet(self.data.classic)
    end
    -- Section TBC
    if isTBCOrAbove then
        loadSet(self.data.tbc)
    end
    -- Section WotLK
    if isWotLKOrAbove then
        loadSet(self.data.wotlk)
    end
    -- Section Cataclysm
    if isCataOrAbove then
        loadSet(self.data.cata)
    end
    -- Section Mists
    if isMistsOrAbove then
        loadSet(self.data.mists)
    end
    -- Section WoD
    if isRetail then
        loadSet(self.data.wod)
    end
    -- Section Legion
    if isRetail then
        loadSet(self.data.legion)
    end
    -- Section BFA
    if isRetail then
        loadSet(self.data.bfa)
    end
    -- Section Shadowlands
    if isRetail then
        loadSet(self.data.sl)
    end
    -- Section Dragonflight
    if isRetail then
        loadSet(self.data.df)
    end
    -- Section The War Within
    if isRetail then
        loadSet(self.data.tww)
    end
    if interfaceVersion >= 110207 then
        loadSet(self.data.patchContent)
    end
end

function Teleporters:addTeleportersToCategory()
    local ctx = Context:New('BBTeleporters_AddItemToCategory')
    -- Loop through list of teleporters and add to category.
    for _, item in ipairs(teleporters) do
        Categories:AddItemToCategory(ctx, item.itemID, L:G("Teleporters"))
        --@debug@
        print("Added " .. item.itemName .. " to category " .. L:G("Teleporters"))
        --@end-debug@
    end
end

-- On plugin load, wipe the Categories we've added
function Teleporters:OnInitialize()
    self.db = AceDB:New("BetterBags_TeleportersDB", defaults)
    self.db:SetProfile("global")
    db = self.db.profile

    self:addTeleportersConfig()
    self:clearTeleportCategory()
    self:hydrateTeleportersTable()
    self:addTeleportersToCategory()
end
