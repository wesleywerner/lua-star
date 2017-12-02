--[[

   Lua star example - Run with love (https://love2d.org/)

   Copyright 2017 wesley werner <wesley.werner@gmail.com>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see http://www.gnu.org/licenses/.

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
