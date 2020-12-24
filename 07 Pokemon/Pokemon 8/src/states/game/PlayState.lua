PlayState = Class({__includes = BaseState})

function PlayState:init(pokemon)
  self.level = Level()

  self.player =
    Player(
    {
      column = 3,
      row = 10,
      level = self.level,
      pokemon = pokemon,
      stateMachine = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["walking"] = function()
            return PlayerWalkingState(self.player)
          end
        }
      )
    }
  )
  self.player:changeState("idle")
end

function PlayState:update(dt)
  Timer.update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateStack:push(
      FadeState(
        {
          color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
          duration = 0.5,
          opacity = 1,
          callback = function()
            gStateStack:pop()
            gStateStack:push(StartState())
            gStateStack:push(
              FadeState(
                {
                  color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                  duration = 0.5,
                  opacity = 0,
                  callback = function()
                  end
                }
              )
            )
          end
        }
      )
    )
  end

  if love.keyboard.wasPressed("h") or love.keyboard.wasPressed("H") then
    gStateStack:push(DialogueState("Your pokemon has been healed.\nKeep on fighting!"))
  end

  self.player:update(dt)
end

function PlayState:render()
  self.level:render()

  self.player:render()
end
