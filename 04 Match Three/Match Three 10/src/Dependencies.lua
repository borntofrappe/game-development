-- require the libraries and files used throughout the game

-- push, to create a 'projection' giving the game a retro, pixelated look
push = require 'lib/push'
-- class, to work with classes
Class = require 'lib/class'
-- knife timer, to work with time-based events
Timer = require 'lib/timer'

-- constants specified in constants.lua
require 'src/constants'
-- functions detailed in Util.lua
require 'src/Util'
-- classes making up the game: board, tile
require 'src/Board'
require 'src/Tile'

-- state machine, allowing to transition, update and render the logic described in each state class
require 'src/StateMachine'
-- the different states
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/GameoverState'