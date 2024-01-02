-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.9.10 by Dathus [BR] on 2023-08-19 9:52 PM (-03:00 GMT)

-- Check if vON Library is Loaded Already
if von == nil then
	include("von.lua")
end

resource.AddWorkshop("106516163")

AddCSLuaFile("autorun/client/playx_init.lua")
AddCSLuaFile("playxlib.lua")
AddCSLuaFile("playx/client/playx.lua")
AddCSLuaFile("playx/client/bookmarks.lua")
AddCSLuaFile("playx/client/context-menu.lua")
AddCSLuaFile("playx/client/vgui/playx_browser.lua")
AddCSLuaFile("playx/client/panel.lua")

-- Add handlers
local p = file.Find("playx/client/handlers/*.lua","LUA")
for _, file in pairs(p) do
    AddCSLuaFile("playx/client/handlers/" .. file)
end

include("playx/playx.lua")