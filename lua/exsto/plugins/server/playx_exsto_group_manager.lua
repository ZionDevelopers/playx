-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.7.9 by Nexus [BR] on 12-07-2013 02:48 PM

 -- Exsto
 -- PlayX Plugin 

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
	Name = "PlayX",
	ID = "playx",
	Desc = "A plugin that allows PlayX Usage!",
	Owner = "Nexus [BR]",
	CleanUnload = true;
} )

function PLUGIN:Init()
	exsto.CreateFlag( "playxaccess", "Allows users to use PlayX." )
end

function PLUGIN:OnUnload()
	exsto.Flags["playxaccess"] = nil
end

PLUGIN:Register()