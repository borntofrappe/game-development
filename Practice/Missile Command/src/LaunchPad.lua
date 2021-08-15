LaunchPad = {}

function LaunchPad:new(x, y, missiles)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = STRUCTURE_WIDTH,
    ["height"] = STRUCTURE_HEIGHT,
    ["missiles"] = missiles or 15,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function LaunchPad:render()
  if self.inPlay then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures.spritesheet, gQuads.structures[2], self.x, self.y)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(gFonts.small)
    love.graphics.printf(self.missiles, self.x, self.y + self.height - gFonts.small:getHeight(), self.width, "center")
  end
end
