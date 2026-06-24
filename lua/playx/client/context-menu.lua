-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.0 by DathusBR on 2026-05-11 02:12 PM (-03:00 GMT)

-- Add Hook for MenuPar Polulate
hook.Add( "PopulateMenuBar", "", function( menubar )

  -- Get / Add Context Menu Bar: PlayX
  local mbar = menubar:AddOrGetMenu( "PlayX" )

  mbar:AddCVar( PlayX.Translation.get("fullscreen_contextmenu"), "playx_fullscreen", "1", "0" )    
end )
