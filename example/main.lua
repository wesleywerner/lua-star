--[[
    Lua star example - Run with love (https://love2d.org/)
    Copyright 2018 Wesley Werner <wesley.werner@gmail.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

local luastar = require("lua-star")

-- a 2D map where true is open and false is blocked
local map = { }
local mapsize = 10
local screensize = 500
local tilesize = screensize / mapsize

-- path start and end
local path = nil
local start = { x = 1, y = 10 }
local goal = { x = 10, y = 1 }

function love.load()

    love.window.setMode( screensize, screensize )

    -- build an open map
    for x=1, mapsize do
        map[x] = {}
        for y=1, mapsize do
            map[x][y] = true
        end
    end

    requestPath()

end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    end

end

function love.draw()

    -- draw walls
    love.graphics.setColor(255, 255, 255)
    for x=1, mapsize do
        for y=1, mapsize do
            local fillstyle = "line"
            if map[x][y] == false then fillstyle = "fill" end
            love.graphics.rectangle(fillstyle, (x-1)*tilesize, (y-1)*tilesize, tilesize, tilesize)
        end
    end

    -- draw start and end
    love.graphics.print("START", (start.x-1) * tilesize, (start.y-1) * tilesize)
    love.graphics.print("GOAL", (goal.x-1) * tilesize, (goal.y-1) * tilesize)

    -- draw the path
    if path then
        for i, p in ipairs(path) do
            love.graphics.setColor(0, 128, 0)
            love.graphics.rectangle("fill", (p.x-1)*tilesize, (p.y-1)*tilesize, tilesize, tilesize)
            love.graphics.setColor(255, 255, 255)
            love.graphics.print(i, (p.x-1) * tilesize, (p.y-1) * tilesize)
        end
    end

end

function love.mousepressed( x, y, button, istouch )

    local dx = math.floor(x / tilesize) + 1
    local dy = math.floor(y / tilesize) + 1
    map[dx][dy] = not map[dx][dy]
    requestPath()

end

function positionIsOpenFunc(x, y)

    -- should return true if the position is open to walk
    return map[x][y]

end

function requestPath()

    path = luastar:find(mapsize, mapsize, start, goal, positionIsOpenFunc)

end
