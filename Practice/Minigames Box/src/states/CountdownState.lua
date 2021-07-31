CountdownState = BaseState:new()

function CountdownState:enter()
  local state
  repeat
    state = gStates[math.random(#gStates)]
  until state ~= gState

  gState = state

  self.title = string.upper(state .. "!")

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

  Timer:after(
    COUNTDOWN_FEEBACK,
    function()
      Timer:remove(CAMERA_SHAKE.label)
      gStateMachine:change(state)
    end
  )
end

function CountdownState:update(dt)
  Timer:update(dt)
end

function CountdownState:render()
  love.graphics.setColor(0.28, 0.25, 0.18)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    self.title,
    self.cameraShake.x,
    PLAYING_HEIGHT / 2 - gFonts.large:getHeight() / 2 + self.cameraShake.y,
    PLAYING_WIDTH,
    "center"
  )
end
