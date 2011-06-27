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
World = {}

function World.new()
	local self = { runningStates = {} }
	local actors = {}
	local spawnQueue = {}
	local removeQueue = {}
	local updateList = {}
	local drawList = {}
	local stateInitQueue = {}

	function self.spawn(actor)
		spawnQueue[actor.uid] = actor
		return actor
	end

	function self.remove(actor)
		removeQueue[actor.uid] = actor
--WATCH THIS!		self.runningStates[actor] = nil
		self.setUpdateListDirty()
		self.setDrawListDirty()
	end

	local function reallySpawn(actor)
		actors[actor.uid] = actor
		drawList[#drawList+1] = actor
		updateList[#updateList+1] = actor
		self.setUpdateListDirty()
		self.setDrawListDirty()
	end

	local function reallyRemove(actor)
		-- Remove it from the actors table
		actors[actor.uid] = nil
		
		-- Remove it from the update list
		for i,v in pairs(updateList) do
			if v == actor then
				table.remove(updateList, i)
				break
			end
		end

		-- Remove it from the draw list
		for i,v in pairs(drawList) do
			if v == actor then
				table.remove(drawList, i)
				break
			end
		end

		self.runningStates[actor] = nil
	end

	local function resumeState(actor, co, ...)
		local ok, err = coroutine.resume(co, ...)
		if not ok then
			print(err)
		end
		if coroutine.status(co) == "dead" then
--			print("State " .. actor.state .. " died in actor " .. actor.type .. " (" .. tostring(actor) .. ")")
		--	actor.state = nil
			self.runningStates[actor] = nil
--			actor.state = nil
		end
	end

	local function reallyInitState(actor, name, ...)
		if type(name) ~= "string" then 
			error("Expected name string, got " .. type(name)) 
		end

		local sf = actor.states[name]
		
		if not sf then
			error("Can't find state '" .. name .. "' in " .. actor.type )
		end

		if type(sf) ~= "function" then
			error("Expected state '" .. name .. "' to be a function, was " .. type(sf))
		end

		-- Record which state we're in (just handy to have).		
		actor.state = name
--		print("state: " .. name)
	
		co = coroutine.create(sf)
		self.runningStates[actor] = co

		-- Run prolog
		resumeState(actor, co, ...)
	end

	function self.setDrawListDirty()
		drawList.dirty = true 
	end

	function self.setUpdateListDirty()
		updateList.dirty = true 
	end

	function self.hasActor(type)
		for _,actor in pairs(actors) do
			if actor.type == type then
				return true
			end
		end
	end

	function self.getActors(type)
		local results = {}
		for _,actor in pairs(actors) do
			if actor.type == type then
				table.insert(results, actor)
			end
		end
		return results
	end

	function self.initState(actor, name, ...)
--		actor.state = name
		stateInitQueue[#stateInitQueue+1] = { actor, name, ... }
	end

	local function updateSort(a,b)
		local aup = a.updatePriority
		local bup = b.updatePriority
		return aup < bup
	end

	function self.update(dt)
		for _,v in pairs(removeQueue) do
			reallyRemove(v)
		end
		removeQueue = {}

		for _,v in pairs(spawnQueue) do
			reallySpawn(v)
		end
		spawnQueue = {}

		for _,v in pairs(stateInitQueue) do
			reallyInitState(unpack(v))
		end
		stateInitQueue = {}

		if updateList.dirty then
			table.sort(updateList, updateSort)
			updateList.dirty = false
		end

		--for _,actor in ipairs(updateList) do	
	--		local co = self.runningStates[actor]
		for actor,co in pairs(self.runningStates) do
			if co then
				resumeState(actor, co, dt*100)
			end
		end
	end
	
	local function drawSort(a,b)
		local adp = a.drawPriority
		local bdp = b.drawPriority
		
		local ax,ay = a.getRect()
		local bx,by = b.getRect()
		
		if adp == bdp then
			if ax == bx then
				return ax > bx		
			end		
			return ay < by
		end
		
		return adp < bdp
	end
	
	function self.draw()
		if drawList.dirty then
			table.sort(drawList, drawSort)
			drawList.dirty = false
		end
	
		for _,v in ipairs(drawList) do
			v.draw()
		end
		
		love.graphics.checkMaterialStack()
	end


	return self
end
