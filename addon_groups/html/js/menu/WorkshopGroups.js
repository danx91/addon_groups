//Created by danx91

//Constructor
function WorkshopGroups(){

}

/*
group struct
{
	id: 0,
	name: "name",
	enabled: false,
	elements: 0
}
*/

//Initialize
WorkshopGroups.prototype.Init = function(scope){
	var self = this;
	this.Scope = scope;

	this.Scope.Groups = [];
	this.Scope.SelectedGroups = {};
	this.Scope.ShowGroups = false;
	this.Scope.GroupsLoading = true;

	this.Scope.ActiveGroupsPage = 1;
	this.Scope.GroupsOffset = 0;

	this.Scope.GroupNameText = "";

	this.TotalGroups = 0;

	if (!IN_ENGINE){
		setTimeout(function(){
			WorkshopTestGroups(self);
		}, 0);
	}

	this.Scope.SetShowGroups = function(showgroups){
		scope.ShowGroups = showgroups;

		if(showgroups == true)
			self.Refresh();
	}

	this.Scope.AnyGroup = function(){
		for(var k in scope.SelectedGroups)
			if(scope.SelectedGroups[k] == true)
				return true;
		return false;
	}

	this.Scope.DisableAllGroups = function(){
		lua.Run("addongroups.DisableAll();");
	}

	this.Scope.EnableAllGroups = function(){
		lua.Run("addongroups.EnableAll();");
	}

	this.Scope.RemoveAllGroups = function(){
		lua.Run("addongroups.RemoveAll();");
	}

	this.Scope.DisableSelectedGroups = function(){
		for(var k in scope.SelectedGroups){
			if(!scope.SelectedGroups[k]) continue;
			lua.Run("addongroups.SetEnabled( %s, false );", String(k));
			scope.Groups[k - 1].enabled = false;
			scope.SelectedGroups[k] = false;
		}
	}

	this.Scope.EnableSelectedGroups = function(){
		for(var k in scope.SelectedGroups){
			if(!scope.SelectedGroups[k]) continue;
			lua.Run("addongroups.SetEnabled( %s, true );", String(k));
			scope.Groups[k - 1].enabled = true;
			scope.SelectedGroups[k] = false;
		}
	}

	this.Scope.RemoveSelectedGroups = function(){
		for(var k in scope.SelectedGroups){
			if(!scope.SelectedGroups[k]) continue;
			lua.Run("addongroups.Remove( %s );", String(k));
			scope.SelectedGroups[k] = false;
		}

		self.Refresh();
		self.SaveGroups();
	}

	this.Scope.SetGroupEnabled = function(group, enabled){
		lua.Run("addongroups.SetEnabled( %s, %s );", String(group.id), String(enabled));
		group.enabled = enabled

		self.SaveGroups();
	}

	this.Scope.UnselectAllGroups = function(){
		for(var k in scope.SelectedGroups)
			scope.SelectedGroups[k] = false;
	}

	this.Scope.SelectedToGroup = function(){
		for(var k in scope.SelectedItems){
			if (!scope.SelectedItems[k]) continue;
			lua.Run("addongroups.AddAddon( %s, %s );", String( scope.GroupNameText ), String( k ));
			scope.SelectedItems[k] = false;
		}

		self.SaveGroups();
	}

	this.Scope.RemoveFromGroup = function(){
		for(var k in scope.SelectedItems){
			if (!scope.SelectedItems[k] ) continue;
			lua.Run("addongroups.RemoveAddon( %s, %s );", String( scope.GroupNameText ), String( k ));
			scope.SelectedItems[k] = false;
		}

		self.SaveGroups();
	}

	this.Scope.NextGroupsPage = function(){
		if(scope.ActiveGroupsPage < scope.GroupsPages.length){
			scope.ActiveGroupsPage++;
			scope.GroupsOffset += scope.GroupsPerPage;
			self.Refresh();
		}
	}

	this.Scope.PrevGroupsPage = function(){
		if(scope.ActiveGroupsPage > 1){
			scope.ActiveGroupsPage--;
			scope.GroupsOffset -= scope.GroupsPerPage;
			self.Refresh();
		}
	}

	this.Scope.ToGroupsPage = function(p){
		if(scope.ActiveGroupsPage != p){
			var diff = p - scope.ActiveGroupsPage;
			scope.ActiveGroupsPage = p;
			scope.GroupsOffset -= diff * scope.GroupsPerPage;
			self.Refresh();
		}
	}

	this.CalculateSize();
	this.Refresh();
}

//Tell lua that we want refresh groups
WorkshopGroups.prototype.Refresh = function(){
	this.Scope.GroupsLoading = true;
	lua.Run("addongroups.RefreshGroups( %s, %s );", String(this.Scope.GroupsPerPage), String(this.Scope.GroupsOffset));
}

//Receive lua response
WorkshopGroups.prototype.Apply = function( groups, total ){
	this.Scope.GroupsLoading = false;

	this.Scope.Groups = groups;
	this.Scope.TotalGroups = total;

	var pages = Math.ceil(total / this.Scope.GroupsPerPage);

	this.Scope.GroupsPages = [];

	for(var i = 1; i <= pages; i++)
		this.Scope.GroupsPages.push(i);

	this.Scope.$digest();
}

//Calculate how many groups we can have per page
WorkshopGroups.prototype.CalculateSize = function(){
	var w = Math.max( 480, $( "workshopcontainer" ).width() );
	var h = Math.max( 320, $( "workshopcontainer" ).height() - 48 );

	var groupsx = Math.floor( w / 200 );
	var groupsy = Math.floor( h / 75 );

	if ( groupsx > 5 ) groupsx = 5;
	if ( groupsy > 8 ) groupsy = 8;

	this.Scope.GroupsPerPage = groupsx * groupsy;

	this.Scope.GroupWidth	= Math.floor( w / groupsx ) - 26;
	this.Scope.GroupHeight	= Math.floor( h / groupsy ) - 26;
}

//Tell lua to save groups
WorkshopGroups.prototype.SaveGroups = function(){
	lua.Run("addongroups.SaveGroups()");
}