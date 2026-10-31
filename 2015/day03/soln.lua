local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day03/data.txt"

local dirs = {
  ["^"] = { 0, 1 },
  ["v"] = { 0, -1 },
  ["<"] = { -1, 0 },
  [">"] = { 1, 0 },
}

local Solver = {}
Solver.__index = Solver

function Solver.new()
  return setmetatable({}, Solver)
end

function Solver:load_data(filename)
  local file = io.open(filename, "r") or io.open("data.txt", "r")
  if not file then
    error("File not found: " .. filename)
  end
  local content = file:read("*a")
  file:close()
  return content
end

function Solver:puzzle1(data_)
  local visited = { ["0,0"] = true }
  local count = 1
  local x, y = 0, 0

  for i = 1, #data_ do
    local c = data_:sub(i, i)
    local d = dirs[c]
    if d then
      x = x + d[1]
      y = y + d[2]
      local key = x .. "," .. y
      if not visited[key] then
        visited[key] = true
        count = count + 1
      end
    end
  end

  return count
end

function Solver:puzzle2(data_)
  local visited = { ["0,0"] = true }
  local count = 1
  local sx, sy = 0, 0
  local rx, ry = 0, 0

  for i = 1, #data_ do
    local c = data_:sub(i, i)
    local d = dirs[c]
    if d then
      if i % 2 == 1 then
        sx = sx + d[1]
        sy = sy + d[2]
        local key = sx .. "," .. sy
        if not visited[key] then
          visited[key] = true
          count = count + 1
        end
      else
        rx = rx + d[1]
        ry = ry + d[2]
        local key = rx .. "," .. ry
        if not visited[key] then
          visited[key] = true
          count = count + 1
        end
      end
    end
  end

  return count
end

local function main()
  print("Hello, Day 3!\n")

  local solver = Solver.new()
  local data = solver:load_data(DATA_FILE)

  local res1 = solver:puzzle1(data)
  local t1 = bench(function()
    solver:puzzle1(data)
  end)
  print(string.format("part 1: %s, min: %s us, median: %s us", res1, t1.min, t1.median))

  local res2 = solver:puzzle2(data)
  local t2 = bench(function()
    solver:puzzle2(data)
  end)
  print(string.format("part 2: %s, min: %s us, median: %s us", res2, t2.min, t2.median))

  print("\nfin")
end

main()
