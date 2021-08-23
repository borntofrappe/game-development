DigState = BaseState:new()

function DigState:enter(params)
  local textures = {}
  for c = 1, COLUMNS do
    for r = 1, ROWS do
      table.insert(
        textures,
        {
          ["id"] = love.math.random(TEXTURE_TYPES),
          ["x"] = (c - 1) * TEXTURE_SIZE,
          ["y"] = (r - 1) * TEXTURE_SIZE
        }
      )
    end
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
