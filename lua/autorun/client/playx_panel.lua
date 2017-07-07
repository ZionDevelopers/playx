PlayXGUI = {}
PlayX._BookmarksPanelList = nil

PlayXGUI.Colors = {}
PlayXGUI.Colors["backgroundColor"] = Color(50,50,50,50)
PlayXGUI.Colors["textColor"] = Color(220,220,220,255)
PlayXGUI.Colors["buttonColor"] = Color(80,80,80,100)
PlayXGUI.Colors["buttonPressedColor"] = Color(30,30,30,50)
PlayXGUI.Colors["buttonLineColor"] = Color(0,200,255,255)
PlayXGUI.Colors["buttonHoverColor"] = Color(255,50,50,255)
PlayXGUI.Colors["buttonLinePressColor"] = Color(0,255,0,255)
PlayXGUI.Colors["menuBackground"] = Color(100, 0, 0, 200)
PlayXGUI.bodyFont = "HudHintTextLarge"
surface.CreateFont("Trebuchet24_Underline",{
    size = 24,
    underline = true,
    font = "Trebuchet MS",})

include("playx/client/vgui/administrate_panel.lua")
include("playx/client/vgui/bookmarks_panel.lua")
include("playx/client/vgui/help_panel.lua")
include("playx/client/vgui/navigator_panel.lua")
include("playx/client/vgui/settings_panel.lua")


local PANEL = {}
function PANEL:Init()
    --[[---------------------------------------------------------
    	Main Panel
    -----------------------------------------------------------]]
	self.frame = vgui.Create("DFrame",nil,"playXUI")
--		self.frame:SetSize(ScrW()/1.2,ScrH()/1.1)
		self.frame:SetSize(ScrW()/1.8,ScrH()/1.5)
		self.frame:Center()
        self.frame:SetBackgroundBlur(true)
		self.frame:SetTitle("PlayX")
        self.frame:SetDeleteOnClose(false)
        self.frame:SetDraggable(false)
        self.frame:ShowCloseButton(false)
        self.frame:MakePopup()
		self.frame.Paint = function(self,w,h)
			surface.SetDrawColor(PlayXGUI.Colors["backgroundColor"])
			surface.DrawRect(0,0,w,h)
		end
        self.Close = function()
            if self and IsValid(self.frame) then
                self.frame:Close()
            end
        end
        self.IsHidden = function()
            return !self.frame:IsVisible()
        end
        self.HidePanel = function()
            self.frame:Hide()
        end
        self.ShowPanel = function()
            self.frame:Show()
        end

        self.frame.image = vgui.Create("DImage",self.frame)
        self.frame.image:SetPos(0,0)
        self.frame.image:SetSize(self.frame:GetWide(),self.frame:GetTall())
        self.frame.image:SetImage("vgui/panel/curtains.jpg")

        self.frame.CloseButton = vgui.Create("DButton",self.frame)
            self.frame.CloseButton:SetPos(self.frame:GetWide()-20,0)
            self.frame.CloseButton:SetSize(20,20)
            self.frame.CloseButton:SetText("")
            self.frame.CloseButton.Paint = function(pnl,w,h)
                surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
                surface.DrawRect(0,0,w,h)
                surface.SetDrawColor(255,0,0,255)
                surface.DrawLine(0,0,w,h)
                surface.DrawLine(0,h,w,0)

            end
            self.frame.CloseButton.DoClick = function()
                self:HidePanel()
            end
--[[---------------------------------------------------------
    Context Panel C-Menu ?
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	DPropertySheets
-----------------------------------------------------------]]
	self.mainSheet = vgui.Create("DPropertySheet",self.frame)
		self.mainSheet:SetPadding(4)
		self.mainSheet:Dock(FILL)
		self.mainSheet:InvalidateParent(true)
		self.mainSheet.Paint = function(self,w,h)
			surface.SetDrawColor(PlayXGUI.Colors["backgroundColor"])
			surface.DrawRect(0,0,w,h)
		end

		--[[------------------------------------------------------------------------------------------------------------------
				Administrate Sheet
		--------------------------------------------------------------------------------------------------------------------]]
			self.mainSheet.Administrate = vgui.Create("DPanel",self.mainSheet)
				self.mainSheet.Administrate.Paint = function(self,w,h)
						surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
						surface.DrawRect(0,0,w,h)
					end
				self.mainSheet.Administrate:Dock(FILL)
				self.mainSheet.Administrate:InvalidateParent(true)
				self.mainSheet.Administrate.Tab = self.mainSheet:AddSheet("Administrate",self.mainSheet.Administrate,"icon16/tick.png")
				self.mainSheet.Administrate.Tab.Tab.Paint = function(self,w,h )
					surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
					surface.DrawRect(0,0,w,h)
				end
			PlayXGUI.ControlPanel(self.mainSheet.Administrate)

		--[[------------------------------------------------------------------------------------------------------------------
				Bookmarks Sheet
		--------------------------------------------------------------------------------------------------------------------]]
			self.mainSheet.Bookmarks = vgui.Create("DPanel",self.mainSheet)
					self.mainSheet.Bookmarks.Paint = function(self,w,h)
						surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
						surface.DrawRect(0,0,w,h)
					end
				self.mainSheet.Bookmarks:Dock(FILL)
				self.mainSheet.Bookmarks:InvalidateParent(true)
				self.mainSheet.Bookmarks.Tab = self.mainSheet:AddSheet("Bookmarks",self.mainSheet.Bookmarks,"icon16/book.png")
				self.mainSheet.Bookmarks.Tab.Tab.Paint = function(self,w,h )
					surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
					surface.DrawRect(0,0,w,h)
				end
			PlayXGUI.BookmarksPanel(self.mainSheet.Bookmarks)

		--[[------------------------------------------------------------------------------------------------------------------
				Navigator Sheet
		--------------------------------------------------------------------------------------------------------------------]]
			self.mainSheet.Navigator = vgui.Create("Panel",self.mainSheet)
					self.mainSheet.Navigator.Paint = function(self,w,h)
						surface.SetDrawColor(PlayXGUI.Colors["backgroundColor"])
						surface.DrawRect(0,0,w,h)
					end
			self.mainSheet.Navigator.Browser = vgui.Create("PlayXBrowser",self.mainSheet.Navigator)
			self.mainSheet.Navigator.Browser:Dock(FILL)

            self.mainSheet.Navigator.window = vgui.Create("DPanel",self.mainSheet.Navigator)
            self.mainSheet.Navigator.window:SetSize(0,50)
            self.mainSheet.Navigator.window:Dock(TOP)
            PlayXGUI.NavigatorPanel(self.mainSheet.Navigator.window)
			self.mainSheet.Navigator.window.Paint = function(self,w,h)
				surface.SetDrawColor(PlayXGUI.Colors["backgroundColor"])
				surface.DrawRect(0,0,w,h)
			end

			self.mainSheet.Navigator.Tab = self.mainSheet:AddSheet("Navigator",self.mainSheet.Navigator,"icon16/zoom.png")
			self.mainSheet.Navigator.Tab.Tab.Paint = function(self,w,h )
				surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
				surface.DrawRect(0,0,w,h)
			end
	
		--[[------------------------------------------------------------------------------------------------------------------
				Settings Sheet
		--------------------------------------------------------------------------------------------------------------------]]
			self.mainSheet.Settings = vgui.Create("DPanel",self.mainSheet)
					self.mainSheet.Settings.Paint = function(self,w,h)
						surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
						surface.DrawRect(0,0,w,h)
					end
					self.mainSheet.Settings:Dock(FILL)
					self.mainSheet.Settings:InvalidateParent(true)
					self.mainSheet.Settings.Tab = self.mainSheet:AddSheet("Settings",self.mainSheet.Settings,"icon16/page_gear.png")
					self.mainSheet.Settings.Tab.Tab.Paint = function(self,w,h )
						surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
						surface.DrawRect(0,0,w,h)
					end
					PlayXGUI.SettingsPanel(self.mainSheet.Settings)

		--[[------------------------------------------------------------------------------------------------------------------
				Help Sheet
		--------------------------------------------------------------------------------------------------------------------]]
			self.mainSheet.Help = vgui.Create("DPanel",self.mainSheet)
				self.mainSheet.Help.Paint = function(self,w,h)
					surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
					surface.DrawRect(0,0,w,h)
				end
				self.mainSheet.Help:Dock(FILL)
				self.mainSheet.Help:InvalidateParent(true)
				self.mainSheet.Help.Tab = self.mainSheet:AddSheet("Help",self.mainSheet.Help,"icon16/heart.png")
				self.mainSheet.Help.Tab.Tab.Paint = function(self,w,h )
					surface.SetDrawColor(PlayXGUI.Colors["buttonColor"])
					surface.DrawRect(0,0,w,h)
				end
				PlayXGUI.PlayXHelpPanel(self.mainSheet.Help)
end

function PANEL:Think()
	self.mainSheet.Settings:EnableDisablePanels() --update the button hiding/showing (maybe wanna use hooks instead)
end
derma.DefineControl( "PlayUI", "PlayX user-interface", PANEL,nil)