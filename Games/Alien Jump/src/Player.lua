Player = Class {}

function Player:init(def)
  self.x = def.x or 8
  self.y = def.y or VIRTUAL_HEIGHT - ALIEN_HEIGHT
  self.width = ALIEN_WIDTH
  self.height = ALIEN_HEIGHT

  self.dy = 0

  self.sprite = def.sprite or 1
  self.stateMachine =
    def.stateMachine or
    StateMachine(
      {
        ["idle"] = function()
          return PlayerIdleState(self.player)
        end
      }
    )
  self.stateStack = def.stateStack
  self.currentAnimation = ALIEN_ANIMATION["idle"]
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:changeState(state, params)
  self.stateMachine:change(state, params)
end

function Player:render()
  love.graphics.draw(
    gTextures["alien"],
    gQuads["alien"][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x),
    math.floor(self.y)
  )
end
