PlayState = Class({__includes = BaseState})

function PlayState:init(pokemon)
  gSounds["field_music"]:play()

  self.level = Level()

  self.player =
    Player(
    {
      ["column"] = 3,
      ["row"] = 10,
      ["level"] = self.level,
      ["pokemon"] = pokemon,
      ["stateMachine"] = StateMachine(
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

function PlayState:exit()
  gSounds["field_music"]:pause()
end

function PlayState:update(dt)
  Timer.update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateStack:push(
      FadeState(
        {
          ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
          ["duration"] = 0.5,
          ["opacity"] = 1,
          ["callback"] = function()
            gStateStack:pop()
            gStateStack:push(StartState())
            gStateStack:push(
              FadeState(
                {
                  ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                  ["duration"] = 0.5,
                  ["opacity"] = 0,
                  ["callback"] = function()
                  end
                }
              )
            )
          end
        }
      )
    )
  end

  if love.keyboard.wasPressed("s") or love.keyboard.wasPressed("S") then
    self.player.sprite = math.random(#gFrames["entities"])
  end

  if love.keyboard.wasPressed("h") or love.keyboard.wasPressed("H") then
    self.player.pokemon.stats.hp = self.player.pokemon.baseStats.hp
    gSounds["heal"]:play()
    gStateStack:push(
      DialogueState(
        {
          ["chunks"] = {"Your pokemon has been healed.\nKeep on fighting!"}
        }
      )
    )
  end

  self.player:update(dt)
end

function PlayState:render()
  self.level:render()

  self.player:render()
end
