Interactable = {}

function Interactable:new(x, y, type)
  local type = type or "solid"
  local data = INTERACTABLES[type]
  local width = data.width
  local height = data.height
  local frames = data.frames

  local this = {
    ["type"] = type,
    ["frame"] = 1,
    ["frames"] = frames,
    ["x"] = math.floor(x - width / 2),
    ["y"] = math.floor(y - height / 2),
    ["width"] = width,
    ["height"] = height,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Interactable:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["interactables"][self.type][self.frame], self.x, self.y)
end
