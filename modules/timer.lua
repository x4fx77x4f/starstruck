guestenv.love.timer = {
	step = function()
		return timer.frametime()
	end,
	getTime = function()
		return timer.systime()
	end
}
