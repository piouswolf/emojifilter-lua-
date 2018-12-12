# emojifilter-lua-

All emojis' unicode codepoint(s):
https://unicode.org/Public/emoji/12.0/emoji-data.txt

Emoji.lua is a unabridged key-value codepoints table generated from parsing emoji-data.txt(excluding 0023/002A/0030..0039).
...
["2668"] = true, -- (♨️)       hot springs
["270F"] = true, -- (✏️)       pencil
...
So, a unicode codepoint(s) translated from a utf-8 word can be checked by the table.
