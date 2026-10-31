local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day07/data.txt"

local Solver = {}
Solver.__index = Solver

function Solver.new()
  local self = setmetatable({}, Solver)
  self.memo = {}
  return self
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

function Solver:rec_circuit(graph, wire)
  if self.memo[wire] ~= nil then
    return self.memo[wire]
  end

  local num = tonumber(wire)
  if num ~= nil then
    self.memo[wire] = num & 0xFFFF
    return self.memo[wire]
  end

  local rule = graph[wire]
  if not rule then
    error("Unknown wire: " .. tostring(wire))
  end

  local result = 0
  local op = rule.op

  if op == "ASSIGN" then
    result = self:rec_circuit(graph, rule.arg1)
  elseif op == "NOT" then
    local x = self:rec_circuit(graph, rule.arg1)
    result = (~x) & 0xFFFF
  elseif op == "AND" then
    local x = self:rec_circuit(graph, rule.arg1)
    local y = self:rec_circuit(graph, rule.arg2)
    result = (x & y) & 0xFFFF
  elseif op == "OR" then
    local x = self:rec_circuit(graph, rule.arg1)
    local y = self:rec_circuit(graph, rule.arg2)
    result = (x | y) & 0xFFFF
  elseif op == "LSHIFT" then
    local x = self:rec_circuit(graph, rule.arg1)
    local y = self:rec_circuit(graph, rule.arg2)
    result = (x << y) & 0xFFFF
  elseif op == "RSHIFT" then
    local x = self:rec_circuit(graph, rule.arg1)
    local y = self:rec_circuit(graph, rule.arg2)
    result = (x >> y) & 0xFFFF
  end

  self.memo[wire] = result
  return result
end

function Solver:build_graph(data_)
  local graph = {}
  for _, row in ipairs(data_) do
    local parts = {}
    for part in row:gmatch("%S+") do
      table.insert(parts, part)
    end

    if #parts == 3 then
      graph[parts[3]] = { op = "ASSIGN", arg1 = parts[1] }
    elseif #parts == 4 then
      graph[parts[4]] = { op = "NOT", arg1 = parts[2] }
    elseif #parts == 5 then
      graph[parts[5]] = { op = parts[2], arg1 = parts[1], arg2 = parts[3] }
    end
  end
  return graph
end

function Solver:puzzle1(data_)
  local graph = self:build_graph(data_)
  self.memo = {}
  local signale = self:rec_circuit(graph, "a")
  self.memo = {}
  return signale
end

function Solver:puzzle2(data_)
  local graph = self:build_graph(data_)
  self.memo = {}
  local a_val = self:rec_circuit(graph, "a")
  self.memo = {}
  graph["b"] = { op = "ASSIGN", arg1 = tostring(a_val) }
  local signale = self:rec_circuit(graph, "a")
  self.memo = {}
  return signale
end

local function main()
  print("Hello, Day 7!\n")

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
