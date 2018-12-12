local emoji = require "emoji"
local emojiFilter = {}

local bitValue = {1, 2, 4, 8, 16, 32, 64, 128}

local function utf8Word(str, index)
	local len = string.len(str)
	local arr  = {0xfc, 0xf8, 0xf0, 0xe0, 0xc0, 0}
	local word

    if index <= len then
        if string.byte(str, index, index) >= arr[1] then
            word = string.sub(str, index, index + 5)
            index = index + 6
        elseif string.byte(str, index, index) >= arr[2] then
        	word = string.sub(str, index, index + 4)
            index = index + 5
        elseif string.byte(str, index, index) >= arr[3] then
        	word = string.sub(str, index, index + 3)
            index = index + 4
        elseif string.byte(str, index, index) >= arr[4] then
        	word = string.sub(str, index, index + 2)
            index = index + 3
        elseif string.byte(str, index, index) >= arr[5] then
        	word = string.sub(str, index, index + 1)
            index = index + 2
        else
        	word = string.sub(str, index, index)
            index = index + 1
        end
    end

    return word, index
end

local function numberToBinStr(x)
    local ret = ""

    while x ~= 1 and x ~= 0 do
        ret = tostring(x%2) .. ret
        x = math.modf(x/2)
    end

    ret = tostring(x) .. ret

    return ret
end

local function binToNum(bin)
	local len = string.len(bin)
	local num = 0
	for i=1, len do
		if "1" == string.sub(bin, len-i+1, len -i+1) then
			num = num + bitValue[i]
		end
	end

	return num
end

local function binToUnicode(bin)
	local len = string.len(bin)
	local bytes = math.ceil(len/8)
	local t = {}

	for i=1, bytes do
		local byte

		if i == bytes then
			if len % 8 ~= 0 then
				byte = string.sub(bin, 1, len % 8)
			else
				byte = string.sub(bin, 1, 8)
			end
		else
			byte = string.sub(bin, len - (i*8) + 1, len - (i*8) + 8)
		end

		table.insert(t, 1, byte)
	end

	local unicode = ""

	for i=1, #t do
		unicode = unicode .. string.format("%X", binToNum(t[i]))
	end

	return unicode
end

local function utf8WordToUnicode(word)
	local len = string.len(word)
	local t = {}

	for i=1, len do
		table.insert(t, numberToBinStr(string.byte(word, i)))
	end

	local bin = ""
	local ret = word
	if 2 <= #t then
		bin = string.sub(t[1], #t + 2)

		for i=2, #t do
			bin = bin .. string.sub(t[i], 3)
		end

		ret = binToUnicode(bin)
	else
		bin = t[1]
		ret = binToUnicode(bin)
	end

	return ret
end

function emojiFilter:trimEmoji(str)
	local ret = ""
	local len = string.len(str)
	local index = 1

	while index <= len do
		local word, i = utf8Word(str, index)

		if word then
			local unicode = utf8WordToUnicode(word)

			if not emoji[unicode] then
				ret = ret .. word
			end
		else
			break;
		end

		index = i
	end

	return ret
end

return emojiFilter
