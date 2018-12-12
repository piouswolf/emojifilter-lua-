local emojicode = {}
local emojiMap = {}

local function split(str, reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList, w)
    end)

    return resultStrList
end

local function readlines()
	local file = io.open("./emoji.txt", "r")

	assert(file)

	local line

	while true do
		line = file:read("*l")

		if line then
			local space = string.find(line, " ")
			local sl = string.sub(line, 1, space-1)

			if sl then
				local codes = split(sl, "..")
				table.insert(emojicode, {s=codes[1], e=codes[#codes]})
			end
		else
			break
		end
	end

	file:close()
end

readlines()

for i=1, #emojicode, 1 do
	if emojicode[i].s ~= emojicode[i].e then
		local s = unicodeToNumber(emojicode[i].s)
		local e = unicodeToNumber(emojicode[i].e)

		for i=s, e do
			local code = string.format("%X", i)
			emojiMap[code] = true
		end
	else
		emojiMap[emojicode[i].s] = true
	end
end

--emojiMap can be save to file emoji.lua by your own way.
--coding ...
