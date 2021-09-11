EnemyExplodingState = BaseState:new()

local ENEMY_IN_PLAY_DELAY = 0.5

function EnemyExplodingState:new(enemy)
  local this = {
    ["enemy"] = enemy
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function EnemyExplodingState:enter(params)
  local numberFrames = params and params.numberFrames or #self.enemy.currentAnimation.frames
  self.enemy.currentAnimation.interval = ENEMY_IN_PLAY_DELAY / numberFrames

  Timer:after(
    ENEMY_IN_PLAY_DELAY,
    function()
      self.enemy.inPlay = false
    end
  )
end

function EnemyExplodingState:update(dt)
  self.enemy.currentAnimation:update(dt)

  if self.enemy.level.player.inPlay and self.enemy:collides(self.enemy.level.player) then
    self.enemy.level.player:changeState("lose")
  end
end
