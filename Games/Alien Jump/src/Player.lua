Player = Class {}

function Player:init(def)
  self.width = ALIEN_WIDTH
  self.height = ALIEN_HEIGHT

  self.x = def.x or 8
  self.y = def.y or VIRTUAL_HEIGHT - self.height

  self.dy = 0

  self.stateMachine =
    def.stateMachine or
    StateMachine(
      {
        ["idle"] = function()
          return PlayerIdleState(self.player)
        end
      }
    )

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
    gTextures[gAlienVariant .. "_alien"],
    gQuads[gAlienVariant .. "_alien"][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x),
    math.floor(self.y)
  )
end
