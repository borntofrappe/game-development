PlayerLoseState = BaseState:new()

local PLAYER_ANIMATION_INTERVAL = 0.15
local GAME_STATE_DELAY = PLAYER_ANIMATION_INTERVAL * 10 + 1

function PlayerLoseState:new(player)
  player.currentAnimation = Animation:new({5, 1}, PLAYER_ANIMATION_INTERVAL)
  player.inPlay = false

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerLoseState:enter()
  Timer:after(
    GAME_STATE_DELAY,
    function()
      gStateStack:push(
        TransitionState:new(
          {
            ["callback"] = function()
              gStateStack:pop()
              gStateStack:push(TitleState:new())
            end
          }
        )
      )
    end
  )
end

function PlayerLoseState:update(dt)
  self.player.currentAnimation:update(dt)
end
