local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2016/day02/data.txt"

local dirs = {
  U = { 0, 1 },
  D = { 0, -1 },
  L = { -1, 0 },
  R = { 1, 0 },
}

local buttons_1 = {
  ["-1,1"] = "1",
  ["0,1"] = "2",
  ["1,1"] = "3",
  ["-1,0"] = "4",
  ["0,0"] = "5",
  ["1,0"] = "6",
  ["-1,-1"] = "7",
  ["0,-1"] = "8",
  ["1,-1"] = "9",
}

local buttons_2 = {
  ["0,2"] = "1",
  ["-1,1"] = "2",
  ["0,1"] = "3",
  ["1,1"] = "4",
  ["-2,0"] = "5",
  ["-1,0"] = "6",
  ["0,0"] = "7",
  ["1,0"] = "8",
  ["2,0"] = "9",
  ["-1,-1"] = "A",
  ["0,-1"] = "B",
  ["1,-1"] = "C",
  ["0,-2"] = "D",
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
  local px, py = 0, 0
  local result = {}

  for _, line in ipairs(data_) do
    for i = 1, #line do
      local c = line:sub(i, i)
      local d = dirs[c]
      if d then
        local nx = px + d[1]
        local ny = py + d[2]
        if buttons_1[nx .. "," .. ny] then
          px = nx
          py = ny
        end
      end
    end
    table.insert(result, buttons_1[px .. "," .. py])
  end

  local code = table.concat(result)
  return code
end

function Solver:puzzle2(data_)
  local px, py = -2, 0
  local result = {}

  for _, line in ipairs(data_) do
    for i = 1, #line do
      local c = line:sub(i, i)
      local d = dirs[c]
      if d then
        local nx = px + d[1]
        local ny = py + d[2]
        if buttons_2[nx .. "," .. ny] then
          px = nx
          py = ny
        end
      end
    end
    table.insert(result, buttons_2[px .. "," .. py])
  end

  local code = table.concat(result)
  return code
end

local function main()
  print("Hello, Day 02!\n")

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
