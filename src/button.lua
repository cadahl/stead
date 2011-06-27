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

Button = {
	btn_default = {
		inner = { 8,4,8,12 },
		margins = { 6,2,6,9 }
		images = {
			normal = lg.newImage("img/drawable-hdpi/btn_default_normal.9.png"),
			pressed = lg.newImage("img/drawable-hdpi/btn_default_normal.9.png")
		}			
	}
	btn_default = {
		inner = { 8,4,8,12 },
		margins = { 6,2,6,9 }
	}
}

img:setWrap("repeat", "repeat")

function Button.new(x,y,width,height)
	local s = Actor.new("Button")

	local drawButtonImage

	function s.getRect()
		return x,y,width,height
	end

	function s.setRect(x_,y_,w_,h_)
		x,y,width,height = x_, y_, w_ or width, h_ or height
	end

	function s.draw()
		lg.pushMaterial()
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255,255)

		if drawButtonImage then
			drawButtonImage.draw(x,y,width,height)
		end		
		
		lg.popMaterial()
	end

	function s.states.standby()
		s.wait()
	end

	s.drawPriority = 100
	s.updatePriority = 10

	drawButtonImage = util.ninepatch(img, Button.btn_default)

	return s
end
