BattleMenuState = Class({__includes = BaseState})

function BattleMenuState:init(def)
  self.player = def.player

  self.playerPokemon = def.playerPokemon
  self.wildPokemon = def.wildPokemon

  self.playerPokemonHealth = def.playerPokemonHealth
  self.playerPokemonExp = def.playerPokemonExp
  self.wildPokemonHealth = def.wildPokemonHealth

  self.isPlayerFaster = self.playerPokemon.stats.speed >= self.wildPokemon.stats.speed

  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.selection =
    Selection(
    {
      ["options"] = {
        {
          ["text"] = "Fight",
          ["callback"] = function()
            if self.isPlayerFaster then
              gStateStack:push(
                BattleTurnState(
                  {
                    ["player"] = self.player,
                    ["p1"] = self.playerPokemon,
                    ["p2"] = self.wildPokemon,
                    ["p1Health"] = self.playerPokemonHealth,
                    ["p2Health"] = self.wildPokemonHealth,
                    ["pExp"] = self.playerPokemonExp
                  }
                )
              )
            else
              gStateStack:push(
                BattleTurnState(
                  {
                    ["player"] = self.player,
                    ["p1"] = self.wildPokemon,
                    ["p2"] = self.playerPokemon,
                    ["p1Health"] = self.wildPokemonHealth,
                    ["p2Health"] = self.playerPokemonHealth,
                    ["pExp"] = self.playerPokemonExp
                  }
                )
              )
            end
          end
        },
        {
          ["text"] = "Run",
          ["callback"] = function()
            gStateStack:push(
              BattleMessageState(
                {
                  ["chunks"] = {"You ran away safely."},
                  ["callback"] = function()
                    gStateStack:push(
                      FadeState(
                        {
                          ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                          ["duration"] = 0.5,
                          ["opacity"] = 1,
                          ["callback"] = function()
                            gStateStack:pop()
                            self.callback()
                            gStateStack:push(
                              FadeState(
                                {
                                  ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                  ["duration"] = 0.5,
                                  ["opacity"] = 0
                                }
                              )
                            )
                          end
                        }
                      )
                    )
                  end
                }
              )
            )
          end
        }
      },
      ["option"] = 1
    }
  )
end

function BattleMenuState:update(dt)
  Timer.update(dt)
  self.selection:update(dt)
end

function BattleMenuState:render()
  self.selection:render()
end
