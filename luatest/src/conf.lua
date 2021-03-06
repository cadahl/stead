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

cfg = 
{
	width = 1024,
	height = 768
}

function love.conf(t)
    t.modules.joystick = true  	-- Enable the joystick module (boolean)
    t.modules.audio = true     	-- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true     -- Enable the mouse module (boolean)
    t.modules.sound = true     	-- Enable the sound module (boolean)
    t.modules.physics = false   -- Enable the physics module (boolean)
    t.console = false           -- Attach a console (boolean, Windows only)
    t.title = "Stead"       	-- The title of the window the game is in (string)
    t.author = "Carl Ådahl"     -- The author of the game (string)
    t.screen.fullscreen = false -- Enable fullscreen (boolean)
    t.screen.vsync = true       -- Enable vertical sync (boolean)
    t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
    t.screen.width = cfg.width
    t.screen.height = cfg.height
    t.version = 0.7             -- The LÖVE version this game was made for (number)

	print("width: " .. t.screen.width .. ", height: " .. t.screen.height)
end
