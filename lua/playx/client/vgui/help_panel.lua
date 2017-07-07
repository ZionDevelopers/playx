--[[------------------------------------------------------------------------------------------------------------------
Help Sheet -- Draw the Help Panel
--------------------------------------------------------------------------------------------------------------------]]
function PlayXGUI.PlayXHelpPanel(panel)
	panel:DockMargin(10,5,10,5)
	panel.Paint = function(self,w,h)
		draw.RoundedBox( 0, 0, 0,w,h, PlayXGUI.Colors["backgroundColor"])
	end

	local topPanel = vgui.Create("DPanel",panel)
		topPanel:DockPadding(0,10,0,10)
		topPanel:SetSize(0,panel:GetTall()/2)
		topPanel:Dock(TOP)
		topPanel:InvalidateParent(true)
		topPanel.Paint = function(self,w,h)
			draw.RoundedBox( 0, 0, 0,w,h, PlayXGUI.Colors["backgroundColor"])
		end

	local chatHelpInfoHeader = vgui.Create("DLabel", topPanel)
		chatHelpInfoHeader:SetText( "\n  PlayX Chat Commands\n")
		chatHelpInfoHeader:SetFont("Trebuchet24_Underline")
		chatHelpInfoHeader:Dock(TOP)

	local chatHelpInfo = vgui.Create("RichText", topPanel)
		chatHelpInfo:Dock(FILL)
		function chatHelpInfo:PerformLayout()
			chatHelpInfo:SetFontInternal("HudSelectionText")
			chatHelpInfo:SetBGColor( Color( 20, 20, 20 ) )
		end

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
		chatHelpInfo:Dock( FILL )

	local bottomPanel = vgui.Create("DPanel",panel)
			bottomPanel:DockPadding(0,10,0,10)
			bottomPanel:SetSize(0,panel:GetTall()/2-40)
			bottomPanel:Dock(BOTTOM)
			bottomPanel:InvalidateParent(true)
			bottomPanel.Paint = function(self,w,h)
				draw.RoundedBox( 0, 0, 0,w,h, PlayXGUI.Colors["backgroundColor"])
			end

	local concmdHelpInfoHeader = vgui.Create("DLabel", bottomPanel)
		concmdHelpInfoHeader:SetText( "\n  PlayX Console Commands\n")
		concmdHelpInfoHeader:SetFont("Trebuchet24_Underline")
		concmdHelpInfoHeader:Dock(TOP)

	local concmdHelpInfo = vgui.Create("RichText", bottomPanel)
		concmdHelpInfo:Dock(FILL)
		function concmdHelpInfo:PerformLayout()
			concmdHelpInfo:SetFontInternal("HudSelectionText")
			concmdHelpInfo:SetBGColor( Color( 20, 20, 20 ) )
		end

		concmdHelpInfo:InsertColorChange( 255, 255, 255, 255 )
		concmdHelpInfo:AppendText("- playx_open <URL> <provider> <start (seconds)> <novideo (bool)> <usejw (bool)> <ignore length (bool)>\n")
		concmdHelpInfo:InsertColorChange( 160, 255, 160, 255 )
		concmdHelpInfo:AppendText("- Opens A Video With Specified Args\n")
		concmdHelpInfo:InsertColorChange( 240, 240, 150, 255 )
		concmdHelpInfo:AppendText('(Not all have to be filled, minimum is URL. If Provider Is Blank, Auto Detect Will Be Used. To Signify No Provider, In The Position Of Provider, Use "", Then Continue With Other Vars.)\n')
		concmdHelpInfo:InsertColorChange( 110, 200, 255, 255 )
		concmdHelpInfo:AppendText('\nEx: playx_open "https://www.youtube.com/watch?v=fKQV68-U1Bw" "" 18\n- Starts this video at 18 seconds, all other args default.\n\nEx: playx_open "https://www.youtube.com/watch?v=7d7Soe_MiqQ" "" 0 "true" "false" "false"\n- Opens music video with video disabled and all args specified here.')
end
