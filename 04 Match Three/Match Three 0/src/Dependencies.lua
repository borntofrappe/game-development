-- require the libraries and files used throughout the application

-- push, to create a 'projection' giving the game a retro, pixelated look
push = require 'lib/push'
-- class, to work with classes
Class = require 'lib/class'
-- knife, to work with time-based events
Timer = require 'lib/timer'

-- constants specified in constants.lua
require 'src/constants'

-- functions detailed in Util.lua
require 'src/Util'

-- board class
require 'src/Board'
require 'src/Tile'
