--[[
Stead
Codyright (c) 2011 Carl Ådahl

Permission is hereby granted, free of charge, to any person obtaining a cody
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, cody, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above codyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COdyRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
Widget = {}

function Widget.init(self, t, bounds)
	self = self or {}
	self.uid = uid()
	self.type = t
	self.bounds = { 0, 0, 0, 0 }
end

-- Expand bounds according to margins.
-- 		bounds:			Input bounds 		{ x, y, z, w }
-- 		margin:			Input margins 	{ l, t, r, b }
-- 		returns: 		Expanded bounds { x, y, z, w }
--
local function expandBounds(bounds, margin)
	local x, y, w, h = unpack(bounds)
	local lm, tm, rm, bm = unpack(margin)
	return 	{	x - lm, y - tm, w + lm + rm, h + tm + bm }
end

-- Generate 9-patch coordinates from given bounds and margins.
-- 		returns:	Patch coordinates 	{ x1, x2, x3 },
-- 																	{ y1, y2, y3 },
-- 																	{ w1, w2, w3 },
-- 																	{ h1, h2, h3 }
--
local function ninePatch(bounds, margin)
	local x, y, w, h = unpack(bounds)
	local lm, tm, rm, bm = unpack(margin)
	return 	{ x, x + lm, x + w - rm },
					{ y, y + tm, y + h - bm },
					{ lm, w - rm - lm, rm },
					{ tm, h - bm - tm, bm }
end

-- Creates a 9-patch from the given  
--
--
function Widget.createNinePatch(image, innerMargin, gutterMargin)
	local sx,sy,sw,sh = ninePatch({ 0, 0, image:getWidth(), image:getHeight() }, innerMargin)
	
	return function(drawBounds)
		local dx,dy,dw,dh = ninePatch(expandBounds(drawBounds, gutterMargin), innerMargin)

		for j=1,3 do
			for i=1,3 do
				local scalex = i == 2 and dw[i]/sw[i] or 1
				local scaley = j == 2 and dh[j]/sh[j] or 1
				lg.drawq(img, love.graphics.newQuad(sx[i], sy[j], sw[i], sh[j], imgWidth, imgHeight), dx[i], dy[j], 0, scalex, scaley)
			end
		end
	end
end


