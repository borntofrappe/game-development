PlayState = BaseState:new()

function PlayState:enter(params)
  self.data = params.data

  local level = "xoxxxxox"
  local towns = {}
  local launchPads = {}

  local widthStructures = #level * STRUCTURE_SIZE
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

    x = x + STRUCTURE_SIZE
  end

  self.towns = towns
  self.launchPads = launchPads

  self.missiles = {}

  for i = 1, MISSILES.number do
    local x1 = love.math.random(0, WINDOW_WIDTH)
    local y1 = 0
    local delay = love.math.random(MISSILES["delay-max"])

    local shootLaunchPad = love.math.random(MISSILES["launch-pad-odds"]) == 1

    local target
    if shootLaunchPad then
      target = self.launchPads[love.math.random(#self.launchPads)]
    else
      target = self.towns[love.math.random(#self.towns)]
    end

    local x2 = target.x + target.width / 2
    local y2 = target.y

    local label = "missile-" .. i
    local missile = Missile:new(x1, y1, x2, y2, label)

    Timer:after(
      delay,
      function()
        missile:launch(MISSILE_UPDATE_SPEED)
        table.insert(self.missiles, missile)
      end
    )
  end

  self.trackball = Trackball:new()

  self.antiMissiles = {}

  self.explosions = {}

  self.background = {
    ["y"] = WINDOW_HEIGHT - self.data.background.height - gTextures.background:getHeight()
  }
end

function PlayState:update(dt)
  Timer:update(dt)

  for i, explosion in ipairs(self.explosions) do
    for j, missile in ipairs(self.missiles) do
      if explosion:withinRange(missile) then
        missile.inPlay = false
        break
      end
    end

    if not explosion.inPlay then
      Timer:remove(explosion.label)
      table.remove(self.explosions, i)
    end
  end

  for i, missile in ipairs(self.missiles) do
    if not missile.inPlay then
      Timer:remove(missile.label)
      table.remove(self.missiles, i)
    end
  end

  for i, antiMissile in ipairs(self.antiMissiles) do
    if not antiMissile.inPlay then
      local x = antiMissile.points[#antiMissile.points - 1]
      local y = antiMissile.points[#antiMissile.points]
      local label = antiMissile.label .. "-explosion"
      local explosion = Explosion:new(x, y, label)

      explosion:trigger()
      table.insert(self.explosions, explosion)

      Timer:remove(antiMissile.label)
      table.remove(self.antiMissiles, i)
    end
  end

  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.isDown("up") then
    self.trackball.y = math.max(0, self.trackball.y - TRACKBALL_UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("down") then
    self.trackball.y = math.min(self.data.background.y, self.trackball.y + TRACKBALL_UPDATE_SPEED * dt)
  end

  if love.keyboard.isDown("right") then
    self.trackball.x = math.min(WINDOW_WIDTH, self.trackball.x + TRACKBALL_UPDATE_SPEED * dt)
  elseif love.keyboard.isDown("left") then
    self.trackball.x = math.max(0, self.trackball.x - TRACKBALL_UPDATE_SPEED * dt)
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
      local launchPad = self.launchPads[index]

      local x1 = launchPad.x + launchPad.width / 2
      local y1 = launchPad.y
      local y2 = self.trackball.y
      local label = "launchPad-" .. index .. "-missile-" .. self.launchPads[index].missiles
      launchPad.missiles = launchPad.missiles - 1

      local missile = Missile:new(x1, y1, x2, y2, label)

      missile:launch(ANTI_MISSILE_UPDATE_SPEED)
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

  for i, explosion in ipairs(self.explosions) do
    explosion:render()
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
