
local script_dir = debug.getinfo(1, "S").source:match("^@?(.*[/\\])") or "./"
package.path = script_dir .. "../../?.lua;" .. script_dir .. "../?.lua;./?.lua;" .. package.path
local bench = require("bench")

local DATA_FILE = "2015/day04/data.txt"

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

local function mine(seed, zeros)
    local mask = zeros == 5 and 0xf0ffff or 0xffffff
    local buf = {}
    for i = 0, 63 do buf[i] = 0 end
    local seed_len = #seed
    for i = 1, seed_len do buf[i - 1] = string.byte(seed, i) end
    
    local m0 = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24)
    local m1 = buf[4] | (buf[5] << 8) | (buf[6] << 16) | (buf[7] << 24)
    local m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m15 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    local rot = 0

    local num = 1
    while true do
        local n = num
        local pos = seed_len
        local start_pos = pos
        while n > 0 do
            buf[pos] = 48 + (n % 10)
            n = n // 10
            pos = pos + 1
        end
        local p1 = start_pos
        local p2 = pos - 1
        while p1 < p2 do
            local tmp = buf[p1]; buf[p1] = buf[p2]; buf[p2] = tmp
            p1 = p1 + 1; p2 = p2 - 1
        end
        buf[pos] = 0x80
        local m14 = pos * 8
        local m2 = buf[8] | (buf[9] << 8) | (buf[10] << 16) | (buf[11] << 24)
        local m3 = buf[12] | (buf[13] << 8) | (buf[14] << 16) | (buf[15] << 24)
        buf[pos] = 0

        local a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xd76aa478 + m0) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 7) | (rot >> 25)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xe8c7b756 + m1) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 12) | (rot >> 20)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x242070db + m2) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 17) | (rot >> 15)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xc1bdceee + m3) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 22) | (rot >> 10)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xf57c0faf + m4) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 7) | (rot >> 25)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x4787c62a + m5) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 12) | (rot >> 20)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xa8304613 + m6) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 17) | (rot >> 15)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xfd469501 + m7) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 22) | (rot >> 10)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x698098d8 + m8) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 7) | (rot >> 25)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x8b44f7af + m9) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 12) | (rot >> 20)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xffff5bb1 + m10) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 17) | (rot >> 15)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x895cd7be + m11) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 22) | (rot >> 10)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x6b901122 + m12) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 7) | (rot >> 25)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xfd987193 + m13) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 12) | (rot >> 20)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0xa679438e + m14) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 17) | (rot >> 15)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((b & c) | ((~b & 0xffffffff) & d)) + 0x49b40821 + m15) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 22) | (rot >> 10)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xf61e2562 + m1) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 5) | (rot >> 27)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xc040b340 + m6) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 9) | (rot >> 23)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x265e5a51 + m11) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 14) | (rot >> 18)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xe9b6c7aa + m0) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 20) | (rot >> 12)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xd62f105d + m5) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 5) | (rot >> 27)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x2441453 + m10) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 9) | (rot >> 23)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xd8a1e681 + m15) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 14) | (rot >> 18)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xe7d3fbc8 + m4) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 20) | (rot >> 12)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x21e1cde6 + m9) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 5) | (rot >> 27)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xc33707d6 + m14) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 9) | (rot >> 23)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xf4d50d87 + m3) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 14) | (rot >> 18)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x455a14ed + m8) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 20) | (rot >> 12)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xa9e3e905 + m13) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 5) | (rot >> 27)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0xfcefa3f8 + m2) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 9) | (rot >> 23)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x676f02d9 + m7) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 14) | (rot >> 18)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + ((d & b) | ((~d & 0xffffffff) & c)) + 0x8d2a4c8a + m12) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 20) | (rot >> 12)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xfffa3942 + m5) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 4) | (rot >> 28)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x8771f681 + m8) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 11) | (rot >> 21)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x6d9d6122 + m11) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 16) | (rot >> 16)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xfde5380c + m14) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 23) | (rot >> 9)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xa4beea44 + m1) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 4) | (rot >> 28)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x4bdecfa9 + m4) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 11) | (rot >> 21)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xf6bb4b60 + m7) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 16) | (rot >> 16)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xbebfbc70 + m10) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 23) | (rot >> 9)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x289b7ec6 + m13) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 4) | (rot >> 28)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xeaa127fa + m0) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 11) | (rot >> 21)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xd4ef3085 + m3) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 16) | (rot >> 16)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x4881d05 + m6) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 23) | (rot >> 9)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xd9d4d039 + m9) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 4) | (rot >> 28)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xe6db99e5 + m12) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 11) | (rot >> 21)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0x1fa27cf8 + m15) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 16) | (rot >> 16)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (b ~ c ~ d) + 0xc4ac5665 + m2) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 23) | (rot >> 9)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xf4292244 + m0) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 6) | (rot >> 26)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x432aff97 + m7) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 10) | (rot >> 22)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xab9423a7 + m14) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 15) | (rot >> 17)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xfc93a039 + m5) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 21) | (rot >> 11)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x655b59c3 + m12) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 6) | (rot >> 26)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x8f0ccc92 + m3) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 10) | (rot >> 22)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xffeff47d + m10) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 15) | (rot >> 17)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x85845dd1 + m1) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 21) | (rot >> 11)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x6fa87e4f + m8) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 6) | (rot >> 26)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xfe2ce6e0 + m15) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 10) | (rot >> 22)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xa3014314 + m6) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 15) | (rot >> 17)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x4e0811a1 + m13) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 21) | (rot >> 11)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xf7537e82 + m4) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 6) | (rot >> 26)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xbd3af235 + m11) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 10) | (rot >> 22)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0x2ad7d2bb + m2) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 15) | (rot >> 17)) & 0xffffffff)) & 0xffffffff, b, c
        rot = (a + (c ~ (b | (~d & 0xffffffff))) + 0xeb86d391 + m9) & 0xffffffff
        a, b, c, d = d, (b + (((rot << 21) | (rot >> 11)) & 0xffffffff)) & 0xffffffff, b, c
        local h0 = (0x67452301 + a) & 0xffffffff
        if (h0 & mask) == 0 then
            return num
        end
        num = num + 1
    end
end

function Solver:puzzle1(data_)
    return mine(data_, 5)
end

function Solver:puzzle2(data_)
    return mine(data_, 6)
end

local function main()
    print("Hello, Day 4!\n")

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
