Bush = Class {}

function Bush:init(def)
  self.color = math.random(#gQuads["bushes"])
  self.variants = BUSH_VARIANTS[math.random(#BUSH_VARIANTS)]
  self.x = VIRTUAL_WIDTH
  self.y = VIRTUAL_HEIGHT - BUSH_SIZE
  self.width = BUSH_SIZE * #self.variants
  self.height = BUSH_SIZE
  self.inPlay = true
end

function Bush:render()
  for i, variant in ipairs(self.variants) do
    love.graphics.draw(
      gTextures["bushes"],
      gQuads["bushes"][self.color][variant],
      math.floor(self.x + BUSH_SIZE * (i - 1)),
      math.floor(self.y)
    )
  end
end
