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
-- Version 2.8.5 by Nexus [BR] on 10-01-2014 09:25 PM (-02:00 GMT)

local apiKey = "AI39si79-V-ltHhNyYvyTeaiJeexopkZoiUA56Sk-W8Z5alYUkgntdwvkmu1" ..
               "avAWGNixM_DuLx8-Jai6qy1am7HhbhYvWERzWA"

local GoogleDrive = {}

function GoogleDrive.Detect(uri)    
    local m = playxlib.FindMatch(uri, {
        "^https?://docs.google.com/file/d/([A-Za-z0-9_%-]+)",
		"^https?://drive.google.com/open%?.*id=([A-Za-z0-9_%-]+)",
		"^https?://drive.google.com/file/d/([A-Za-z0-9_%-]+)",
    })
    
    if m then
        return m[1]
    end
end

function GoogleDrive.GetPlayer(uri, useJW)
    if uri:find("^[A-Za-z0-9_%-]+$") then
		local vars = {
			["autoplay"] = "1",
			["start"] = "__start__",
			["rel"] = "0",
			["hd"] = "0",
			["showsearch"] = "0",
			["showinfo"] = "0",
			["enablejsapi"] = "1",
			["version"] = "3"
		}
		local url = Format("https://video.google.com/get_player?docid=%s&=docs&partnerid=30&cc_load_policy=1&controls=0&%s", uri, playxlib.URLEscapeTable(vars))
		Msg(url .. "Hi Mom!")
		return {
			["Handler"] = "FlashAPI",
			["URI"] = url,
			["ResumeSupported"] = true,
			["LowFramerate"] = false,
			["MetadataFunc"] = function(callback, failCallback)
				GoogleDrive.QueryMetadata(uri, callback, failCallback)
			end,
			["HandlerArgs"] = {
				["JSInitFunc"] = "onYouTubePlayerRead",
				["JSVolumeFunc"] = "setVolume",
				["StartMul"] = 1,
			},
		}
    end
end

function GoogleDrive.QueryMetadata(uri, callback, failCallback)
    local vars = playxlib.URLEscapeTable({
        ["alt"] = "atom",
        ["key"] = apiKey,
        ["client"] = game.SinglePlayer() and "SP" or ("MP:" .. GetConVar("hostname"):GetString()),
    })
    //UTF8 URL Decode
    local decodeURI
    do
        local char, gsub, tonumber = string.char, string.gsub, tonumber
        local function _(hex) return char(tonumber(hex, 16)) end
    
        function decodeURI(s)
			if (s==nil) then return end
            s = gsub(s, '%%(%x%x)', _)
            return s
        end
    end
	//End Decode
	local url = "https://docs.google.com/get_video_info?authuser=&docid="..uri
    http.Fetch(url, function(result, size)
        if size == 0 then
            failCallback("HTTP request failed (size = 0)")
            return
        end
		local checkData = string.sub(result,1,2)
		if(checkData=="<!") then
			failCallback('ERROR! file not found.')
			return
		end
		
		local status = string.match(result, 'status=([^&]+)')
		if(status=="fail") then
			failCallback('ERROR! file is not video or file is private.')
			PrintMessage(HUD_PRINTTALK, "The Google Drive video \""..uri.."\" that you tried to play is unavailable!")
			return false
		end
		
		local title = decodeURI(playxlib.HTMLUnescape(string.match(result, 'title=([^&]+)')))				
		local length = tonumber(string.match(result, 'length_seconds=([^ ]+)'))		
		local thumbnail = decodeURI(playxlib.HTMLUnescape(string.match(result, 'iurl=([^&]+)')))
		
        if length then
            callback({
                ["URL"] = "https://docs.google.com/file/d/" .. uri .. "/edit",
                ["Title"] = title,
                ["Length"] = length,
                ["Thumbnail"] = thumbnail,
            })
        else
            callback({
                ["URL"] = "https://docs.google.com/file/d/" .. uri .. "/edit",
            })
        end
    end)
end

list.Set("PlayXProviders", "GoogleDrive", GoogleDrive)
list.Set("PlayXProvidersList", "GoogleDrive", {"GoogleDrive"})