--[[
Stead
Copyright (c) 2011 Carl Ådahl

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
widget = {}

local lg = love.graphics

local function expandOuter(x,y,w,h,outer)
			return 	x - outer[1],
							y - outer[2],
							w + outer[1] + outer[3],
							h + outer[2] + outer[4]
end

local function ninePatchPositions(x,y,w,h,inner)
	return { x, x + inner[1], x + w - inner[3] },
				 { y, y + inner[2], y + h - inner[4] }
end

local function ninePatchSizes(w,h,inner)
	return 	{ inner[1], w-inner[3]-inner[1], inner[3] },
					{ inner[2], h-inner[4]-inner[2], inner[4] }
end

-- inner		LTRB margins to inner rectangle (repeated part inside draw rect).
-- margins	LTRB margins of outer rectangle (outside draw rect).
function widget.ninepatch(widgetConfig, state)
	local lg = love.graphics
	local img = lg.newImage("img/drawable-hdpi/" .. widgetConfig.images[state])
	local sw = img:getWidth()
	local sh = img:getHeight()
	local inner = widgetConfig.inner
	local outer = widgetConfig.margins

	local sxs,sys = ninePatchPositions(0,0,sw,sh,inner)
	local sws,shs = ninePatchSizes(sw,sh,inner)
	
	return {
		draw = function(dx,dy,dw,dh)
		
			dx,dy,dw,dh = expandOuter(dx,dy,dw,dh,outer)

			local dxs,dys = ninePatchPositions(dx,dy,dw,dh,inner)
			local dws,dhs = ninePatchSizes(dw,dh,inner)

			for j=1,3 do
				for i=1,3 do
					local scalex = i == 2 and dws[i]/sws[i] or 1
					local scaley = j == 2 and dhs[j]/shs[j] or 1
					lg.drawq(img, lg.newQuad(sxs[i], sys[j], sws[i], shs[j], sw, sh), dxs[i], dys[j], 0, scalex, scaley)
				end
			end
		end
	}
end

