-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.0 by DathusBR on 2026-05-11 02:12 PM (-03:00 GMT)

include("shared.lua")

language.Add("gmod_playx_repeater", PlayX.translate("playx_repeater"))
language.Add("Undone_gmod_playx_repeater", PlayX.translate("undone_playx_repeater"))
language.Add("Undone_#gmod_playx_repeater", PlayX.translate("undone_playx_repeater"))
language.Add("Cleanup_gmod_playx_repeater", PlayX.translate("cleanup_playx_repeater"))
language.Add("Cleaned_gmod_playx_repeater", PlayX.translate("cleaned_playx_repeater"))

function ENT:Initialize()
    self.Entity:DrawShadow(false)
    
    self.DrawCenter = false
    self.NoScreen = false
    
    self:UpdateScreenBounds()
end

function ENT:DrawScreen(centerX, centerY)
    if IsValid(self.SourceInstance) then
        if not self.SourceInstance.NoScreen then
            self.SourceInstance:DrawScreen(centerX, centerY)
        else
        draw.SimpleText(PlayX.translate("playx_source_no_screen"),
                        "HUDNumber",
                        centerX, centerY, Color(255, 255, 255, 255),
                        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    else
        draw.SimpleText(PlayX.translate("playx_source_required"),
                        "HUDNumber",
                        centerX, centerY, Color(255, 255, 255, 255),
                        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function ENT:Think()  
    if not IsValid(self.SourceInstance) then
        self.SourceInstance = PlayX.GetInstance()
    end
    
    if IsValid(self.SourceInstance) then
        self.DrawCenter = self.SourceInstance.DrawCenter
    end
    self:NextThink(CurTime() + 0.1)  
end  

function ENT:OnRemove() 
end  