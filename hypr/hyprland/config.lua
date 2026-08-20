hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 2,
		col = {
			active_border = {
				colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
	},
	decoration = {
		rounding = 0,
		rounding_power = 0,
		blur = { enabled = false },
	},
	dwindle = {
		smart_split = true,
		preserve_split = true,
	},
	input = {
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
		},
	},
	xwayland = {
		force_zero_scaling = true,
	},
})
