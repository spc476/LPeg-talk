-- **********************************************************************
-- 
-- Copyright 2015 by Sean Conner.  All Rights Reserved.
-- 
-- This program is free software: you can redistribute it and/or modify    
-- it under the terms of the GNU General Public License as published by 
-- the Free Software Foundation, either version 3 of the License, or 
-- any later version.                  
-- 
-- This program is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of 
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
-- GNU General Public License for more details. 
-- 
-- You should have received a copy of the GNU General Public License 
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. 
--
-- Comments, questions and criticisms can be sent to: sean@conman.org
--
-- **********************************************************************

local lpeg = require "lpeg"
local Cmt  = lpeg.Cmt
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

local function range(low,high)
  return function(subject,position,capture)
    local val = tonumber(capture)
    if val >= low and val <= high then
      return position
    end
  end
end

local day  = Cmt(R"09"^1,range(1,31))
local year = Cmt(R"09"^1,range(1970,2200))
local hour = Cmt(R"09"^1,range(0,23))
local min  = Cmt(R"09"^1,range(0,59))
local sec  = Cmt(R"09"^1,range(0,61))
local zone = S"+-" * Cmt(R"09" * R"09",range(0,23)) * Cmt(R"09" * R"09",range(0,59))

local date     = wday * P", " * day * P" " * month * P" " * year
local time     = hour * P':'  * min * P":" * sec   * P" " * zone
local datetime = date * P" "  * time

print(datetime:match "Wed, 2 Dec 2015 20:51:17 +0100")
print(datetime:match "Wed, 31 Dec 2015 20:51:17 +0100")
print(datetime:match "Thu, 32 Dec 2015 20:51:17 +0100")
print(datetime:match "Wed, 99 Dec 9999 99:99:99 -9999")
print(datetime:match "Wed 2 Dec 2015 20:51:17 EST")
