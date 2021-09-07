push = require "res/lib/push"
Timer = require "res/lib/Timer"
require "res/lib/Animation"

require "src/constants"
require "src/Utils"

require "src/Entity"
require "src/Player"
require "src/Enemy"

require "src/StateMachine"
require "src/states/BaseState"

require "src/states/game/TitleState"

require "src/states/entities/player/PlayerIdleState"
require "src/states/entities/player/PlayerWalkingState"
require "src/states/entities/player/PlayerShootingState"
require "src/states/entities/player/PlayerGameoverState"

require "src/states/entities/enemy/EnemyIdleState"
require "src/states/entities/enemy/EnemyWalkingState"
