
-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2024 DathusBR <https://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- Credit: Based on Cinema Fixed Edition: <https://raw.githubusercontent.com/FarukGamer/cinema/master/workshop/gamemodes/cinema_modded/gamemode/modules/scoreboard/controls/cl_htmlcontrols.lua>

-- $Id$
-- Version 2.9.7 by Dathus [BR] on 2023-06-11 8:37 PM (-03:00 GMT)

local PANEL = {}

function PANEL:Open(provider, uri)
  MsgN("PlayXBrowser: Requested to open <" .. provider .. "> / <"  .. uri .. ">")
  PlayX.RequestOpenMedia(provider, uri, 0, false, GetConVar("playx_use_jw"):GetBool(),
    GetConVar("playx_ignore_length"):GetBool())
end

function PANEL:Init()

  local ButtonSize = 32
  local Margins = 2
  local Spacing = 0

  local vecTranslate = Vector()
  local angRotate = Angle()

  self.BackButton = vgui.Create( "DImageButton", self )
  self.BackButton:SetSize( ButtonSize, ButtonSize )
  self.BackButton:SetMaterial( "gui/HTML/back" )
  self.BackButton:Dock( LEFT )
  self.BackButton:DockMargin( Spacing * 3, Margins, Spacing, Margins )
  self.BackButton.DoClick = function()
    self.BackButton:SetDisabled( true )
    self.Cur = self.Cur - 1
    self.HTML:OpenURL(self.History[self.Cur])
    self.Navigating = true
  end

  self.ForwardButton = vgui.Create( "DImageButton", self )
  self.ForwardButton:SetSize( ButtonSize, ButtonSize )
  self.ForwardButton:SetMaterial( "gui/HTML/forward" )
  self.ForwardButton:Dock( LEFT )
  self.ForwardButton:DockMargin( Spacing, Margins, Spacing, Margins )
  self.ForwardButton.DoClick = function()
    self.ForwardButton:SetDisabled( true )
    self.Cur = self.Cur + 1
    self.HTML:OpenURL(self.History[self.Cur])
    self.Navigating = true
  end

  self.RefreshButton = vgui.Create( "DImageButton", self )
  self.RefreshButton:SetSize( ButtonSize, ButtonSize )
  self.RefreshButton:SetMaterial( "gui/HTML/refresh" )
  self.RefreshButton:Dock( LEFT )
  self.RefreshButton:DockMargin( Spacing, Margins, Spacing, Margins )
  self.RefreshButton.DoClick = function()
    self.RefreshButton:SetDisabled( true )
    self.Refreshing = true
    self.HTML:OpenURL( self.HTML:GetURL() )
  end

  self.RefreshButton.PaintOver = function(pnl)
    if pnl._PushedMatrix then
      cam.PopModelMatrix()
      pnl._PushedMatrix = nil
    end
  end

  self.RefreshButton.Paint = function(pnl, w, h )
    if self.HTML and self.HTML:IsLoading() then
      local x, y = pnl:LocalToScreen(0,0)

      vecTranslate.x = x + w / 2
      vecTranslate.y = y + h / 2

      angRotate.y = RealTime() * 512

      local mat = Matrix()
      mat:Translate( vecTranslate )
      mat:Rotate( angRotate )
      mat:Translate( -vecTranslate )
      cam.PushModelMatrix( mat )
      pnl._PushedMatrix = true
    end
  end

  self.HomeButton = vgui.Create( "DImageButton", self )
  self.HomeButton:SetSize( ButtonSize, ButtonSize )
  self.HomeButton:SetMaterial( "gui/HTML/home" )
  self.HomeButton:Dock( LEFT )
  self.HomeButton:DockMargin( Spacing, Margins, Spacing * 3, Margins )
  self.HomeButton.DoClick = function()
    self.HTML:Stop()
    self.HTML:OpenURL( GetConVarString("playx_navigator_homepage_url"):Trim() )
    self.Cur = 1
  end

  self.AddressBar = vgui.Create( "DTextEntry", self )
  self.AddressBar:Dock( FILL )
  self.AddressBar:DockMargin( Spacing, Margins * 3, Spacing, Margins * 3 )
  self.AddressBar.OnEnter = function()
    self.HTML:Stop()
    self.HTML:OpenURL( self.AddressBar:GetValue() )
  end

  self.RequestButton = vgui.Create( "DButton", self )
  self.RequestButton:SetSize( ButtonSize * 8, ButtonSize )
  self.RequestButton:SetText( "Request URL" )
  self.RequestButton:SetTooltip( "Click to play" )
  -- self.RequestButton:SetDisabled( true )
  self.RequestButton:Dock( RIGHT )
  self.RequestButton:DockMargin( 8, 4, 8, 4 )
  self.RequestButton.BackgroundColor = Color(123, 32, 29)
  self.RequestButton.DoClick = function()
    PlayX.NavigatorCapturedURL = self.HTML.URL;    
    self:Open("", self.HTML.URL);
    self.HTML:Stop()
    self.HTML:OpenURL( GetConVarString("playx_navigator_homepage_url"):Trim() )
    PlayX._NavigatorWindow:Close();
  end

  self:SetHeight( ButtonSize + Margins * 2 )

  self.NavStack = 0;
  self.History = {}
  self.Cur = 1

  -- This is the default look, feel free to change it on your created control :)
  self:SetButtonColor( Color( 250, 250, 250, 200 ) )
  self.BorderSize = 4
  self.BackgroundColor = Color( 33, 33, 33, 255 )
  self.HomeURL = GetConVarString("playx_navigator_homepage_url"):Trim()

end

function PANEL:SetHTML( html )

  self.HTML = html

  if ( html.URL ) then
    self.HomeURL = self.HTML.URL
  end

  self.AddressBar:SetText( self.HomeURL )
  self:UpdateHistory( self.HomeURL )

  self.HTML.OnBeginLoadingDocument = function( panel, url )
    self.HTML.URL2 = url
  end

  self.HTML.OnFinishLoading = function( panel )

    local url = self.HTML:GetURL()

    if self.HTML.URL2 ~= url then
      url = self.HTML.URL2
      self.HTML:SetURL(url)
    end

    self.AddressBar:SetText( url )
    self:FinishedLoading()

  end

  self.HTML.OnURLChanged = function ( panel, url )

    self.AddressBar:SetText( url )
    self.NavStack = self.NavStack + 1
    self:StartedLoading()
    self:UpdateHistory( url )

    --[[

    -- Check for valid URL

    if theater.ExtractURLData( url, Theater ) then

      self.RequestButton:SetDisabled( false )

    else

      self.RequestButton:SetDisabled( true )

    end

    ]]

  end

end

function PANEL:UpdateHistory( url )

  --print( "PANEL:UpdateHistory", url )
  self.Cur = math.Clamp( self.Cur, 1, table.Count( self.History ) )

  if ( self.Refreshing ) then

    self.Refreshing = false
    self.RefreshButton:SetDisabled( false )
    return

  end

  if ( self.Navigating ) then

    self.Navigating = false
    self:UpdateNavButtonStatus()
    return

  end

  -- We were back in the history queue, but now we're navigating
  -- So clear the front out so we can re-write history!!
  if ( self.Cur < table.Count( self.History ) ) then

    for i = self.Cur + 1, table.Count( self.History ) do
      self.History[i] = nil
    end

  end

  if not table.HasValue(self.History, url) then -- It spams the same entry multiple times...
    self.Cur = table.insert( self.History, url )
  end

  self:UpdateNavButtonStatus()

end

function PANEL:FinishedLoading()

  self.RefreshButton:SetDisabled( false )

end

function PANEL:StartedLoading()

  self.RefreshButton:SetDisabled( true )

end

function PANEL:UpdateNavButtonStatus()

  --print( self.Cur, table.Count( self.History ) )

  self.ForwardButton:SetDisabled( self.Cur >= table.Count( self.History ) )
  self.BackButton:SetDisabled( self.Cur == 1 )

end

function PANEL:SetButtonColor( col )

  self.BackButton:SetColor( col )
  self.ForwardButton:SetColor( col )
  self.RefreshButton:SetColor( col )
  self.HomeButton:SetColor( col )

end

function PANEL:Paint()

  draw.RoundedBoxEx( self.BorderSize, 0, 0, self:GetWide(), self:GetTall(), self.BackgroundColor, true, true, false, false )

end

derma.DefineControl( "PlayXHTMLControls", "", PANEL, "Panel" )
