--[[------------------------------------------------------------------------------------------------------------------
Administrate --- Draw the control panel.
--------------------------------------------------------------------------------------------------------------------]]
function PlayXGUI.ControlPanel(panel)

	--New Coloring Scheme
	panel.Paint = function() 
		draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), PlayXGUI.Colors["backgroundColor"])
	end

	local logo     
	if file.Exists("materials/vgui/panel/playxlogo.vtf", "GAME") or file.Exists("materials/vgui/panel/playxlogo.vmt", "GAME") then   
		logo = vgui.Create("Material", panel)
		logo:SetSize(panel:GetTall(),panel:GetWide())
		logo:SetPos(50,50)
		logo:SetMaterial( "vgui/panel/playxlogo" )
		logo.AutoSize = false
	else
		logo = vgui.Create("DLabel", panel)
		logo:SetText("PLAYX")
		logo:SetFont("DermaLarge")
	end

	--Create Provider Selection Box--------------------------------------------------------
	local providerSelectLabel = vgui.Create( "DLabel", panel )
		providerSelectLabel:SetText( "Provider:" )
		providerSelectLabel:SetTextColor(PlayXGUI.Colors["textColor"])
		providerSelectLabel:SetFont( "HudHintTextLarge" )

	local providerSelect = vgui.Create("DComboBox", panel)
		providerSelect:SetPos( 100, panel:GetTall()/8*3 )
		providerSelect:SetWide( 200 )
		providerSelect:SetTall(20)
		providerSelect:SetColor( PlayXGUI.Colors["textColor"] )
		providerSelect:SetTextColor( PlayXGUI.Colors["textColor"] )
		providerSelect.Paint = function() 
			providerSelect:SetColor( PlayXGUI.Colors["menuBackground"] )
			providerSelect:SetTextColor( PlayXGUI.Colors["textColor"] )
			surface.SetDrawColor( PlayXGUI.Colors["textColor"] )
			surface.DrawOutlinedRect( 0, 0, providerSelect:GetWide(), providerSelect:GetTall())
		end

	--Add Providers To ComboBox----------------------------
	providerSelect:Clear()
	providerSelect:AddChoice("Auto-Detect","", true)
	for k, v in pairs(PlayX.Providers) do
		providerSelect:AddChoice(PlayX.Providers[k],k,false)
	end

	providerSelect.DoClick = function(self)
		if ( self:IsMenuOpen() ) then
			return self:CloseMenu()
		end

		--self:OpenMenu() --inserting the function OpenMenu() from dcombobox.lua itself instead of calling it so I can edit the paint-hook directly
		if ( pControlOpener && pControlOpener == self.TextEntry ) then
			return
		end

		-- Don't do anything if there aren't any options..
		if ( #self.Choices == 0 ) then return end

		-- If the menu still exists and hasn't been deleted
		-- then just close it and don't open a new one.
		if ( IsValid( self.Menu ) ) then
			self.Menu:Remove()
			self.Menu = nil
		end

		self.Menu = DermaMenu( false, self )

		if ( self:GetSortItems() ) then
			local sorted = {}
			for k, v in pairs( self.Choices ) do
				local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
				if ( isstring( val ) && string.len( val ) > 1 && !tonumber( val ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
				table.insert( sorted, { id = k, data = v, label = val } )
			end
			for k, v in SortedPairsByMemberValue( sorted, "label" ) do
				local pnl = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
				pnl.Paint = function(self,w,h)
					draw.RoundedBox(0,0,0,w,h,PlayXGUI.Colors["menuBackground"])
				end
			end
		else
			for k, v in pairs( self.Choices ) do
				local pnl = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
				pnl.Paint = function(self,w,h)
					draw.RoundedBox(0,0,0,w,h,PlayXGUI.Colors["textCmenuBackgroundolor"])
				end
			end
		end

		local x, y = self:LocalToScreen( 0, self:GetTall() )

		self.Menu:SetMinimumWidth( self:GetWide() )
		self.Menu:Open( x, y, false, self )
	end

	function providerSelect:OnSelect( index, value, data )
		RunConsoleCommand("playx_provider", providerSelect:GetOptionData(index))
	end

	--Start At Box--------------------------------------------------------------------------
	local uriEntryBoxLabel = vgui.Create( "DLabel", panel )
				uriEntryBoxLabel:SetText( "URI: " )
				uriEntryBoxLabel:SetTextColor(PlayXGUI.Colors["textColor"])
				uriEntryBoxLabel:SetFont( "HudHintTextLarge" )
				uriEntryBoxLabel:SizeToContents()

				local uriEntryBox = vgui.Create( "DTextEntry", panel )
				uriEntryBox:SetWide( 220 )
				uriEntryBox:SetFont( "DermaDefaultBold" )
				uriEntryBox:SetConVar( "playx_uri" )
				uriEntryBox.Paint = function(self,w,h)
					surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
					surface.DrawOutlinedRect( 0, 0, w, h )
					draw.RoundedBox( 2, 0, 0, w, h, PlayXGUI.Colors["menuBackground"] ) 
					self:DrawTextEntryText( PlayXGUI.Colors["textColor"], PlayXGUI.Colors["buttonColor"], PlayXGUI.Colors["buttonLineColor"] )
				end
	local startAtBoxLabel = vgui.Create( "DLabel", panel )
		startAtBoxLabel:SetText( "Start At: " )
		startAtBoxLabel:SetTextColor(PlayXGUI.Colors["textColor"])
		startAtBoxLabel:SetFont("HudHintTextLarge")
		startAtBoxLabel:SizeToContents()
		local startAtBox = vgui.Create( "DTextEntry", panel )
		startAtBox:SetWide( 220 )
			startAtBox:SetFont("DermaDefaultBold")
			startAtBox:SetConVar( "playx_start_time" )
			startAtBox.Paint = function(self,w,h)
				surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
				surface.DrawOutlinedRect( 0, 0, w, h )
				draw.RoundedBox( 2, 0, 0, w, h, PlayXGUI.Colors["menuBackground"] ) 
				self:DrawTextEntryText( PlayXGUI.Colors["textColor"], PlayXGUI.Colors["buttonColor"], PlayXGUI.Colors["buttonLineColor"] )
			end

	local openMediaButton = vgui.Create( "DButton", panel )
		openMediaButton:SetText( "Open Media" )
		openMediaButton:SetFont("CenterPrintText")
		openMediaButton:SetColor(PlayXGUI.Colors["textColor"])
		openMediaButton.DoClick = function()
			RunConsoleCommand("playx_gui_open")
			RunConsoleCommand("playx_provider", "")
		end
		openMediaButton.Paint = function()    
			openMediaButton:SetColor(PlayXGUI.Colors["textColor"])
			if openMediaButton:IsDown() then 
				surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), openMediaButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLinePressColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
			else
				surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), openMediaButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
			end
			if openMediaButton:IsHovered() && not openMediaButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonHoverColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
			elseif not openMediaButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, openMediaButton:GetWide(), 3)
			end
		end

	local closeMediaButton = vgui.Create( "DButton", panel )
		closeMediaButton:SetText( "Close Media" )
		closeMediaButton:SetFont("DermaDefaultBold")
		closeMediaButton:SetColor(PlayXGUI.Colors["textColor"])
		closeMediaButton:SetConsoleCommand("playx_gui_close")
		closeMediaButton.Paint = function()    
			closeMediaButton:SetColor(PlayXGUI.Colors["textColor"])
			if closeMediaButton:IsDown() then 
				surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), closeMediaButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLinePressColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
			else
				surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), closeMediaButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
			end
			if closeMediaButton:IsHovered() && not closeMediaButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonHoverColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
			elseif not closeMediaButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, closeMediaButton:GetWide(), 3)
			end
		end

	local addBookmarkButton = vgui.Create( "DButton", panel )
		addBookmarkButton:SetText( "Add Current Media to Bookmarks" )
		addBookmarkButton:SetFont("CenterPrintText")
		addBookmarkButton:SetColor(PlayXGUI.Colors["textColor"])
		addBookmarkButton:SetConsoleCommand("playx_gui_bookmark")
		addBookmarkButton.Paint = function()    
			addBookmarkButton:SetColor(PlayXGUI.Colors["textColor"])

			if addBookmarkButton:IsDown() then 
				surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), addBookmarkButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLinePressColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
			else
				surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), addBookmarkButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
			end
			if addBookmarkButton:IsHovered() && not addBookmarkButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonHoverColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
			elseif not addBookmarkButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, addBookmarkButton:GetWide(), 3)
			end
		end

	local dividerAdvOptions = vgui.Create("DLabel", panel)
		dividerAdvOptions:SetText( "--Advanced Options--")
		dividerAdvOptions:SetTextColor(PlayXGUI.Colors["textColor"])
		dividerAdvOptions:SetFont(PlayXGUI.bodyFont)
		dividerAdvOptions:SizeToContents()
		dividerAdvOptions.Paint = function ()
			dividerAdvOptions:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local lowFrameRateCheckbox = vgui.Create("DCheckBoxLabel", panel)
		lowFrameRateCheckbox:SetText( "Disable Video (Use with music)" )
		lowFrameRateCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
		lowFrameRateCheckbox:SetFont(PlayXGUI.bodyFont)
		lowFrameRateCheckbox:SetValue(GetConVar("playx_force_low_framerate"))
		lowFrameRateCheckbox:SetConVar( "playx_force_low_framerate" )
		lowFrameRateCheckbox.Paint = function ()
			lowFrameRateCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local doNotAutoStopCheckbox = vgui.Create("DCheckBoxLabel", panel)
		doNotAutoStopCheckbox:SetText( "Disable Auto Stop" )
		doNotAutoStopCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
		doNotAutoStopCheckbox:SetFont(PlayXGUI.bodyFont)
		doNotAutoStopCheckbox:SetValue(GetConVar("playx_ignore_length"))
		doNotAutoStopCheckbox:SetConVar( "playx_ignore_length" )
		doNotAutoStopCheckbox.Paint = function ()
			doNotAutoStopCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
		end

	local useJWCheckBox = vgui.Create("DCheckBoxLabel", panel)
		useJWCheckBox:SetText( "Use Better Settings For Better Quality" )
		useJWCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
		useJWCheckBox:SetFont(PlayXGUI.bodyFont)
		useJWCheckBox:SetValue(GetConVar("playx_use_jw"))
		useJWCheckBox:SetConVar( "playx_use_jw" )
		useJWCheckBox.Paint = function ()
			useJWCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
		end



	 local pauseButton = vgui.Create( "DButton", panel )
		pauseButton:SetText( "Pause (NOT ACTIVE)" )
		pauseButton:SetFont("CenterPrintText")
		pauseButton:SetSize(64, 35)
		pauseButton:SetColor(PlayXGUI.Colors["textColor"])
		pauseButton:SetConsoleCommand("playx_pause")
		pauseButton.Paint = function()    
		pauseButton:SetColor(PlayXGUI.Colors["textColor"])
			if pauseButton:IsDown() then 
				surface.SetDrawColor( PlayXGUI.Colors["buttonPressedColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), pauseButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLinePressColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
			else
				surface.SetDrawColor( PlayXGUI.Colors["buttonColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), pauseButton:GetTall())
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
			end
			if pauseButton:IsHovered() && not pauseButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonHoverColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
			elseif not pauseButton:IsDown() then
				surface.SetDrawColor( PlayXGUI.Colors["buttonLineColor"] )
				surface.DrawRect( 0, 0, pauseButton:GetWide(), 3)
			end
		end

	function panel:ResizeContent()--there is probably a better way to set the size after using dock. But I don't know how
		logo:SetSize(panel:GetWide()/4,panel:GetTall()/5)
		logo:SetPos(panel:GetWide()/2-panel:GetWide()/8,0)

		providerSelectLabel:SetPos( 20, panel:GetTall()/11*2 )
		providerSelect:SetPos( providerSelectLabel:GetWide() + 20, panel:GetTall()/11*2 )
		uriEntryBoxLabel:SetPos( providerSelectLabel:GetWide() + providerSelect:GetWide() + 40 , panel:GetTall()/11*2 )
		uriEntryBox:SetPos( providerSelectLabel:GetWide() + providerSelect:GetWide() + uriEntryBoxLabel:GetWide() + 60, panel:GetTall()/11*2 )

		local lengthForAllBoxes = providerSelectLabel:GetWide() + providerSelect:GetWide() + uriEntryBoxLabel:GetWide() + uriEntryBox:GetWide() + 80
		local checkSize = panel:GetWide() - lengthForAllBoxes >= startAtBoxLabel:GetWide() + startAtBox:GetWide() + 20

		if checkSize then --if we can squezze the 3rd box there do it
			startAtBoxLabel:SetPos( lengthForAllBoxes+20, panel:GetTall()/11*2 )
			startAtBox:SetPos( lengthForAllBoxes+startAtBoxLabel:GetWide() + 40, panel:GetTall()/11*2 )
		else --else put it below
			startAtBoxLabel:SetPos( 20, panel:GetTall()/11*3 )
			startAtBox:SetPos( 80, panel:GetTall()/11*3 )
		end

		openMediaButton:SetPos(20,panel:GetTall()/11*(4 - (checkSize and 1 or 0)))
		openMediaButton:SetSize(panel:GetWide()-40, 35)

		closeMediaButton:SetPos(20,panel:GetTall()/11*(5 - (checkSize and 1 or 0)))
		closeMediaButton:SetSize(panel:GetWide()-40, 35)

		addBookmarkButton:SetPos(20,panel:GetTall()/11*(6 - (checkSize and 1 or 0)))
		addBookmarkButton:SetSize(panel:GetWide()-40, 35)

		dividerAdvOptions:SetPos(panel:GetWide()/2-dividerAdvOptions:GetWide()/2,panel:GetTall()/11*(7 - (checkSize and 1 or 0)))

		lowFrameRateCheckbox:SetPos(20,panel:GetTall()/11*(8 - (checkSize and 1 or 0)))
		doNotAutoStopCheckbox:SetPos(lowFrameRateCheckbox:GetWide()+60,panel:GetTall()/11*(8 - (checkSize and 1 or 0)))
		local checkLength = (panel:GetWide() - (lowFrameRateCheckbox:GetWide() + doNotAutoStopCheckbox:GetWide() + 60) ) >= useJWCheckBox:GetWide()

		if checkLength then
			useJWCheckBox:SetPos(lowFrameRateCheckbox:GetWide() + doNotAutoStopCheckbox:GetWide() + 80,panel:GetTall()/11*(8 - (checkSize and 1 or 0)))
		else
			useJWCheckBox:SetPos(20,panel:GetTall()/11*(9 - (checkSize and 1 or 0)))
		end

		pauseButton:SetPos(20,panel:GetTall()/11*(10 - (checkSize and 1 or 0) - (checkLength and 1 or 0) ))
		pauseButton:SetSize(panel:GetWide()-40, 35)
	end

end