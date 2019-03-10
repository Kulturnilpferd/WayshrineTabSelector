WayshrineTabSelector = {}
WayshrineTabSelector.variableVersion = 2 
WayshrineTabSelector.Default = {
	DropdownMenuIndex = "Quests"
}

local _events = {}

local function GetUniqueEventId(id)
    local count = _events[id] or 0
    count = count + 1
    _events[id] = count
    return count
end

local function GetEventName(id)
    return table.concat({ "WayshrineTabSelector_", tostring(id), "_", tostring(GetUniqueEventId(id)) })
end

local function addEvent(id, func)
    local name = GetEventName(id)
    EVENT_MANAGER:RegisterForEvent(name, id, func)
end

local function init(func, ...)
    local arg = { ... }
    addEvent(EVENT_ADD_ON_LOADED, function(eventCode, addOnName)
	if (addOnName ~= "WayshrineTabSelector") then
	    return
	end
	func(unpack(arg))
    end)
end

local panelData = {
    type = "panel",
    name = "Wayshrine Tab Selector",
    displayName = "Wayshrine Tab Selector",
    author = "Kulturnilpferd",
    version = "1.0",
    slashCommand = "/wayshrinetabselector",	
    registerForRefresh = true,	
    registerForDefaults = true,
}

local optionsTable = {
    [1] = {
        type = "header",
        name = "",
        width = "full",
    },
    [2] = {
        type = "description",
        title = nil,
        text = "Choose a custom default tab on wayshrine menu",
        width = "full",
    },
    [3] = {
        type = "dropdown",
        name = "Default Wayshrine Tab",
        choices = {"Quests", "Key", "Filters", "Locations", "Houses"},
        getFunc = function() 
			return WayshrineTabSelector.savedVariables.DropdownMenuIndex end,
        setFunc = function(var)
			WayshrineTabSelector.savedVariables.DropdownMenuIndex = var	
			end,
        width = "half",
    },
}

local LAM = LibStub("LibAddonMenu-2.0")

init(function()
	local function StartFastTravelInteract()
		if WayshrineTabSelector.savedVariables.DropdownMenuIndex == "Quests" then
			WORLD_MAP_INFO:SelectTab(SI_MAP_INFO_MODE_QUESTS)
		elseif WayshrineTabSelector.savedVariables.DropdownMenuIndex == "Key" then
			WORLD_MAP_INFO:SelectTab(SI_MAP_INFO_MODE_KEY)
		elseif WayshrineTabSelector.savedVariables.DropdownMenuIndex == "Filters" then
			WORLD_MAP_INFO:SelectTab(SI_MAP_INFO_MODE_FILTERS)
		elseif WayshrineTabSelector.savedVariables.DropdownMenuIndex == "Locations" then
			WORLD_MAP_INFO:SelectTab(SI_MAP_INFO_MODE_LOCATIONS)
		elseif WayshrineTabSelector.savedVariables.DropdownMenuIndex == "Houses" then
			WORLD_MAP_INFO:SelectTab(SI_MAP_INFO_MODE_HOUSES)
		end		
	end
	
	--local function EndFastTravelInteract()
		--if SI_MAP_INFO_MODE_QUESTS:IsActive then
		--	d("1")
		--end
		--if SI_MAP_INFO_MODE_KEY:IsVisible() then
		--	d("2")
		--end
	--end
	
	addEvent(EVENT_START_FAST_TRAVEL_INTERACTION, function()
		StartFastTravelInteract()
    end)

    addEvent(EVENT_START_FAST_TRAVEL_KEEP_INTERACTION, function()
		StartFastTravelInteract()
    end)
	
	--addEvent(EVENT_END_FAST_TRAVEL_INTERACTION, function()
	--EndFastTravelInteract()
    --end)
	
	WayshrineTabSelector.savedVariables = ZO_SavedVars:NewAccountWide("WayshrineTabSelectorDB", WayshrineTabSelector.variableVersion, nil, WayshrineTabSelector.Default)
	LAM:RegisterAddonPanel("MyAddon", panelData)
	LAM:RegisterOptionControls("MyAddon", optionsTable)
end)