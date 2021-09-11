Player = Entity:new()

function Player:new(x, y, level)
  local this = {
    ["direction"] = "right",
    ["projectiles"] = {},
    ["inPlay"] = true
  }

  local def = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = SPRITE_SIZE,
    ["height"] = SPRITE_SIZE,
    ["quads"] = "player",
    ["level"] = level
  }

  local stateMachine =
    StateMachine:new(
    {
      ["idle"] = function()
        return PlayerIdleState:new(this)
      end,
      ["walk"] = function()
        return PlayerWalkingState:new(this)
      end,
      ["shoot"] = function()
        return PlayerShootingState:new(this)
      end,
      ["lose"] = function()
        return PlayerLoseState:new(this)
      end
    }
  )

  stateMachine:change("idle")
  def.stateMachine = stateMachine

  Entity.init(this, def)

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  Entity.update(self, dt)

  for k, projectile in pairs(self.projectiles) do
    projectile:update(dt)
    for j, enemy in pairs(self.level.enemies) do
      if enemy.inPlay and projectile:collides(enemy) then
        enemy:changeState("explode")
        projectile.inPlay = false
        break
      end
    end

    for j, wall in pairs(self.level.walls) do
      if projectile:collides(wall) then
        projectile.inPlay = false
        break
      end
    end

    if not projectile.inPlay then
      table.remove(self.projectiles, k)
    end
  end
end

function Player:render()
  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTexture,
    gQuads[self.quads][self.currentAnimation:getCurrentFrame()],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x) + self.width,
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
