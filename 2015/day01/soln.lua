local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day01/data.txt"

local function load_data(filename)
  local file = io.open(filename, "r") or io.open("data.txt", "r")
  if not file then
    error("File not found: " .. filename)
  end
  local content = file:read("*a")
  file:close()
  return content
end

local function puzzle1(data_)
  local sum = 0
  for i = 1, #data_ do
    local c = data_:sub(i, i)
    if c == "(" then
      sum = sum + 1
    elseif c == ")" then
      sum = sum - 1
    end
  end
  return sum
end

local function puzzle2(data_)
  local sum = 0
  for i = 1, #data_ do
    local c = data_:sub(i, i)
    if c == "(" then
      sum = sum + 1
    else
      sum = sum - 1
    end
    if sum == -1 then
      return i
    end
  end
  return sum
end

local function main()
  print("Hello, Day 1!\n")

  local data = load_data(DATA_FILE)

  local res1 = puzzle1(data)
  local t1 = bench(function()
    puzzle1(data)
  end)
  print(string.format("part 1: %s, min: %s us, median: %s us", res1, t1.min, t1.median))

  local res2 = puzzle2(data)
  local t2 = bench(function()
    puzzle2(data)
  end)
  print(string.format("part 2: %s, min: %s us, median: %s us", res2, t2.min, t2.median))

  print("\nfin")
end

main()
