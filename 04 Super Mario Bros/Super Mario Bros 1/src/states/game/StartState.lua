StartState = Class({__includes = BaseState})

function StartState:init()
  self.map = LevelMaker.generate(100, 10)
  self.background = math.random(#gFrames.backgrounds)
  self.tileset = math.random(#gFrames.tiles)
  self.topperset = math.random(#gFrames.tops)
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  for x, column in ipairs(self.map) do
    for y, tile in ipairs(column) do
      love.graphics.draw(
        gTextures["tiles"],
        gFrames["tiles"][self.tileset][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )
      if tile.topper then
        love.graphics.draw(
          gTextures["tops"],
          gFrames["tops"][self.topperset][1],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end
    end
  end

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Super Mario Bros.", 1, VIRTUAL_HEIGHT / 2 - 36 - 8 + 1, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Super Mario Bros.", 0, VIRTUAL_HEIGHT / 2 - 36 - 8, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Press Enter", 1, VIRTUAL_HEIGHT / 2 + 24 + 1, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Press Enter", 0, VIRTUAL_HEIGHT / 2 + 24, VIRTUAL_WIDTH, "center")
end
