local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day02/data.txt"

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
  local sum = 0
  for _, row in ipairs(data_) do
    local l, w, h = row:match("(%d+)x(%d+)x(%d+)")
    l, w, h = tonumber(l), tonumber(w), tonumber(h)
    local s1 = l * w
    local s2 = w * h
    local s3 = h * l
    local min_side = math.min(s1, math.min(s2, s3))
    sum = sum + 2 * s1 + 2 * s2 + 2 * s3 + min_side
  end
  return sum
end

function Solver:puzzle2(data_)
  local sum = 0
  for _, row in ipairs(data_) do
    local l, w, h = row:match("(%d+)x(%d+)x(%d+)")
    l, w, h = tonumber(l), tonumber(w), tonumber(h)
    local p1 = 2 * (l + w)
    local p2 = 2 * (w + h)
    local p3 = 2 * (h + l)
    local min_perim = math.min(p1, math.min(p2, p3))
    local bow = l * w * h
    sum = sum + min_perim + bow
  end
  return sum
end

local function main()
  print("Hello, Day 2!\n")

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
