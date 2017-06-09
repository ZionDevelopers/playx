
--[[------------------------------------------------------------------------------------------------------------------
Administrate --- Draw the control panel.
--------------------------------------------------------------------------------------------------------------------]]
--TODO:Remake the panel
function PlayXGUI.ControlPanel(panel)
    panel:ClearControls()
    panel:SetLabel( "Playx Settings - Media" )
    
    --New Coloring Scheme
    panel.Paint = function() 
        draw.RoundedBox( 0, 0, 0,panel:GetWide(),panel:GetTall(), PlayXGUI.Colors["backgroundColor"])
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
                providerSelectLabel:SetTextColor(PlayXGUI.Colors["textColor"])
                providerSelectLabel:SetPos( 0, 5.5 )
                providerSelectLabel:SetFont( "HudHintTextLarge" )
                providerSelectLabel:SizeToContents()

    local providerSelect = vgui.Create("DComboBox", selectPnl)
                providerSelect:SetPos( 70, 2 )
                providerSelect:SetWide( 200 )
                providerSelect:SetColor( PlayXGUI.Colors["textColor"] )
                providerSelect:SetTextColor( PlayXGUI.Colors["textColor"] )
                providerSelect.Paint = function() 
                    providerSelect:SetColor( PlayXGUI.Colors["textColor"] )
                    providerSelect:SetTextColor( PlayXGUI.Colors["textColor"] )
                    surface.SetDrawColor( PlayXGUI.Colors["textColor"] )
                    surface.DrawOutlinedRect( 0, 0, providerSelect:GetWide(), providerSelect:GetTall())
                end
    panel:AddItem(selectPnl)

    selectPnl.Paint = function() 
        draw.RoundedBox( 0, 0, 0,selectPnl:GetWide(),selectPnl:GetTall(), PlayXGUI.Colors["backgroundColor"])
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
                uriEntryBoxLabel:SetTextColor(PlayXGUI.Colors["textColor"])
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
        draw.RoundedBox( 0, 0, 0,uripnl:GetWide(),uripnl:GetTall(), PlayXGUI.Colors["backgroundColor"])
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
                startAtBoxLabel:SetTextColor(PlayXGUI.Colors["textColor"])
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
        draw.RoundedBox( 0, 0, 0,startatpnl:GetWide(),startatpnl:GetTall(), PlayXGUI.Colors["backgroundColor"])
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
            panel:AddItem(openMediaButton)

    --panel:AddControl("Button", {
    --    Label = "Open Media",
    --    Command = "playx_gui_open",
    --})
    
    local closeMediaButton = vgui.Create( "DButton", panel )
                closeMediaButton:SetText( "Close Media" )
                closeMediaButton:SetFont("DermaDefaultBold")
                closeMediaButton:SetSize(64, 35)
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
            panel:AddItem(addBookmarkButton)
    
    --panel:AddControl("Button", {
    --    Label = "Add as Bookmark",
    --    Command = "playx_gui_bookmark",
    --})

    local dividerAdvOptions = vgui.Create("DLabel", panel)
                dividerAdvOptions:SetText( "\n  --Advanced Options--\n")
                dividerAdvOptions:SetTextColor(PlayXGUI.Colors["textColor"])
                dividerAdvOptions:SetFont(PlayXGUI.bodyFont)
                dividerAdvOptions.Paint = function ()
                    dividerAdvOptions:SetTextColor(PlayXGUI.Colors["textColor"])
                end
            panel:AddItem(dividerAdvOptions)

    local lowFrameRateCheckbox = vgui.Create("DCheckBoxLabel", panel)
        lowFrameRateCheckbox:SetText( "Disable Video (Use with music)" )
        lowFrameRateCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
        lowFrameRateCheckbox:SetFont(PlayXGUI.bodyFont)
        lowFrameRateCheckbox:SetValue(GetConVar("playx_force_low_framerate"))
        lowFrameRateCheckbox:SetConVar( "playx_force_low_framerate" )
        lowFrameRateCheckbox.Paint = function ()
            lowFrameRateCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(lowFrameRateCheckbox)

    local doNotAutoStopCheckbox = vgui.Create("DCheckBoxLabel", panel)
        doNotAutoStopCheckbox:SetText( "Disable Auto Stop" )
        doNotAutoStopCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
        doNotAutoStopCheckbox:SetFont(PlayXGUI.bodyFont)
        doNotAutoStopCheckbox:SetValue(GetConVar("playx_ignore_length"))
        doNotAutoStopCheckbox:SetConVar( "playx_ignore_length" )
        doNotAutoStopCheckbox.Paint = function ()
            doNotAutoStopCheckbox:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(doNotAutoStopCheckbox)

    local useJWCheckBox = vgui.Create("DCheckBoxLabel", panel)
        useJWCheckBox:SetText( "Use Better Settings For Better Quality" )
        useJWCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
        useJWCheckBox:SetFont(PlayXGUI.bodyFont)
        useJWCheckBox:SetValue(GetConVar("playx_use_jw"))
        useJWCheckBox:SetConVar( "playx_use_jw" )
        useJWCheckBox.Paint = function ()
            useJWCheckBox:SetTextColor(PlayXGUI.Colors["textColor"])
        end
    panel:AddItem(useJWCheckBox)

    panel:Help("\n\n\n\n\n")

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
            panel:AddItem(pauseButton)


    panel:Help("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n") --Add Space To Extend Menu Color (I know, janky)
    
end