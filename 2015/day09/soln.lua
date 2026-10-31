local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day09/data.txt"

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

function Solver:find_path(graph, start, unvisited, is_min)
  if #unvisited == 0 then
    return 0
  end

  local best = is_min and math.huge or -math.huge
  for i, city in ipairs(unvisited) do
    local new_unvisited = {}
    for j, c in ipairs(unvisited) do
      if i ~= j then
        table.insert(new_unvisited, c)
      end
    end
    local dist = graph[start][city] + self:find_path(graph, city, new_unvisited, is_min)
    if is_min then
      if dist < best then
        best = dist
      end
    else
      if dist > best then
        best = dist
      end
    end
  end

  return best
end

function Solver:puzzle1(data_)
  local graph = {}
  local city_set = {}

  for _, row in ipairs(data_) do
    local c1, c2, dist = row:match("(%w+) to (%w+) = (%d+)")
    dist = tonumber(dist)

    graph[c1] = graph[c1] or {}
    graph[c1][c2] = dist
    graph[c2] = graph[c2] or {}
    graph[c2][c1] = dist

    city_set[c1] = true
    city_set[c2] = true
  end

  local all_cities = {}
  for c in pairs(city_set) do
    table.insert(all_cities, c)
  end

  local min_dist = math.huge
  for i, city in ipairs(all_cities) do
    local unvisited = {}
    for j, c in ipairs(all_cities) do
      if i ~= j then
        table.insert(unvisited, c)
      end
    end
    local d = self:find_path(graph, city, unvisited, true)
    if d < min_dist then
      min_dist = d
    end
  end

  return min_dist
end

function Solver:puzzle2(data_)
  local graph = {}
  local city_set = {}

  for _, row in ipairs(data_) do
    local c1, c2, dist = row:match("(%w+) to (%w+) = (%d+)")
    dist = tonumber(dist)

    graph[c1] = graph[c1] or {}
    graph[c1][c2] = dist
    graph[c2] = graph[c2] or {}
    graph[c2][c1] = dist

    city_set[c1] = true
    city_set[c2] = true
  end

  local all_cities = {}
  for c in pairs(city_set) do
    table.insert(all_cities, c)
  end

  local max_dist = -math.huge
  for i, city in ipairs(all_cities) do
    local unvisited = {}
    for j, c in ipairs(all_cities) do
      if i ~= j then
        table.insert(unvisited, c)
      end
    end
    local d = self:find_path(graph, city, unvisited, false)
    if d > max_dist then
      max_dist = d
    end
  end

  return max_dist
end

local function main()
  print("Hello, Day 9!\n")

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
