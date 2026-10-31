local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day06/data.txt"

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
  local rows = {}
  for line in file:lines() do
    if line ~= "" then
      table.insert(rows, line)
    end
  end
  file:close()
  return rows
end

function Solver:puzzle1(data_)
  local grid = {}
  for i = 0, 999999 do
    grid[i] = 0
  end

  for _, row in ipairs(data_) do
    local x1, y1, x2, y2 = row:match("(%d+),(%d+)%s+through%s+(%d+),(%d+)")
    x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)

    if row:sub(1, 7) == "turn on" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          grid[base + y] = 1
        end
      end
    elseif row:sub(1, 8) == "turn off" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          grid[base + y] = 0
        end
      end
    elseif row:sub(1, 6) == "toggle" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          local idx = base + y
          grid[idx] = grid[idx] ~ 1
        end
      end
    end
  end

  local sum = 0
  for i = 0, 999999 do
    sum = sum + grid[i]
  end

  return sum
end

function Solver:puzzle2(data_)
  local grid = {}
  for i = 0, 999999 do
    grid[i] = 0
  end

  for _, row in ipairs(data_) do
    local x1, y1, x2, y2 = row:match("(%d+),(%d+)%s+through%s+(%d+),(%d+)")
    x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)

    if row:sub(1, 7) == "turn on" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          local idx = base + y
          grid[idx] = grid[idx] + 1
        end
      end
    elseif row:sub(1, 8) == "turn off" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          local idx = base + y
          local v = grid[idx] - 1
          grid[idx] = v > 0 and v or 0
        end
      end
    elseif row:sub(1, 6) == "toggle" then
      for x = x1, x2 do
        local base = x * 1000
        for y = y1, y2 do
          local idx = base + y
          grid[idx] = grid[idx] + 2
        end
      end
    end
  end

  local sum = 0
  for i = 0, 999999 do
    sum = sum + grid[i]
  end

  return sum
end

local function main()
  print("Hello, Day 6!\n")

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
