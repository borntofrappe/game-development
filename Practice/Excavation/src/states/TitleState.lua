TitleState = BaseState:new()

-- replace `x`s with a specific tile
local TILES =
  [[
ooooooooooooooooo
oxxoooxoooxxxooxo
oxoxooxooxoooooxo
oxoxooxooxoxxooxo
oxoxooxooxooxoooo
oxxoooxoooxxoooxo
ooooooooooooooooo
]]

function TitleState:new()
  local columns = TILES:gsub(" ", ""):find("\n") - 1
  local tiles, rows = TILES:gsub("\n", "")

  local grid = {}
  local cellSize = TILE_SIZE

  local width = columns * cellSize
  local height = rows * cellSize
  local xStart = VIRTUAL_WIDTH / 2 - width / 2
  local yStart = VIRTUAL_HEIGHT / 2 - height / 2

  for column = 1, columns do
    for row = 1, rows do
      local index = column + (row - 1) * columns
      local character = tiles:sub(index, index)
      local x = xStart + (column - 1) * cellSize
      local y = yStart + (row - 1) * cellSize
      local id = character == "x" and 1 or #gQuads.tiles

      local tile = Tile:new(x, y, id)
      table.insert(grid, tile)
    end
  end

  local this = {
    ["grid"] = grid
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    local numberGems = love.math.random(GEMS_MAX)

    gStateStack:push(
      TransitionState:new(
        {
          ["transitionStart"] = true,
          ["callback"] = function()
            gStateStack:pop() -- title state

            gStateStack:push(PlayState:new(numberGems))
            gStateStack:push(
              DialogueState:new(
                {
                  ["chunks"] = {"Something pinged in the wall!\n" .. numberGems .. " confirmed!"}
                }
              )
            )
            gStateStack:push(
              TransitionState:new(
                {
                  ["transitionStart"] = false
                }
              )
            )
          end
        }
      )
    )
  end
end

function TitleState:render()
  love.graphics.setColor(0.292, 0.222, 0.155)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1)
  for k, tile in pairs(self.grid) do
    tile:render()
  end
end
