-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.4 by DathusBR on 2026-06-24 05:31 PM (-03:00 GMT)

PlayX = PlayX or {}
PlayX.Translation = {}
PlayX.Translation.data = {}
PlayX.Translation.language = ""
PlayX.Translation.fallback = "en"

-- Gets the current language code.
-- @return string The current language code.
PlayX.Translation.getLanguage = function ()
    local gmod_language = GetConVar("gmod_language")

    if CLIENT then
		return gmod_language and gmod_language:GetString() or PlayX.Translation.fallback
	else
        return PlayX.Translation.fallback
    end
end

-- Imports a translation table for a specific language.
-- @param language string The language code (e.g., "en", "fr").
-- @param data table A table containing key-value pairs of translation strings.
PlayX.Translation.import = function (language, data)
    PlayX.Translation.data[language] = data
end

-- Start translation
PlayX.Translation.init = function ()
    PlayX.Translation.language = PlayX.Translation.getLanguage()
    cvars.AddChangeCallback("gmod_language", function (cvar, old, new)
        PlayX.Translation.language = PlayX.Translation.getLanguage()
    end)
    -- Load translations
    local p = file.Find("playx/translation/locale/*.lua","LUA")
    for _, file in pairs(p) do
        local status, err = pcall(function() include("playx/translation/locale/" .. file) end)
        if not status then
            ErrorNoHalt("Failed to load translation(s) in " .. file .. ": " .. err)
        end

        if SERVER then
            local status, err = pcall(function() AddCSLuaFile("playx/translation/locale/" .. file) end)
            if not status then
                ErrorNoHalt("Failed to load translation(s) in " .. file .. ": " .. err)
            end
        end
    end
end

-- Translates a given key using the current language, with optional formatting.
-- @param key string The translation key to look up.
-- @param ... Additional arguments to format the translation string.
-- @return string The translated and formatted string.
PlayX.Translation.get = function (key, ...)
    local translationTable = PlayX.Translation.data[PlayX.Translation.language] or PlayX.Translation.data[PlayX.Translation.fallback]
    local translation = translationTable[key] or key
    local args = {...}
    if #args > 0 then
        return string.format(translation, ...)
    else
        return translation
    end
    
end
