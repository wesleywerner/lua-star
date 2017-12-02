describe("Lua star", function()

    -- start is always top left (1,1)
    -- goal is always bottom right (10, 10)
    local start = { x = 1, y = 1 }
    local goal = { x = 10, y = 10 }
    local map = nil

    -- define some test maps (10 x 10)
    local mapsize = 10
    local openmap = [[
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                ]]

    local openmapSolution = {
        { x = 1, y = 1 },
        { x = 2, y = 2 },
        { x = 3, y = 3 },
        { x = 4, y = 4 },
        { x = 5, y = 5 },
        { x = 6, y = 6 },
        { x = 7, y = 7 },
        { x = 8, y = 8 },
        { x = 9, y = 9 },
        { x = 10, y = 10 },
    }

    local simplemap = [[
                0000000000
                0000000110
                0000001110
                0000011100
                0000111000
                0001110000
                0011100000
                0111000000
                0000000000
                0000000000
                ]]

    local simplemapSolution = {
        { x = 1, y = 1 },
        { x = 2, y = 2 },
        { x = 3, y = 3 },
        { x = 4, y = 4 },
        { x = 4, y = 5 },
        { x = 3, y = 6 },
        { x = 2, y = 7 },
        { x = 1, y = 8 },
        { x = 2, y = 9 },
        { x = 3, y = 10 },
        { x = 4, y = 10 },
        { x = 5, y = 10 },
        { x = 6, y = 10 },
        { x = 7, y = 10 },
        { x = 8, y = 10 },
        { x = 9, y = 10 },
        { x = 10, y = 10 },
    }

    local complexmap = [[
                0000000000
                1111111110
                0000000000
                0111111111
                0100110000
                0101010100
                0001010110
                1111011010
                0000000010
                0000000010
                ]]

    local complexmapSolution = {
        { x = 1, y = 1 },
        { x = 2, y = 1 },
        { x = 3, y = 1 },
        { x = 4, y = 1 },
        { x = 5, y = 1 },
        { x = 6, y = 1 },
        { x = 7, y = 1 },
        { x = 8, y = 1 },
        { x = 9, y = 1 },
        { x = 10, y = 2 },
        { x = 9, y = 3 },
        { x = 8, y = 3 },
        { x = 7, y = 3 },
        { x = 6, y = 3 },
        { x = 5, y = 3 },
        { x = 4, y = 3 },
        { x = 3, y = 3 },
        { x = 2, y = 3 },
        { x = 1, y = 4 },
        { x = 1, y = 5 },
        { x = 1, y = 6 },
        { x = 2, y = 7 },
        { x = 3, y = 6 },
        { x = 4, y = 5 },
        { x = 5, y = 6 },
        { x = 5, y = 7 },
        { x = 5, y = 8 },
        { x = 6, y = 9 },
        { x = 7, y = 9 },
        { x = 8, y = 8 },
        { x = 7, y = 7 },
        { x = 7, y = 6 },
        { x = 8, y = 5 },
        { x = 9, y = 6 },
        { x = 10, y = 7 },
        { x = 10, y = 8 },
        { x = 10, y = 9 },
        { x = 10, y = 10 },
    }

    local unsolvablemap = [[
                0000000000
                0000000000
                0000000000
                0000000000
                1111111111
                0000000000
                0000000000
                0000000000
                0000000000
                0000000000
                ]]

    -- convert a string map into a table
    local function makemap(template)
        map = { }
        template:gsub(".", function(c)
            if c == "0" or c == "1" then
                table.insert(map, c)
            end
        end)
    end

    -- get the value at position xy on a map
    local function mapTileIsOpen(x, y)
        return map[ ((y-1) * 10) + x ] == "0"
    end

    local function printSolution(path)
        print(#path, "points")
        for i, v in ipairs(path) do
            print(string.format("{ x = %d, y = %d },", v.x, v.y))
        end
        for h=1, mapsize do
            for w=1, mapsize do
                local walked = false
                for _, p in ipairs(path) do
                    if p.x == w and p.y == h then
                        walked = true
                    end
                end
                if walked then
                    io.write(".")
                else
                    io.write("#")
                end
            end
            io.write("\n")
        end
    end

    -- begin tests

    it("find a path with no obstacles", function()

        local luastar = require("lua-star")
        makemap(openmap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        --printSolution(path)
        assert.are.equal(10, #path)
        assert.are.same(openmapSolution, path)

    end)

    it("find a path on a simple map", function()

        local luastar = require("lua-star")
        makemap(simplemap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        --printSolution(path)
        assert.are.equal(17, #path)
        assert.are.same(simplemapSolution, path)

    end)

    it("find a path on a complex map", function()

        local luastar = require("lua-star")
        makemap(complexmap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        --printSolution(path)
        assert.are.equal(38, #path)
        assert.are.same(complexmapSolution, path)

    end)

    it("find no path", function()

        local luastar = require("lua-star")
        makemap(unsolvablemap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        assert.is_false(path)

    end)

    it("does not cache paths by default", function()

        local luastar = require("lua-star")
        makemap(openmap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        local samepath = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen)
        assert.is_not.equal(path, samepath)

    end)

    it("caches paths", function()

        local luastar = require("lua-star")
        makemap(openmap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen, true)
        local samepath = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen, true)
        assert.are.equal(path, samepath)

    end)

    it("clears cached paths", function()

        local luastar = require("lua-star")
        makemap(openmap)
        local path = luastar:find(mapsize, mapsize, start, goal, mapTileIsOpen, true)
        luastar:clearCached()
        assert.is_nil(luastar.cache)

    end)

end)

