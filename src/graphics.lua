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
local stack = {}

function lg.pushMaterial()
	stack[#stack+1] =
	{
		blendMode = { lg.getBlendMode() },
		color = { lg.getColor() }
	}
end

function lg.popMaterial()
	if #stack == 0 then
		error("graphics: Material stack is empty in pop().")
	end
	
	local se = stack[#stack]
	lg.setBlendMode(unpack(se.blendMode))
	lg.setColor(unpack(se.color))
	stack[#stack] = nil
end

function lg.checkMaterialStack()
	if #stack ~= 0 then
		print("graphics: Material stack leak!")
		
		for i,v in ipairs(stack) do
			print(i .. ": " .. v.blendMode .. ", (" .. v.color[1] .. ", " .. v.color[2] .. ", " .. v.color[3] .. ", " .. v.color[4] .. ")")
		end
	end
end
--[[
love.graphics.newFont = function(font, size)
	if type(font) == "number" then
		size = font
		font = love.filesystem.newFileData(vera_ttf_b64, "Vera.ttf", "base64")
	end
	return love.graphics.newFont1(font, size)
end

love.graphics.setFont = function(font, size)
	if type(font) == "number" then
		size = font
		font = love.filesystem.newFileData(vera_ttf_b64, "Vera.ttf", "base64")
	end
	return love.graphics.setFont1(font, size)
end

	love.graphics.print = function (...)
		if not love.graphics.getFont() then 
			love.graphics.setFont(12)
		end
		love.graphics.print1(...)
		love.graphics.print = love.graphics.print1
	end

	love.graphics.printf = function (...)
		if not love.graphics.getFont() then 
			love.graphics.setFont(12)
		end
		love.graphics.printf1(...)
		love.graphics.printf = love.graphics.printf1
	end

	local nameToFunc = {
		alpha = { "src_alpha", "one_minus_src_alpha", "add" },
		multiplicative = { "dst_color", "one_minus_src_alpha", "add" },
		additive = { "src_alpha", "one", "add" },
		subtractive = { "src_alpha", "one", "reverse_subtract" }
	}

	local funcToName = {}
	for m,f in pairs(nameToFunc) do
		if not funcToName[ f[1] ] then 
			funcToName[ f[1] ] = {} 
		end
    	funcToName[ f[1] ][ f[2] ] = m
	end

	function love.graphics.setBlendMode(src, dst, op)
		-- simplemode
    	if not dst and not op and nameToFunc[src] then
    	    love.graphics.setBlendModeRGB( unpack(nameToFunc[src]) )
    	    love.graphics.setBlendModeAlpha( unpack(nameToFunc[src]) )
    	else -- RGBA src,dst,op
		    love.graphics.setBlendModeRGB( src, dst, op )
		    love.graphics.setBlendModeAlpha( src, dst, op )
		end
	end

	-- Find src,dst,op -> simplemode mapping, in just three lookups.
	local function reverseMatch(src,dst,op)
		local m1 = funcToName[src]
		if not m1 then return end
		local m2 = m1[dst]
		if not m2 then return end
		local m3 = m2[op]
		if not m3 then return end
		return m3
	end

	function love.graphics.getBlendMode()
	    local srcRGB, dstRGB, opRGB = love.graphics.getBlendModeRGB()
	    local srcA, dstA, opA = love.graphics.getBlendModeAlpha()

		-- If separate blend modes are set up, this function returns nil.
		-- Should use getBlendModeRGB and getBlendModeAlpha
	    if srcRGB ~= srcA or dstRGB ~= dstA or opRGB ~=opA then
	    	return
	    end

		-- If matching simple mode found, return it.
	    local rgbm = reverseMatch(srcRGB,dstRGB,opRGB)
	    if rgbm then
	        return rgbm
	    end

		-- Otherwise RGBA src,dst,op 
	    return srcRGB, dstRGB, opRGB
	end
]]
