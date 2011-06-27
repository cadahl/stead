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
util = {}

function util.sequence(...)
	local funs = {...}
	return function()
		for _,fn in pairs(funs) do
			fn()
		end
	end
end

-- inner	LTRB distances to inner rectangle (repeated part).
-- margins	LTRB margins around patch.
function util.ninepatch(img, widgetConfig)
	local inner = widgetConfig.inner
	local margins = widgetConfig.margins
	local lg = love.graphics
	local sw = img:getWidth()
	local sh = img:getHeight()

	local sws = { inner[1], sw-inner[3]-inner[1], inner[3] }
	local shs = { inner[2], sh-inner[4]-inner[2], inner[4] }
	
	return {
		draw = function(dx,dy,dw,dh)
			dx = dx - margins[1]
			dw = dw + margins[1] + margins[3]
			dy = dy - margins[2]
			dh = dh + margins[2] + margins[4]

			local dws = { inner[1], dw-inner[3]-inner[1], inner[3] }
			local dhs = { inner[2], dh-inner[4]-inner[2], inner[4] }
		
			local sxs = { 0, inner[1], sw - inner[3] }
			local sys = { 0, inner[2], sh - inner[4] }
			local dxs = { dx, dx + inner[1], dx + dw - inner[3] }
			local dys = { dy, dy + inner[2], dy + dh - inner[4] }
	
			for j=1,3 do
				for i=1,3 do
					local scalex = 1
					local scaley = 1

					if i == 2 then
						scalex = dws[i]/sws[i]
					end

					if j == 2 then
						scaley = dhs[j]/shs[j]
					end
								
					lg.drawq(img, lg.newQuad(sxs[i], sys[j], sws[i], shs[j], sw, sh), dxs[i], dys[j], 0, scalex, scaley)
				end
			end
		end
	}
end

