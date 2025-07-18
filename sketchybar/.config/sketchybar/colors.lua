return {
	black = 0xff25273A,
	white = 0xffb5c9ff,
	red = 0xffFF6C8D,
	green = 0xff90D05A,
	blue = 0xff6EA3FE,
	yellow = 0xffE9AD5B,
	orange = 0xffFF9856,
	magenta = 0xffC198FD,
	grey = 0xff9AA9D9,
	transparent = 0x00000000,
	bar = {
		bg = 0x002c2e34,
		border = 0xff2c2e34,
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xff7f8490,
	},
	bg1 = 0xff313244,
	bg2 = 0xff414550,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
