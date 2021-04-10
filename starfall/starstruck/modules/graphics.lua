local string = safestring

local bgclr = Color(0, 0, 0, 255)
local bgr, bgg, bgb, bga = 0, 0, 0, 1
local linewidth = 1
local linewidthhalf = linewidth/2
local corner64 = material.load("gui/corner64")
local corner512 = material.load("gui/corner512")

local Image_idx = {}
local Image_meta = {}
local function Image_new(mat)
	local Image = {}
	Image_idx[Image] = mat
	setmetatable(Image, {
		__index = Image_meta,
		__metatable = true
	})
	return Image
end

local Font_idx = {}
local Font_meta = {}
local function Font_new(font)
	local Font = {}
	Font_idx[Font] = font
	setmetatable(Font, {
		__index = Font_meta,
		__metatable = true
	})
	return Font
end

function present()
	render.selectRenderTarget()
	render.setRGBA(127, 127, 127, 255)
	render.drawRect(wx-2, wy-2, ww+4, wh+4)
	render.setRGBA(255, 255, 255, 255)
	render.setRenderTargetTexture("guest")
	render.drawTexturedRectUV(wx, wy, ww, wh, w1, w2, w3, w4)
	render.selectRenderTarget("guest")
end
guestenv.love.graphics = {
	isActive = function()
		return true
	end,
	isCreated = function()
		return true
	end,
	present = present,
	origin = function() end,
	clear = function(r, g, b, a, clearstencil, cleardepth)
		a = a or 1
		render.clear(Color(r*255, g*255, b*255, a*255), cleardepth)
	end,
	setBackgroundColor = function(r, g, b, a)
		bgr, bgg, bgb, bga = r, g, b, a
	end,
	getBackgroundColor = function()
		return bgr, bgg, bgb, bga
	end,
	print = function(text, x, y, r, sx, sy, ox, oy, kx, ky)
		local mtx
		if r or sx or sy or ox or oy then
			mtx = Matrix()
			sx, sy = sx or 1, sy or 1
			mtx:setScale(Vector(sx, sy))
			ox, oy = ox or 0, oy or 0
			mtx:setTranslation(Vector(x, y))
			mtx:setAngles(Angle(0, math.deg(r), 0))
			render.pushMatrix(mtx)
			render.drawText(-ox, -oy, text)
			render.popMatrix()
		else
			render.drawText(x, y, text)
		end
	end,
	rectangle = function(mode, x, y, width, height, rx, ry, segments)
		if mode == "line" then
			x = x-linewidthhalf
			y = y-linewidthhalf
			width = width+linewidth
			height = height+linewidth
			-- TODO: Proper rounded outline implementation
			--if rx or ry then
			--	rx = rx and math.min(rx, width/2) or 0
			--	ry = ry and math.min(ry, height/2) or 0
			--else
				render.drawRectOutline(x, y,  width, height)
			--end
		elseif mode == "fill" then
			if rx or ry then
				if rx == ry then
					render.drawRoundedBox(rx, x, y, width, height)
				else
					render.drawRect(x, y+ry, width, height-ry-ry)
					render.drawRect(x+rx, y, width-rx-rx, height)
					render.drawRect(x+rx, y+height-ry, width-rx-rx, ry)
					render.setMaterial(math.max(rx, ry) > 64 and corner512 or corner64)
					render.drawTexturedRect(x, y, rx, ry)
					render.drawTexturedRectUV(x+width-rx, y, rx, ry, 1, 0, 0, 1)
					render.drawTexturedRectUV(x+width-rx, y+height-ry, rx, ry, 1, 1, 0, 0)
					render.drawTexturedRectUV(x, y+height-ry, rx, ry, 0, 1, 1, 0)
				end
			else
				render.drawRect(x, y, width, height)
			end
		else
			error("not a valid DrawMode")
		end
	end,
	setColor = function(r, g, b, a)
		a = a or 1
		render.setRGBA(r*255, g*255, b*255, a*255)
	end,
	setLineWidth = function(width)
		linewidth = width
		linewidthhalf = width/2
	end,
	getLineWidth = function()
		return linewidth
	end,
	newImage = function(path)
		path = "data/sf_filedata/"..guestpath.."/"..string.normalizePath(path)
		return Image_new(material.createFromImage(path, ""))
	end,
	draw = function(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
		local mat = Image_idx[drawable]
		if mat then
			render.setMaterial(mat)
			render.drawTexturedRect(x, y, mat:getWidth(), mat:getHeight())
			return
		end
		error("not a drawable", 2)
	end,
	newFont = function(filename, size, hinting, dpiscale)
		if type(filename) == "number" then
			dpiscale = hinting
			hinting = size
			size = filename
			filename = nil
		end
		assert(not filename, "custom fonts not implemented")
		assert(not hinting, "hinting not implemented")
		assert(not dpiscale, "dpi scale not implemented")
		size = size or 12
		return Font_new(render.createFont("Verdana", size+3))
	end,
	setFont = function(font)
		curfont = font
		render.setFont(assert(Font_idx[font], "that's not a font..."))
	end,
	getFont = function()
		return curfont
	end
}

curfont = guestenv.love.graphics.newFont()
defaultfont = assert(Font_idx[curfont], "default font error")
