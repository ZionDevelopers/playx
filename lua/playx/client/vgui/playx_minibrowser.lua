-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
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

local PANEL = {}

function PANEL:Init()
end

function PANEL:OpeningVideo(provider, uri)
end

function PANEL:Open(provider, uri)
    MsgN("PlayXBrowser: Requested to open <" .. provider .. "> / <"  .. uri .. ">")
    PlayX.RequestOpenMedia(provider, uri, 0, false, GetConVar("playx_use_jw"):GetBool(),
                           GetConVar("playx_ignore_length"):GetBool())
    self:OpeningVideo(provider, uri)
end

function PANEL:Paint()
	if not self.Started then
		self.Started = true
		
		self.HTML = vgui.Create("PlayXHTML", self)
		self.HTML:Dock(FILL)
		self.HTML:OpenURL("http://m.youtube.com/my_favorites")
        
        local oldOpenURL = self.HTML.OpeningURL
        local Detected = false
        local OpenURL = false
        local DetectedProvider = ""
        local Test = ""
        
        self.HTML.OpeningURL = function(_, url, target, postdata)
            for id, p in pairs(list.Get("PlayXProviders")) do
            	Test = p.Detect(uri)
            	if Test then 
            		Detected = true
            		DetectedProvider = id
            		OpenURL = Test
            		break
            	end
            end
            
            if Detected then
				PlayX.NavigatorCapturedURL = OpenURL
				self.HTML:OpenURL(self.Chrome.HomeURL)
                self:Open(DetectedProvider, OpenURL)                
                return true
            end
            
            oldOpenURL(_, url, target, postdata)
        end
        
		self:InvalidateLayout()
		
	end
end

vgui.Register("PlayXMiniBrowser", PANEL, "Panel")
