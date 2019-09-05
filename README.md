# Addon Groups

## Outdated
Currently this addon will break saves and dupes in addons list.

## About
Addon Groups is addons management tool. This modification allows you to create addons groups and manage them. Addon Groups can simply enable or disable bunch of addons by one click.

## Installation
1. Turn off Garry's Mod
2. Click green button "Clone or download"
3. Click "Download ZIP"
4. Unzip "addon_groups.zip" and open "addon_groups" folder (you should see "html" and "lua" folders)
5. Go to your Garry's Mod folder (e.g. "C:\Program Files\Steam\steamapps\common\GarrysMod\garrysmod\")
6. Copy "html" and "lua" folders to Garry's Mod folder (windows should warn you about overwriting 6 files)
7. Launch Garry's Mod
8. If everything works, you should see "Addon groups" button in "Addons"

## Usage
#### Adding and removing addons to group
1. Go to 'Addons > Subscriptions' and select checkboxes on addons you want to add/remove
2. Type group name in "Group name" text box
3. Click "Add selected to group" or "Remove selected from group"

*(If you add addon to non existing group, new group will be created. If you remove last addon from group, this group will be removed)*

#### Removing groups
1. Go to 'Addons > Addon groups' and select checkboxes on groups you want to remove
2. Click "Remove selected groups" button

#### Removing all groups
1. Go to 'Addons > Addon groups'
2. Click "Remove all groups" button

#### Enabling and disabling one group
1. Go to 'Addons > Addon groups' and hover mouse on group you want to enable/disable
2. Click "Enable" or "Disable" button

#### Enabling and disabling groups
1. Go to 'Addons > Addon groups' and select checkboxes on groups you want to enable/disable
2. Click "Enable selected groups" or "Disable selected groups" button

#### Enabling and disabling all groups
1. Go to 'Addons > Addon groups'
2. Click "Enable all groups" or "Disable all groups" button

## Deinstallation
1. Turn off Garry's Mod
2. Go to your Garry's Mod folder (e.g. "C:\Program Files\Steam\steamapps\common\GarrysMod\garrysmod\")
3. Go to every path listed below and for each path do following instructions:\
  a) Look for "x" and "default_x" file pairs\
  b) Delete "x" file and rename "default_x" file to "x"
  
Paths:
- lua\menu\
- html\
- html\template\
- html\js\menu\

## Questions you may ask
Q: I can't see "Addon groups" button\
A: Make sure you did everything what I said in ***Installation*** section

Q: Why you didn't put this on workshop?\
A: Garry doesn't allow to upload ".html" and ".js" files to workshop because these files are *"dangerous"*. Also I couldn't find any way to add lua code to menu within addon.

Q: I found bug\
A: Click "Issues" button on the top of this page and create new issue

Q: Can I make pull request?\
A: Sure
