-- PlayX
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
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

PlayX.QueueWindow = nil
PlayX.Queue = {}

local QueueWindow = nil
local advancedView = false

function PlayX.DeleteItemFromQueue(line)
    local id = line:GetValue(1)
    
    Derma_Query("Are you sure you want to delete '" .. id .. "'?",
                "Delete Item",
                "Yes", function()
                    local Queue = PlayX.GetItemFromQueue(id)
                    if Queue then
                        Queue:Delete()
                        PlayX.SaveQueue()
                    end
                end,
                "No", function() end)
end

local function IsTrue(s)
    local s = s:lower():Trim()
    return s == "t" or s == "true" or s == "1" or s == "y" or s == "yes"
end

local Queue = {}

function Queue:add(id, title, uri)
    local instance = {
    	["ID"] = id,
        ["Title"] = title,
        ["URI"] = uri,
        ["Deleted"] = false,
    }
    
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Queue:Update(id, title, uri)
    if self.Deleted then
        Error("Operation performed on deleted item")    
    end
    
    local id = tonumber(id)
    local title = title:Trim()
    local uri = uri:Trim()
    
    if id == 0 then
        return false, "A id is required."
    end
    
    if title == "" then
        return false, "A title is required."
    end
    
    if uri == "" then
        return false, "A URI is required."
    end
    
    for _, item in ipairs(PlayX.Queue) do
        if id > 0 and id == item.ID and
            self.Queue:lower() ~= item.Title:lower() then
            return false, "An existing, different entry already has the id '" .. id .. "'."
        end
    end
    
    local oldTitle = self.Title
    
    self.ID = id
    self.Title = title
    self.URI = uri
    
    -- Update the panel
    if PlayX._QueuePanel then
        local Queue = PlayX._QueuePanelList
        for _, line in pairs(Queue:GetLines()) do
           if line:GetValue(1) == oldTitle then
           		line:SetValue(1, id)
                line:SetValue(1, title)
                line:SetValue(2, uri)
                if uri ~= "" then
                    line:SetTooltip("URI: " .. uri)
                else
                    line:SetTooltip(false)
                end
                break
           end
        end
    end
    
    -- Update the window
    if QueueWindow then
        local Queue = QueueWindow
        for _, line in pairs(Queue:GetLines()) do
           if line:GetValue(2):lower() == oldTitle:lower() then
                line:SetValue(1, id)
                line:SetValue(2, title)
                line:SetValue(3, uri)
                break
           end
        end
    end
    
    return true
end

function Queue:DeleteItem()
    self.Deleted = true
    
    for i, item in ipairs(PlayX.Queue) do
        if item == self then
            table.remove(PlayX.Queue, i)
                        
            -- Now let's update the panel
            if PlayX._QueuePanel then
                local Queue = PlayX._QueuePanel
                for _, line in pairs(Queue:GetLines()) do
                   if line:GetValue(1) == self.ID then
                        Queue:RemoveLine(line:GetID())
                        break
                   end
                end
            end
            
            -- Now let's update the window
            if QueueWindow then
                local Queue = QueueWindow
                for _, line in pairs(Queue:GetLines()) do
                   if line:GetValue(1) == self.ID then
                        Queue:RemoveLine(line:GetID())
                        break
                   end
                end
            end
            
            return true
        end
    end
    
    return false
end

function Queue:PlayItem()
    if self.Deleted then
        Error("Operation performed on deleted item")    
    end
    
    PlayX.NavigatorCapturedURL = ""
    
    RunConsoleCommand("playx_open", self.URI, "", 0)
end

function Queue:CopyToPanel()
    if self.Deleted then
        Error("Operation performed on deleted item")    
    end
    
    RunConsoleCommand("playx_provider", "")
    RunConsoleCommand("playx_uri", self.URI)
    RunConsoleCommand("playx_start_time", 0)
    RunConsoleCommand("playx_force_low_framerate", 0)
end


function PlayX.AddItemToQueue(id, title, uri)
    local id = tonumber(id)
    local title = title:Trim()
    local uri = uri:Trim()
    
    if id == 0 then
        return false, "A id is required."
    end   
    if title == "" then
        return false, "A title is required."
    end
    if uri == "" then
        return false, "A URI is required."
    end
    
    for _, item in pairs(PlayX.Queue) do
        if id > 0 and id == item.ID then
            return false, "An existing entry already has the id '" .. id .. "'."
        end
        if title:lower() == item.Title:lower() then
            return false, "An existing entry already has the title '" .. title .. "'."
        end
    end
    
    local item = Queue:add(id, title, uri)
    table.insert(PlayX.Queue, item)
    
    -- Let's update the bookmarks panel
    if PlayX._QueuePanel then
        local Queue = PlayX._QueuePanel
        local line = Queue:AddLine(id, title)
        if uri ~= "" then
            line:SetTooltip("URI: " .. uri)
        end
    end
    
    -- Let's update the bookmarks window
    if QueueWindow then
        local Queue = QueueWindow
        Queue:AddLine(id, title, uri)
    end
    
    return true
end

function PlayX.GetItemFromQueue(id)
    for i, item in pairs(PlayX.Queue) do
        if id == item.ID then
            return item
        end
    end
    
    return nil
end

function PlayX.GetItemFromQueueByURI(uri)
    if uri:Trim() == "" then return end
    
    for i, item in pairs(PlayX.Queue) do
        if uri:lower():Trim() == item.URI:lower():Trim() then
            return item
        end
    end
    
    return nil
end

function PlayX.OpenQueueWindow(id)
    if PlayX.QueueWindow and PlayX.QueueWindow:IsValid() then
        return
    end
    
    local Queue = nil
    
    local frame = vgui.Create("DFrame")
    PlayX.QueueWindow = frame
    frame:SetTitle("PlayX Queue")
    frame:SetDeleteOnClose(true)
    frame:SetScreenLock(true)
    frame:SetSize(math.min(600, ScrW() - 20), ScrH() * 4/5)
    frame:SetSizable(true)
    frame:Center()
    frame:MakePopup()
    
    -- ID input
    local IDLabel = vgui.Create("DLabel", frame)
    IDLabel:SetText("ID:")
    IDLabel:SetWide(50)
    local IDInput = vgui.Create("DTextEntry", frame)
    IDInput:SetWide(50)
    
    -- Title input
    local titleLabel = vgui.Create("DLabel", frame)
    titleLabel:SetText("Title:")
    titleLabel:SetWide(200)
    local titleInput = vgui.Create("DTextEntry", frame)
    titleInput:SetWide(250)
    
    -- URI input
    local uriLabel = vgui.Create("DLabel", frame)
    uriLabel:SetText("URI:")
    uriLabel:SetWide(200)
    local uriInput = vgui.Create("DTextEntry", frame)
    uriInput:SetWide(250)
    
    -- Advanced link
    surface.SetFont("Default")
    local w, h = surface.GetTextSize("<< Advanced")
    local advancedLink = vgui.Create("DButton", frame)
    advancedLink:SetText("")
    advancedLink:SetTall(20)
    advancedLink:SetWide(w + 5)
    advancedLink:SetTooltip("Show advanced bookmark settings")
    advancedLink:SetCursor("hand")
    advancedLink.DoClick = function()
        advancedView = not advancedView
        frame:InvalidateLayout(true, true)
    end
    advancedLink.Paint = function()
        local textStyleColor = advancedLink:GetTextStyleColor()
        local text = asdvancedView and "<< Advanced" or "Advanced >>"
        surface.SetFont("Default")
        surface.SetDrawColor(textStyleColor)
        surface.SetTextColor(textStyleColor)
        surface.SetTextPos(0, 0) 
        local w, h = surface.GetTextSize(text)
        surface.DrawText(text)
        surface.DrawLine(0, h, w, h)
    end
    
    -- Update button
    local updateButton = vgui.Create("DButton", frame)
    updateButton:SetText("Update")
    updateButton:SetWide(80)
    updateButton:SetTooltip("Update the selected entry with these values")
    updateButton.DoClick = function()
        local oldID = ""
        local line = nil
        
        if Queue:GetSelectedLine() then
            line = Queue:GetLine(Queue:GetSelectedLine())
            oldID = line:GetValue(1)
        else
            Derma_Message("An item is not selected.", "Error", "OK")
            return
        end
         
        local ID = tonumber(IDInput:GetValue())   
        local title = titleInput:GetValue():Trim()        
        local uri = uriInput:GetValue():Trim()        
        
        local item = PlayX.GetItemFromQueue(oldID)
        
        if not item then
            Derma_Message("The selected item does not exist.", "Error", "OK")
            return
        end
        
        local result, err = item:Update(id, title, uri)
        if not result then
            Derma_Message(err, "Error", "OK")
            return
        end
    end
    
    -- Add button
    local addButton = vgui.Create("DButton", frame)
    addButton:SetText("Add")
    addButton:SetWide(80)
    addButton:SetTooltip("Add a new entry with these values")
    addButton.DoClick = function()
    	local ID = IDInput:GetValue():Trim()
        local title = titleInput:GetValue():Trim()        
        local uri = uriInput:GetValue():Trim()
        
        local result, err = PlayX.AddItemToQueue(id, title, uri)
        if result then
        	IDInput:SetValue(0)
	        titleInput:SetValue("")
	        uriInput:SetValue("")
        else
            Derma_Message(err, "Error", "OK")
        end
    end
    
    -- Clear button
    local clearButton = vgui.Create("DButton", frame)
    clearButton:SetText("Clear")
    clearButton:SetWide(80)
    clearButton:SetTooltip("Clear the form")
    clearButton.DoClick = function()
    	IDInput:SetValue(0)
        titleInput:SetValue("")
        uriInput:SetValue("")
    end
    
    -- Delete button
    local deleteButton = vgui.Create("DButton", frame)
    deleteButton:SetText("Delete...")
    deleteButton:SetWide(80)
    deleteButton:SetTooltip("Delete the selected entry (after confirmation)")
    deleteButton.DoClick = function()
        if Queue:GetSelectedLine() then
            -- GetSelected() not working
            PlayX.DeleteItemFromQueue(Queue:GetLine(Queue:GetSelectedLine()))
        else
            Derma_Message("An item is not selected.", "Error", "OK")
        end
    end
    
    -- Close button
    local closeButton = vgui.Create("DButton", frame)
    closeButton:SetText("Close")
    closeButton:SetWide(80)
    closeButton.DoClick = function()
        frame:Close()
    end
    
    -- Make list view
    Queue = vgui.Create("DListView", frame)
    QueueWindow = Queue
    Queue:SetMultiSelect(false)
    Queue:AddColumn("ID")
    Queue:AddColumn("Title")
    Queue:AddColumn("URI")
        
    for k, item in pairs(PlayX.Queue) do
         Queue:AddLine(item.ID, item.Title,item.URI)
    end
    
    Queue.OnRowSelected = function(lst, index)
        local line = lst:GetLine(index)
        local item = PlayX.GetItemFromQueue(line:GetValue(1))
        IDInput:SetValue(item.ID)
        titleInput:SetValue(item.Title)
        uriInput:SetValue(item.URI)
    end
    
    Queue.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Open", function()
	        PlayX.GetItemFromQueue(line:GetValue(1):Trim()):PlayItem()
            frame:Close()
        end)
        menu:AddOption("Delete...", function()
            PlayX.DeleteItemFromQueue(line)
        end)
        menu:AddOption("Copy URI", function()
            SetClipboardText(line:GetValue(2))
        end)
        menu:AddOption("Copy to 'Administrate'", function()
            PlayX.GetItemFromQueue(line:GetValue(1):Trim()):CopyToPanel()
            frame:Close()
        end)
        menu:Open() 
    end
    
    Queue.DoDoubleClick = function(lst, index, line)
        if not line then return end
        PlayX.GetItemFromQueue(line:GetValue(1):Trim()):PlayItem()
        frame:Close()
    end
    
    if id then
        for _, line in pairs(Queue:GetLines()) do
           if line:GetValue(1) == id then
                Queue:SelectItem(line)
                break
           end
        end
    end
    
    -- Layout
    local oldPerform = frame.PerformLayout
    frame.PerformLayout = function()
        oldPerform(frame)
        Queue:StretchToParent(10, 28, 10, advancedView and 160 or 110)
        
        IDLabel:SetPos(10, Queue:GetTall() + 35)
        IDInput:SetPos(70, Queue:GetTall() + 35)
        
        titleLabel:SetPos(10, Queue:GetTall() + 35)
        titleInput:SetPos(70, Queue:GetTall() + 35)
        
        uriLabel:SetPos(10, Queue:GetTall() + 35 + 23)
        uriInput:SetPos(70, Queue:GetTall() + 35 + 23)
        uriInput:SetWide(frame:GetWide() - 300)
        
        advancedLink:SetPos(10, Queue:GetTall() + 20 + 35 + 27)
        

        
        updateButton:SetPos(10, frame:GetTall() - 32)
        addButton:SetPos(3 + updateButton:GetWide() + 10,
                         frame:GetTall() - 32)
        clearButton:SetPos(3 + updateButton:GetWide() + addButton:GetWide() + 30,
                           frame:GetTall() - 32)
        deleteButton:SetPos(3 + updateButton:GetWide() + addButton:GetWide() + clearButton:GetWide() + 33,
                            frame:GetTall() - 32)
        closeButton:SetPos(frame:GetWide() - closeButton:GetWide() - 10,
                            frame:GetTall() - 32)
    end
    
    frame:InvalidateLayout(true, true)
end
