local Vec2 = require("hyprland.lib.vec2")

local resize_delta = 20
local motions = { H = "l", J = "d", K = "u", L = "r" }
local exec_binds = {
	["SUPER + Q"] = "kitty",
	["SUPER + R"] = "rofi -show drun",
	["SUPER + SHIFT + R"] = "rofi -show calc -modi calc -no-show-match -no-sort | wl-copy",
	["SUPER + PERIOD"] = "rofimoji",
	["SUPER + ALT + B"] = "zen-browser",
	["SUPER + ALT + F"] = "dolphin",
	["SUPER + ALT + K"] = "krita",
	["SUPER + ALT + L"] = "hyprlock",
}

hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + C", hl.dsp.window.kill())
hl.bind("SUPER + E", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())

-- Mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, drag = true })

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

for key, direction in pairs(motions) do
	local resize_vec = Vec2.from_direction(direction) * resize_delta

	-- Move focus
	hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))

	-- Move window
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))

	-- Resize window
	hl.bind(
		"SUPER + CTRL + " .. key,
		hl.dsp.window.resize({
			x = resize_vec.x,
			y = resize_vec.y,
			direction = direction,
			relative = true,
		}),
		{ repeating = true }
	)
end

for i = 1, 10, 1 do
	local key = tostring(i % 10)

	-- Move workspace
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))

	-- Move window across workspace
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
end

for key, cmd in pairs(exec_binds) do
	hl.bind(key, hl.dsp.exec_cmd(cmd))
end
