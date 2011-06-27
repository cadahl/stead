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
local lg = love.graphics

Screen = {}

local font = lg.newFont("fonts/droidsans.ttf", 20)
local img = lg.newImage("img/background.png")
img:setWrap("repeat", "repeat")

function Screen.new(x,y)
	local s = Actor.new("screen")
	local quad = lg.newQuad(0, 0, cfg.width, cfg.height, img:getHeight(), img:getHeight())
	
	function s.getRect()
		return 0,0,cfg.width,cfg.height
	end

	function s.draw()
		lg.pushMaterial()
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255,255)
		lg.drawq(img, quad, x, y)
		lg.popMaterial()
	end

	function s.states.standby()
		s.wait()
	end

	s.drawPriority = -100
	s.updatePriority = 10

	return s
end
