-- https://github.com/love2d/love/blob/master/src/scripts/boot.lua

local string = safestring

function guestenv.love.createhandlers()
	-- Standard callback handlers.
	guestenv.love.handlers = setmetatable({
		keypressed = function(b, s, r)
			if guestenv.love.keypressed then return guestenv.love.keypressed(b,s,r) end
		end,
		keyreleased = function(b, s)
			if guestenv.love.keyreleased then return guestenv.love.keyreleased(b,s) end
		end,
		textinput = function(t)
			if guestenv.love.textinput then return guestenv.love.textinput(t) end
		end,
		textedited = function(t, s, l)
			if guestenv.love.textedited then return guestenv.love.textedited(t,s,l) end
		end,
		mousemoved = function(x, y, dx, dy, t)
			if guestenv.love.mousemoved then return guestenv.love.mousemoved(x, y, dx, dy, t) end
		end,
		mousepressed = function(x, y, b, t, c)
			if guestenv.love.mousepressed then return guestenv.love.mousepressed(x, y, b, t, c) end
		end,
		mousereleased = function(x, y, b, t, c)
			if guestenv.love.mousereleased then return guestenv.love.mousereleased(x, y, b, t, c) end
		end,
		wheelmoved = function(x, y)
			if guestenv.love.wheelmoved then return guestenv.love.wheelmoved(x,y) end
		end,
		touchpressed = function(id, x, y, dx, dy, p)
			if guestenv.love.touchpressed then return guestenv.love.touchpressed(id, x, y, dx, dy, p) end
		end,
		touchreleased = function(id, x, y, dx, dy, p)
			if guestenv.love.touchreleased then return guestenv.love.touchreleased(id, x, y, dx, dy, p) end
		end,
		touchmoved = function(id, x, y, dx, dy, p)
			if guestenv.love.touchmoved then return guestenv.love.touchmoved(id, x, y, dx, dy, p) end
		end,
		joystickpressed = function(j, b)
			if guestenv.love.joystickpressed then return guestenv.love.joystickpressed(j, b) end
		end,
		joystickreleased = function(j, b)
			if guestenv.love.joystickreleased then return guestenv.love.joystickreleased(j, b) end
		end,
		joystickaxis = function(j, a, v)
			if guestenv.love.joystickaxis then return guestenv.love.joystickaxis(j, a, v) end
		end,
		joystickhat = function(j, h, v)
			if guestenv.love.joystickhat then return guestenv.love.joystickhat(j, h, v) end
		end,
		gamepadpressed = function(j, b)
			if guestenv.love.gamepadpressed then return guestenv.love.gamepadpressed(j, b) end
		end,
		gamepadreleased = function(j, b)
			if guestenv.love.gamepadreleased then return guestenv.love.gamepadreleased(j, b) end
		end,
		gamepadaxis = function(j, a, v)
			if guestenv.love.gamepadaxis then return guestenv.love.gamepadaxis(j, a, v) end
		end,
		joystickadded = function(j)
			if guestenv.love.joystickadded then return guestenv.love.joystickadded(j) end
		end,
		joystickremoved = function(j)
			if guestenv.love.joystickremoved then return guestenv.love.joystickremoved(j) end
		end,
		focus = function(f)
			if guestenv.love.focus then return guestenv.love.focus(f) end
		end,
		mousefocus = function(f)
			if guestenv.love.mousefocus then return guestenv.love.mousefocus(f) end
		end,
		visible = function(v)
			if guestenv.love.visible then return guestenv.love.visible(v) end
		end,
		quit = function()
			return
		end,
		threaderror = function(t, err)
			if guestenv.love.threaderror then return guestenv.love.threaderror(t, err) end
		end,
		resize = function(w, h)
			if guestenv.love.resize then return guestenv.love.resize(w, h) end
		end,
		filedropped = function(f)
			if guestenv.love.filedropped then return guestenv.love.filedropped(f) end
		end,
		directorydropped = function(dir)
			if guestenv.love.directorydropped then return guestenv.love.directorydropped(dir) end
		end,
		lowmemory = function()
			if guestenv.love.lowmemory then guestenv.love.lowmemory() end
		end,
		displayrotated = function(display, orient)
			if guestenv.love.displayrotated then return guestenv.love.displayrotated(display, orient) end
		end
	}, {
		__index = function(self, name)
			error("Unknown event: "..name)
		end
	})
end

function guestenv.love.boot() end

function guestenv.love.init()
	local c = {
		title = "Untitled",
		version = guestenv.love._version,
		window = {
			width = 800,
			height = 600,
			x = nil,
			y = nil,
			minwidth = 1,
			minheight = 1,
			fullscreen = false,
			fullscreentype = "desktop",
			display = 1,
			vsync = 1,
			msaa = 0,
			borderless = false,
			resizable = false,
			centered = true,
			highdpi = false,
			usedpiscale = true
		},
		modules = {
			data = true,
			event = true,
			keyboard = true,
			mouse = true,
			timer = true,
			joystick = true,
			touch = true,
			image = true,
			graphics = true,
			audio = true,
			math = true,
			physics = true,
			sound = true,
			system = true,
			font = true,
			thread = true,
			window = true,
			video = true
		},
		audio = {
			mixwithsystem = true, -- Only relevant for Android / iOS.
			mic = false -- Only relevant for Android.
		},
		console = false, -- Only relevant for Windows.
		identity = false,
		appendidentity = false,
		externalstorage = false, -- Only relevant for Android.
		accelerometerjoystick = true, -- Only relevant for Android / iOS.
		gammacorrect = false
	}
	require(hostpath.."/modules/builtins.lua")
	-- If love.conf errors, we'll trigger the error after loading modules so
	-- the error message can be displayed in the window.
	local confpath = guestpath.."/conf.lua"
	if file.exists(confpath) then
		conf = loadstring(assert(file.read(confpath), "failed to open conf.lua"))
		if type(conf) == "function" then
			setfenv(conf, guestenv)
			confok, conferr = pcall(conf)
			if confok then
				confok, confer = pcall(guestenv.love.conf, c)
				if not confok then
					conferr = conferr.message
				end
			else
				conferr = conferr.message
			end
		else
			conferr = conf
		end
	else
		confok = true
	end
	for k, v in ipairs({
		--"data",
		--"thread",
		"timer",
		"event",
		--"keyboard",
		--"joystick",
		--"mouse",
		--"touch",
		--"sound",
		--"system",
		--"audio",
		--"image",
		--"video",
		--"font",
		"window",
		"graphics",
		--"math",
		--"physics"
	}) do
		if c.modules[v] then
			require(hostpath.."/modules/"..v..".lua")
		end
	end
	assert(confok, conferr)
	if guestenv.love.event then
		guestenv.love.createhandlers()
	end
	if c.window and c.modules.window then
		guestenv.love.window.setTitle(c.window.title or c.title or "Untitled")
		assert(guestenv.love.window.setMode(c.window.width, c.window.height, {
			fullscreen = c.window.fullscreen,
			fullscreentype = c.window.fullscreentype,
			vsync = c.window.vsync,
			msaa = c.window.msaa,
			stencil = c.window.stencil,
			depth = c.window.depth,
			resizable = c.window.resizable,
			minwidth = c.window.minwidth,
			minheight = c.window.minheight,
			borderless = c.window.borderless,
			centered = c.window.centered,
			display = c.window.display,
			highdpi = c.window.highdpi,
			usedpiscale = c.window.usedpiscale,
			x = c.window.x,
			y = c.window.y
		}), "Could not set window mode")
	end
	if guestenv.love.timer then
		guestenv.love.timer.step()
	end
	local path = guestpath.."/main.lua"
	if not file.exists(path) then
		errhand(
			"No code to run\n"..
			"Your game might be packaged incorrectly.\n"..
			"Make sure main.lua is at the top level of the zip."
		)
		return
	end
	local func = loadstring(file.read(path), "main.lua")
	if type(func) == "function" then
		setfenv(func, guestenv)
		local thread = coroutine.create(function()
			func()
			guestenv.love.run()
		end)
		xpcall(coroutine.resume, errhand, thread)
	else
		errhand(func)
	end
end

function guestenv.love.run()
	if guestenv.love.load then
		guestenv.love.load()
	end
	if guestenv.love.timer then
		guestenv.love.timer.step()
	end
	local dt = 0
	local bg = Color(0, 0, 0)
	local thread = coroutine.create(function()
		while true do
			if guestenv.love.event then
				guestenv.love.event.pump()
			end
			if guestenv.love.timer then
				dt = guestenv.love.timer.step()
			end
			if guestenv.love.update then
				guestenv.love.update(dt)
			end
			if guestenv.love.graphics and guestenv.love.graphics.isActive() then
				render.setBackgroundColor(bg)
				render.selectRenderTarget("guest")
				guestenv.love.graphics.origin()
				guestenv.love.graphics.clear(guestenv.love.graphics.getBackgroundColor())
				guestenv.love.graphics.setFont(guestenv.love.graphics.getFont())
				render.setRGBA(255, 255, 255, 255)
				if guestenv.love.draw then
					guestenv.love.draw()
				end
				guestenv.love.graphics.present()
			end
			if errored then
				return
			end
			coroutine.yield()
		end
	end)
	hook.add("render", "guest", function()
		return xpcall(coroutine.resume, errhand, thread)
	end)
end

function errhand(msg)
	if type(msg) == "table" then
		msg = msg.message
	end
	guestenv.love.errhand(msg)
end

function guestenv.love.errhand(msg)
	msg = tostring(msg)
	print("Error: "..msg)
	if
		not guestenv.love.window or
		not guestenv.love.graphics or
		not guestenv.love.event
	then
		return
	end
	if not guestenv.love.graphics.isCreated() or not guestenv.love.window.isOpen() then
		local success, status = pcall(guestenv.love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
	local font = render.createFont("Verdana", 14)
	local trace = debugTraceback()
	local sanitizedmsg = {}
	for char in string.gmatch(msg, "[%z\x01-\x7f\xc2-\xf4][\x80-\xbf]*") do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
	local err = {}
	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
	table.insert(err, "\n")
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
	local p = table.concat(err, "\n")
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
	local bg = Color(80, 157, 220, 255)
	local pos = 70
	local markup = render.parseMarkup(p, ww-pos)
	hook.remove("render", "guest")
	hook.add("render", "guest", function()
		render.selectRenderTarget("guest")
		render.clear(bg, true)
		render.setRGBA(255, 255, 255, 255)
		markup:draw(pos, pos)
		present()
	end)
end

return function()
	guestenv.love.boot()
	guestenv.love.init()
end
