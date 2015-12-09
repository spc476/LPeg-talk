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

os.setlocale("se_NO.UTF-8")

timef = require "strftime"

test    = [[%A, %d %B %Y @ %H:%M:%S]]
pattern = timef:match(test)

now    = os.time() - 86400
nowstr = os.date(test,now)

print(now)
print(nowstr)

x = pattern:match(nowstr)

for name,value in pairs(x) do
  print(name,value)
end

