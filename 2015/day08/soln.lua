local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day08/data.txt"

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
  local result = 0
  for _, row in ipairs(data_) do
    local code_len = #row
    local inner = row:sub(2, code_len - 1)
    local mem_len = 0
    local i = 1
    local len = #inner
    while i <= len do
      local c = inner:sub(i, i)
      if c == "\\" then
        local next_c = inner:sub(i + 1, i + 1)
        if next_c == "x" then
          mem_len = mem_len + 1
          i = i + 4
        else
          mem_len = mem_len + 1
          i = i + 2
        end
      else
        mem_len = mem_len + 1
        i = i + 1
      end
    end
    result = result + (code_len - mem_len)
  end
  return result
end

function Solver:puzzle2(data_)
  local result = 0
  for _, row in ipairs(data_) do
    local code_len = #row
    local extra = 2 -- for surrounding quotes
    for i = 1, code_len do
      local c = row:sub(i, i)
      if c == '"' or c == "\\" then
        extra = extra + 1
      end
    end
    result = result + extra
  end
  return result
end

local function main()
  print("Hello, Day 8!\n")

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
