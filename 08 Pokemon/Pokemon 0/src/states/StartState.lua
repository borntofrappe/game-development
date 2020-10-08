StartState = Class({__includes = BaseState})

function StartState:init()
  self.pokemon = {
    ["sprite"] = POKEDEX[math.random(#POKEDEX)],
    x = VIRTUAL_WIDTH / 2 - POKEMON_WIDTH / 2,
    y = VIRTUAL_HEIGHT / 2 + 36 - POKEMON_HEIGHT / 2
  }

  Timer.every(
    4,
    function()
      Timer.tween(
        0.25,
        {
          [self.pokemon] = {x = -POKEMON_WIDTH}
        }
      ):finish(
        function()
          self.pokemon.sprite = POKEDEX[math.random(#POKEDEX)]
          self.pokemon.x = VIRTUAL_WIDTH
          Timer.tween(
            0.25,
            {
              [self.pokemon] = {x = VIRTUAL_WIDTH / 2 - POKEMON_WIDTH / 2}
            }
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer.update(dt)

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
end

function StartState:render()
  love.graphics.clear(0.97, 0.97, 1)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Pokemon!", 0, VIRTUAL_HEIGHT / 4 - 24, VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["small"])
  love.graphics.printf("Press enter", 0, VIRTUAL_HEIGHT / 4 + 24, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(0.25, 0.75, 0.5)
  love.graphics.ellipse("fill", VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 60, 70, 18)

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["pokemon"][self.pokemon.sprite]["front"], self.pokemon.x, self.pokemon.y)
end
