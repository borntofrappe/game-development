Bush = Class {}

function Bush:init(def)
  self.color = math.random(#gQuads["bushes"])
  self.variants = BUSH_VARIANTS[math.random(#BUSH_VARIANTS)]
  self.x = VIRTUAL_WIDTH
  self.y = VIRTUAL_HEIGHT - BUSH_HEIGHT
  self.width = BUSH_WIDTH * #self.variants
  self.height = BUSH_HEIGHT

  self.inPlay = true
end

function Bush:render()
  for i, variant in ipairs(self.variants) do
    love.graphics.draw(
      gTextures["bushes"],
      gQuads["bushes"][self.color][variant],
      self.x + BUSH_WIDTH * (i - 1),
      self.y
    )
  end
end
