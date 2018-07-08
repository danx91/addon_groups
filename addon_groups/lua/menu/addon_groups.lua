--Addon groups by reated by danx91

--Some useful functions
local MainMenu = nil
local ExecuteJS = function( text )
	if !MainMenu or !MainMenu.HTML then
		MainMenu = pnlMainMenu
		if !MainMenu or !MainMenu.HTML then return false end
	end
	MainMenu.HTML:QueueJavascript( text )
	return true
end

local function ToBool( b )
	if b == 1 or b == "1" or b == true or b == "true" then
		return true
	end
	return false
end

--All groups are stored here
local groups = {}

--Temporary variables
local current_groups = {}
local current_offset = 0
local current_perpage = 0

--Modules are deprecated, this is table to hold everything in one place
addongroups = {}

--Called by JS to disable all groups
function addongroups.DisableAll()
	--print( "disable all" )
	for k, v in pairs( groups ) do
		v.enabled = false
		addongroups.SetGroupMount( v, false, true )
	end
	
	steamworks.ApplyAddons()
	addongroups.Update()
	addongroups.SaveGroups()
end

--Called by JS to enable all groups
function addongroups.EnableAll()
	--print( "enable all" )
	for k, v in pairs( groups ) do
		v.enabled = true
		addongroups.SetGroupMount( v, true, true )
	end
	
	steamworks.ApplyAddons()
	addongroups.Update()
	addongroups.SaveGroups()
end

--Called by JS to remove all groups
function addongroups.RemoveAll()
	--print( "remove all" )
	for k, v in pairs( groups ) do
		groups[k] = nil
	end
	current_offset = 0
	
	addongroups.Update()
	addongroups.SaveGroups()
end

--Called by JS to set group enabled/disabled
function addongroups.SetEnabled( id, enabled )
	id  = tonumber( id ) + current_offset
	--print( "setenabled", id, enabled )
	local group = groups[id]
	local enabled = ToBool( enabled )
	if group /*and group.enabled != enabled*/ then
		group.enabled = enabled
		addongroups.SetGroupMount( group, enabled )
	end
end

--Called by JS or lua to remove group
function addongroups.Remove( id )
	id  = tonumber( id ) + current_offset
	--print( "remove", id )
	table.remove( groups, id )
end

--Called by JS to add addon to group or create group if doesn't exist
function addongroups.AddAddon( group, addon )
	--print( "add addon", group, addon )
	local g = addongroups.FindByName( group )
	local isaddonmounted = steamworks.ShouldMountAddon( addon )
	if !g then
		g = {
			name = group,
			elements = { [addon] = true },
			enabled = isaddonmounted
		}
		table.insert( groups, g )
	else
		if !g.elements[addon] then
			g.elements[addon] = true
			g.enabled = g.enabled and isaddonmounted
		end
	end
end

--Called by JS to remove addon. This function will remove group if last addon has beed removed
function addongroups.RemoveAddon( group, addon )
	--print( "rmeove addon", group, addon )
	addon = tonumber( addon )
	local g, id = addongroups.FindByName( group )
	if g and g.elements[addon] then
		g.elements[addon] = nil
		
		if table.Count( g.elements ) == 0 then
			addongroups.Remove( id )
			addongroups.Update()
		else
			addongroups.Refresh( g )
		end
	end
end

--Checks whether group should be enabled or disabled
function addongroups.Refresh( group )
	--print( "refresh", group.name )
	for k, v in pairs( group.elements ) do
		if !steamworks.ShouldMountAddon( k ) then
			group.enabled = false
			return
		end
	end
	group.enabled = true
end

--Un/mounts addons in group
function addongroups.SetGroupMount( group, mount, noapply )
	for k, v in pairs( group.elements ) do
		steamworks.SetShouldMountAddon( k, mount )
	end
	
	if !noapply then
		steamworks.ApplyAddons()
	end
end

--Returns group and id if there is group with specified name, nil on fail
function addongroups.FindByName( name )
	if !name then return end
	for id, v in pairs( groups ) do
		if v.name == name then
			return v, id
		end
	end
end

--Called by JS to refresh all groups
function addongroups.RefreshGroups( amount, offset )
	--print( "refresh groups", amount, offset )
	current_perpage = amount
	current_offset = offset

	for k, v in pairs( groups ) do
		addongroups.Refresh( v )
	end
	
	addongroups.Update()
end

--Calculates which groups should be visible
function addongroups.Update()
		current_groups = {}

		for i = current_offset + 1, current_offset + current_perpage do
			local group = groups[i]
			if group then
				table.insert( current_groups, group )
			end
		end
	
	addongroups.Apply( current_groups, #groups )
end

--Output to JS
function addongroups.Apply( groups, total )
	local tab = "["
	for id, v in pairs( groups ) do
		tab = tab..string.format( "{id:%i,name:\"%s\",enabled:%s,elements:%i},", id, v.name, v.enabled and "true" or "false", table.Count( v.elements ) )
	end
	tab = tab.."]"
	
	--print( "apply", total, table.Count( groups ) )
	
	ExecuteJS( string.format( "groups.Apply( %s, %i )", tab, total ) )
end

--Loads groups
function addongroups.LoadGroups()
	local text = file.Read( "addon_groups.txt", "DATA" )
	if text then
		local groups_tmp = util.JSONToTable( text )
		if groups_tmp then
			groups = groups_tmp
		end
	end
end
addongroups.LoadGroups()

--Saves groups
function addongroups.SaveGroups()
	local json = util.TableToJSON( groups )
	if json then
		file.Write( "addon_groups.txt", json )
	end
end

--Language part
language.Add( "addons.groups", "Addon groups" )
language.Add( "addons.groups.subtitle", "Manage your addons" )

language.Add( "addons.selected_to_group", "Add selected to group" )
language.Add( "addons.remove_from_group", "Remove selected from group" )
language.Add( "addons.group_name", "Group name" )

language.Add( "addons.remove_from_group.warning", "You are about to remove selected addons from group, are you sure?" )

language.Add( "groups.enable_all", "Enable all groups" )
language.Add( "groups.disable_all", "Disable all groups" )
language.Add( "groups.remove_all", "Remove all groups" )

language.Add( "groups.enable_selected", "Enable selected groups" )
language.Add( "groups.disable_selected", "Disable selected groups" )
language.Add( "groups.remove_selected", "Remove selected groups" )
language.Add( "groups.unselectall", "Unselect all" )

language.Add( "groups.enable_all.warning", "You are about to enable all groups, are you sure?" )
language.Add( "groups.disable_all.warning", "You are about to disable all groups, are you sure?" )
language.Add( "groups.remove_all.warning", "You are about to remove all groups, are you sure?" )
language.Add( "groups.enable_selected.warning", "You are about to enable selected groups, are you sure?" )
language.Add( "groups.disable_selected.warning", "You are about to disable selected groups, are you sure?" )
language.Add( "groups.remove_selected.warning", "You are about to remove selected groups, are you sure?" )

language.Add( "groups.loading", "Loading groups..." )
language.Add( "groups.none", "You have no addon groups" )

language.Add( "groups.disable", "Disable" )
language.Add( "groups.enable", "Enable" )