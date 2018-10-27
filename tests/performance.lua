--[[
    Copyright 2018 Wesley Werner <wesley.werner@gmail.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

local luastar = require("lua-star")
local map = { }
local mapsize = 3000
local numberOfTests = 1000
local mapDensity = 0.65

local seed = os.time()
math.randomseed(seed)
print (string.format("Running with seed %d", seed))

print (string.format("Building a map of %dx%d...", mapsize, mapsize))
for x=1, mapsize do
    map[x] = {}
    for y=1, mapsize do
        map[x][y] = math.random()
    end
end

-- precalculate a bunch of start and goal positions
-- doubled up for each start/goal pair

print (string.format("Precalculating %d random start/goal positions...", mapsize * 2))
local testPoints = { }
for i = 1, mapsize * 2 do
    table.insert (testPoints, { x = math.random(1, mapsize), y = math.random(1, mapsize)})
end

print (string.format("Finding %d paths...", numberOfTests))
function positionIsOpenFunc(x, y)
    return map[x][y] > mapDensity
end
local testStart = os.clock()
for testNumber = 1, numberOfTests do
    luastar:find(
        mapsize, mapsize, -- map size
        table.remove (testPoints), -- start
        table.remove (testPoints), -- goal
        positionIsOpenFunc)
end
local testEnd = os.clock()
local totalSec = testEnd - testStart
local pathSec = totalSec / numberOfTests

print (string.format([[
    Done in %.2f seconds.
    That is %.4f seconds, or %d milliseconds, per path.
    The map has %.1f million locations, with about %d%% open space.]],
    totalSec, -- total seconds
    pathSec, -- seconds per path
    pathSec*1000, -- milliseconds per path
    (mapsize*mapsize)/1000000, -- number of locations
    mapDensity*100 -- % open space on the map
))
