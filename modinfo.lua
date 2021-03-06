-- This information tells other players more about the mod
name = "Ear Mod"
description = "Full of ear people"
author = "yellowmoleproductions"
version = "1.0"

-- This is the URL name of the mod's thread on the forum; the part after the index.php? and before the first & in the URL
-- Example:
-- http://forums.kleientertainment.com/index.php?/files/file/202-sample-mods/
-- becomes
-- /files/file/202-sample-mods/
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 6

---- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options ={
	{
	name = "fetch_ring",
	label = "Spawn ring nearby?",
	options =
	{
	{
	description = "Yes",
	data = true
	},
	{
	description = "No",
	data = false
	}		
	},
	default = "No",	},
	}