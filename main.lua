-- Variables --
---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

---@class Categories: AceModule
local categories = addon:GetModule('Categories')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

-- Add the list of items that teleport you
local teleporters = {
    { itemID = 6948, itemName = "Hearthstone" },
    { itemID = 17690, itemName = "Frostwolf Insignia Rank 1" },
    { itemID = 17691, itemName = "Stormpike Insignia Rank 1" },
    { itemID = 17900, itemName = "Stormpike Insignia Rank 2" },
    { itemID = 17901, itemName = "Stormpike Insignia Rank 3" },
    { itemID = 17902, itemName = "Stormpike Insignia Rank 4" },
    { itemID = 17903, itemName = "Stormpike Insignia Rank 5" },
    { itemID = 17904, itemName = "Stormpike Insignia Rank 6" },
    { itemID = 17905, itemName = "Frostwolf Insignia Rank 2" },
    { itemID = 17906, itemName = "Frostwolf Insignia Rank 3" },
    { itemID = 17907, itemName = "Frostwolf Insignia Rank 4" },
    { itemID = 17908, itemName = "Frostwolf Insignia Rank 5" },
    { itemID = 17909, itemName = "Frostwolf Insignia Rank 6" },
    { itemID = 18149, itemName = "Rune of Recall (Frostwolf Keep)" },
    { itemID = 18150, itemName = "Rune of Recall (Dun Baldar)" },
    { itemID = 18984, itemName = "Dimensional Ripper - Everlook" },
    { itemID = 18986, itemName = "Ultrasafe Transporter - Gadgetzan" },
    { itemID = 22589, itemName = "Atiesh, Greatstaff of the Guardian (Mage)" },
    { itemID = 22630, itemName = "Atiesh, Greatstaff of the Guardian (Warlock)" },
    { itemID = 22631, itemName = "Atiesh, Greatstaff of the Guardian (Priest)" },
    { itemID = 22632, itemName = "Atiesh, Greatstaff of the Guardian (Druid)" },
    { itemID = 28585, itemName = "Ruby Slippers" },
    { itemID = 29796, itemName = "Socrethar's Teleportation Stone" },
    { itemID = 30542, itemName = "Dimensional Ripper - Area 52" },
    { itemID = 32757, itemName = "Blessed Medallion of Karabor" },
    { itemID = 35230, itemName = "Darnarian's Scroll of Teleportation" },
    { itemID = 36955, itemName = "Ultrasafe Transporter - Toshley's Station" },
    { itemID = 37118, itemName = "Scroll of Recall" },
    { itemID = 37863, itemName = "Direbrew's Remote" },
    { itemID = 38685, itemName = "Teleport Scroll: Zul'Farrak" },
    { itemID = 40585, itemName = "Signet of the Kirin Tor" },
    { itemID = 40586, itemName = "Band of the Kirin Tor" },
    { itemID = 43824, itemName = "The Schools of Arcane Magic - Mastery (spires atop the Violet Citadel)" },
    { itemID = 44934, itemName = "Loop of the Kirin Tor" },
    { itemID = 44935, itemName = "Ring of the Kirin Tor" },
    { itemID = 45688, itemName = "Inscribed Band of the Kirin Tor" },
    { itemID = 45689, itemName = "Inscribed Loop of the Kirin Tor" },
    { itemID = 45690, itemName = "Inscribed Ring of the Kirin Tor" },
    { itemID = 45691, itemName = "Inscribed Signet of the Kirin Tor" },
    { itemID = 46874, itemName = "Argent Crusader's Tabard" },
    { itemID = 48933, itemName = "Wormhole Generator: Northrend" },
    { itemID = 48954, itemName = "Etched Band of the Kirin Tor" },
    { itemID = 48955, itemName = "Etched Loop of the Kirin Tor" },
    { itemID = 48956, itemName = "Etched Ring of the Kirin Tor" },
    { itemID = 48957, itemName = "Etched Signet of the Kirin Tor" },
    { itemID = 50287, itemName = "Boots of the Bay" },
    { itemID = 51557, itemName = "Runed Signet of the Kirin Tor" },
    { itemID = 51558, itemName = "Runed Loop of the Kirin Tor" },
    { itemID = 51559, itemName = "Runed Ring of the Kirin Tor" },
    { itemID = 51560, itemName = "Runed Band of the Kirin Tor" },
    { itemID = 52251, itemName = "Jaina's Locket" },
    { itemID = 54452, itemName = "Ethereal Portal" },
    { itemID = 60336, itemName = "Scroll of Recall II" },
    { itemID = 60337, itemName = "Scroll of Recall III" },
    { itemID = 58487, itemName = "Potion of Deepholm" },
    { itemID = 61379, itemName = "Gidwin's Hearthstone" },
    { itemID = 63206, itemName = "Wrap of Unity: Stormwind" },
    { itemID = 63207, itemName = "Wrap of Unity: Orgrimmar" },
    { itemID = 63352, itemName = "Shroud of Cooperation: Stormwind" },
    { itemID = 63353, itemName = "Shroud of Cooperation: Orgrimmar" },
    { itemID = 63378, itemName = "Hellscream's Reach Tabard" },
    { itemID = 63379, itemName = "Baradin's Wardens Tabard" },
    { itemID = 64457, itemName = "The Last Relic of Argus" },
    { itemID = 64488, itemName = "The Innkeeper's Daughter" },
    { itemID = 65274, itemName = "Cloak of Coordination: Orgrimmar" },
    { itemID = 65360, itemName = "Cloak of Coordination: Stormwind" },
    { itemID = 68808, itemName = "Hero's Hearthstone" },
    { itemID = 68809, itemName = "Veteran's Hearthstone" },
    { itemID = 87215, itemName = "Wormhole Generator: Pandaria" },
    { itemID = 87548, itemName = "Lorewalker's Lodestone" },
    { itemID = 92510, itemName = "Vol'jin's Hearthstone" },
    { itemID = 93672, itemName = "Dark Portal (MoP)" },
    { itemID = 95050, itemName = "The Brassiest Knuckle (Brawl'gar Arena)" },
    { itemID = 95051, itemName = "The Brassiest Knuckle (Bizmo's Brawlpub)" },
    { itemID = 95567, itemName = "Kirin Tor Beacon" },
    { itemID = 95568, itemName = "Sunreaver Beacon" },
    { itemID = 103678, itemName = "Time-Lost Artifact" },
    { itemID = 110560, itemName = "Garrison Hearthstone" },
    { itemID = 112059, itemName = "Wormhole Centrifuge" },
    { itemID = 117389, itemName = "Draenor Archaeologist's Lodestone" },
    { itemID = 118662, itemName = "Bladespire Relic" },
    { itemID = 118663, itemName = "Relic of Karabor" },
    { itemID = 118907, itemName = "Pit Fighter's Punching Ring (Bizmo's Brawlpub)" },
    { itemID = 118908, itemName = "Pit Fighter's Punching Ring (Brawl'gar Arena)" },
    { itemID = 119183, itemName = "Scroll of Risky Recall" },
    { itemID = 128502, itemName = "Hunter's Seeking Crystal" },
    { itemID = 128503, itemName = "Master Hunter's Seeking Crystal" },
    { itemID = 128353, itemName = "Admiral's Compass" },
    { itemID = 129276, itemName = "Beginner's Guide to Dimensional Rifting" },
    { itemID = 132119, itemName = "Orgrimmar Portal Stone" },
    { itemID = 132120, itemName = "Stormwind Portal Stone" },
    { itemID = 132517, itemName = "Intra-Dalaran Wormhole Generator" },
    { itemID = 132523, itemName = "Reaves Battery" },
    { itemID = 138448, itemName = "Emblem of Margoss" },
    { itemID = 139590, itemName = "Scroll of Teleport: Ravenholdt" },
    { itemID = 139599, itemName = "Empowered Ring of the Kirin Tor" },
    { itemID = 140192, itemName = "Dalaran Hearthstone" },
    { itemID = 140493, itemName = "Adept's Guide to Dimensional Rifting" },
    { itemID = 141013, itemName = "Scroll of Town Portal: Shala'nir" },
    { itemID = 141014, itemName = "Scroll of Town Portal: Sashj'tar" },
    { itemID = 141015, itemName = "Scroll of Town Portal: Kal'delar" },
    { itemID = 141016, itemName = "Scroll of Town Portal: Faronaar" },
    { itemID = 141017, itemName = "Scroll of Town Portal: Lian'tril" },
    { itemID = 141324, itemName = "Talisman of the Shal'dorei" },
    { itemID = 141605, itemName = "Flight Master's Whistle" },
    { itemID = 142298, itemName = "Astonishingly Scarlet Slippers" },
    { itemID = 142469, itemName = "Violet Seal of the Grand Magus" },
    { itemID = 142542, itemName = "Tome of Town Portal (Diablo 3 event)" },
    { itemID = 142543, itemName = "Scroll of Town Portal (Diablo 3 event)" },
    { itemID = 144341, itemName = "Rechargeable Reaves Battery" },
    { itemID = 144391, itemName = "Pugilist's Powerful Punching Ring (Alliance)" },
    { itemID = 144392, itemName = "Pugilist's Powerful Punching Ring (Horde)" },
    { itemID = 150733, itemName = "Scroll of Town Portal (Ar'gorok in Arathi)" },
    { itemID = 151652, itemName = "Wormhole Generator: Argus" },
    { itemID = 159224, itemName = "Zuldazar Hearthstone" },
    { itemID = 160219, itemName = "Scroll of Town Portal (Stromgarde in Arathi)" },
    { itemID = 162973, itemName = "Greatfather Winter's Hearthstone" },
    { itemID = 163045, itemName = "Headless Horseman's Hearthstone" },
    { itemID = 163694, itemName = "Scroll of Luxurious Recall" },
    { itemID = 166559, itemName = "Commander's Signet of Battle" },
    { itemID = 166560, itemName = "Captain's Signet of Command" },
    { itemID = 165669, itemName = "Lunar Elder's Hearthstone" },
    { itemID = 165670, itemName = "Peddlefeet's Lovely Hearthstone" },
    { itemID = 165802, itemName = "Noble Gardener's Hearthstone" },
    { itemID = 166746, itemName = "Fire Eater's Hearthstone" },
    { itemID = 166747, itemName = "Brewfest Reveler's Hearthstone" },
    { itemID = 167075, itemName = "Ultrasafe Transporter: Mechagon" },
    { itemID = 168807, itemName = "Wormhole Generator: Kul Tiras" },
    { itemID = 168808, itemName = "Wormhole Generator: Zandalar" },
    { itemID = 168862, itemName = "G.E.A.R. Tracking Beacon" },
    { itemID = 168907, itemName = "Holographic Digitalization Hearthstone" },
    { itemID = 169064, itemName = "Montebank's Colorful Cloak" },
    { itemID = 169297, itemName = "Stormpike Insignia" },
    { itemID = 172179, itemName = "Eternal Traveler's Hearthstone" },
    { itemID = 172203, itemName = "Cracked Hearthstone" },
    { itemID = 172924, itemName = "Wormhole Generator: Shadowlands" },
    { itemID = 173373, itemName = "Faol's Hearthstone" },
    { itemID = 173430, itemName = "Nexus Teleport Scroll" },
    { itemID = 173532, itemName = "Tirisfal Camp Scroll" },
    { itemID = 173528, itemName = "Gilded Hearthstone" },
    { itemID = 173537, itemName = "Glowing Hearthstone" },
    { itemID = 173716, itemName = "Mossy Hearthstone" },
    { itemID = 180290, itemName = "Night Fae Hearthstone" },
    { itemID = 180817, itemName = "Cypher of Relocation (Ve'nari's Refuge)" },
    { itemID = 181163, itemName = "Scroll of Teleport: Theater of Pain" },
    { itemID = 182773, itemName = "Necrolord's Hearthstone" },
    { itemID = 183716, itemName = "Venthyr Sinstone" },
    { itemID = 184353, itemName = "Kyrian Hearthstone" },
    { itemID = 184500, itemName = "Attendant's Pocket Portal: Bastion" },
    { itemID = 184501, itemName = "Attendant's Pocket Portal: Revendreth" },
    { itemID = 184502, itemName = "Attendant's Pocket Portal: Maldraxxus" },
    { itemID = 184503, itemName = "Attendant's Pocket Portal: Ardenweald" },
    { itemID = 184504, itemName = "Attendant's Pocket Portal: Oribos" },
    { itemID = 188952, itemName = "Dominated Hearthstone" },
    { itemID = 189827, itemName = "Cartel Xy's Proof of Initiation" },
    { itemID = 190196, itemName = "Enlightened Hearthstone" },
    { itemID = 190237, itemName = "Broker Translocation Matrix" },
    { itemID = 191029, itemName = "Lilian's Hearthstone" },
    { itemID = 193588, itemName = "Timewalker's Hearthstone" },
    { itemID = 198156, itemName = "Wyrmhole Generator: Dragon Isles" },
    { itemID = 200613, itemName = "Aylaag Windstone Fragment" },
    { itemID = 200630, itemName = "Ohn'ir Windsage's Hearthstone" },
    { itemID = 201957, itemName = "Thrall's Hearthstone" },
    { itemID = 202046, itemName = "Lucky Tortollan Charm" },
    { itemID = 204481, itemName = "Morqut Hearth Totem" },
    { itemID = 204802, itemName = "Scroll of Teleport: Zskera Vaults" },
    { itemID = 205255, itemName = "Niffen Diggin' Mitts" },
    { itemID = 209035, itemName = "Hearthstone of the Flame" },
    { itemID = 212337, itemName = "Stone of the Hearth" },
}

-- Loop through list of teleporters and add to category.
for _, item in ipairs(teleporters) do
    categories:AddItemToCategory(item.itemID, L:G("Teleporters"))
end