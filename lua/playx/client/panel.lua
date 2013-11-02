-- PlayX
-- Copyright (c) 2009 sk89q <http://www.sk89q.com>
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
-- Version 3.0.0 by Nexus [BR] on 13-08-2013 07:59 PM

PlayX._BookmarksPanelList = nil

local hasLoaded = false

--- Draw the settings panel.
local function SettingsPanel(panel)
    panel:ClearControls()

    panel:AddControl("CheckBox", {
        Label = "Enabled",
        Command = "playx_enabled",
    })
    
    panel:AddControl("CheckBox", {
        Label = "HD Quality",
        Command = "playx_hd",
    }):SetTooltip("Check to Enable HD Videos")
    
    if PlayX.CrashDetected then
	    local msg = panel:AddControl("Label", {Text = "PlayX has detected a crash in a previous session. Is it safe to " ..
	       "re-enable PlayX? For most people, crashes " ..
	       "with the new versions of Gmod and PlayX are very rare, but a handful " ..
	       "of people crash every time something is played. Try enabling " ..
	       "PlayX a few times to determine whether you fall into this group."})
	    msg:SetWrap(true)
        msg:SetColor(Color(255, 255, 255, 255))
        msg:SetTextColor(Color(255, 255, 255, 255))
		msg:SetTextInset(8, 0)
		msg:SetContentAlignment(7)
		msg:SetAutoStretchVertical( true )
        msg.Paint = function(self)
            draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(255, 0, 0, 100))
        end
    end
    
    if not PlayX.Enabled then
        return
    end

    panel:AddControl("CheckBox", {
        Label = "Show errors in message boxes",
        Command = "playx_error_windows",
    }):SetTooltip("Uncheck to use hints instead")
	
	panel:AddControl("CheckBox", {
        Label = "Only play videos near me",
        Command = "playx_video_range_enabled",
    }):SetTooltip("Uncheck to play videos in any part of the map")
	
	panel:AddControl("CheckBox", {
        Label = "Show hints about video range",
        Command = "playx_video_range_hints_enabled",
    }):SetTooltip("Uncheck to not see hints about video out of range")

    panel:AddControl("Slider", {
        Label = "Volume:",
        Command = "playx_volume",
        Type = "Integer",
        Min = "0",
        Max = "100",
    }):SetTooltip("May have no effect, depending on what's playing.")
	
	panel:AddControl("Slider", {
        Label = "Video radius:",
        Command = "playx_video_radius",
        Type = "Integer",
        Min = "500",
        Max = "5000",
    }):SetTooltip("Choose the video player radius.")
    
    if PlayX.CurrentMedia then
        if PlayX.CurrentMedia.ResumeSupported then
            local button = panel:AddControl("Button", {
                Label = "Hide Player",
                Command = "playx_hide",
            })
            
            if not PlayX.Playing then
                button:SetDisabled(true)
            end
            
            if PlayX.Playing then
                panel:AddControl("Button", {
                    Label = "Re-initialize Player",
                    Command = "playx_resume",
                })
            else
                panel:AddControl("Button", {
                    Label = "Resume Play",
                    Command = "playx_resume",
                })
            end
            
            panel:AddControl("Label", {
                Text = "The current media supports resuming."
            })
        else
            if PlayX.Playing then
                panel:AddControl("Button", {
                    Label = "Stop Play",
                    Command = "playx_hide",
                }):SetTooltip("This is a temporary disable.")
            
                local resumeBt = panel:AddControl("Button", {
                    Label = "Re-initialize Player",
                    Command = "playx_resume",
                })
            	
            	if resumeBt ~= nil then
                	resumeBt:SetDisabled(true)
                end
            else
                local stopBt = panel:AddControl("Button", {
                    Label = "Stop Play",
                    Command = "playx_hide",
                }):SetTooltip("This is a temporary disable.")
                
                if not PlayX.Playing and stopBt ~= nil then
                    stopBt:SetDisabled(true)
                end
                
                local resumeBt = panel:AddControl("Button", {
                    Label = "Resume Play",
                    Command = "playx_resume",
                })
            	
            	if resumeBt ~= nil then
                	resumeBt:SetDisabled(true)
                end
            end
            
            panel:AddControl("Label", {
                Text = "The current media cannot be resumed once stopped."
            })
        end
    else
        panel:AddControl("Label", {
            Text = "No media is playing at the moment."
        })
    end
end

--- Draw the control panel.
local function ControlPanel(panel)
    panel:ClearControls()
    
    local options = {
        ["Auto-detect"] = {["playx_provider"] = ""}
    }
    
    for id, name in ipairs(list.Get("PlayXProvidersList")) do
        options[name[1]] = {["playx_provider"] = id}
    end
    
    panel:AddControl("ListBox", {
        Label = "Provider:",
        Options = options,
    })

    local textbox = panel:AddControl("TextBox", {
        Label = "URI:",
        Command = "playx_uri",
        WaitForEnter = false,
    })
    textbox:SetTooltip("Example: http://www.youtube.com/watch?v=NWdTcxv4V-g")

    panel:AddControl("TextBox", {
        Label = "Start At:",
        Command = "playx_start_time",
        WaitForEnter = false,
    })

    if PlayX.JWPlayerURL then
        panel:AddControl("CheckBox", {
            Label = "Use an improved player when applicable",
            Command = "playx_use_jw",
        })
    end

    panel:AddControl("CheckBox", {
        Label = "Force low frame rate",
        Command = "playx_force_low_framerate",
    }):SetTooltip("Use this for music-only videos")
    
    panel:AddControl("CheckBox", {
        Label = "Don't auto stop on finish when applicable",
        Command = "playx_ignore_length",
    })
    
    panel:AddControl("Button", {
        Label = "Open Media",
        Command = "playx_gui_open",
    })
    
    local button = panel:AddControl("Button", {
        Label = "Close Media",
        Command = "playx_gui_close",
    })
    
    panel:AddControl("Button", {
        Label = "Add as Bookmark",
        Command = "playx_gui_bookmark",
    })
    
    if not PlayX.CurrentMedia then
        button:SetDisabled(true)
    end
end
PANEL = {}
vgui.Register( "dlistview", PANEL ,"DListView")

--- Draw the control panel.
local function BookmarksPanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
    
    local bookmarks = panel:AddControl("DListView", {})
    PlayX._BookmarksPanelList = bookmarks
    bookmarks:SetMultiSelect(false)
    bookmarks:AddColumn("Title")
    bookmarks:AddColumn("URI")
    bookmarks:SetTall(ScrH() * 7.5/10)
    
    for k, bookmark in pairs(PlayX.Bookmarks) do
        local line = bookmarks:AddLine(bookmark.Title, bookmark.URI)
        if bookmark.Keyword ~= "" then
            line:SetTooltip("Keyword: " .. bookmark.Keyword)
        end
    end
    
    bookmarks.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Open", function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
        end)
        menu:AddOption("Edit...", function()
            PlayX.OpenBookmarksWindow(line:GetValue(1))
        end)
		
		menu:AddOption("Delete...", function()
           	PlayX.BookmarkDelete(line)
        end)

        menu:AddOption("Copy URI", function()
            SetClipboardText(line:GetValue(2))

        end)
        menu:AddOption("Copy to 'Administrate'", function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):CopyToPanel()
        end)
        menu:Open()
    end
    
    bookmarks.DoDoubleClick = function(lst, index, line)
        if not line then return end
        PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
    end
    
    local button = panel:AddControl("Button", {Text="Open Selected"})
    button.DoClick = function()
        if bookmarks:GetSelectedLine() then
            local line = bookmarks:GetLine(bookmarks:GetSelectedLine())
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
	    else
            Derma_Message("You didn't select an entry.", "Error", "OK")
	    end
    end
    
    local button = panel:AddControl("Button", {Text="Manage Bookmarks..."})
    button.DoClick = function()
        PlayX.OpenBookmarksWindow()
    end
end

--- Draw the control panel.
local function YoutubeFavoritesPanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
    
    local textbox = panel:AddControl("TextBox", {
        Label = "Youtube Account ID:",
        Command = "playx_yt_id",
    })
    textbox:SetTooltip("Example: myyoutubeid")
    
    local ImportBT = panel:AddControl("Button", {
        Label = "Import",
        Command = "playx_import_ytfavorites",
    })
        
    local favorites = panel:AddControl("DListView", {})

    favorites:SetMultiSelect(false)
    favorites:AddColumn("Title")
    favorites:AddColumn("URI")
    favorites:SetTall(ScrH() * 7.5/10)
    
    for k, favorite in pairs(PlayX.YoutubeFavorites) do
        favorites:AddLine(favorite.Title, favorite.URI)
    end
    
    favorites.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        
        menu:AddOption("Play", function()
        	RunConsoleCommand("playx_open", line:GetValue(2):Trim(), "", 0)
        end)
        
        menu:Open()
    end
    
    favorites.DoDoubleClick = function(lst, index, line)
        if not line then return end
         RunConsoleCommand("playx_open", line:GetValue(2):Trim(), "", 0)
    end
    
    local button = panel:AddControl("Button", {Text="Open Selected"})
    button.DoClick = function()
        if favorites:GetSelectedLine() then
            local line = bookmarks:GetLine(favorites:GetSelectedLine())
            RunConsoleCommand("playx_open", line:GetValue(2):Trim(), "", 0)
	    else
            Derma_Message("You didn't select an entry.", "Error", "OK")
	    end
    end  
end

--- Draw the control panel.
local function HistoryPanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
   
    local history = panel:AddControl("DListView", {})

    history:SetMultiSelect(false)
    history:AddColumn("Time")
    history:AddColumn("Title")
    history:AddColumn("Player")
    history:AddColumn("URL")
    history:SetTall(ScrH() * 7.5/10)
    
    for k, v in pairs(PlayX.History) do
        history:AddLine(v.Time, v.Title, v.Player, v.URL)      
    end
    
    history.OnRowRightClick = function(lst, index, line)
 		local menu = DermaMenu()
 		
        menu:AddOption("Play", function()
        	RunConsoleCommand("playx_open", line:GetValue(4):Trim(), "", 0)
        end)
        
        menu:Open()
    end
    
    history.DoDoubleClick = function(lst, index, line)
        if not line then return end
         RunConsoleCommand("playx_open", line:GetValue(4):Trim(), "", 0)
    end
    
    local button = panel:AddControl("Button", {Text="Clear History"})
    button.DoClick = function()   
    	Derma_Query("Confirm", "Empty play history?", "Yes", function () PlayX.ClearHistory() end, "No", function () end) 
    end  
end

--- Draw the control panel.
local function QueuePanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
           
    local Queue = panel:AddControl("DListView", {})

    Queue:SetMultiSelect(false)
    Queue:AddColumn("ID")
    Queue:AddColumn("Title")
    Queue:SetTall(ScrH() * 7.5/10)
    
    for k, item in pairs(PlayX.Queue) do
        Queue:AddLine(item.ID, item.Title)        
    end
    
    Queue.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Play", function()
        	PlayX.GetItemFromQueue(line:GetValue(1)):PlayItem()
        end)
        
        menu:AddOption("Edit...", function()
            PlayX.OpenQueueWindow(line:GetValue(1))
        end)
		
		menu:AddOption("Delete...", function()
           	PlayX.DeleteItemFromQueue(line)
        end)

        menu:AddOption("Copy URI", function()
            SetClipboardText(line:GetValue(3))

        end)
        menu:AddOption("Copy to 'Administrate'", function()
            PlayX.GetItemFromQueue(line:GetValue(3):Trim()):CopyToPanel()
        end)
        menu:Open()
    end
    
    Queue.DoDoubleClick = function(lst, index, line)
        if not line then return end
        PlayX.GetItemFromQueue(line:GetValue(1)):PlayItem()
    end
    
    local button = panel:AddControl("Button", {Text="Empty Queue"})
    button.DoClick = function()     	
    	if PlayX.IsPermitted(LocalPlayer()) then
    		Derma_Query("Confirm", "You really want Empty Queue", "Yes", function () PlayX.Queue = {} PlayX.UpdateQueuePanel() end, "No", function () end) 
    	else
    		Derma_Message("You need PlayX Permission to use it.", "Error", "OK")
    	end
    end  
end

--- Draw the control panel.
local function NavigatorPanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
    
    if PlayX.NavigatorCapturedURL ~= "" and PlayX.CurrentMedia then
	    panel:AddControl("Label", {
	        Text = "URI: "..PlayX.NavigatorCapturedURL
	     })
	     
	     local button = panel:AddControl("Button", {
	        Label = "Add as Bookmark",
	        Command = "playx_navigator_addbookmark",
	    })    
    end
    
    local button = panel:AddControl("Button", {
        Label = "Open Media Navigator",
        Command = "playx_navigator_window",
    })  
end

--- PopulateToolMenu hook.
local function PopulateToolMenu()
    hasLoaded = true
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXSettings", "Settings", "", "", SettingsPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXControl", "Administrate", "", "", ControlPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXNavigator", "Navigator", "", "", NavigatorPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXBookmarks", "Bookmarks (Local)", "", "", BookmarksPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXYoutubeFavorites", "Bookmarks (Youtube)", "", "", YoutubeFavoritesPanel) 
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXHistory", "History", "", "", HistoryPanel) 
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXQueue", "Queue", "", "", QueuePanel)
    PlayX.ImportYoutubeFavorites()
end

hook.Add("PopulateToolMenu", "PlayXPopulateToolMenu", PopulateToolMenu)

--- Updates the tool panels.
function PlayX.UpdatePanels()
    if not hasLoaded then return end
    SettingsPanel(controlpanel.Get("PlayXSettings"))
    ControlPanel(controlpanel.Get("PlayXControl"))
    NavigatorPanel(controlpanel.Get("PlayXNavigator"))
    HistoryPanel(controlpanel.Get("PlayXHistory"))
    QueuePanel(controlpanel.Get("PlayXQueue"))
end

--- Update Youtube Bookmarks
function PlayX.UpdateYoutubeFavoritePanel()
	 YoutubeFavoritesPanel(controlpanel.Get("PlayXYoutubeFavorites"))
end

--- Update History
function PlayX.UpdateHistoryPanel()
	 HistoryPanel(controlpanel.Get("PlayXHistory"))
end

--- Update Queue
function PlayX.UpdateQueuePanel()
	 QueuePanel(controlpanel.Get("PlayXQueue"))
end
