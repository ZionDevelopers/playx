--[[------------------------------------------------------------------------------------------------------------------
Settings Sheet -- Draw the settings panel.
--------------------------------------------------------------------------------------------------------------------]]
function PlayXGUI.SettingsPanel(panel)
	panel.Paint = function() 
		draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), PlayXGUI.Colors["backgroundColor"])
	end

	local enabledCheckBox = vgui.Create("DCheckBoxLabel", panel)
		enabledCheckBox:SetPos(20,50)
		enabledCheckBox:SetText( "Enabled" )
		enabledCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
		enabledCheckBox:SetValue(GetConVar("playx_enabled"))
		enabledCheckBox:SetConVar( "playx_enabled" )
		enabledCheckBox.Paint = function ()
			enabledCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
		end


	local dividerLabel = vgui.Create("DLabel", panel)
		dividerLabel:SetText( "--- Modify Client Side Setings Here When Player Enabled ---")
		dividerLabel:SetTextColor(PlayXGUI.Colors["textColor"])
		dividerLabel:SizeToContents()
		dividerLabel:SetPos(panel:GetWide()/2 - dividerLabel:GetWide()/2,80)
		dividerLabel.Paint = function ()
			dividerLabel:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local msgLabel = vgui.Create("DLabel",panel)
		local Text = "PlayX has detected a crash in a previous session. Is it safe to " ..
			"re-enable PlayX? For most people, crashes " ..
			"with the new versions of Gmod and PlayX are very rare, but a handful " ..
			"of people crash every time something is played. Try enabling " ..
			"PlayX a few times to determine whether you fall into this group."
		msgLabel:SetText(Text)
		msgLabel:SetWrap(true)
		msgLabel:SetColor(Color(255, 255, 255, 255))
		msgLabel:SetTextColor(Color(255, 255, 255, 255))
		msgLabel:SetTextInset(8, 0)
		msgLabel:SetContentAlignment(7)
		msgLabel:SetAutoStretchVertical( true )
		msgLabel.Paint = function(self)
			draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall() * 10, Color(255, 0, 0, 100))
		end

	if not PlayX.Enabled then
		return
	end

	local videoRangeCheck = vgui.Create("DCheckBoxLabel", panel)
		videoRangeCheck:SetText("Enable Video Range (Only Play Videos Near Me)")
		videoRangeCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		videoRangeCheck:SetValue(GetConVar("playx_video_range_enabled"))
		videoRangeCheck:SetConVar("playx_video_range_enabled")
		videoRangeCheck:SetPos(20,100)
		videoRangeCheck.Paint = function ()
			videoRangeCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local rangeHintCheck = vgui.Create("DCheckBoxLabel", panel)
		rangeHintCheck:SetText("Show Hints when I enter Or Leave Video Range")
		rangeHintCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		rangeHintCheck:SetValue(GetConVar("playx_video_range_hints_enabled"))
		rangeHintCheck:SetConVar("playx_video_range_hints_enabled")
		rangeHintCheck:SetPos(videoRangeCheck:GetWide() + 40,100)
		rangeHintCheck.Paint = function ()
			rangeHintCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local volumeSlider = vgui.Create("DNumSlider", panel)
		volumeSlider:SetSize(panel:GetWide()-40,20)
		volumeSlider:SetPos(20,120)
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

	local rangeSlider = vgui.Create("DNumSlider", panel)
		rangeSlider:SetSize(panel:GetWide()-40,20)
		rangeSlider:SetPos(20,140)
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

	local dividerLabelAdv = vgui.Create("DLabel", panel)
		dividerLabelAdv:SetPos(panel:GetWide()/2 - dividerLabelAdv:GetWide()/2,200)
		dividerLabelAdv:SetText( "--- Other Options ---")
		dividerLabelAdv:SetTextColor(PlayXGUI.Colors["textColor"])
		dividerLabelAdv:SizeToContents()
		dividerLabelAdv.Paint = function ()
			dividerLabelAdv:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local errorWindowsCheck = vgui.Create("DCheckBoxLabel", panel)
		errorWindowsCheck:SetPos(20,220)
		errorWindowsCheck:SetText( "Show Error Message Boxes" )
		errorWindowsCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		errorWindowsCheck:SetValue(GetConVar("playx_error_windows"))
		errorWindowsCheck:SetConVar( "playx_error_windows" )
		errorWindowsCheck:SizeToContents()
		errorWindowsCheck.Paint = function ()
			errorWindowsCheck:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local hideButton = vgui.Create( "DButton", panel )
		hideButton:SetText( "Hide Player" )
		hideButton:SetSize(40,40)
		hideButton:SetPos(20,240)
		hideButton:SetColor(PlayXGUI.Colors["textColor"])
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
		hideButton:SetConsoleCommand("playx_hide")

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
			surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
			surface.DrawRect( 0, 0, reInitButton:GetWide(), reInitButton:GetTall())
			end
		end

	local resumeButton = vgui.Create( "DButton", panel )
		resumeButton:SetConsoleCommand("playx_resume")
		resumeButton:SetText( "Resume Play" )
		resumeButton:SetColor(PlayXGUI.Colors["textColor"])
		resumeButton:SetConsoleCommand("playx_resume")
		resumeButton:SetEnabled(false)
		resumeButton:SetVisible(false)
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

	local dividerResumeSupported = vgui.Create("DLabel", panel)
		dividerResumeSupported:SetText( "The Current Media Supports Pausing / Resuming")
		dividerResumeSupported:SizeToContents()
		dividerResumeSupported.Paint = function () dividerResumeSupported:SetTextColor(PlayXGUI.Colors["textColor"]) end
		dividerResumeSupported:SetTextColor(PlayXGUI.Colors["textColor"])
		dividerResumeSupported:SetVisible(false)

	local dividerLabelMediaStopWarn = vgui.Create("DLabel", panel)
		dividerLabelMediaStopWarn:SetPos(20,300)
		dividerLabelMediaStopWarn:SetText( "\nCurrent Media Cannot Be Resumed Once Stopped\n")
		dividerLabelMediaStopWarn:SizeToContents()
		dividerLabelMediaStopWarn.Paint = function () 
			dividerLabelMediaStopWarn:SetTextColor(PlayXGUI.Colors["textColor"]) 
		end

	local dividerLabelNoMedia = vgui.Create("DLabel", panel)
		dividerLabelNoMedia:SetPos(20,350)
		dividerLabelNoMedia:SetText( "--No Media Is Currently Playing--")
		dividerLabelNoMedia:SizeToContents()
		dividerLabelNoMedia:SetTextColor(PlayXGUI.Colors["textColor"])
		dividerLabelNoMedia.Paint = function () dividerLabelNoMedia:SetTextColor(PlayXGUI.Colors["textColor"]) end

	function panel:EnableDisablePanels()--is there a hook when the player does something ? (new request/stops etc.) 
										--if so add this to the hook-call
		if PlayX.CurrentMedia then
			dividerLabelNoMedia:SetVisible(false)
			reInitButton:SetEnabled(true)
			reInitButton:SetVisible(true)
			reInitButton:SetSize(panel:GetWide()-40,20)
			reInitButton:SetPos(20,265)

			if PlayX.CurrentMedia.ResumeSupported then
					dividerLabelMediaStopWarn:SetVisible(false)
					hideButton:SetEnabled(true)
					hideButton:SetVisible(true)
					hideButton:SetSize(panel:GetWide()-40,20)
					hideButton:SetPos(20,240)

					resumeButton:SetEnabled(true)
					resumeButton:SetVisible(true)

					resumeButton:SetSize(panel:GetWide()-40,20)
					resumeButton:SetPos(20,320)

					dividerResumeSupported:SetVisible(true)
					dividerResumeSupported:SetPos(panel:GetWide()/2-dividerResumeSupported:GetWide()/2,300)
			elseif not PlayX.CurrentMedia.ResumeSupported then
				dividerLabelMediaStopWarn:SetVisible(true)
			end
		elseif not PlayX.CurrentMedia then
			dividerLabelNoMedia:SetVisible(true)
		end

		if PlayX.Playing then
			resumeButton:SetEnabled(false)
			resumeButton:SetVisible(false)
			dividerResumeSupported:SetVisible(false)
		elseif not PlayX.Playing then
			hideButton:SetEnabled(false)
			hideButton:SetVisible(false)

			reInitButton:SetEnabled(false)
			reInitButton:SetVisible(false)
		end

		if PlayX.CrashDetected then
			msgLabel:SetVisible(true)
			msgLabel:SetPos(20,20)
			msgLabel:SetSize(panel:GetWide()-40,panel:GetTall()-360)
		elseif not PlayX.CrashDetected then
			msgLabel:SetVisible(false)
		end
	end
end
