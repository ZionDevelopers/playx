-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.0 by DathusBR on 2026-05-11 02:12 PM (-03:00 GMT)

if PlayX.translation == nil then
    include("playx/translation/translation.lua")
    PlayX.initTranslation()
end

ENT.Type = "anim"
ENT.Base = "gmod_playx"
 
ENT.PrintName = PlayX.translate("playx_repeater")
ENT.Author = "DathusBR"
ENT.Contact = "https://www.juliocesar.me"
ENT.Purpose = PlayX.translate("repeater_purpose")
ENT.Instructions = PlayX.translate("repeater_instructions")
ENT.Category = "PlayX"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

cleanup.Register("gmod_playx_repeater")