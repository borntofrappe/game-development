Pokemon = Class {}

function Pokemon:init(def)
  local def = def or {}

  local pokemon = def.pokemon or POKEDEX[math.random(#POKEDEX)]
  self.name = pokemon.name
  self.stats = pokemon.stats
  self.type = def.type or "front"

  self.width = POKEMON_WIDTH
  self.height = POKEMON_HEIGHT

  self.x = def.x or VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = def.y or VIRTUAL_HEIGHT / 2 - self.height / 2
end

function Pokemon:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["pokemon"][self.name][self.type], self.x, self.y)
end
