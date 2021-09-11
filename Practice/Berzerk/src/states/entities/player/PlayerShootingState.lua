PlayerShootingState = BaseState:new()

local PLAYER_STATE_DELAY = 0.15

function PlayerShootingState:new(player)
  player.currentAnimation = Animation:new({4}, 1)

  local this = {
    ["player"] = player
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayerShootingState:enter()
  local projectile = Projectile:new(self.player)
  table.insert(self.player.projectiles, projectile)

  Timer:after(
    PLAYER_STATE_DELAY,
    function()
      if
        love.keyboard.isDown("left") or love.keyboard.isDown("right") or love.keyboard.isDown("up") or
          love.keyboard.isDown("down")
       then
        self.player:changeState("walk")
      else
        self.player:changeState("idle")
      end
    end
  )
end
