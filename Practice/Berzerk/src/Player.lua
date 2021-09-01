Player = {}

function Player:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = SPRITE_SIZE,
    ["direction"] = "left"
  }

  local stateMachine =
    gStateMachine:new(
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
      ["gameover"] = function()
        return PlayerGameoverState:new(this)
      end
    }
  )

  stateMachine:change("idle")

  this.stateMachine = stateMachine

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:changeState(state, params)
  self.stateMachine:change(state, params)
end

function Player:render()
  love.graphics.draw(
    gTexture,
    gQuads.player[self.currentAnimation:getCurrentFrame()],
    self.direction == "right" and self.x or self.x + self.size,
    self.y,
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
