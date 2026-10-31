local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day11/data.txt"

local Solver = {}
Solver.__index = Solver

function Solver.new()
  local self = setmetatable({}, Solver)
  self.alphabet = "abcdefghijklmnopqrstuvwxyz"
  return self
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

function Solver:next_passwd(passwd)
  local bytes = { string.byte(passwd, 1, #passwd) }
  local pos = #bytes
  while pos >= 1 do
    if bytes[pos] == 122 then -- 'z'
      bytes[pos] = 97 -- 'a'
      pos = pos - 1
    else
      bytes[pos] = bytes[pos] + 1
      break
    end
  end
  return string.char(table.unpack(bytes))
end

function Solver:is_valid(passwd)
  if passwd:find("[iol]") then
    return false
  end

  local pair_count = 0
  local i = 1
  local len = #passwd
  while i < len do
    if passwd:byte(i) == passwd:byte(i + 1) then
      pair_count = pair_count + 1
      i = i + 2
    else
      i = i + 1
    end
  end
  if pair_count < 2 then
    return false
  end

  local has_straight = false
  for j = 1, len - 2 do
    local b1 = passwd:byte(j)
    local b2 = passwd:byte(j + 1)
    local b3 = passwd:byte(j + 2)
    if b2 == b1 + 1 and b3 == b1 + 2 then
      has_straight = true
      break
    end
  end

  return has_straight
end

function Solver:get_valid_passwd(passwd)
  local cur = passwd
  while true do
    cur = self:next_passwd(cur)
    if self:is_valid(cur) then
      return cur
    end
  end
end

function Solver:puzzle1(data_)
  return 4
end

function Solver:puzzle2(data_)
  return 4
end

local function main()
  print("Hello, Day 11!\n")

  local solver = Solver.new()
  local data = solver:load_data(DATA_FILE)

  print(data)

  local passwd = solver:get_valid_passwd(data)
  print("passwd: " .. passwd)

  passwd = solver:get_valid_passwd(passwd)
  print("passwd: " .. passwd)

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
