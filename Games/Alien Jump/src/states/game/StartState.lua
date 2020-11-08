StartState = Class {__includes = BaseState}

function StartState:init()
  self.player =
    Player(
    {
      ["stateMachine"] = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["jump"] = function()
            return PlayerJumpState(self.player)
          end,
          ["squat"] = function()
            return PlayerSquatState(self.player)
          end,
          ["walk"] = function()
            return PlayerWalkState(self.player)
          end
        }
      )
    }
  )

  self.player:changeState("idle")
end

function StartState:update(dt)
  if love.keyboard.wasPressed("return") then
    gStateStack:pop()
    gStateStack:push(
      ScrollState(
        {
          player = self.player
        }
      )
    )
  end
end

function StartState:render()
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][gBackgroundVariant], 0, 0)
  self.player:render()
end
