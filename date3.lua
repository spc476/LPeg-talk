local dump = require "org.conman.table".dump
local lpeg = require "lpeg"
local Cmt  = lpeg.Cmt
local Cc   = lpeg.Cc
local Ct   = lpeg.Ct
local Cg   = lpeg.Cg
local C    = lpeg.C
local P    = lpeg.P
local R    = lpeg.R
local S    = lpeg.S

local wday = P"Sun" * Cc(1)
           + P"Mon" * Cc(2)
           + P"Tue" * Cc(3)
           + P"Wed" * Cc(4)
           + P"Thu" * Cc(5)
           + P"Fri" * Cc(6)
           + P"Sat" * Cc(7)

local month = P"Jan" * Cc( 1)
            + P"Feb" * Cc( 2)
            + P"Mar" * Cc( 3)
            + P"Apr" * Cc( 4)
            + P"May" * Cc( 5)
            + P"Jun" * Cc( 6)
            + P"Jul" * Cc( 7)
            + P"Aug" * Cc( 8)
            + P"Sep" * Cc( 9)
            + P"Oct" * Cc(10)
            + P"Nov" * Cc(11)
            + P"Dec" * Cc(12)

local function range(low,high)
  return function(subject,position,capture)
    local val = tonumber(capture)
    if val >= low and val <= high then
      return position,val
    end
  end
end

local day  = Cmt(R"09"^1,range(1,31))
local year = Cmt(R"09"^1,range(1970,2200))
local hour = Cmt(R"09"^1,range(0,23))
local min  = Cmt(R"09"^1,range(0,59))
local sec  = Cmt(R"09"^1,range(0,61))
local zone = (C(S"+-") * Cmt(R"09" * R"09",range(0,23)) * Cmt(R"09" * R"09",range(0,59)))
           / function(sign,hour,min)
               local tz = hour * 3600 + min * 60
               if sign == '-' then
                 return -tz
               else
                 return tz
               end
             end

local date     = Cg(wday,"wday")   * P", "
               * Cg(day,"day")     * P" "
               * Cg(month,"month") * P" "
               * Cg(year, "year")
local time     = Cg(hour,"hour") * P':'
               * Cg(min,"min")   * P":" 
               * Cg(sec,"sec")   * P" " 
               * Cg(zone,"zone")
local datetime = Ct(date * P" " * time)

dump("now",datetime:match "Wed, 2 Dec 2015 20:51:17 +0100")
dump("now",datetime:match "Wed, 31 Dec 2015 20:51:17 -0500")
