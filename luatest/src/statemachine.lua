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
StateMachine = {}

function StateMachine.init(self)

	self = self or {}
	self.dt = 0
	self.states = {}

	PropertyBag.init(self, { 
		drawPriority = { value = 0, onSet = world.setDrawListDirty },
		updatePriority = { value = 0, onSet = world.setUpdateListDirty }
	})

	-- doFor(time, func, ...)	
	--	Repeat the specified function every frame for a certain amount of time.	
	function self.doFor(time, func, ...)
		local localTime = 0
		while localTime < (time or 0) do
			func(localTime, ...)
			self.update()
			localTime = localTime + self.dt
		end
	end
	 
	-- wait()	
	--	Wait indefinitely.
	function self.wait()
		while true do self.update() end	
	end

	-- waitFor(time)	
	--	Wait for a set amount of time (update frames).
	function self.waitFor(time)
		self.doFor(time, function() end)
	end

	-- waitWhile(otherActor, state)	
	--	Wait until the other actor enters the specified state.
	function self.waitUntil(otherActor, state)
		if otherActor then
			while otherActor.state ~= state do self.update() end
		end
	end

	-- waitWhile(otherActor, state)	
	--	Wait while the other actor is in the specified state.
	function self.waitWhile(otherActor, state)
		if otherActor then
			while otherActor.state == state do self.update() end
		end
	end

	-- waitKey(key) 	
	-- 	Wait for specified love.keyboard.KeyCode
	-- waitKey() 		
	-- 	Wait for *any* key
	function self.waitKey(key)
		if key then
			while not love.keyboard.isDown(key) do self.update() end
		else
			local oldKeyCount = keysPressed
			while keysPressed == oldKeyCount do self.update() end
		end
	end
	 
	-- enterState(state, ...)	
	-- 	Enter a new state (takes effect the next update)	
	function self.enterState(name, ...)
		world.initState(self, name, ...)
	end

	-- update()	
	-- 	Let the game update itself (we yield one frame).
	function self.update()
		self.dt = coroutine.yield()
		return self.dt
	end

	return self
end


