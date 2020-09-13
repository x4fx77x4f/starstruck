local string = safestring
render.createRenderTarget("guest")
guestenv.love.window = {
	setTitle = function(title)
		title = string.gsub(title, "%z.*$", "")
		setName(title)
	end,
	setMode = function(w, h, c)
		assert(w <= 1024, "width must not be greater than 1024")
		assert(h <= 1024, "height must not be greater than 1024")
		w1, w2, w3, w4 = 0, 0, w/1024, h/1024
		if w > h then
			if w > 512 then
				h = (512/w)*h
				w = 512
			end
		else
			if h > 512 then
				w = (512/h)*w
				h = 512
			end
		end
		wx, wy, ww, wh = (512-w)/2, (512-h)/2, w, h
		return true
	end,
	isActive = function()
		return true
	end,
	isCreated = function()
		return true
	end,
	isOpen = function()
		return true
	end
}
