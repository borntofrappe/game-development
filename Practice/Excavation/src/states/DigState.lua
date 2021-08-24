DigState = BaseState:new()

local OFFSET_INCREMENT = 0.1
local OFFSET_START_MAX = 1000

function DigState:enter(params)
  local offsetStartColumn = love.math.random(OFFSET_START_MAX)
  local offsetStartRow = love.math.random(OFFSET_START_MAX)
  local offsetColumn = offsetStartColumn
  local offsetRow = offsetStartRow

  local textures = {}
  for c = 1, COLUMNS do
    offsetRow = 0
    for r = 1, ROWS do
      offsetRow = offsetRow + OFFSET_INCREMENT
      local noise = love.math.noise(offsetColumn, offsetRow)
      local id = math.floor(noise * (TEXTURE_TYPES - 1)) + 2
      table.insert(
        textures,
        {
          ["id"] = id,
          ["x"] = (c - 1) * TEXTURE_SIZE,
          ["y"] = (r - 1) * TEXTURE_SIZE
        }
      )
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end
  self.textures = textures
end

function DigState:update(dt)
end

function DigState:render()
  love.graphics.setColor(1, 1, 1)
  for i, texture in pairs(self.textures) do
    love.graphics.draw(gTextures.spritesheet, gQuads.textures[texture.id], texture.x, texture.y)
  end

  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.tools["pickaxe"]["fill"],
    math.floor(VIRTUAL_WIDTH / 2 - TOOLS_WIDTH / 2),
    math.floor(VIRTUAL_HEIGHT / 2 - TOOLS_HEIGHT / 2)
  )
end
