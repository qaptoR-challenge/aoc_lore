local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day10/data.txt"

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
  return content
end

function Solver:look_and_say(data, iter)
  local current = data
  for _ = 1, iter do
    local out = {}
    local len = #current
    local i = 1
    while i <= len do
      local b = current:byte(i)
      local j = i + 1
      while j <= len and current:byte(j) == b do
        j = j + 1
      end
      local count = j - i
      table.insert(out, tostring(count))
      table.insert(out, string.char(b))
      i = j
    end
    current = table.concat(out)
  end
  return current
end

function Solver:puzzle1(data_)
  local result = self:look_and_say(data_, 40)
  return #result
end

function Solver:puzzle2(data_)
  local result = self:look_and_say(data_, 50)
  return #result
end

local function main()
  print("Hello, Day 10!\n")

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
