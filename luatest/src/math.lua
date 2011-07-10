--[[
Gemböbble
Copyright (c) 2010-2011 Carl Ådahl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]


-- randomsign(x)
-- Randomly returns a sign factor, either -1 or 1.
function math.randomsign()
	if math.random() < 0.5 then
		return -1
	else
		return 1
	end
end

-- sign(x)
-- Returns -1 for x < 0, 0 for x = 0 and 1 for x > 1. 
function math.sign(x)
	if x < 0 then
		return -1
	elseif x > 0 then
		return 1
	else
		return 0
	end
end

-- saturate(x)
-- Returns x, clamped to the range [0,1]
function math.saturate(x)
	if x < 0 then return 0 end
	if x > 1 then return 1 end
	return x
end

-- lerp(a, b, k)
-- Returns a linear interpolation between a and b, based on the
-- coefficient k when it is in [0,1]. If k is outside this range,
-- the function returns extrapolated values along the same line.
function math.lerp(a, b, k)
	return a * (1-k) + b * k
end

-- smoothstep(edge0, edge1, x)
-- Returns an interpolation value based on the inputs:
--   x < edge0 returns 0 
--   x > edge0 and x < edge1 returns a smoothed value in [0,1] 
--   x > edge1 returns 1
-- The interpolated part is smooth in the sense that the tangent 
-- is horizontal at 0 and 1.
-- http://en.wikipedia.org/wiki/Smoothstep
function math.smoothstep(edge0, edge1, x)
	x = math.saturate((x - edge0) / (edge1 - edge0))
	return x * x * (3 - 2 * x)
end

