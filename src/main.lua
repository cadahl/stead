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

require "conf.lua"
require "util.lua"
require "math.lua"
require "graphics.lua"
require "actor.lua"
require "screen.lua"
require "world.lua"
require "widget.lua"
require "button.lua"

keysPressed = 0

function love.load()
	world = World.new()

	screen = world.spawn(Screen.new(0,0))
	button = world.spawn(Button.new(0,0,16,16))

	love.keyboard.setKeyRepeat(0,1)
	
	print(love.joystick.getNumJoysticks() .. " joystick(s) found:")
	
	if love.joystick.open(0) then
		print(love.joystick.getName(0))
	end
	
	love.graphics.setBackgroundColor(0,0,0,0)
end

function love.draw()
	world.draw()
	love.graphics.print(love.timer.getFPS( ), 0,0)
end

function love.update(dt)
	world.update(dt)
	if dragx then
		button.setRect(dragx,dragy,love.mouse.getX()-dragx,love.mouse.getY()-dragy)
	end
end

function love.keypressed(key, unicode)

	if key == "escape" then
		os.exit()
	end
	
	keysPressed = keysPressed + 1
end

function love.mousepressed(x,y,button)
	dragx,dragy = x,y
end

function love.mousereleased(x,y,button)
	dragx,dragy = nil
end
