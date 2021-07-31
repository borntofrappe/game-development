StartState = BaseState:new()

function StartState:enter()
  self.cameraShake = {
    ["x"] = 0,
    ["y"] = 0
  }

  Timer:every(
    CAMERA_SHAKE.interval,
    function()
      self.cameraShake.x = math.random(CAMERA_SHAKE.x * -1, CAMERA_SHAKE.x)
      self.cameraShake.y = math.random(CAMERA_SHAKE.y * -1, CAMERA_SHAKE.y)
    end,
    true,
    CAMERA_SHAKE.label
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.mouse.waspressed(1) then
    local x, y = love.mouse:getPosition()
    if
      x > WINDOW_PADDING and x < WINDOW_WIDTH - WINDOW_PADDING and y > WINDOW_PADDING and
        y < WINDOW_HEIGHT - WINDOW_PADDING
     then
      Timer:remove(CAMERA_SHAKE.label)
      gStateMachine:change("countdown")
    end
  end
end

function StartState:render()
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    "Minigames Box",
    self.cameraShake.x,
    PLAYING_HEIGHT / 2 - gFonts.large:getHeight() + self.cameraShake.y,
    PLAYING_WIDTH,
    "center"
  )

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Physics-based 2D experiments", 0, PLAYING_HEIGHT / 2 + 24, PLAYING_WIDTH, "center")
end
