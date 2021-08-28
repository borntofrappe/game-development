Tool = {}

function Tool:new(x, y, width, height, name, type)
  local panel = Panel:new(x, y, width, height)

  local this = {
    ["panel"] = panel,
    ["x"] = math.floor(panel.x + panel.width / 2 - TOOLS_WIDTH / 2),
    ["y"] = math.floor(panel.y + panel.height / 2 - TOOLS_WIDTH / 2),
    ["name"] = name,
    ["type"] = type
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tool:select()
  self.type = "fill"
end

function Tool:deselect()
  self.type = "outline"
end

function Tool:render()
  self.panel:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.spritesheet, gQuads.tools[self.name][self.type], self.x, self.y)
end
