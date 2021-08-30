TitleState = BaseState:new()

-- 17 columns by 7 rows
local TITLE_TEXT =
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
  local columns = TITLE_TEXT:gsub(" ", ""):find("\n") - 1
  local titleText, rows = TITLE_TEXT:gsub("\n", "")

  local tileSize = TILE_SIZE

  local width = columns * tileSize
  local height = rows * tileSize
  local xStart = VIRTUAL_WIDTH / 2 - width / 2
  local yStart = VIRTUAL_HEIGHT / 2 - height / 2

  local title = {}

  for column = 1, columns do
    for row = 1, rows do
      local index = column + (row - 1) * columns
      local character = titleText:sub(index, index)
      local x = xStart + (column - 1) * tileSize
      local y = yStart + (row - 1) * tileSize
      local id = character == "o" and #gQuads.textures or 1

      local tile = Tile:new(x, y, id)
      table.insert(title, tile)
    end
  end

  local this = {
    ["title"] = title
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    local numberGems = love.math.random(GEMS_MAX)

    gStateStack:push(
      TransitionState:new(
        {
          ["transitionStart"] = true,
          ["callback"] = function()
            gStateStack:pop()

            gStateStack:push(PlayState:new(numberGems))
            gStateStack:push(DialogueState:new({"Something pinged in the wall!\n" .. numberGems .. " confirmed!"}))
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
  for k, tile in pairs(self.title) do
    tile:render()
  end
end
