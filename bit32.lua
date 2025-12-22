bit32 = {}
local N = 32
local P = 2 ^ N

bit32.bnot = function(x)
    x = x % P
    return (P - 1) - x
end

bit32.band = function(x, y)
    if y == 255 then return x % 256 end
    if y == 65535 then return x % 65536 end
    if y == 4294967295 then return x % 4294967296 end
    x, y = x % P, y % P
    local r, p = 0, 1
    for i = 1, N do
        local a, b = x % 2, y % 2
        x, y = math.floor(x / 2), math.floor(y / 2)
        if a + b == 2 then r = r + p end
        p = p * 2
    end
    return r
end

bit32.bor = function(x, y)
    if y == 255 then return (x - (x % 256)) + 255 end
    if y == 65535 then return (x - (x % 65536)) + 65535 end
    if y == 4294967295 then return 4294967295 end
    x, y = x % P, y % P
    local r, p = 0, 1
    for i = 1, N do
        local a, b = x % 2, y % 2
        x, y = math.floor(x / 2), math.floor(y / 2)
        if a + b >= 1 then r = r + p end
        p = p * 2
    end
    return r
end

bit32.bxor = function(x, y)
    x, y = x % P, y % P
    local r, p = 0, 1
    for i = 1, N do
        local a, b = x % 2, y % 2
        x, y = math.floor(x / 2), math.floor(y / 2)
        if a + b == 1 then r = r + p end
        p = p * 2
    end
    return r
end

bit32.btest = function(x, y)
    return bit32.band(x, y) ~= 0
end

bit32.lshift = function(x, s)
    if math.abs(s) >= N then return 0 end
    x = x % P
    if s < 0 then return math.floor(x * (2 ^ s)) else return (x * (2 ^ s)) % P end
end

bit32.rshift = function(x, s)
    if math.abs(s) >= N then return 0 end
    x = x % P
    if s > 0 then return math.floor(x * (2 ^ -s)) else return (x * (2 ^ -s)) % P end
end

bit32.arshift = function(x, s)
    if math.abs(s) >= N then return 0 end
    x = x % P
    if s > 0 then
        local add = 0
        if x >= (P / 2) then add = P - (2 ^ (N - s)) end
        return math.floor(x * (2 ^ -s)) + add
    else
        return (x * (2 ^ -s)) % P
    end
end

bit32.lrotate = function(x, s)
    x = x % P
    s = s % N
    return ((bit32.lshift(x, s)) + bit32.rshift(x, N - s)) % P
end

bit32.rrotate = function(x, s)
    x = x % P
    s = s % N
    return ((bit32.rshift(x, s)) + bit32.lshift(x, N - s)) % P
end

bit32.byteswap = function(x)
    x = x % P
    return ((x % 256) * 16777216) + (((math.floor(x / 256)) % 256) * 65536) + (((math.floor(x / 65536)) % 256) * 256) + ((math.floor(x / 16777216)) % 256)
end

bit32.countlz = function(x)
    x = x % P
    if x == 0 then return N end
    local c = 0
    for i = N - 1, 0, -1 do
        if math.floor(x / (2 ^ i)) % 2 == 0 then c = c + 1 else break end
    end
    return c
end

bit32.countrz = function(x)
    x = x % P
    if x == 0 then return N end
    local c = 0
    for i = 0, N - 1 do
        if math.floor(x / (2 ^ i)) % 2 == 0 then c = c + 1 else break end
    end
    return c
end

bit32.extract = function(n, field, width)
    width = width or 1
    n = n % P
    return math.floor(n / (2 ^ field)) % (2 ^ width)
end

bit32.replace = function(n, v, field, width)
    width = width or 1
    n = n % P
    v = v % (2 ^ width)
    return (n - (math.floor(n / (2 ^ field)) % (2 ^ width)) * (2 ^ field)) + (v * (2 ^ field))
end
