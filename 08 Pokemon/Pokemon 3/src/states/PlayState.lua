PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.tiles = PlayState:initTiles()

  self.column = 3
  self.row = 6
  self.entity = 1
  self.direction = "down"
  self.variety = 2
end

function PlayState:update(dt)
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

  if love.keyboard.wasPressed("up") then
    self.direction = "up"
  elseif love.keyboard.wasPressed("right") then
    self.direction = "right"
  elseif love.keyboard.wasPressed("down") then
    self.direction = "down"
  elseif love.keyboard.wasPressed("left") then
    self.direction = "left"
  elseif love.keyboard.wasPressed("1") then
    self.variety = 1
  elseif love.keyboard.wasPressed("2") then
    self.variety = 2
  elseif love.keyboard.wasPressed("3") then
    self.variety = 3
  end

  if love.keyboard.wasPressed("r") or love.keyboard.wasPressed("R") then
    self.entity = math.random(#gFrames["entities"])
  end

  if love.keyboard.wasPressed("d") or love.keyboard.wasPressed("D") then
    gStateStack:push(DialogueState())
  end
end

function PlayState:render()
  for k, tile in pairs(self.tiles) do
    tile:render()
  end

  love.graphics.draw(
    gTextures["entities"],
    gFrames["entities"][self.entity][self.direction][self.variety],
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE
  )
end

function PlayState:initTiles()
  local tiles = {}

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      table.insert(tiles, Tile(column, row, TILE_BACKGROUND))
      if row > ROWS - 5 then
        table.insert(tiles, Tile(column, row, TILE_GRASS))
      end
    end
  end

  return tiles
end
