PlayState = BaseState:new()

local WHITESPACE = 0
local UPDATE_SPEED = 100

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

  self.missiles = {}
  local numberMissiles = love.math.random(MISSILES_NUMBER[1], MISSILES_NUMBER[2])

  for i = 1, numberMissiles do
    local x1 = love.math.random(0, WINDOW_WIDTH)
    local y1 = 0
    local delay = love.math.random(MISSILES_DELAY_MAX)

    local shootLaunchPad = love.math.random(MISSILE_LAUNCH_PAD_ODDS) == 1
    local target
    if shootLaunchPad then
      target = self.launchPads[love.math.random(#self.launchPads)]
    else
      target = self.towns[love.math.random(#self.towns)]
    end

    local x2 = target.x + target.width / 2
    local y2 = target.y

    local missile = Missile:new(x1, y1, x2, y2)
    Timer:after(
      delay,
      function()
        missile:launch(MISSILE_TIME)
        table.insert(self.missiles, missile)
      end
    )
  end

  self.trackball = Trackball:new()
  self.antiMissiles = {}

  self.background = {
    ["y"] = WINDOW_HEIGHT - self.data.background.height - gTextures.background:getHeight()
  }
end

function PlayState:update(dt)
  Timer:update(dt)

  for i, missile in ipairs(self.missiles) do
    if not missile.inPlay then
      Timer:remove(missile.label)
      table.remove(self.missiles, i)
    end
  end

  for i, antiMissile in ipairs(self.antiMissiles) do
    if not antiMissile.inPlay then
      Timer:remove(antiMissile.label)
      table.remove(self.antiMissiles, i)
    end
  end

  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.isDown("up") then
    self.trackball.y = math.max(0, self.trackball.y - UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("down") then
    self.trackball.y = math.min(self.data.background.y, self.trackball.y + UPDATE_SPEED * dt)
  end

  if love.keyboard.isDown("right") then
    self.trackball.x = math.min(WINDOW_WIDTH, self.trackball.x + UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    self.trackball.x = math.max(0, self.trackball.x - UPDATE_SPEED * dt)
  end

  if love.keyboard.waspressed("return") then
    local x2 = self.trackball.x
    local index = x2 < WINDOW_WIDTH / 2 and 1 or 2
    if self.launchPads[index].missiles == 0 then
      index = index == 1 and 2 or 1
      if self.launchPads[index].missiles == 0 then
        index = nil
      end
    end

    if index then
      local label = "launchPad-" .. index .. "-missile-" .. self.launchPads[index].missiles
      self.launchPads[index].missiles = self.launchPads[index].missiles - 1

      local missile =
        Missile:new(
        self.launchPads[index].x + self.launchPads[index].width / 2,
        self.launchPads[index].y,
        self.trackball.x,
        self.trackball.y,
        label
      )

      missile:launch(ANTI_MISSILE_TIME)
      table.insert(self.antiMissiles, missile)
    end
  end
end

function PlayState:render()
  self.data:render()
  love.graphics.setColor(1, 1, 1, 0.3)
  love.graphics.draw(gTextures.background, 0, self.background.y)

  for i, town in ipairs(self.towns) do
    town:render()
  end

  for i, launchPad in ipairs(self.launchPads) do
    launchPad:render()
  end

  for i, missile in ipairs(self.missiles) do
    missile:render()
  end

  for i, antiMissile in ipairs(self.antiMissiles) do
    antiMissile:render()

    love.graphics.setLineWidth(0.25)
    local x = antiMissile.points[#antiMissile.points - 1]
    local y = antiMissile.points[#antiMissile.points]
    love.graphics.line(x - TARGET_SIZE, y - TARGET_SIZE, x + TARGET_SIZE, y + TARGET_SIZE)
    love.graphics.line(x - TARGET_SIZE, y + TARGET_SIZE, x + TARGET_SIZE, y - TARGET_SIZE)
  end

  self.trackball:render()
end
