
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

