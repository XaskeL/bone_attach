-- Default
ENABLED_CONTINUE_FRAME = false -- Frame skipping, will be updated through the frame
DIVISION_ARRAY = 4 -- Processing fragment frames

-- LOW PERFORMANCE [x1]
-- ENABLED_CONTINUE_FRAME = false -- Frame skipping, will be updated through the frame
-- DIVISION_ARRAY = 8 -- Processing fragment frames

-- LOW PERFORMANCE [x2]
-- ENABLED_CONTINUE_FRAME = false -- Frame skipping, will be updated through the frame
-- DIVISION_ARRAY = 4 -- Processing fragment frames

-- MEDIUM PERFORMANCE [x1]
-- ENABLED_CONTINUE_FRAME = true -- Frame skipping, will be updated through the frame
-- DIVISION_ARRAY = 1 -- Processing fragment frames

-- MEDIUM PERFORMANCE [x2]
-- ENABLED_CONTINUE_FRAME = false -- Frame skipping, will be updated through the frame
-- DIVISION_ARRAY = 2 -- Processing fragment frames

-- HIGH PERFORMANCE [x1]
-- ENABLED_CONTINUE_FRAME = false -- Frame skipping, will be updated through the frame
-- DIVISION_ARRAY = 1 -- Processing fragment frames

--------------------------------------------------------
-------------------- DISCLAIMER ------------------------
--------------------------------------------------------

-- Make settings suitable for your maximum FPS. 
-- The lower the maximum FPS, the less onClientPreRender will be updated and the less load will be / but the number of artifacts with twitching will increase. 
-- Also try different settings with CPU load.
-- You can also dynamically change the settings for the player’s PC.
-- I tried to achieve load distribution and smooth frametime graphics so that the game was as smooth and enjoyable as possible.
-- Since it is not the FPS that determines the smoothness of the game, but an even frametime graph