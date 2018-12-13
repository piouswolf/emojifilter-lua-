local emojiFilter = require "emojiFilter"
local strWithEmoji = "Hello,❄World!";
local strTrimed = emojiFilter:trimEmoji(strWithEmoji);
print("strTrimed", strTrimed);

----------------------------printed------------------------------
--strTrimed Hello,World!
-----------------------------------------------------------------
