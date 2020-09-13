--@name Starstruck
--@client
--@includedir starstruck
--@includedir starstruck/modules
hostpath = "starstruck"
guestpath = "starstruck"
safestring = table.copy(string)
guestenv = {}
guestenv.love = {}
local function init()
	if
		hasPermission("file.exists") and
		hasPermission("file.read")
	then
		hook.remove("permissionrequest", "permission")
		hook.remove("render", "permission")
		require(hostpath.."/boot.lua")()
	else
		hook.add("render", "permission", function()
			render.setFont("DermaLarge")
			render.drawSimpleText(256, 256, "permission?", 1, 1)
		end)
		hook.add("permissionrequest", "permission", init)
		setupPermissionRequest({
			"file.exists",
			"file.read"
		}, "To read game data from sf_filedata/"..guestpath , true)
	end
end
init()
