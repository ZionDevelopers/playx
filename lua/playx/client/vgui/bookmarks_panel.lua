--[[------------------------------------------------------------------------------------------------------------------
Bookmarks Sheet -- Draw the control panel.
--------------------------------------------------------------------------------------------------------------------]]
function PlayXGUI.BookmarksPanel(panel)
    panel:DockMargin(20,20,20,20)

    local bookmarks = vgui.Create("DListView",panel)
    PlayX._BookmarksPanelList = bookmarks
    bookmarks:Dock(FILL)
    bookmarks:SetMultiSelect(false)
    bookmarks:AddColumn("Title")
    bookmarks:AddColumn("URI")
    bookmarks:SetTall(panel:GetTall() * 0.75)
    
    for k, bookmark in pairs(PlayX.Bookmarks) do
        local line = bookmarks:AddLine(bookmark.Title, bookmark.URI)
        if bookmark.Keyword ~= "" then
            line:SetTooltip("Keyword: " .. bookmark.Keyword)
        end
    end
    
    bookmarks.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Open", function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
        end)
        menu:AddOption("Edit...", function()
            PlayX.OpenBookmarksWindow(line:GetValue(1))
        end)
		
		menu:AddOption("Delete...", function()
           	PlayX.BookmarkDelete(line)
        end)

        menu:AddOption("Copy URI", function()
            SetClipboardText(line:GetValue(2))

        end)
        menu:AddOption("Copy to 'Administrate'", function()
            PlayX.GetBookmark(line:GetValue(1):Trim()):CopyToPanel()
        end)
        menu:Open()
    end
    
    bookmarks.DoDoubleClick = function(lst, index, line)
        if not line then return end
        PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
    end
    
    local button = vgui.Create("DButton",panel)
    button:SetText("Open Selected")
    button:Dock(BOTTOM)
    button.DoClick = function()
        if bookmarks:GetSelectedLine() then
            local line = bookmarks:GetLine(bookmarks:GetSelectedLine())
            PlayX.GetBookmark(line:GetValue(1):Trim()):Play()
	    else
            Derma_Message("You didn't select an entry.", "Error", "OK")
	    end
    end
    
    local button = vgui.Create("DButton",panel)
    button:SetText("Manage Bookmarks...")
    button:Dock(BOTTOM)
    button.DoClick = function()
        PlayX.OpenBookmarksWindow()
    end
end
