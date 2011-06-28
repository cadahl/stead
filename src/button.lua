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
	styles = {
		default = {
			innerMargin = { 8,4,8,12 },
			gutterMargin = { 6,2,6,9 },
			states = {
				normal 	= { image = "img/drawable-hdpi/btn_default_normal.9.png" },
				pressed = { image = "img/drawable-hdpi/btn_default_pressed.9.png" }
			}			
		}
	}
}

local function loadStyle(name)

	local style = Button.styles[name]

	for i,v in pairs(style.states)
		if type(v) == "string" then
			style.states[i] = lg.newImage(v)
		end
	end

	return style
end

function Button.new(t, bounds)
	local s = Widget.init({}, "Button", bounds)
	s.style = loadStyle("default")
	s.drawPriority = 100
	s.updatePriority = 10

	local buttonState = "normal"
	local drawButton = Widget.createNinePatch(s.style[buttonState].image, s.style.innerMargin, s.style.gutterMargin)

	function s.draw()
		lg.pushMaterial()
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255,255)

		if drawButton then
			drawButton(s.bounds)
		end		
		
		lg.popMaterial()
	end

	return s
end

