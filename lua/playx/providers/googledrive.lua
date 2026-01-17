-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.9.24 by Dathus [BR] on 2026-01-17 12:47 PM (-03:00 GMT)

local GoogleDrive = {}

function GoogleDrive.Detect(uri)
    local m = playxlib.FindMatch(uri, {
        "^https://drive%.google%.com/open%?id=([A-Za-z0-9_%-]+)",
        "^https://drive%.google%.com/file/d/([A-Za-z0-9_%-]+)/view"
    })

    if m then
        return m[1]
    end
end

function GoogleDrive.GetPlayer(uri, useJW)
    if uri:find("^[A-Za-z0-9_%-]+$") then
        local url = "https://drive.google.com/file/d/" .. uri .."/preview?autoplay=true"

        return {
            ["Handler"] = "GoogleDrive",
            ["URI"] = url,
            ["ResumeSupported"] = true,
            ["LowFramerate"] = false,
            ["MetadataFunc"] = function(callback, failCallback)
                GoogleDrive.QueryMetadata(uri, callback, failCallback)
            end
        }
    end
end

function GoogleDrive.QueryMetadata(uri, callback, failCallback)  
    callback({
        ["URL"] = "https://drive.google.com/file/d/".. uri .."/view",
    })    
end

list.Set("PlayXProviders", "GoogleDrive", GoogleDrive)
list.Set("PlayXProvidersList", "GoogleDrive", {"Google Drive"})
