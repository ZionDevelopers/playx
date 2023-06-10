-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2011 - 2023 DathusBR <https://www.juliocesar.me>
-- 
-- This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
-- To view a copy of this license, visit Common Creative's Website. <https://creativecommons.org/licenses/by-nc-sa/4.0/>
-- 
-- Credit: Based on Cinema Fixed Edition: <https://raw.githubusercontent.com/FarukGamer/cinema/master/workshop/gamemodes/cinema_modded/gamemode/modules/scoreboard/controls/cl_html.lua>

-- $Id$
-- Version 2.9.1 by Dathus [BR] on 2023-06-10 3:25 PM (-03:00 GMT)

local RealTime = RealTime

DEFINE_BASECLASS( "Panel" )

local PANEL = {}

local JS_CallbackHack = [[(function(){
  var funcname = '%s';
  window[funcname] = function(){
    _gm[funcname].apply(_gm,arguments);
  }
})();]]

local ConsoleColors = {
  ["default"] = Color(255,160,255),
  ["text"] = Color(255,255,255),
  ["error"] = Color(235,57,65),
  ["warn"] = Color(227,181,23),
  ["info"] = Color(100,173,229),
}

local FilterCVar = CreateClientConVar( "playx_html_filter", 0, true, false )

local FILTER_ALL = 0
local FILTER_NONE = 1

AccessorFunc( PANEL, "m_bScrollbars",       "Scrollbars",     FORCE_BOOL )
AccessorFunc( PANEL, "m_bAllowLua",       "AllowLua",     FORCE_BOOL )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

  self.History = {}
  self.CurrentPage = 0

  self.URL = ""

  self:SetScrollbars( true )

  self.JS = {}
  self.Callbacks = {}

  --
  -- Implement a console - because awesomium doesn't provide it for us anymore.
  --
  local console_funcs = {"log","error","debug","warn","info","gmod"}
  for _, func in pairs(console_funcs) do
    self:AddFunction( "console", func, function( param )
      self:ConsoleMessage( param, func )
    end )
  end

  self:AddFunction( "window", "open", function()
    -- prevents popups from opening
  end)

  self:AddFunction( "gmod", "clickSound", function( click )
    if click then
      surface.PlaySound("garrysmod/ui_click.wav")
    else
      surface.PlaySound("garrysmod/ui_hover.wav")
    end
  end )

  self:AddFunction("gmod", "requestUrl", function(url)
    RequestVideoURL(url)
  end)

  self:AddFunction("gmod", "openUrl", function(url)
    if not isstring(url) then return end
    gui.OpenURL(url)
  end)

end

function PANEL:SetupCallbacks()

end

function PANEL:Think()

  -- Poll page for URL change
  if not self._nextUrlPoll or self._nextUrlPoll < RealTime() then
    self:FetchPageURL()
    self._nextUrlPoll = RealTime() + 1
  end

  if self:IsLoading() then

    -- Call started loading
    if not self._loading then

      self:FetchPageURL()

      -- Delay setting up callbacks
      timer.Simple( 0.05, function()
        if IsValid( self ) then
          self:SetupCallbacks()
        end
      end )

      self._loading = true
      self:OnStartLoading()

    end

  else

    -- Call finished loading
    if self._loading then

      self:FetchPageURL()

      -- Hack to add window object callbacks
      if self.Callbacks.window then

        for funcname, callback in pairs(self.Callbacks.window) do
          local js = JS_CallbackHack:format(funcname)
          self:RunJavascript(js)
        end

      end

      self._loading = nil
      self:OnFinishLoading()

    end

    -- Run queued javascript
    if self.JS then
      for k, v in pairs( self.JS ) do
        self:RunJavascript( v )
      end
      self.JS = nil
    end

  end

end

function PANEL:FetchPageURL()
  local js = "console.log(\"GETURL:\" + window.location.href )"
  self:RunJavascript(js)
end

function PANEL:OpenURL( url, ignoreHistory )

  if not ignoreHistory then
    -- Pop URLs from the stack
    while #self.History ~= self.CurrentPage do
      table.remove( self.History )
    end
    table.insert( self.History, url )
    self.CurrentPage = self.CurrentPage + 1
  end

  self:SetURL( url )

  BaseClass.OpenURL( self, url )

end

function PANEL:GetURL()
  return self.URL
end

function PANEL:SetURL( url )
  local current = self.URL

  if current ~= url then
    self:OnURLChanged( url, current )
  end

  self.URL = url
end

function PANEL:OnURLChanged( new, old )

end

--[[---------------------------------------------------------
  Window loading events
-----------------------------------------------------------]]

--
-- Called when the page begins loading
--
function PANEL:OnStartLoading()

end

--
-- Called when the page finishes loading all assets
--
function PANEL:OnFinishLoading()

end

function PANEL:QueueJavascript( js )

  --
  -- Can skip using the queue if there's nothing else in it
  --
  if ( not self.JS and not self:IsLoading() ) then
    return self:RunJavascript( js )
  end

  self.JS = self.JS or {}

  table.insert( self.JS, js )
  self:Think();

end

PANEL.QueueJavaScript = PANEL.QueueJavascript
PANEL.Call = PANEL.QueueJavascript

function PANEL:ConsoleMessage( msg, func )

  if ( not isstring( msg ) ) then msg = "*js variable*" end

  if msg:StartWith("GETURL:") then
    local url = string.sub(msg, 8)

    self:SetURL( url )
    return
  end

  -- Filter messages output to the console
  -- 'console.gmod' always gets output
  local filterLevel = FilterCVar:GetInt()
  if ( func ~= "gmod" and filterLevel == FILTER_ALL ) then return end

  local prefixColor = ConsoleColors.default
  local prefix = "[HTML"
  if func and func:len() > 0 and func ~= "log" then
    if ConsoleColors[func] then
      prefixColor = ConsoleColors[func]
    end
    prefix = prefix .. "::" .. func:upper()
  end
  prefix = prefix .. "] "

  MsgC( prefixColor, prefix )
  MsgC( ConsoleColors.text, msg, "\n" )

end

local JSObjects = {
  window  = "_gm",
  this  = "_gm",
  _gm = "window"
}

--
-- Called by the engine when a callback function is called
--
function PANEL:OnCallback( obj, func, args )

  -- Hack for adding window callbacks
  obj = JSObjects[obj] or obj

  if not self.Callbacks[ obj ] then return end

  --
  -- Use AddFunction to add functions to this.
  --
  local f = self.Callbacks[ obj ][ func ]

  if ( f ) then
    return f( unpack( args ) )
  end

end

--
-- Add a function to Javascript
--
function PANEL:AddFunction( obj, funcname, func )

  if obj == "this" then
    obj = "window"
  end

  --
  -- Create the `object` if it doesn't exist
  --
  if ( not self.Callbacks[ obj ] ) then
    self:NewObject( obj )
    self.Callbacks[ obj ] = {}
  end

  --
  -- This creates the function in javascript (which redirects to c++ which calls OnCallback here)
  --
  self:NewObjectCallback( JSObjects[obj] or obj, funcname )

  --
  -- Store the function so OnCallback can find it and call it
  --
  self.Callbacks[ obj ][ funcname ] = func;

end

function PANEL:OpeningURL( url )

end

function PANEL:FinishedURL( url )

end

derma.DefineControl( "PlayXHTML", "Extended DHTML control", PANEL, "Awesomium" )
