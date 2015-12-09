local lpeg = require "lpeg"
local P    = lpeg.P
local R    = lpeg.R
local S    = lpeg.S

local wday = P"Sun"
           + P"Mon"
           + P"Tue"
           + P"Wed"
           + P"Thu"
           + P"Fri"
           + P"Sat"

local month = P"Jan"
            + P"Feb"
            + P"Mar"
            + P"Apr"
            + P"May"
            + P"Jun"
            + P"Jul"
            + P"Aug"
            + P"Sep"
            + P"Oct"
            + P"Nov"
            + P"Dec"

local day  = R"09" * R"09"^-1
local year = R"09" * R"09" * R"09" * R"09"
local hour = R"09" * R"09"
local min  = R"09" * R"09"
local sec  = R"09" * R"09"
local zone = S"+-" * R"09" * R"09" * R"09" * R"09"

local date     = wday * P", " * day * P" " * month * P" " * year
local time     = hour * P':'  * min * P":" * sec   * P" " * zone
local datetime = date * P" "  * time

print(datetime:match "Wed, 2 Dec 2015 20:51:17 +0100")
print(datetime:match "Wed, 99 Dec 9999 99:99:99 -9999")
print(datetime:match "Wed 2 Dec 2015 20:51:17 EST")
