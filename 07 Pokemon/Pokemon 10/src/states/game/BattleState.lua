BattleState = Class({__includes = BaseState})

function BattleState:init(player)
  self.player = player

  self.battleStart = false

  self.playerPokemon = self.player.pokemon
  self.playerPokemon.x = -POKEMON_WIDTH * 2
  self.playerPokemon.y = VIRTUAL_HEIGHT - 56 - 4 - POKEMON_HEIGHT

  self.wildPokemon =
    Pokemon(
    {
      ["type"] = "front",
      ["x"] = VIRTUAL_WIDTH + POKEMON_WIDTH,
      ["y"] = 8
    }
  )
  self.wildPokemonHealth =
    ProgressBar(
    {
      ["value"] = self.wildPokemon.stats.hp,
      ["max"] = self.wildPokemon.baseStats.hp
    }
  )

  self.playerPokemonHealth =
    ProgressBar(
    {
      ["x"] = VIRTUAL_WIDTH - 8 - VIRTUAL_WIDTH / 2.2,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4 - 8 - 16,
      ["width"] = VIRTUAL_WIDTH / 2.2,
      ["height"] = 8,
      ["value"] = self.playerPokemon.stats.hp,
      ["max"] = self.playerPokemon.baseStats.hp
    }
  )
  self.playerPokemonExperience =
    ProgressBar(
    {
      ["x"] = VIRTUAL_WIDTH - 8 - VIRTUAL_WIDTH / 2.2,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4 - 8 - 8,
      ["width"] = VIRTUAL_WIDTH / 2.2,
      ["height"] = 8,
      ["fillColor"] = {
        ["r"] = 0.18,
        ["g"] = 0.18,
        ["b"] = 0.82
      },
      ["value"] = 0
    }
  )

  self.panel =
    Panel(
    {
      ["x"] = 4,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = 56
    }
  )

  Timer.tween(
    1,
    {
      [self.playerPokemon] = {x = 8 + POKEMON_WIDTH / 2},
      [self.wildPokemon] = {x = VIRTUAL_WIDTH - POKEMON_WIDTH * 3 / 2 - 8}
    }
  ):finish(
    function()
      self.battleStart = true

      gStateStack:push(
        DialogueState(
          {
            ["chunks"] = {
              "A wild " ..
                string.sub(self.wildPokemon.name, 1, 1):upper() ..
                  string.sub(self.wildPokemon.name, 2, -1) .. " appeared!",
              "Go, " ..
                string.sub(self.playerPokemon.name, 1, 1):upper() .. string.sub(self.playerPokemon.name, 2, -1) .. "!"
            },
            ["x"] = 4,
            ["y"] = VIRTUAL_HEIGHT - 56 - 4,
            ["padding"] = 4,
            ["width"] = VIRTUAL_WIDTH - 8,
            ["height"] = 56,
            ["callback"] = function()
              gStateStack:pop()
              gStateStack:push(
                BattleMenuState(
                  {
                    ["callback"] = function()
                      gStateStack:pop()
                      gStateStack:pop()
                    end,
                    ["playerPokemon"] = self.playerPokemon,
                    ["wildPokemon"] = self.wildPokemon,
                    ["wildPokemonHealth"] = self.wildPokemonHealth,
                    ["playerPokemonHealth"] = self.playerPokemonHealth
                  }
                )
              )
            end
          }
        )
      )
    end
  )
end

function BattleState:update(dt)
  Timer.update(dt)
end

function BattleState:render()
  love.graphics.clear(0.95, 0.95, 97)

  love.graphics.setColor(0.25, 0.75, 0.5)
  love.graphics.ellipse(
    "fill",
    self.wildPokemon.x + POKEMON_WIDTH / 2,
    self.wildPokemon.y + POKEMON_HEIGHT,
    POKEMON_WIDTH,
    16
  )
  love.graphics.ellipse(
    "fill",
    self.playerPokemon.x + POKEMON_WIDTH / 2,
    self.playerPokemon.y + POKEMON_HEIGHT,
    POKEMON_WIDTH,
    16
  )

  self.wildPokemon:render()
  self.playerPokemon:render()

  self.panel:render()

  if self.battleStart then
    self.wildPokemonHealth:render()
    self.playerPokemonHealth:render()
    self.playerPokemonExperience:render()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.setFont(gFonts["x-small"])
    love.graphics.print(
      "LV 5",
      self.wildPokemonHealth.x + 2,
      self.wildPokemonHealth.y + self.wildPokemonHealth.height + 2
    )
    love.graphics.print("LV 5", self.playerPokemonHealth.x + 2, self.playerPokemonHealth.y - 2 - 8)
  end
end
