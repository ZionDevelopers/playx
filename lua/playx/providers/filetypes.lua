-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.8 by DathusBR on 2026-07-07 01:18 PM (-03:00 GMT)

local Shoutcast = {}

function Shoutcast.Detect(uri)
    local m = playxlib.FindMatch(uri, {
        "^https?://[^:/]+/;stream%.nsv$",
        "^https?://[^:/]+:[0-9]+/?$",
    })
    
    if m then
        return m[1]
    end
end

function Shoutcast.GetPlayer(uri, useJW)
    local m = playxlib.FindMatch(uri, {
        "^https?://.+$",
    })
    
    if m then        
        return {
            ["Handler"] = "Shoutcast",
            ["URI"] = GetConVar("playx_shoutcast_host_url"):GetString():Trim() .. "?url=" .. playxlib.url(uri),
            ["ResumeSupported"] = true,
            ["LowFramerate"] = true,
            ["MetadataFunc"] = function(callback, failCallback)
                Shoutcast.QueryMetadata(uri, callback, failCallback)
            end,
        }
    end
end

function Shoutcast.QueryMetadata(uri, callback, failCallback)
    callback({
        ["URL"] = uri,
    })
end

list.Set("PlayXProviders", "Shoutcast", Shoutcast)
list.Set("PlayXProvidersList", "Shoutcast", {"Shoutcast"})

local MP3 = {}

function MP3.Detect(uri)
    local m = playxlib.FindMatch(uri:gsub("%?.*$", ""), {
        "^https?://.+%.mp3$",
        "^https?://.+%.MP3$",
    })
    
    if m then
        return m[1]
    end
end

function MP3.GetPlayer(uri, useJW)
    if uri:lower():find("^https?://") then
        return {
            ["Handler"] = "JWAudio",
            ["URI"] = uri,
            ["ResumeSupported"] = true,
            ["LowFramerate"] = true,
            ["MetadataFunc"] = function(callback, failCallback)
                MP3.QueryMetadata(uri, callback, failCallback)
            end,
        }
    end
end

function MP3.QueryMetadata(uri, callback, failCallback)
    callback({
        ["URL"] = uri,
    })
end

list.Set("PlayXProviders", "MP3", MP3)
list.Set("PlayXProvidersList", "MP3", {"MP3"})

local Video = {}

function Video.Detect(uri)
    local m = playxlib.FindMatch(uri:gsub("%?.*$", ""), {
        "^https?://.+%.mp4$",
        "^https?://.+%.MP4$",
        "^https?://.+%.webm$",
        "^https?://.+%.WEBM$",
        "^https?://.+%.aac$",
        "^https?://.+%.AAC$",
    })
    
    if m then
        return m[1]
    end
end

function Video.GetPlayer(uri, useJW)
    if uri:lower():find("^https?://") then
        return {
            ["Handler"] = "JWVideo",
            ["URI"] = uri,
            ["ResumeSupported"] = true,
            ["LowFramerate"] = false,
            ["MetadataFunc"] = function(callback, failCallback)
                Video.QueryMetadata(uri, callback, failCallback)
            end,
        }
    end
end

function Video.QueryMetadata(uri, callback, failCallback)
    callback({
        ["URL"] = uri,
    })
end

list.Set("PlayXProviders", "Video", Video)
list.Set("PlayXProvidersList", "Video", {"MP4/AAC/WEBM"})

local Image = {}

function Image.Detect(uri)
    local m = playxlib.FindMatch(uri:gsub("%?.*$", ""), {
        "^http://.+%.jpe?g$",
        "^http://.+%.JPE?G$",
        "^http://.+%.png$",
        "^http://.+%.PNG$",
        "^http://.+%.gif$",
        "^http://.+%.GIF$",
    })
    
    if m then
        return m[1]
    end
end

function Image.GetPlayer(uri, useJW)
    if uri:lower():find("^https?://") then
        return {
            ["Handler"] = "IFrame",
            ["URI"] = GetConVar("playx_image_host_url"):GetString() .. "?url=" .. uri,
            ["ResumeSupported"] = true,
            ["LowFramerate"] = false,
            ["MetadataFunc"] = function(callback, failCallback)
                Image.QueryMetadata(uri, callback, failCallback)
            end,
        }
    end
end

function Image.QueryMetadata(uri, callback, failCallback)
    callback({
        ["URL"] = uri,
    })
end

list.Set("PlayXProviders", "Image", Image)
list.Set("PlayXProvidersList", "Image", {"Image"})
list.Set("PlayXProviders", "AnimatedImage", Image) -- Legacy