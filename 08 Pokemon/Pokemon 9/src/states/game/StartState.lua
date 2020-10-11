StartState = Class({__includes = BaseState})

function StartState:init()
  self.pokemon =
    Pokemon(
    {
      ["type"] = "front",
      ["x"] = VIRTUAL_WIDTH / 2 - POKEMON_WIDTH / 2,
      ["y"] = VIRTUAL_HEIGHT / 2 + 36 - POKEMON_HEIGHT / 2
    }
  )

  self.tween =
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
          self.pokemon.name = POKEDEX[math.random(#POKEDEX)]
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

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self.tween:remove()

    gStateStack:push(
      FadeState(
        {
          color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
          duration = 0.5,
          opacity = 1,
          callback = function()
            gStateStack:pop()
            local pokemon = Pokemon({["type"] = "back"})
            if love.keyboard.isDown("p") then
              pokemon.name = self.pokemon.name
            end
            gStateStack:push(PlayState(pokemon))
            gStateStack:push(
              DialogueState(
                "Welcome to a wonderful world populated by\n" ..
                  #POKEDEX .. " feisty creatures.\nCan you find them all?",
                "Good luck!"
              )
            )
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
end

function StartState:render()
  love.graphics.clear(0.95, 0.95, 97)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Pokemon!", 0, VIRTUAL_HEIGHT / 4 - 24, VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["small"])
  love.graphics.printf("Press enter", 0, VIRTUAL_HEIGHT / 4 + 24, VIRTUAL_WIDTH, "center")

  love.graphics.setColor(0.25, 0.75, 0.5)
  love.graphics.ellipse("fill", VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 60, 70, 18)

  self.pokemon:render()
end
