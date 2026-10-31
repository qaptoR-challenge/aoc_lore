local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2016/day01/data.txt"

local dirs = {
  { 0, 1 },
  { 1, 0 },
  { 0, -1 },
  { -1, 0 },
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
  local content = file:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
  file:close()

  local moves = {}
  for move in content:gmatch("[^, ]+") do
    table.insert(moves, move)
  end
  return moves
end

function Solver:puzzle1(data_)
  local direction = 1 -- 1-based: 1=UP, 2=RIGHT, 3=DOWN, 4=LEFT
  local px, py = 0, 0

  for _, move in ipairs(data_) do
    local dir = move:sub(1, 1)
    local dist = tonumber(move:sub(2))

    if dir == "R" then
      direction = (direction % 4) + 1
    elseif dir == "L" then
      direction = ((direction - 2) % 4) + 1
    end

    for _ = 1, dist do
      px = px + dirs[direction][1]
      py = py + dirs[direction][2]
    end
  end

  return math.abs(px) + math.abs(py)
end

function Solver:puzzle2(data_)
  local direction = 1
  local px, py = 0, 0
  local visited = { ["0,0"] = true }
  local result = 0
  local found = false

  for _, move in ipairs(data_) do
    local dir = move:sub(1, 1)
    local dist = tonumber(move:sub(2))

    if dir == "R" then
      direction = (direction % 4) + 1
    elseif dir == "L" then
      direction = ((direction - 2) % 4) + 1
    end

    for _ = 1, dist do
      px = px + dirs[direction][1]
      py = py + dirs[direction][2]
      local key = px .. "," .. py
      if visited[key] then
        result = math.abs(px) + math.abs(py)
        found = true
        break
      else
        visited[key] = true
      end
    end

    if found then
      break
    end
  end

  return result
end

local function main()
  print("Hello, Day 01!\n")

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
