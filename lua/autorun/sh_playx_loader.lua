-- PlayX
-- Copyright (c) 2009 sk89q <http://www.sk89q.com>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$
-- Version 2.8.0 by Nexus [BR] on 13-08-2013 02:48 PM

--Setup Loading Log Formatation
include("playx/basic.lua")

Msg( "\n/====================================\\\n")
Msg( "||               PlayX              ||\n" )
Msg( "||----------------------------------||\n" )
loadingLog("Version 2.8.0")
loadingLog("Updated on 13-08-2013")
Msg( "||----------------------------------||\n" )
Msg( "||  Loading...                      ||\n" )

if CLIENT then
	-- Loading Client
	loadingLog("PlayX Client")
	include("playx/client/playx.lua")
elseif SERVER then
	-- Check if vON Library is Loaded Already
	if von == nil then
		loadingLog("vON")
		include("von.lua")
	end
	
	AddCSLuaFile("playxlib.lua")
	AddCSLuaFile("playx/basic.lua")
	AddCSLuaFile("playx/client/playx.lua")
	AddCSLuaFile("playx/client/bookmarks.lua")
	AddCSLuaFile("playx/client/vgui/playx_browser.lua")
	AddCSLuaFile("playx/client/panel.lua")
	
	-- Add handlers
	local p = file.Find("playx/client/handlers/*.lua","LUA")
	for _, file in pairs(p) do
	    AddCSLuaFile("playx/client/handlers/" .. file)
	end
	
	-- Loading PlayX Server
	loadingLog("PlayX Server")
	include("playx/playx.lua")
end
Msg( "\\====================================/\n\n" )
