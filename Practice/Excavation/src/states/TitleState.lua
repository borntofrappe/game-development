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

function TitleState:enter()
  local columns = TITLE_TEXT:gsub(" ", ""):find("\n") - 1
  local titleText, rows = TITLE_TEXT:gsub("\n", "")

  local width = columns * TILE_SIZE
  local height = rows * TILE_SIZE
  local x = VIRTUAL_WIDTH / 2 - width / 2
  local y = VIRTUAL_HEIGHT / 2 - height / 2

  local title = {}

  for column = 1, columns do
    for row = 1, rows do
      local index = column + (row - 1) * columns
      local character = titleText:sub(index, index)
      local id = character == "o" and #gQuads.textures or 1
      table.insert(title, Tile:new(x + (column - 1) * TILE_SIZE, y + (row - 1) * TILE_SIZE, id))
    end
  end

  self.title = title
end

function TitleState:goToDigState()
  gStateStack:push(
    TransitionState:new(
      {
        ["callback"] = function()
          gStateStack:pop()
          gStateStack:push(DigState:new())
        end
      }
    )
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
  -- self:goToDigState()
  end

  if love.mouse.waspressed(1) then
  -- self:goToDigState()
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
