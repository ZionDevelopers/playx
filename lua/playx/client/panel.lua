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
-- Version 2.7.7 by Nexus [BR] on 20-06-2013 02:43 PM

PlayX._BookmarksPanelList = nil

local hasLoaded = false

local backgroundColor = Color(50,50,50,255)
local textColor = Color(220,220,220,255)
local buttonColor = Color(80,80,80,225)
local buttonPressedColor = Color(30,30,30,255)
local buttonLineColor = Color(0,200,255,255)
local buttonHoverColor = Color(255,50,50,255)
local buttonLinePressColor = Color(0,255,0,255)
local bodyFont = "HudHintTextLarge"

--- Draw the settings panel.
local function SettingsPanel(panel)
    panel:ClearControls()
    panel:SetLabel( "Playx Settings - Client Side" )
    
    --New Coloring Scheme
    panel.Paint = function() 
        draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), backgroundColor )
    end

    local enabledCheckBox = vgui.Create("DCheckBoxLabel", panel)
        enabledCheckBox:SetText( "Enabled" )
        enabledCheckBox:SetTextColor(textColor)
        enabledCheckBox:SetValue(GetConVar("playx_enabled"))
        enabledCheckBox:SetConVar( "playx_enabled" )
        enabledCheckBox.Paint = function ()
            enabledCheckBox:SetTextColor(textColor)
        end
    panel:AddItem(enabledCheckBox)

    local dividerLabel = vgui.Create("DLabel", panel)
        dividerLabel:SetText( "--- Modify Client Side Setings Here When Player Enabled ---")
        dividerLabel:SetTextColor(textColor)
        dividerLabel.Paint = function ()
            dividerLabel:SetTextColor(textColor)
        end
    panel:AddItem(dividerLabel)

    --panel:Help("\n") --Add Space

    --panel:CheckBox("Enabled", "playx_enabled")
    --panel:AddControl("CheckBox", {
    --    Label = "Enabled",
    --    Command = "playx_enabled",
    --})

    

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
            draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall() * 10, Color(255, 0, 0, 100))
        end
    end
    
    if not PlayX.Enabled then
        return
    end

    local videoRangeCheck = vgui.Create("DCheckBoxLabel", panel)
        videoRangeCheck:SetText("Enable Video Range (Only Play Videos Near Me)")
        videoRangeCheck:SetTextColor(textColor)
        videoRangeCheck:SetValue(GetConVar("playx_video_range_enabled"))
        videoRangeCheck:SetConVar("playx_video_range_enabled")
        videoRangeCheck.Paint = function ()
            videoRangeCheck:SetTextColor(textColor)
        end
        panel:AddItem(videoRangeCheck)

	--panel:AddControl("CheckBox", {
    --    Label = "Only play videos near me",
    --    Command = "playx_video_range_enabled",
    --}):SetTooltip("Uncheck to play videos in any part of the map")
        local rangeHintCheck = vgui.Create("DCheckBoxLabel", panel)
            rangeHintCheck:SetText("Show Hints when I enter Or Leave Video Range")
            rangeHintCheck:SetTextColor(textColor)
            rangeHintCheck:SetValue(GetConVar("playx_video_range_hints_enabled"))
            rangeHintCheck:SetConVar("playx_video_range_hints_enabled")
            rangeHintCheck.Paint = function ()
                rangeHintCheck:SetTextColor(textColor)
            end
        panel:AddItem(rangeHintCheck)

	--panel:AddControl("CheckBox", {
    --   Label = "Show hints about video range",
    --    Command = "playx_video_range_hints_enabled",
    --}):SetTooltip("Uncheck to not see hints about video out of range")

    volumeSlider = vgui.Create("DNumSlider", panel)
      volumeSlider:SetText( "Player Volume:" )
        volumeSlider:SetMinMax(0,100)
        volumeSlider:SetValue(GetConVar("playx_volume"))
        volumeSlider:SetConVar("playx_volume")
        volumeSlider.TextArea:SetTextColor(textColor)
        volumeSlider.Label:SetColor(textColor)
        volumeSlider.Label.Paint = function () 
            volumeSlider.Label:SetTextColor(textColor)
            volumeSlider.TextArea:SetTextColor(textColor)
        end
    panel:AddItem(volumeSlider)

    --panel:AddControl("Slider", {
    --    Label = "Volume:",
    --    Command = "playx_volume",
    --    Type = "Integer",
    --    Min = "0",
    --    Max = "100",
    --}):SetTooltip("May have no effect, depending on what's playing.")

    rangeSlider = vgui.Create("DNumSlider", panel)
      rangeSlider:SetText( "Max Range: " )
        rangeSlider:SetMinMax(500, 5000)
        rangeSlider:SetValue(GetConVar("playx_video_radius"))
        rangeSlider:SetConVar("playx_video_radius")
        rangeSlider.TextArea:SetTextColor(textColor)
        rangeSlider.Label:SetColor(textColor)
        rangeSlider.Label.Paint = function () 
            rangeSlider.Label:SetTextColor(textColor)
            rangeSlider.TextArea:SetTextColor(textColor)
        end
    panel:AddItem(rangeSlider)
	
	--panel:AddControl("Slider", {
      --  Label = "Video radius:",
      --  Command = "playx_video_radius",
      --  Type = "Integer",
      --  Min = "500",
      --  Max = "5000",
    --}):SetTooltip("Choose the video player radius.")

    local dividerLabelAdv = vgui.Create("DLabel", panel)
        dividerLabelAdv:SetText( "\n--- Other Options ---\n")
        dividerLabelAdv:SetTextColor(textColor)
        dividerLabelAdv.Paint = function ()
            dividerLabelAdv:SetTextColor(textColor)
        end
    panel:AddItem(dividerLabelAdv)

    local errorWindowsCheck = vgui.Create("DCheckBoxLabel", panel)
        errorWindowsCheck:SetText( "Show Error Message Boxes" )
        errorWindowsCheck:SetTextColor(textColor)
        errorWindowsCheck:SetValue(GetConVar("playx_error_windows"))
        errorWindowsCheck:SetConVar( "playx_error_windows" )
        errorWindowsCheck.Paint = function ()
            errorWindowsCheck:SetTextColor(textColor)
        end
    panel:AddItem(errorWindowsCheck)

    --panel:AddControl("CheckBox", {
    --    Label = "Show errors in message boxes",
    --    Command = "playx_error_windows",
    --}):SetTooltip("Uncheck to use hints instead")

   
    if PlayX.CurrentMedia then
        if PlayX.CurrentMedia.ResumeSupported then

            local hideButton = vgui.Create( "DButton", panel )
                hideButton:SetText( "Hide Player" )
                hideButton:SetColor(textColor)
                hideButton:SetConsoleCommand("playx_hide")
                hideButton.Paint = function()    
                    hideButton:SetColor(textColor)
        
                    if hideButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, hideButton:GetWide(), hideButton:GetTall())
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, hideButton:GetWide(), hideButton:GetTall())
                    end
        
                end
            panel:AddItem(hideButton)

           -- local button = panel:AddControl("Button", {
           --     Label = "Hide Player",
           --     Command = "playx_hide",
           -- })
            
            if not PlayX.Playing then
                hideButton:SetDisabled(true)
            end
            
            if PlayX.Playing then

                local reInitButton = vgui.Create( "DButton", panel )
                reInitButton:SetText( "Re-Initialize Player" )
                reInitButton:SetColor(textColor)
                reInitButton:SetConsoleCommand("playx_resume")
                reInitButton.Paint = function()    
                    reInitButton:SetColor(textColor)
        
                    if reInitButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, reInitButton:GetWide(), reInitButton:GetTall())
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, reInitButton:GetWide(), reInitButton:GetTall())
                    end
        
                end
            panel:AddItem(reInitButton)

                --panel:AddControl("Button", {
                --    Label = "Re-initialize Player",
                --    Command = "playx_resume",
                --})
            else

                local resumeButton = vgui.Create( "DButton", panel )
                resumeButton:SetText( "Resume Play" )
                resumeButton:SetColor(textColor)
                resumeButton:SetConsoleCommand("playx_resume")
                resumeButton.Paint = function()    
                    resumeButton:SetColor(textColor)
        
                    if resumeButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, resumeButton:GetWide(), resumeButton:GetTall())
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, resumeButton:GetWide(), resumeButton:GetTall())
                    end
        
                end
            panel:AddItem(resumeButton)

                --panel:AddControl("Button", {
                --    Label = "Resume Play",
                --    Command = "playx_resume",
                --})
            end
            
            local dividerResumeSupported = vgui.Create("DLabel", panel)
                dividerResumeSupported:SetText( "\nThe Current Media Supports Pausing / Resuming\n")
                dividerResumeSupported:SetTextColor(textColor)
                dividerResumeSupported.Paint = function ()
                    dividerResumeSupported:SetTextColor(textColor)
                end
            panel:AddItem(dividerResumeSupported)

            --panel:AddControl("Label", {
            --    Text = "The current media supports resuming."
            --})
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

            local dividerLabelMediaStopWarn = vgui.Create("DLabel", panel)
                dividerLabelMediaStopWarn:SetText( "\nCurrent Media Cannot Be Resumed Once Stopped\n")
                dividerLabelMediaStopWarn:SetTextColor(textColor)
                dividerLabelMediaStopWarn.Paint = function ()
                    dividerLabelMediaStopWarn:SetTextColor(textColor)
                end
            panel:AddItem(dividerLabelNoMedia)
            
            --panel:AddControl("Label", {
            --    Text = "The current media cannot be resumed once stopped."
            --})
        end
    else
        local dividerLabelNoMedia = vgui.Create("DLabel", panel)
                dividerLabelNoMedia:SetText( "\n --No Media Is Currently Playing-- \n")
                dividerLabelNoMedia:SetTextColor(textColor)
                dividerLabelNoMedia.Paint = function ()
                    dividerLabelNoMedia:SetTextColor(textColor)
                end
            panel:AddItem(dividerLabelNoMedia)
        --panel:AddControl("Label", {
        --    Text = "No media is playing at the moment."
        --})
    end

    local chatHelpInfoHeader = vgui.Create("DLabel", panel)
        chatHelpInfoHeader:SetText( "\nPlayX Chat Commands\n")
        chatHelpInfoHeader:SetFont("Trebuchet24")
        chatHelpInfoHeader:SetTextColor(textColor)
    panel:AddItem(chatHelpInfoHeader)

    local chatHelpInfo = vgui.Create("DLabel", panel)
        chatHelpInfo:SetText( "-!playx {EXACT URL}\n-!ytplay {search video here}\n    -Plays first result\n")
        chatHelpInfo:SetTextColor(textColor)
        chatHelpInfo:SetFont("DermaDefaultBold")
    panel:AddItem(chatHelpInfo)

    panel:Help("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n") --Add Space To Extend Menu Color (I know, janky)
end

--- Draw the control panel.
local function ControlPanel(panel)
    panel:ClearControls()
    panel:SetLabel( "Playx Settings - Media" )
    
    --New Coloring Scheme
    panel.Paint = function() 
        draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), backgroundColor )
    end
    
    -- TODO: Put the Providers ComboBox and URI Text Box On Same Line MAYBE
    -- TODO: Convert Providers ListBox to DForm ComboBox DONE
     
    if file.Exists("materials/vgui/panel/playxlogo.vtf", "GAME") or file.Exists("materials/vgui/panel/playxlogo.vmt", "GAME") then   
        local logo = vgui.Create("Material", panel)
        logo:SetPos( 1, 2 )
        logo:SetSize(128,128)
        logo:SetMaterial( "vgui/panel/playxlogo" )
        logo.AutoSize = false
        panel:AddItem(logo)
    else
        local logoT = vgui.Create("DLabel", panel)
        logoT:SetText("PLAYX")
        logoT:SetFont("DermaLarge")
        panel:AddItem(logoT)
    end

    --Create Provider Selection Box--------------------------------------------------------
    local selectPnl = vgui.Create( "DPanel" )
    local providerSelectLabel = vgui.Create( "DLabel", selectPnl )
                providerSelectLabel:SetText( "Provider:" )
                providerSelectLabel:SetTextColor(textColor)
                providerSelectLabel:SetPos( 0, 5.5 )
                providerSelectLabel:SetFont( "HudHintTextLarge" )
                providerSelectLabel:SizeToContents()

    local providerSelect = vgui.Create("DComboBox", selectPnl)
                providerSelect:SetPos( 70, 2 )
                providerSelect:SetWide( 200 )
                providerSelect:SetColor( textColor )
                providerSelect:SetTextColor( textColor )
                providerSelect.Paint = function() 
                    providerSelect:SetColor( textColor )
                    providerSelect:SetTextColor( textColor )
                    surface.SetDrawColor( textColor )
                    surface.DrawOutlinedRect( 0, 0, providerSelect:GetWide(), providerSelect:GetTall())
                end
    panel:AddItem(selectPnl)

    selectPnl.Paint = function() 
        draw.RoundedBox( 0, 0, 0,selectPnl:GetWide(),selectPnl:GetTall(), backgroundColor )
    end

    --Add Providers To ComboBox----------------------------
    providerSelect:Clear()

    providerSelect:AddChoice("Auto-Detect","", true)
    for k, v in pairs(PlayX.Providers) do
        providerSelect:AddChoice(PlayX.Providers[k],k,false)
    end
    function providerSelect:OnSelect( index, value, data )
        RunConsoleCommand("playx_provider", providerSelect:GetOptionData(index))
        
    end

    --panel:AddControl("ListBox", {
    --    Label = "Provider:",
    --    Options = options,
    --})

    --local URIEntryBox = vgui.Create("DTextEntry", panel)
    --    URIEntryBox:SetConVar( "playx_uri" )
    --    URIEntryBox:SetSize(100,15)
    --panel:AddItem(URIEntryBox)

    --Start At Box--------------------------------------------------------------------------
    local uripnl = vgui.Create( "DPanel" )
    local uriEntryBoxLabel = vgui.Create( "DLabel", uripnl )
                uriEntryBoxLabel:SetText( "URI: " )
                uriEntryBoxLabel:SetTextColor(textColor)
                uriEntryBoxLabel:SetPos( 26, 5.5 )
                uriEntryBoxLabel:SetFont( "HudHintTextLarge" )
                uriEntryBoxLabel:SizeToContents()

                local uriEntryBox = vgui.Create( "DTextEntry", uripnl )
                uriEntryBox:SetPos( 60, 2 )
                uriEntryBox:SetWide( 220 )
                uriEntryBox:SetFont( "DermaDefaultBold" )
                uriEntryBox:SetConVar( "playx_uri" )

                panel:AddItem(uripnl)

    uripnl.Paint = function() 
        draw.RoundedBox( 0, 0, 0,uripnl:GetWide(),uripnl:GetTall(), backgroundColor )
    end

    --local textbox = panel:AddControl("TextBox", {
    --    Label = "URI:",
    --    Command = "playx_uri",
    --    WaitForEnter = false,
    --})
    --textbox:SetTooltip("Example: http://www.youtube.com/watch?v=NWdTcxv4V-g")

    local startatpnl = vgui.Create( "DPanel" )
    local startAtBoxLabel = vgui.Create( "DLabel", startatpnl )
                startAtBoxLabel:SetText( "Start At: " )
                startAtBoxLabel:SetTextColor(textColor)
                startAtBoxLabel:SetFont("HudHintTextLarge")
                startAtBoxLabel:SetPos( 0, 5.5 )
                startAtBoxLabel:SizeToContents()

                local startAtBox = vgui.Create( "DTextEntry", startatpnl )
                startAtBox:SetPos( 60, 2 )
                startAtBox:SetWide( 220 )
                startAtBox:SetFont("DermaDefaultBold")
                startAtBox:SetConVar( "playx_start_time" )

                panel:AddItem(startatpnl)

    startatpnl.Paint = function() 
        draw.RoundedBox( 0, 0, 0,startatpnl:GetWide(),startatpnl:GetTall(), backgroundColor )
    end

    --panel:AddControl("TextBox", {
    --    Label = "Start At:",
    --    Command = "playx_start_time",
    --    WaitForEnter = false,
    --})
    
     

    --if PlayX.JWPlayerURL then
    --    panel:AddControl("CheckBox", {
    --        Label = "Use an improved player when applicable",
    --        Command = "playx_use_jw",
    --    })
    --end

    --panel:AddControl("CheckBox", {
    --    Label = "Force low frame rate",
    --    Command = "playx_force_low_framerate",
    --}):SetTooltip("Use this for music-only videos")
    
    --panel:AddControl("CheckBox", {
    --    Label = "Don't auto stop on finish when applicable",
    --    Command = "playx_ignore_length",
    --})
    
    local openMediaButton = vgui.Create( "DButton", panel )
                openMediaButton:SetText( "Open Media" )
                openMediaButton:SetFont("CenterPrintText")
                openMediaButton:SetSize(64, 35)
                openMediaButton:SetColor(textColor)
                openMediaButton.DoClick = function()
                    RunConsoleCommand("playx_gui_open")
                    RunConsoleCommand("playx_provider", "")
                end
                openMediaButton.Paint = function()    
                    openMediaButton:SetColor(textColor)
        
                    if openMediaButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), openMediaButton:GetTall())
                        surface.SetDrawColor( buttonLinePressColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), openMediaButton:GetTall())
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
                    end
                    if openMediaButton:IsHovered() && not openMediaButton:IsDown() then
                        surface.SetDrawColor( buttonHoverColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
                    elseif not openMediaButton:IsDown() then
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
                    end
        
                end
            panel:AddItem(openMediaButton)

    --panel:AddControl("Button", {
    --    Label = "Open Media",
    --    Command = "playx_gui_open",
    --})
    
    local closeMediaButton = vgui.Create( "DButton", panel )
                closeMediaButton:SetText( "Close Media" )
                closeMediaButton:SetFont("DermaDefaultBold")
                closeMediaButton:SetSize(64, 35)
                closeMediaButton:SetColor(textColor)
                closeMediaButton:SetConsoleCommand("playx_gui_close")
                closeMediaButton.Paint = function()    
                    closeMediaButton:SetColor(textColor)
        
                    if closeMediaButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), closeMediaButton:GetTall())
                        surface.SetDrawColor( buttonLinePressColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), closeMediaButton:GetTall())
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
                    end
                    if closeMediaButton:IsHovered() && not closeMediaButton:IsDown() then
                        surface.SetDrawColor( buttonHoverColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
                    elseif not closeMediaButton:IsDown() then
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
                    end
        
                end
            panel:AddItem(closeMediaButton)
    if not PlayX.CurrentMedia then
        closeMediaButton:SetDisabled(true)
    end

    --local button = panel:AddControl("Button", {
    --    Label = "Close Media",
    --   Command = "playx_gui_close",
    --})

    local addBookmarkButton = vgui.Create( "DButton", panel )
                addBookmarkButton:SetText( "Add Current Media to Bookmarks" )
                addBookmarkButton:SetFont("CenterPrintText")
                addBookmarkButton:SetSize(64, 35)
                addBookmarkButton:SetColor(textColor)
                addBookmarkButton:SetConsoleCommand("playx_gui_bookmark")
                addBookmarkButton.Paint = function()    
                    addBookmarkButton:SetColor(textColor)
        
                    if addBookmarkButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), addBookmarkButton:GetTall())
                        surface.SetDrawColor( buttonLinePressColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), addBookmarkButton:GetTall())
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
                    end
                    if addBookmarkButton:IsHovered() && not addBookmarkButton:IsDown() then
                        surface.SetDrawColor( buttonHoverColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
                    elseif not addBookmarkButton:IsDown() then
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
                    end
        
                end
            panel:AddItem(addBookmarkButton)
    
    --panel:AddControl("Button", {
    --    Label = "Add as Bookmark",
    --    Command = "playx_gui_bookmark",
    --})

    local dividerAdvOptions = vgui.Create("DLabel", panel)
                dividerAdvOptions:SetText( "\n  --Advanced Options--\n")
                dividerAdvOptions:SetTextColor(textColor)
                dividerAdvOptions:SetFont(bodyFont)
                dividerAdvOptions.Paint = function ()
                    dividerAdvOptions:SetTextColor(textColor)
                end
            panel:AddItem(dividerAdvOptions)

    local lowFrameRateCheckbox = vgui.Create("DCheckBoxLabel", panel)
        lowFrameRateCheckbox:SetText( "Disable Video (Use with music)" )
        lowFrameRateCheckbox:SetTextColor(textColor)
        lowFrameRateCheckbox:SetFont(bodyFont)
        lowFrameRateCheckbox:SetValue(GetConVar("playx_force_low_framerate"))
        lowFrameRateCheckbox:SetConVar( "playx_force_low_framerate" )
        lowFrameRateCheckbox.Paint = function ()
            lowFrameRateCheckbox:SetTextColor(textColor)
        end
    panel:AddItem(lowFrameRateCheckbox)

    local doNotAutoStopCheckbox = vgui.Create("DCheckBoxLabel", panel)
        doNotAutoStopCheckbox:SetText( "Disable Auto Stop" )
        doNotAutoStopCheckbox:SetTextColor(textColor)
        doNotAutoStopCheckbox:SetFont(bodyFont)
        doNotAutoStopCheckbox:SetValue(GetConVar("playx_ignore_length"))
        doNotAutoStopCheckbox:SetConVar( "playx_ignore_length" )
        doNotAutoStopCheckbox.Paint = function ()
            doNotAutoStopCheckbox:SetTextColor(textColor)
        end
    panel:AddItem(doNotAutoStopCheckbox)

    local useJWCheckBox = vgui.Create("DCheckBoxLabel", panel)
        useJWCheckBox:SetText( "Use Better Settings For Better Quality" )
        useJWCheckBox:SetTextColor(textColor)
        useJWCheckBox:SetFont(bodyFont)
        useJWCheckBox:SetValue(GetConVar("playx_use_jw"))
        useJWCheckBox:SetConVar( "playx_use_jw" )
        useJWCheckBox.Paint = function ()
            useJWCheckBox:SetTextColor(textColor)
        end
    panel:AddItem(useJWCheckBox)

    panel:Help("\n\n\n\n\n")

     local pauseButton = vgui.Create( "DButton", panel )
                pauseButton:SetText( "Pause (NOT ACTIVE)" )
                pauseButton:SetFont("CenterPrintText")
                pauseButton:SetSize(64, 35)
                pauseButton:SetColor(textColor)
                pauseButton:SetConsoleCommand("playx_pause")
                pauseButton.Paint = function()    
                    pauseButton:SetColor(textColor)
        
                    if pauseButton:IsDown() then 
                        surface.SetDrawColor( buttonPressedColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), pauseButton:GetTall())
                        surface.SetDrawColor( buttonLinePressColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
                    else
                        surface.SetDrawColor( buttonColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), pauseButton:GetTall())
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
                    end
                    if pauseButton:IsHovered() && not pauseButton:IsDown() then
                        surface.SetDrawColor( buttonHoverColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
                    elseif not pauseButton:IsDown() then
                        surface.SetDrawColor( buttonLineColor )
                        surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
                    end
        
                end
            panel:AddItem(pauseButton)


    panel:Help("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n") --Add Space To Extend Menu Color (I know, janky)
    
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

surface.CreateFont("Trebuchet24_Underline",{
    size = 24,
    underline = true,
    font = "Trebuchet MS",})

local function PlayXHelpPanel(panel)
    panel:ClearControls()

    panel:SizeToContents()

    --New Coloring Scheme
    panel.Paint = function() 
        draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), backgroundColor )
    end

    local chatHelpInfoHeader = vgui.Create("DLabel", panel)
        chatHelpInfoHeader:SetText( "\n  PlayX Chat Commands\n")
        chatHelpInfoHeader:SetFont("Trebuchet24_Underline")
        --function chatHelpInfoHeader:PerformLayout()
        --    chatHelpInfoHeader:SizeToContents()
        --end
        --chatHelpInfoHeader:SetTextColor(textColor)
    panel:AddItem(chatHelpInfoHeader)

    local chatHelpInfo = vgui.Create("RichText", panel)
        chatHelpInfo:Dock( FILL )
        --chatHelpInfo:SetSize( panel:GetWide(), panel:GetTall() * 5)
        chatHelpInfo:InsertColorChange( 255, 255, 255, 255 )
        chatHelpInfo:AppendText("- !playx <URL>\n- !play <URL>\n- !link<URL>\n")
        chatHelpInfo:InsertColorChange( 160, 255, 160, 255 )
        chatHelpInfo:AppendText("- Opens the URL\n")
        chatHelpInfo:InsertColorChange( 240, 240, 150, 255 )
        chatHelpInfo:AppendText("(Will Try Auto Detect Provider)\n")
        chatHelpInfo:InsertColorChange( 110, 200, 255, 255 )
        chatHelpInfo:AppendText("\nEx: !playx http://dl1.webmfiles.org/big-buck-bunny_trailer.webm\n\nEx: !playx https://www.youtube.com/watch?v=ouIdaJhvXx0\n")

        chatHelpInfo:InsertColorChange( 255, 255, 255, 255 )
        chatHelpInfo:AppendText("----------------------------------\n-!ytplay <Youtube Video Search or URL>\n\n")
        chatHelpInfo:InsertColorChange( 160, 255, 160, 255 )
        chatHelpInfo:AppendText("-Search A Video On Youtube and Play First Result or Insert Youtube URL\n")
        chatHelpInfo:InsertColorChange( 110, 200, 255, 255 )
        chatHelpInfo:AppendText("\nEx: !ytplay keyboard cat\n\nEx: !ytplay https://www.youtube.com/watch?v=KcAY6-xl8A0\n")

        chatHelpInfo:InsertColorChange( 255, 255, 255, 255 )
        chatHelpInfo:AppendText("----------------------------------\n-!yt <Video Search>\n")
        chatHelpInfo:InsertColorChange( 160, 255, 160, 255 )
        chatHelpInfo:AppendText("-Search Youtube for Video\n")
        chatHelpInfo:InsertColorChange( 240, 240, 150, 255 )
        chatHelpInfo:AppendText("(Only Queues Video To Be Played With !ytplay, Does Not Play It)\n")
        chatHelpInfo:InsertColorChange( 110, 200, 255, 255 )
        chatHelpInfo:AppendText("\nEx: !yt stanley parable playthrough\n")

        chatHelpInfo:InsertColorChange( 255, 255, 255, 255 )
        chatHelpInfo:AppendText("----------------------------------\n-!ytlisten <Youtube Music Search>\n")
        chatHelpInfo:InsertColorChange( 160, 255, 160, 255 )
        chatHelpInfo:AppendText("-Search Youtube for Music\n")
        chatHelpInfo:InsertColorChange( 240, 240, 150, 255 )
        chatHelpInfo:AppendText("(Will Open Without Video, Only Audio. Best for Music Only Videos.)\n")
        chatHelpInfo:InsertColorChange( 110, 200, 255, 255 )
        chatHelpInfo:AppendText("\nEx: !ytlisten \n")
        
        function chatHelpInfo:PerformLayout()
            chatHelpInfo:SetFontInternal("HudSelectionText")
            chatHelpInfo:SetToFullHeight()
            chatHelpInfo:SetBGColor( Color( 20, 20, 20 ) )
        end
    panel:AddItem(chatHelpInfo)

    local concmdHelpInfoHeader = vgui.Create("DLabel", panel)
        concmdHelpInfoHeader:SetText( "\n  PlayX Console Commands\n")
        concmdHelpInfoHeader:SetFont("Trebuchet24_Underline")
    panel:AddItem(concmdHelpInfoHeader)

    local concmdHelpInfo = vgui.Create("RichText", panel)
        concmdHelpInfo:Dock( FILL )
        concmdHelpInfo:InsertColorChange( 255, 255, 255, 255 )
        concmdHelpInfo:AppendText("- playx_open <URL> <provider> <start (seconds)> <novideo (bool)> <usejw (bool)> <ignore length (bool)>\n")
        concmdHelpInfo:InsertColorChange( 160, 255, 160, 255 )
        concmdHelpInfo:AppendText("- Opens A Video With Specified Args\n")
        concmdHelpInfo:InsertColorChange( 240, 240, 150, 255 )
        concmdHelpInfo:AppendText('(Not all have to be filled, minimum is URL. If Provider Is Blank, Auto Detect Will Be Used. To Signify No Provider, In The Position Of Provider, Use "", Then Continue With Other Vars.)\n')
        concmdHelpInfo:InsertColorChange( 110, 200, 255, 255 )
        concmdHelpInfo:AppendText('\nEx: playx_open "https://www.youtube.com/watch?v=fKQV68-U1Bw" "" 18\n- Starts this video at 18 seconds, all other args default.\n\nEx: playx_open "https://www.youtube.com/watch?v=7d7Soe_MiqQ" "" 0 "true" "false" "false"\n- Opens music video with video disabled and all args specified here.')

        function concmdHelpInfo:PerformLayout()
            concmdHelpInfo:SetFontInternal("HudSelectionText")
            concmdHelpInfo:SetToFullHeight()
            concmdHelpInfo:SetBGColor( Color( 20, 20, 20 ) )
        end
    panel:AddItem(concmdHelpInfo)

    panel:Help("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

end

--- PopulateToolMenu hook.
local function PopulateToolMenu()
    hasLoaded = true
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXSettings", "Settings", "", "", SettingsPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXControl", "Administrate", "", "", ControlPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXBookmarks", "Bookmarks (Local)", "", "", BookmarksPanel) 
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXNavigator", "Navigator", "", "", NavigatorPanel)
    spawnmenu.AddToolMenuOption("Options", "PlayX", "PlayXHelp", "Help", "", "", PlayXHelpPanel)
end

hook.Add("PopulateToolMenu", "PlayXPopulateToolMenu", PopulateToolMenu)

--- Updates the tool panels.
function PlayX.UpdatePanels()
    if not hasLoaded then return end
    SettingsPanel(controlpanel.Get("PlayXSettings"))
    ControlPanel(controlpanel.Get("PlayXControl"))
    NavigatorPanel(controlpanel.Get("PlayXNavigator"))
    PlayXHelpPanel(controlpanel.Get("PlayXHelp"))
end
