local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day05/data.txt"

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
    if not (row:find("ab") or row:find("cd") or row:find("pq") or row:find("xy")) then
      local _, vcount = row:gsub("[aeiou]", "")
      if vcount >= 3 then
        local double_letter = false
        for i = 1, #row - 1 do
          if row:byte(i) == row:byte(i + 1) then
            double_letter = true
            break
          end
        end
        if double_letter then
          sum = sum + 1
        end
      end
    end
  end
  return sum
end

function Solver:puzzle2(data_)
  local sum = 0
  for _, row in ipairs(data_) do
    local pair_twice = false
    local len = #row
    for i = 1, len - 3 do
      local pair = row:sub(i, i + 1)
      if row:find(pair, i + 2, true) then
        pair_twice = true
        break
      end
    end
    if pair_twice then
      local repeat_between = false
      for i = 1, len - 2 do
        if row:byte(i) == row:byte(i + 2) then
          repeat_between = true
          break
        end
      end
      if repeat_between then
        sum = sum + 1
      end
    end
  end
  return sum
end

local function main()
  print("Hello, Day 5!\n")

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
