-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- $Id$
-- Version 2.9.1 by Dathus [BR] on 2023-06-10 3:25 PM (-03:00 GMT)

local PANEL = {}

function PANEL:Init()
  self.Chrome = vgui.Create("PlayXHTMLControls", self);
  self.Chrome:Dock(TOP)
  self.Chrome.HomeURL = GetConVar("playx_navigator_homepage_url"):GetString():Trim()
end

function PANEL:OpeningVideo(provider, uri)
end

function PANEL:Paint()
  if not self.Started then
    self.Started = true

    self.HTML = vgui.Create("PlayXHTML", self)
    self.HTML:Dock(FILL)
    self.HTML:OpenURL(GetConVar("playx_navigator_homepage_url"):GetString():Trim())

    self.Chrome:SetHTML(self.HTML)

    self:InvalidateLayout()

  end
end

vgui.Register("PlayXBrowser", PANEL, "Panel")
