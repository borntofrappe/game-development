push = require "res/lib/push"
Timer = require "res/lib/Timer"
require "res/lib/Animation"

require "src/constants"
require "src/Utils"

require "src/Ground"
require "src/Dino"
require "src/Cloud"
require "src/Cactus"
require "src/Bird"

require "src/StateMachine"
require "src/states/BaseState"

require "src/states/game/WaitingState"
require "src/states/game/PlayingState"
require "src/states/game/StoppedState"

require "src/states/dino/DinoIdleState"
require "src/states/dino/DinoRunningState"
require "src/states/dino/DinoJumpingState"
require "src/states/dino/DinoDuckingState"
require "src/states/dino/DinoStoppedState"
