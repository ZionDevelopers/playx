-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2026 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- $Id$
-- Version 2.12.3 by DathusBR on 2026-05-11 07:30 PM (-03:00 GMT)

PlayX._BookmarksPanelList = nil

local hasLoaded = false

--- Draw the settings panel.
local function SettingsPanel(panel)
    panel:ClearControls()

    panel:AddControl("CheckBox", {
        Label = PlayX.Translation.get("panel_enabled"),
        Command = "playx_enabled",
    })
    
    if PlayX.CrashDetected then
	    local msg = panel:AddControl("Label", {Text = PlayX.Translation.get("panel_crash_detected")})
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
        Label = PlayX.Translation.get("panel_error_windows"),
        Command = "playx_error_windows",
    }):SetTooltip(PlayX.Translation.get("panel_error_windows_tooltip"))
	
	panel:AddControl("CheckBox", {
        Label = PlayX.Translation.get("panel_only_play_videos_near_me"),

        Command = "playx_video_range_enabled",
    }):SetTooltip(PlayX.Translation.get("panel_only_play_videos_near_me_tooltip"))
	
	
	panel:AddControl("CheckBox", {
        Label = PlayX.Translation.get("panel_show_video_range_hints"),
        Command = "playx_video_range_hints_enabled",
    }):SetTooltip(PlayX.Translation.get("panel_show_video_range_hints_tooltip"))
    
    panel:AddControl("Slider", {
        Label = PlayX.Translation.get("panel_volume"),
        Command = "playx_volume",
        Type = "Integer",
        Min = "0",
        Max = "100",
    }):SetTooltip(PlayX.Translation.get("panel_volume_tooltip"))
	
	panel:AddControl("Slider", {
        Label = PlayX.Translation.get("panel_video_radius"),
        Command = "playx_video_radius",
        Type = "Integer",
        Min = "500",
        Max = "5000",
    }):SetTooltip(PlayX.Translation.get("panel_video_radius_tooltip"))
    
    if PlayX.CurrentMedia then
        if PlayX.CurrentMedia.ResumeSupported then
            local button = panel:AddControl("Button", {
                Label = PlayX.Translation.get("panel_hide_player"),
                Command = "playx_hide",
            })
            
            if not PlayX.Playing then
                button:SetDisabled(true)
            end
            
            if PlayX.Playing then
                panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_reinitialize_player"),
                    Command = "playx_resume",
                })
            else
                panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_resume_play"),
                    Command = "playx_resume",
                })
            end
            
            panel:AddControl("Label", {
                Text = PlayX.Translation.get("panel_media_resume_supported"),
            })
        else
            if PlayX.Playing then
                panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_stop_play"),
                    Command = "playx_hide",
                }):SetTooltip(PlayX.Translation.get("panel_stop_play_tooltip"))
            
                local resumeBt = panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_reinitialize_player"),
                    Command = "playx_resume",
                })
            	
            	if resumeBt ~= nil then
                	resumeBt:SetDisabled(true)
                end
            else
                local stopBt = panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_stop_play"),
                    Command = "playx_hide",
                }):SetTooltip(PlayX.Translation.get("panel_stop_play_tooltip"))
                
                if not PlayX.Playing and stopBt ~= nil then
                    stopBt:SetDisabled(true)
                end
                
                local resumeBt = panel:AddControl("Button", {
                    Label = PlayX.Translation.get("panel_resume_play"),
                    Command = "playx_resume",
                })
            	
            	if resumeBt ~= nil then
                	resumeBt:SetDisabled(true)
                end
            end
            
            panel:AddControl("Label", {
                Text = PlayX.Translation.get("panel_media_resume_not_supported"),
            })
        end
    else
        panel:AddControl("Label", {
            Text = PlayX.Translation.get("panel_no_media_playing"),
        })
    end
    
end

--- Draw the control panel.
local function ControlPanel(panel)
    panel:ClearControls()
    
    local options = {
        [PlayX.Translation.get("panel_provider_auto_detect")] = {["playx_provider"] = ""}
    }
    
    for id, name in pairs(PlayX.Providers) do
        options[name] = {["playx_provider"] = id}
    end
    
    -- TODO: Put the following two controls on the same line
    
    panel:AddControl("ListBox", {
        Label = PlayX.Translation.get("panel_provider"),
        Options = options,
    })

    local textbox = panel:AddControl("TextBox", {
        Label = PlayX.Translation.get("panel_uri"),
        Command = "playx_uri",
        WaitForEnter = false,
    })
    textbox:SetTooltip(PlayX.Translation.get("panel_uri_tooltip"))

    panel:AddControl("TextBox", {
        Label = PlayX.Translation.get("panel_start_at"),
        Command = "playx_start_time",
        WaitForEnter = false,
    })

    if PlayX.JWPlayerURL then
        panel:AddControl("CheckBox", {
            Label = PlayX.Translation.get("panel_use_jw"),
            Command = "playx_use_jw",
        })
    end

    panel:AddControl("CheckBox", {
        Label = PlayX.Translation.get("panel_force_low_framerate"),
        Command = "playx_force_low_framerate",
    }):SetTooltip(PlayX.Translation.get("panel_force_low_framerate_tooltip"))
    
    panel:AddControl("CheckBox", {
        Label = PlayX.Translation.get("panel_ignore_length"),
        Command = "playx_ignore_length",
    })
    
    panel:AddControl("Button", {
        Label = PlayX.Translation.get("panel_open_media"),
        Command = "playx_gui_open",
    })
    
    local button = panel:AddControl("Button", {
        Label = PlayX.Translation.get("panel_close_media"),
        Command = "playx_gui_close",
    })
    
    panel:AddControl("Button", {
        Label = PlayX.Translation.get("panel_add_as_bookmark"),
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
    bookmarks:AddColumn(PlayX.Translation.get("bookmark_column_title"))
    bookmarks:AddColumn(PlayX.Translation.get("bookmark_column_uri"))
    bookmarks:SetTall(ScrH() * 7.5/10)
    
    for k, bookmark in pairs(PlayX.Bookmarks) do
        local line = bookmarks:AddLine(bookmark.Title, bookmark.URI)
        if bookmark.Keyword ~= "" then
            line:SetTooltip(PlayX.Translation.get("bookmark_keyword_tooltip", bookmark.Keyword))
        end
    end
    
    bookmarks.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption(PlayX.Translation.get("bookmark_open_button"), function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
        end)
        menu:AddOption(PlayX.Translation.get("bookmark_edit_button"), function()
            PlayX.OpenBookmarksWindow(line:GetValue(1))
        end)
		
		menu:AddOption(PlayX.Translation.get("bookmark_delete_button"), function()
           	PlayX.BookmarkDelete(line)
        end)

        menu:AddOption(PlayX.Translation.get("bookmark_copy_uri"), function()
            SetClipboardText(line:GetValue(2))

        end)
        menu:AddOption(PlayX.Translation.get("bookmark_copy_to_administrate"), function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):CopyToPanel()
        end)
        menu:Open()
    end
    
    bookmarks.DoDoubleClick = function(lst, index, line)
        if not line then return end
        PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
    end
    
    local button = panel:AddControl("Button", {Text=PlayX.Translation.get("bookmark_open_selected_button")})
    button.DoClick = function()
        if bookmarks:GetSelectedLine() then
            local line = bookmarks:GetLine(bookmarks:GetSelectedLine())
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
	    else
            Derma_Message(PlayX.Translation.get("error_bookmark_not_selected"), PlayX.Translation.get("error"), PlayX.Translation.get("ok"))
	    end
    end
    
    local button = panel:AddControl("Button", {Text=PlayX.Translation.get("bookmark_manage_button")})
    button.DoClick = function()
        PlayX.OpenBookmarksWindow()
    end
end

--- Draw the control panel.
local function NavigatorPanel(panel)
    panel:ClearControls()
    
    panel:SizeToContents(true)
    
    if PlayX.NavigatorCapturedURL ~= "" and PlayX.CurrentMedia then
	    panel:AddControl("Label", {
	        Text = PlayX.Translation.get("navigator_captured_uri", PlayX.NavigatorCapturedURL)
	     })
	     
	     local button = panel:AddControl("Button", {
	        Label = PlayX.Translation.get("bookmark_add_as_bookmark_button"),
	        Command = "playx_navigator_addbookmark",
	    })    
    end
    
    local button = panel:AddControl("Button", {
        Label = PlayX.Translation.get("navigator_open_button"),
        Command = "playx_navigator_window",
    })  
end

-- Setup Apply Key Function
local function applyFullscreenKey()
  RunConsoleCommand( "playx_fullscreen_register_key", GetConVar("playx_fullscreen_bindkey"):GetInt() )
end 

-- Setup Panel
local function fullscreenPanel(panel)
  -- Clear Controls
  panel:ClearControls()
  -- Add Panel Elements
  panel:AddControl("Header", {Text = PlayX.Translation.get("fullscreen_panel_header")})  
  panel:AddControl("Numpad", {Label = PlayX.Translation.get("fullscreen_key_label"), Command = "playx_fullscreen_bindkey", ButtonSize = "18"})  
  
  -- Add Buton to Apply                  
  local Button = vgui.Create("DButton") 
  Button:SetSize(50, 20)
  Button:SetText(PlayX.Translation.get("panel_apply"))
  Button.DoClick = function( button )
    -- Run Apply on Click
    applyFullscreenKey()
  end
  
  -- Add Buton to panel   
  panel:AddItem(Button)                    
end

--- PopulateToolMenu hook.
local function PopulateToolMenu()
    hasLoaded = true
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXSettings", PlayX.Translation.get("spawnmenu_settings"), "", "", SettingsPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXControl", PlayX.Translation.get("spawnmenu_administrate"), "", "", ControlPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXBookmarks", PlayX.Translation.get("spawnmenu_bookmarks"), "", "", BookmarksPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXNavigator", PlayX.Translation.get("spawnmenu_navigator"), "", "", NavigatorPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXFullscreen", PlayX.Translation.get("spawnmenu_fullscreen"), "", "", fullscreenPanel)
end

hook.Add("PopulateToolMenu", "PlayXPopulateToolMenu", PopulateToolMenu)

--- Updates the tool panels.
function PlayX.UpdatePanels()
    if not hasLoaded then return end
    SettingsPanel(controlpanel.Get("PlayXSettings"))
    ControlPanel(controlpanel.Get("PlayXControl"))
    NavigatorPanel(controlpanel.Get("PlayXNavigator"))
    fullscreenPanel(controlpanel.Get( "PlayXFullscreen"))
end

-- Setup Timer for Apply on Start
timer.Create( "RetardedApplyKeyDelay", 1, 1, function()
  -- Apply New Key
  applyFullscreenKey()
end)

-- Add Command
concommand.Add("playx_fullscreen_register_key", function(ply, com, args)
  RunConsoleCommand("playx_fullscreen_bindkey", tonumber(args[1]))
end)
