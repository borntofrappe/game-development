BattleState = Class({__includes = BaseState})

function BattleState:init(player)
  self.player = player

  self.player.pokemon.x = -POKEMON_WIDTH * 2
  self.player.pokemon.y = VIRTUAL_HEIGHT - 56 - 4 - POKEMON_HEIGHT

  self.pokemon =
    Pokemon(
    {
      ["type"] = "front",
      ["x"] = VIRTUAL_WIDTH + POKEMON_WIDTH,
      ["y"] = 8
    }
  )

  self.textBox =
    TextBox(
    {
      text = "A wild " ..
        string.sub(self.pokemon.name, 1, 1):upper() .. string.sub(self.pokemon.name, 2, -1) .. " appeared!",
      x = 4,
      y = VIRTUAL_HEIGHT - 56 - 4,
      padding = 4,
      width = VIRTUAL_WIDTH - 8,
      height = 56
    }
  )

  Timer.tween(
    1,
    {
      [self.player.pokemon] = {x = 8 + POKEMON_WIDTH / 2},
      [self.pokemon] = {x = VIRTUAL_WIDTH - POKEMON_WIDTH * 3 / 2 - 8}
    }
  )
end

function BattleState:update(dt)
  Timer.update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateStack:pop()
  end
end

function BattleState:render()
  love.graphics.clear(0.97, 0.97, 1)

  love.graphics.setColor(0.25, 0.75, 0.5)
  love.graphics.ellipse("fill", self.pokemon.x + POKEMON_WIDTH / 2, self.pokemon.y + POKEMON_HEIGHT, POKEMON_WIDTH, 16)
  love.graphics.ellipse(
    "fill",
    self.player.pokemon.x + POKEMON_WIDTH / 2,
    self.player.pokemon.y + POKEMON_HEIGHT,
    POKEMON_WIDTH,
    16
  )

  self.player.pokemon:render()
  self.pokemon:render()

  self.textBox:render()
end
