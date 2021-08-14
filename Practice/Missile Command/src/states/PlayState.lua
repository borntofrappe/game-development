PlayState = BaseState:new()

local WHITESPACE = 0

function PlayState:enter(params)
  self.data = params.data

  local level = "xoxxxxox"
  local towns = {}
  local launchPads = {}

  local widthStructures = #level * STRUCTURE_SIZE + (#level - 1) * WHITESPACE
  local heightStructures = STRUCTURE_SIZE
  local x = WINDOW_WIDTH / 2 - widthStructures / 2
  local y = WINDOW_HEIGHT - self.data.background.height - STRUCTURE_SIZE

  for i = 1, #level do
    local structure = level:sub(i, i) == "x" and "town" or "launch-pad"
    if structure == "town" then
      table.insert(towns, Town:new(x, y))
    else
      table.insert(launchPads, LaunchPad:new(x, y))
    end

    x = x + STRUCTURE_SIZE + WHITESPACE
  end

  self.towns = towns
  self.launchPads = launchPads

  self.background = {
    ["y"] = WINDOW_HEIGHT - self.data.background.height - 70
  }
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  self.data:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.background, 0, self.background.y)

  for i, town in ipairs(self.towns) do
    town:render()
  end

  for i, launchPad in ipairs(self.launchPads) do
    launchPad:render()
  end
end
