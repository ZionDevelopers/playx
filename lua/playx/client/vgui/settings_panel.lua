--[[------------------------------------------------------------------------------------------------------------------
Settings Sheet -- Draw the settings panel.
--------------------------------------------------------------------------------------------------------------------]]
--TODO:Remake the panel
function PlayXGUI.SettingsPanel(panel)
    panel:SetLabel( "Playx Settings - Client Side" )
    
    --New Coloring Scheme
    panel.Paint = function() 
        draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), PlayXGUI.Colors["backgroundColor"])
    end

    local enabledCheckBox = vgui.Create("DCheckBoxLabel", panel)
        enabledCheckBox:SetText( "Enabled" )
        enabledCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
        enabledCheckBox:SetValue(GetConVar("playx_enabled"))
        enabledCheckBox:SetConVar( "playx_enabled" )
        enabledCheckBox.Paint = function ()
            enabledCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(enabledCheckBox)

    local dividerLabel = vgui.Create("DLabel", panel)
        dividerLabel:SetText( "--- Modify Client Side Setings Here When Player Enabled ---")
        dividerLabel:SetTextColor(PlayXGUI.Colors["textColor"])
        dividerLabel.Paint = function ()
            dividerLabel:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(dividerLabel)

    panel:Help("\n") --Add Space

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
        videoRangeCheck:SetTextColor(PlayXGUI.Colors["textColor"])
        videoRangeCheck:SetValue(GetConVar("playx_video_range_enabled"))
        videoRangeCheck:SetConVar("playx_video_range_enabled")
        videoRangeCheck.Paint = function ()
            videoRangeCheck:SetTextColor(PlayXGUI.Colors["textColor"])
        end
        panel:AddItem(videoRangeCheck)

	--panel:AddControl("CheckBox", {
    --    Label = "Only play videos near me",
    --    Command = "playx_video_range_enabled",
    --}):SetTooltip("Uncheck to play videos in any part of the map")
        local rangeHintCheck = vgui.Create("DCheckBoxLabel", panel)
            rangeHintCheck:SetText("Show Hints when I enter Or Leave Video Range")
            rangeHintCheck:SetTextColor(PlayXGUI.Colors["textColor"])
            rangeHintCheck:SetValue(GetConVar("playx_video_range_hints_enabled"))
            rangeHintCheck:SetConVar("playx_video_range_hints_enabled")
            rangeHintCheck.Paint = function ()
                rangeHintCheck:SetTextColor(PlayXGUI.Colors["textColor"])
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
        volumeSlider.TextArea:SetTextColor(PlayXGUI.Colors["textColor"])
        volumeSlider.Label:SetColor(PlayXGUI.Colors["textColor"])
        volumeSlider.Label.Paint = function () 
            volumeSlider.Label:SetTextColor(PlayXGUI.Colors["textColor"])
            volumeSlider.TextArea:SetTextColor(PlayXGUI.Colors["textColor"])
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
        rangeSlider.TextArea:SetTextColor(PlayXGUI.Colors["textColor"])
        rangeSlider.Label:SetColor(PlayXGUI.Colors["textColor"])
        rangeSlider.Label.Paint = function () 
            rangeSlider.Label:SetTextColor(PlayXGUI.Colors["textColor"])
            rangeSlider.TextArea:SetTextColor(PlayXGUI.Colors["textColor"])
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
        dividerLabelAdv:SetTextColor(PlayXGUI.Colors["textColor"])
        dividerLabelAdv.Paint = function ()
            dividerLabelAdv:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(dividerLabelAdv)

    local errorWindowsCheck = vgui.Create("DCheckBoxLabel", panel)
        errorWindowsCheck:SetText( "Show Error Message Boxes" )
        errorWindowsCheck:SetTextColor(PlayXGUI.Colors["textColor"])
        errorWindowsCheck:SetValue(GetConVar("playx_error_windows"))
        errorWindowsCheck:SetConVar( "playx_error_windows" )
        errorWindowsCheck.Paint = function ()
            errorWindowsCheck:SetTextColor(PlayXGUI.Colors["textColor"])
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
                hideButton:SetColor(PlayXGUI.Colors["textColor"])
                hideButton:SetConsoleCommand("playx_hide")
                hideButton.Paint = function()    
                    hideButton:SetColor(PlayXGUI.Colors["textColor"])
        
                    if hideButton:IsDown() then 
                        surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
                        surface.DrawRect( 0, 0, hideButton:GetWide(), hideButton:GetTall())
                    else
                        surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
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
                reInitButton:SetColor(PlayXGUI.Colors["textColor"])
                reInitButton:SetConsoleCommand("playx_resume")
                reInitButton.Paint = function()    
                    reInitButton:SetColor(PlayXGUI.Colors["textColor"])
        
                    if reInitButton:IsDown() then 
                        surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
                        surface.DrawRect( 0, 0, reInitButton:GetWide(), reInitButton:GetTall())
                    else
                        surface.SetDrawColor(  )
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
                resumeButton:SetColor(PlayXGUI.Colors["textColor"])
                resumeButton:SetConsoleCommand("playx_resume")
                resumeButton.Paint = function()    
                    resumeButton:SetColor(PlayXGUI.Colors["textColor"])
        
                    if resumeButton:IsDown() then 
                        surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
                        surface.DrawRect( 0, 0, resumeButton:GetWide(), resumeButton:GetTall())
                    else
                        surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
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
                dividerResumeSupported:SetTextColor(PlayXGUI.Colors["textColor"])
                dividerResumeSupported.Paint = function ()
                    dividerResumeSupported:SetTextColor(PlayXGUI.Colors["textColor"])
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
                dividerLabelMediaStopWarn:SetTextColor(PlayXGUI.Colors["textColor"])
                dividerLabelMediaStopWarn.Paint = function ()
                    dividerLabelMediaStopWarn:SetTextColor(PlayXGUI.Colors["textColor"])
                end
            panel:AddItem(dividerLabelNoMedia)
            
            --panel:AddControl("Label", {
            --    Text = "The current media cannot be resumed once stopped."
            --})
        end
    else
        local dividerLabelNoMedia = vgui.Create("DLabel", panel)
                dividerLabelNoMedia:SetText( "\n --No Media Is Currently Playing-- \n")
                dividerLabelNoMedia:SetTextColor(PlayXGUI.Colors["textColor"])
                dividerLabelNoMedia.Paint = function ()
                    dividerLabelNoMedia:SetTextColor(PlayXGUI.Colors["textColor"])
                end
            panel:AddItem(dividerLabelNoMedia)
        --panel:AddControl("Label", {
        --    Text = "No media is playing at the moment."
        --})
    end
--    panel:Help("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n") --Add Space To Extend Menu Color (I know, janky)
end