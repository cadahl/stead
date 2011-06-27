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
local lg = love.graphics

Background = {}

local logo = lg.newImage("img/logo.png")
local badges = lg.newImage("img/badges.png")
local lillfonten2 = lg.newFont("fonts/heavywei.ttf", 20*1.3333)
local fonten = lg.newFont("fonts/heavywei.ttf", 52)
local storfonten = lg.newFont("fonts/heavywei.ttf", 105*1.3333)
local jattefonten = lg.newFont("fonts/heavywei.ttf", 200*1.3333)
local ball = lg.newImage("img/threeballs.png")
local img = lg.newImage("img/background.png")
img:setWrap("repeat", "repeat")

function Background.new(x,y)
	local s = Actor.new("background")
	local scrol = 0

	function s.getX()
		return x
	end

	function s.getY()
		return y
	end

	local function drawSurface()
		lg.pushMaterial()
		lg.setBlendMode("alpha")
		lg.setColor(255,255,255,255)
		lg.drawq(img, lg.newQuad(0, -scrol, cfg.width, cfg.height, img:getHeight(), img:getHeight()), x, y)
		lg.popMaterial()
	end

	function s.draw()
		drawSurface()
	end

	local function rollin(nextScreen)
		--print("Rollin: in " .. s.state)
		nextScreen.y = -nextScreen.height
		local t = 0
		local startTime = s.dt
		local endTime = startTime + nextScreen.height
		local startY = -nextScreen.height
		local endY = 0

		if s.prevScreen then
			s.draw = util.sequence(drawSurface, s.prevScreen.draw, nextScreen.draw)
		else
			s.draw = util.sequence(drawSurface, nextScreen.draw)
		end
		
		while s.update() do
    		local nextY = math.lerp(startY, endY, math.smoothstep(0,1,math.smoothstep(0, 120, t)))
    		local dy = nextY - nextScreen.y
    		
    		nextScreen.y = nextY
    		if s.prevScreen then
	    		s.prevScreen.y = s.prevScreen.y + dy
	    	end
    		scrol = scrol + dy
    		
    		t = t + s.dt

    		if nextScreen.y >= endY-2 then
    			s.prevScreen = nextScreen
				s.draw = util.sequence(drawSurface, s.prevScreen.draw)
				break
    		end
		end
		
	end

	function s.states.loading(mapNumber)
		local screen = {} 
		screen.y = 0 
		screen.height = cfg.height
		screen.draw = function()
			lg.pushMaterial()
			lg.setColor(230,250,230,80)
			lg.setFont(fonten)
			lg.setBlendMode("additive")
			lg.print("    Get ready for", 0, screen.y + cfg.height/2-fonten:getHeight()/2-5)
			lg.print("                Level " .. mapNumber, 0, screen.y + cfg.height/2+fonten:getHeight()/2+5)
			lg.popMaterial()
		end
		
		rollin(screen)

		s.waitFor(30)
		
		s.enterState("loadingMap")
	end
	
	function s.states.loadingMap()
		local screen = {}
		screen.y = 0
		screen.height = cfg.height
		screen.draw = function()
			lg.pushMaterial()
			lg.setColor(230,250,230,80)
			lg.setFont(fonten)
			lg.setBlendMode("additive")
			lg.print("--------------------------------", 4, cfg.failureLine - 16+screen.y)	
			lg.popMaterial()
		end
		rollin(screen)
		s.enterState("playing")
	end

	function s.states.credits()
--		s.waitFor(30)
		
		local screen = {}
		screen.y = 0
		screen.height = cfg.height
		screen.draw = function()
			lg.pushMaterial()
			lg.draw(ball, cfg.width/2 - ball:getWidth()/2, cfg.height/2 - ball:getHeight()/2+screen.y-90, 0, 1, 1, 0, 0)
			lg.setColor(250,250,240,80)
			lg.setBlendMode("additive")
			lg.draw(logo, cfg.width/2 - logo:getWidth()/2, screen.y + 47, 0, 1, 1, 0, 0)
			lg.setColor(250,250,240,80)
			lg.setFont(lillfonten2)
			local credity = 535
			lg.print("beta version", 151+30, screen.y+credity+25)
			lg.print("by carl adahl, 2010", 110+30, screen.y+credity+50)
			lg.draw(badges, cfg.width/2 - badges:getWidth()/2-5, screen.y + 320, 0, 1, 1, 0, 0)
			lg.popMaterial()
		end
		rollin(screen)
		s.enterState("standby")
	end
	
	function s.states.lost()
		local screen = {} 
		screen.y = 0 
		screen.height = cfg.height
		screen.draw = function()
			lg.pushMaterial()
			lg.setColor(230,250,230,80)
			lg.setFont(fonten)
			lg.setBlendMode("additive")
			lg.print("Oops. Try again.", 90, screen.y + cfg.height/2-fonten:getHeight()/2)
			lg.popMaterial()
		end
		
		rollin(screen)

		s.waitFor(120)
		
		s.enterState("standby")
	end
	
	function s.states.playing()
		s.wait()
	end

	function s.states.standby()
		s.wait()
	end

	s.drawPriority = -100
	s.updatePriority = 10

	return s
end

