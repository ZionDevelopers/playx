--[[------------------------------------------------------------------------------------------------------------------
Navigator Sheet -- Draw the control panel.
--------------------------------------------------------------------------------------------------------------------]]

function PlayXGUI.NavigatorPanel(panel)
    panel:DockMargin(10,0,10,0)

        local label = vgui.Create("Label",panel)
        label:SetPos(0,0)
        label:SetText("URI: "..PlayX.NavigatorCapturedURL)
        label:SizeToContents()

        local Addbutton = vgui.Create("DButton",panel)
        Addbutton:SetText("Add current URL as Bookmark")
        Addbutton:SetFont("Trebuchet24_Underline")
        Addbutton:SizeToContents()
        panel:SizeToChildren(false,true)
        Addbutton.DoClick = function()
            LocalPlayer():ConCommand("playx_navigator_addbookmark")
        end

        local OpenButton = vgui.Create("DButton",panel)
        OpenButton:SetText("Open current URL")
        OpenButton:SetFont("Trebuchet24_Underline")
        OpenButton:SizeToContents()
        OpenButton:SetPos(Addbutton:GetWide()+5,0)
        panel:SizeToChildren(false,true)
        OpenButton.DoClick = function()
            if panel:GetParent().Browser.Chrome.AddressBar:GetText() != "" then
                --TODO:Get the actual url of the video playing in the html-panel
                LocalPlayer():ConCommand("playx_open \""..panel:GetParent().Browser.Chrome.AddressBar:GetText().."\"")         
            end
        end

end