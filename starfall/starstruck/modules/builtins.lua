local string = safestring

-- TODO: find a way to deal with starfall's custom error types.
guestenv.assert = assert
guestenv.error = error
guestenv.pcall = pcall
guestenv.xpcall = xpcall

guestenv.print = print
guestenv.type = type
guestenv.select = select
guestenv.unpack = unpack
guestenv.tostring = tostring
guestenv.tonumber = tonumber

guestenv.table = {
	concat = table.concat,
	foreach = table.forEach,
	foreachi = table.foreachi,
	getn = table.getn,
	insert = table.insert,
	maxn = table.maxn,
	remove = table.remove,
	sort = table.sort
}

-- String methods are unaffected because Starfall is fucking gay
local gueststring = {
	byte = string.byte,
	char = string.char,
	dump = string.dump,
	find = string.find,
	format = string.format,
	gfind = string.gfind,
	gmatch = string.gmatch,
	gsub = string.gsub,
	len = string.len,
	lower = string.lower,
	match = string.match,
	rep = string.rep,
	reverse = string.reverse,
	sub = string.sub,
	upper = string.upper
}
for k, v in pairs(_G.string) do
	_G.string[k] = nil
end
for k, v in pairs(gueststring) do
	_G.string[k] = v
end
guestenv.string = _G.string

guestenv.pairs = pairs
guestenv.ipairs = ipairs
guestenv.next = next

function guestenv.dofile(path)
	local data = file.read(guestpath.."/"..string.normalizePath(path))
	assert(data, "failed to read file "..path)
	local func = loadstring(data, path)
	assert(type(func) == "function", func)
	setfenv(func, guestenv)
	return func()
end
guestenv.package = {
	path = "./?.lua",
	cpath = "",
	preload = {}
}
function guestenv.require(path)
	if package.preload[path] then
		return package.preload[path]()
	end
	if path == "love" then
		return guestenv
	elseif path == "utf8" then
		return require(hostpath.."/modules/utf8.lua")
	end
	local module = path:match("^love%.(%w+)$")
	if module then
		module = module:lower()
		return require(hostpath.."/modules/"..module..".lua")
	end
	path = string.gsub(path, "%.", "/")
	local err =
		"module '"..path.."' not found:\n"..
		"\tno field package.preload['"..path.."']\n"..
		"\tno '"..path.."' in LOVE paths.\n"
	for location in string.gmatch(guestenv.package.path..";", "(.*);") do
		location = string.normalizePath(location)
		location = string.gsub(location, "?", path)
		local path = guestpath.."/"..location
		if file.exists(path) then
			local func = loadstring()
			return assert(type(func) == "function", func)()
		else
			err = err.."\tno file '"..path.."'\n"
		end
	end
	error(err:gsub("\n$", ""), 2)
end

-- ugly hack!!
function debugTraceback(message, level)
	local traceback
	xpcall("", function(a, b)
		traceback = b:gsub("^attempt to call a string value\n", "")
	end)
	return message and message.."\n"..traceback or traceback
end
guestenv.debug = {
	traceback = debugTraceback,
	getinfo = debugGetInfo
}
