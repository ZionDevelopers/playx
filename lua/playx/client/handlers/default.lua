-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.8 by DathusBR on 2026-07-07 01:18 PM (-03:00 GMT)

list.Set("PlayXHandlers", "IFrame", function(width, height, start, volume, uri, handlerArgs)
    return playxlib.GenerateIFrame(width, height, uri)
end)

list.Set("PlayXHandlers", "JW", function(width, height, start, volume, uri, handlerArgs)
     return playxlib.GenerateJWPlayer(width, height, start, volume, uri, handlerArgs)
end)

list.Set("PlayXHandlers", "JWVideo", function(width, height, start, volume, uri, handlerArgs)
    return playxlib.GenerateJWPlayer(width, height, start, volume, uri, "video")
end)

list.Set("PlayXHandlers", "JWAudio", function(width, height, start, volume, uri, handlerArgs)
    return playxlib.GenerateJWPlayer(width, height, start, volume, uri, "mp3")
end)
