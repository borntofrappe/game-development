PlayState = BaseState:new()

function PlayState:enter(params)
  self.isGameOver = false
  self.data = params.data

  self.missiles = {}

  for i = 1, love.math.random(MISSILES["number"][1], MISSILES["number"][2]) do
    local x1 = love.math.random(0, WINDOW_WIDTH)
    local y1 = 0
    local delayMax = love.math.random(MISSILES["delay-max"][1], MISSILES["delay-max"][2])
    local delay = love.math.random(delayMax)

    local launchPads = {}
    for j, launchPad in ipairs(self.data.launchPads) do
      if launchPad.inPlay then
        table.insert(launchPads, launchPad)
      end
    end
    local shootLaunchPad = #launchPads > 0 and love.math.random(MISSILES["launch-pad-odds"]) == 1

    local target
    if shootLaunchPad then
      target = launchPads[love.math.random(#launchPads)]
    else
      target = self.data.towns[love.math.random(#self.data.towns)]
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
      if explosion:destroys(missile) then
        missile.inPlay = false
        self.data.points = self.data.points + 25

        local x = missile.currentPoints[#missile.currentPoints - 1]
        local y = missile.currentPoints[#missile.currentPoints]
        local label = missile.label .. "-explosion"
        local explosion = Explosion:new(x, y, label)

        explosion:trigger()
        table.insert(self.explosions, explosion)
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
      local destroysStructure = #missile.points == #missile.currentPoints
      if destroysStructure then
        local destroysTown = false

        for j, town in ipairs(self.data.towns) do
          if missile.points[#missile.points - 1] > town.x and missile.points[#missile.points - 1] < town.x + town.width then
            table.remove(self.data.towns, j)
            destroysTown = true
            break
          end
        end

        if not destroysTown then
          for j, launchPad in ipairs(self.data.launchPads) do
            if
              launchPad.inPlay and missile.points[#missile.points - 1] > launchPad.x and
                missile.points[#missile.points - 1] < launchPad.x + launchPad.width
             then
              launchPad.inPlay = false
              break
            end
          end
        end

        local x = missile.points[#missile.points - 1]
        local y = missile.points[#missile.points]
        local label = missile.label .. "-explosion"
        local explosion = Explosion:new(x, y, label)

        explosion:trigger()
        table.insert(self.explosions, explosion)

        if #self.data.towns == 0 then
          self.isGameOver = true
        end
      end

      Timer:remove(missile.label)
      table.remove(self.missiles, i)

      if #self.missiles == 0 then
        self.isGameOver = true
      end
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
    Timer:reset()
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

  if love.keyboard.waspressed("return") and not self.isGameOver then
    local x2 = self.trackball.x
    local index = x2 < WINDOW_WIDTH / 2 and 1 or 2
    if not self.data.launchPads[index].inPlay or self.data.launchPads[index].missiles == 0 then
      index = index == 1 and 2 or 1
      if not self.data.launchPads[index].inPlay or self.data.launchPads[index].missiles == 0 then
        index = nil
      end
    end

    if index then
      local launchPad = self.data.launchPads[index]

      local x1 = launchPad.x + launchPad.width / 2
      local y1 = launchPad.y
      local y2 = self.trackball.y
      local label = "launchPad-" .. index .. "-missile-" .. self.data.launchPads[index].missiles
      launchPad.missiles = launchPad.missiles - 1

      local missile = Missile:new(x1, y1, x2, y2, label)

      missile:launch(ANTI_MISSILE_UPDATE_SPEED)
      table.insert(self.antiMissiles, missile)
    end
  end

  if self.isGameOver and #Timer.intervals == 0 then
    if #self.data.towns == 0 then
      gStateMachine:change("gameover")
    else
      gStateMachine:change(
        "victory",
        {
          ["data"] = self.data
        }
      )
    end
  end
end

function PlayState:render()
  self.data:render()
  love.graphics.setColor(1, 1, 1, 0.3)
  love.graphics.draw(gTextures.background, 0, self.background.y)

  for i, town in ipairs(self.data.towns) do
    town:render()
  end

  for i, launchPad in ipairs(self.data.launchPads) do
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
