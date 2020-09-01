Interactable = Class {}

function Interactable:init(x, y, type)
  self.x = x
  self.y = y
  self.type = math.random(TYPES)
  self.width = INTERACTABLE_WIDTH
  self.height = INTERACTABLE_HEIGHTS[self.type]
  self.variety = 1
end

function Interactable:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["interactables"][self.type][self.variety],
    math.floor(self.x),
    math.floor(self.y)
  )
end
