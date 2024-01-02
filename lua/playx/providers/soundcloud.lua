-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- Soundcloud provider coded initially by Xerasin

-- Version 2.9.6 by Dathus [BR] on 2023-06-11 4:54 PM (-03:00 GMT)

local SoundCloud = {}

function SoundCloud.Detect(uri, useJW)
  local m = playxlib.FindMatch(uri:gsub("%?.*$", ""), {
    "^http[s]?://soundcloud.com/(.+)/(.+)$",
    "^http[s]?://www.soundcloud.com/(.+)/(.+)$",
    "^http[s]?://api.soundcloud.com/tracks/(%d)+",
  })
  if(m) then
    if m[1] and m[2] then
      return "http://soundcloud.com/"..m[1].."/"..m[2]
    elseif(m[1]) then
      return "http://api.soundcloud.com/tracks/"..m[1]
    end
  end
end

function SoundCloud.GetPlayer(uri, useJW)
  local url = uri
  return {
    ["Handler"] = "SoundCloud",
    ["URI"] = GetConVarString("playx_soundcloud_host_url") .. '?url=' .. url,
    ["ResumeSupported"] = true,
    ["LowFramerate"] = false,
    ["QueryMetadata"] = function(callback, failCallback)
      SoundCloud.QueryMetadata(uri, callback, failCallback)
    end,
    ["HandlerArgs"] = {
      ["VolumeMul"] = 0.1,
    },
  }
end

function SoundCloud.QueryMetadata(uri, callback, failCallback)
  local url = "http://api.soundcloud.com/resolve.json?url=" .. uri .. "&client_id=3775c0743f360c022a2fed672e33909d"

  http.Fetch(url,function(content,size)
    local dec = util.JSONToTable(content)
    if content == NULL or not dec then
      if failCallback then failCallback("Failed to get Metadata") end
      return
    end
    if(dec and dec["title"] ~= nil) then
      local title = dec["title"]
      local desc = dec["description"]
      local viewerCount = dec["playback_count"]
      --local tags = playxlib.ParseTags(dec["tag_list"])
      callback({
        ["Duration"] = math.floor(tonumber(dec["duration"])/1000),
        ["URL"] = dec["uri"],
        ["URL2"] = uri,
        ["Title"] = title,
        ["Description"] = desc,
        ["Tags"] = tags,
        ["ViewerCount"] = viewerCount,
      })
    end
  end)
end

list.Set("PlayXProviders", "SoundCloud", SoundCloud)
list.Set("PlayXProvidersList", "SoundCloud", {"SoundCloud"})
