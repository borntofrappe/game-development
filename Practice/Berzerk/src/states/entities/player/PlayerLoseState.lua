PlayerLoseState = BaseState:new()

local PLAYER_ANIMATION_INTERVAL = 0.15
local PLAY_STATE_DELAY = PLAYER_ANIMATION_INTERVAL * 10 + 1

function PlayerLoseState:new(player)
  player.currentAnimation = Animation:new({5, 1}, PLAYER_ANIMATION_INTERVAL)

  local this = {
    ["player"] = player,
    ["delay"] = PLAY_STATE_DELAY
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerLoseState:update(dt)
  self.player.currentAnimation:update(dt)

  self.delay = self.delay - dt
  if self.delay <= 0 then
    gStateStack:push(
      TransitionState:new(
        {
          ["callback"] = function()
            gStateStack:pop()
            gStateStack:push(PlayState:new())
          end
        }
      )
    )
  end
end
