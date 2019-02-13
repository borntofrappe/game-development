-- require the libraries and files used throughout the application


-- push, to create a 'projection' giving the game a retro, pixelated look
push = require 'lib/push'
-- class, to work with classes
Class = require 'lib/class'

-- constants.lua, storing a referencce to constant variables
require 'src/constants'

-- state machine, allowing to transition, update and render the logic described in each state class
require 'src/StateMachine'

-- util.lua, with utility functions to prominently generate quads
require 'src/Util'

-- paddke, with the logic for the paddle
require 'src/Paddle'


-- the different state classes
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
