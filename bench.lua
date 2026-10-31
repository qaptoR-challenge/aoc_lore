local socket = require("socket")

local M = {}

function M.getms()
  return math.floor(socket.gettime() * 1000)
end

function M.getus()
  return math.floor(socket.gettime() * 1000000)
end

function M.bench(callable, reps, warmup_ms)
  warmup_ms = warmup_ms or 100
  reps = reps or 10
  if warmup_ms > 0 then
    local start_warmup = M.getms()
    while M.getms() - start_warmup < warmup_ms do
    end
  end
  callable()
  local times = {}
  local sum_us = 0
  for _ = 1, reps do
    local t0 = M.getus()
    callable()
    local t1 = M.getus()
    local dt = t1 - t0
    table.insert(times, dt)
    sum_us = sum_us + dt
  end
  table.sort(times)
  local min_val = times[1]
  local max_val = times[#times]
  local median_val
  if #times % 2 == 1 then
    median_val = times[math.floor(#times / 2) + 1]
  else
    local m1 = times[#times // 2]
    local m2 = times[#times // 2 + 1]
    median_val = (m1 + m2) / 2
    if median_val == math.floor(median_val) then
      median_val = math.floor(median_val)
    end
  end
  local mean_val = sum_us / reps
  return {
    min = min_val,
    median = median_val,
    mean = mean_val,
    max = max_val,
    reps = reps,
  }
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.bench(...)
  end,
})
