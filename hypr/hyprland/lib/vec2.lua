---@class Vec2
---@field x number
---@field y number
local Vec2 = {}

---@type metatable<Vec2>
local Vec2_mt = {
	__index = Vec2,

	---@param a Vec2
	---@param b number
	---@return Vec2
	__mul = function(a, b)
		return Vec2.new(a.x * b, a.y * b)
	end,
}

---@param x number
---@param y number
---@return Vec2
---@constructor
function Vec2.new(x, y)
	return setmetatable({
		x = x,
		y = y,
	}, Vec2_mt)
end

---@param direction "l"|"d"|"u"|"r"
---@return Vec2
---@constructor
function Vec2.from_direction(direction)
	local direction_to_normal = {
		l = { x = -1, y = 0 },
		d = { x = 0, y = 1 },
		u = { x = 0, y = -1 },
		r = { x = 1, y = 0 },
	}

	local normal = direction_to_normal[direction]
	local x = normal.x
	local y = normal.y

	return Vec2.new(x, y)
end

return Vec2
