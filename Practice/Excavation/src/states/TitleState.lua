TitleState = BaseState:new()

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

function TitleState:enter(params)
  local columns = TITLE_TEXT:gsub(" ", ""):find("\n") - 1
  local titleText, rows = TITLE_TEXT:gsub("\n", "")

  local width = columns * TILE_SIZE
  local height = rows * TILE_SIZE
  local x = VIRTUAL_WIDTH / 2 - width / 2
  local y = VIRTUAL_HEIGHT / 2 - height / 2

  self.outline = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height
  }

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

  local toolName = love.math.random(2) == 1 and "pickaxe" or "hammer"
  self.tool = Tool:new(toolName, "fill", x + width, y + height)
end

function TitleState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change("dig")
  end
end

function TitleState:render()
  love.graphics.setColor(0.242, 0.172, 0.105)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle("line", self.outline.x, self.outline.y, self.outline.width, self.outline.height)

  love.graphics.setColor(1, 1, 1)
  for k, tile in pairs(self.title) do
    tile:render()
  end

  self.tool:render()
end
