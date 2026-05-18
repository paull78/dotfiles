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

	-- Space (desktop) tiles — palette borrowed from the bubble theme on the
	-- right side. Active tile gets the teal-bubble look with a cream ring;
	-- inactive tiles stay dark but each gets its own quietly-colored outer
	-- border, cycling through darkened bubble colors.
	screen = {
		-- Active (currently focused) tile. Fill is set per-tile from
		-- inactive_borders[i] in spaces.lua, so each space lights up in its
		-- own hue. Only the cream rings + white text are shared.
		active_border  = 0xfff2efe2, -- cream inner ring
		active_text    = 0xffffffff,
		bracket_active = 0xfff2efe2, -- cream outer ring on selection

		-- Inactive text/labels stay neutral; per-tile color lives on the outer ring
		inactive_text  = 0xffc4ccc6, -- soft warm grey number
		inactive_label = 0xff7e8c87, -- muted teal-grey app icons

		-- Per-tile dark border colors (used on the bracket / outer ring when
		-- the tile is inactive). One entry per space, cycling through the
		-- bubble palette so the row has subtle color rhythm.
		inactive_borders = {
			0xff5d3f7e, -- 1: dark purple (← bubble.network)
			0xff2c625a, -- 2: dark teal   (← bubble.cpu)
			0xff437558, -- 3: dark green  (← bubble.gpu)
			0xff586328, -- 4: dark olive  (← bubble.memory)
			0xff8d4e3e, -- 5: dark salmon (← bubble.volume)
			0xff346485, -- 6: dark blue   (← bubble.time)
			0xff985f28, -- 7: dark orange (← bubble.battery)
			0xff5d3f7e, -- 8: purple
			0xff2c625a, -- 9: teal
			0xff437558, -- 10: green
			0xff586328, -- 11: olive
			0xff8d4e3e, -- 12: salmon
		},
	},

	-- Right-side segmented pill ("bubble") theme
	bubble = {
		border  = 0xfff2efe2, -- soft cream outline
		text    = 0xffffffff, -- pure white for high contrast on colored bubbles
		network = 0xff8a5fb8, -- saturated purple
		cpu     = 0xff3f8c7c, -- saturated teal
		gpu     = 0xff5fa67c, -- saturated green (sibling of cpu's teal)
		memory  = 0xff7c8c3f, -- saturated olive (transitions cpu's teal to gpu's green)
		volume  = 0xffc97058, -- saturated salmon
		time    = 0xff4a8fbf, -- saturated sky blue
		battery = 0xffd6883a, -- saturated orange
	},

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
