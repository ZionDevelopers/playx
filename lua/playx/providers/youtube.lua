-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.9.14 by Dathus [BR] on 2024-01-05 7:40 PM (-03:00 GMT)

local YouTube = {}

function YouTube.Detect(uri)
    local m = playxlib.FindMatch(uri, {
        "^https?://youtu%.be/([A-Za-z0-9_%-]+)",
        "^https?://youtube%.com/watch%?.*v=([A-Za-z0-9_%-]+)",
        "^https?://[A-Za-z0-9%.%-]*%.youtube%.com/watch%?.*v=([A-Za-z0-9_%-]+)",
        "^https?://[A-Za-z0-9%.%-]*%.youtube%.com/v/([A-Za-z0-9_%-]+)",
        "^https?://youtube%-nocookie%.com/watch%?.*v=([A-Za-z0-9_%-]+)",
        "^https?://[A-Za-z0-9%.%-]*%.youtube%-nocookie%.com/watch%?.*v=([A-Za-z0-9_%-]+)",
        "^https?://[A-Za-z0-9%.%-]*%.youtube%.com/live/([A-Za-z0-9_%-]+)",
    })

    if m then
        return m[1]
    end
end

function YouTube.GetPlayer(uri, useJW)
    if uri:find("^[A-Za-z0-9_%-]+$") then
        local url = GetConVar("playx_youtube_host_url"):GetString() .. "?v=" .. uri

        return {
            ["Handler"] = "YoutubeNative",
            ["URI"] = url,
            ["ResumeSupported"] = true,
            ["LowFramerate"] = false,
            ["MetadataFunc"] = function(callback, failCallback)
                YouTube.QueryMetadata(uri, callback, failCallback)
            end
        }
    end
end

function YouTube.QueryMetadata(uri, callback, failCallback)
  local vars = {
      ["part"] = "snippet,statistics,contentDetails",
      ["maxResults"] = "1",
      ["id"] = uri,
      ["client"] = game.SinglePlayer() and "SP" or ("MP:" .. GetConVar("hostname"):GetString())
  }
      
  local function successF (resultsTable)        
        -- Do a check to avoid error
        if resultsTable.pageInfo.resultsPerPage == 0 or resultsTable.items[1] == nil then
          PrintMessage(HUD_PRINTTALK, "The Youtube video \""..uri.."\" that you tried to play is unavailable!")
          return false
        end
                
        local title = resultsTable.items[1].snippet.title
        local desc = resultsTable.items[1].snippet.description
        local submitter = resultsTable.items[1].snippet.channelTitle

        local publishedDate = nil
        local y, mo, d, h, m, s = string.match(resultsTable.items[1].snippet.publishedAt, "([0-9]+)-([0-9]+)-([0-9]+)T([0-9]+):([0-9]+):([0-9]+)%.000Z")
        if y then
            publishedDate = playxlib.UTCTime({year=tonumber(y), month=tonumber(m),
                                           day=tonumber(d), hour=tonumber(h),
                                           min=tonumber(m), sec=tonumber(s)})
        end

        local modifiedDate = nil
        --No modifiedDate available in the v3 API, as far as I'm aware.
        local y, mo, d, h, m, s = string.match(resultsTable.items[1].snippet.publishedAt, "([0-9]+)-([0-9]+)-([0-9]+)T([0-9]+):([0-9]+):([0-9]+)%.000Z")
        if y then
            modifiedDate = playxlib.UTCTime({year=tonumber(y), month=tonumber(mo),
                                          day=tonumber(d), hour=tonumber(h),
                                          min=tonumber(m), sec=tonumber(s)})
        end


        --length is in ISO
        local length_raw = resultsTable.items[1].contentDetails.duration
        --Thanks Wyozi/Wiox
        local length = tonumber(length_raw:match("(%d+)S") or 0) + tonumber(length_raw:match("(%d+)M") or 0)*60 + tonumber(length_raw:match("(%d+)H") or 0)*3600
        local tags = resultsTable.items[1].snippet.tags or {}
        local thumbnail = resultsTable.items[1].snippet.thumbnails.default.url
        local comments = resultsTable.items[1].statistics.commentCount

        local faves = resultsTable.items[1].statistics.favoriteCount
        local views = resultsTable.items[1].statistics.viewCount

        local likes = resultsTable.items[1].statistics.likeCount
        local numRaters = likes -- + resultsTable.items[1].statistics.dislikeCount
        local rating = likes/numRaters * 5

        if length then
            callback({
                ["URL"] = "https://www.youtube.com/watch?v=" .. uri,
                ["Title"] = title,
                ["Description"] = desc,
                ["Length"] = length,
                ["Tags"] = tags,
                ["DatePublished"] = publishedDate,
                ["DateModified"] = modifiedDate,
                ["Submitter"] = submitter,
                ["SubmitterURL"] = submitter and "https://www.youtube.com/" .. submitter or nil,
                ["NumFaves"] = faves,
                ["NumViews"] = views,
                ["NumComments"] = comments,
                ["RatingNorm"] = rating,
                ["NumRatings"] = numRaters,
                ["Thumbnail"] = thumbnail,
            })
        else
            callback({
                ["URL"] = "https://www.youtube.com/watch?v=" .. uri,
            })
        end
    end

    PlayX.YouTubeAPIManager("youtube/v3/videos", vars, successF, function () end)
end

list.Set("PlayXProviders", "YouTube", YouTube)
list.Set("PlayXProvidersList", "YouTube", {"YouTube"})
