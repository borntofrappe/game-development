Data = {}

function Data:new()
  local backgroundHeight = gFonts.normal:getHeight()

  local background = {
    ["x"] = 0,
    ["y"] = WINDOW_HEIGHT - backgroundHeight,
    ["width"] = WINDOW_WIDTH,
    ["height"] = backgroundHeight
  }

  local level = "xoxxxxox"
  local towns = {}
  local launchPads = {}

  local widthStructures = #level * STRUCTURE_WIDTH
  local heightStructures = STRUCTURE_HEIGHT
  local x = WINDOW_WIDTH / 2 - widthStructures / 2
  local y = WINDOW_HEIGHT - background.height - STRUCTURE_HEIGHT

  for i = 1, #level do
    local structure = level:sub(i, i) == "x" and "town" or "launch-pad"
    if structure == "town" then
      table.insert(towns, Town:new(x, y))
    else
      table.insert(launchPads, LaunchPad:new(x, y))
    end

    x = x + STRUCTURE_WIDTH
  end

  local this = {
    ["points"] = 0,
    ["towns"] = towns,
    ["launchPads"] = launchPads,
    ["background"] = background
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Data:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.background.x, self.background.y, self.background.width, self.background.height)

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.print("Points " .. self.points, 8, self.background.y)
end
