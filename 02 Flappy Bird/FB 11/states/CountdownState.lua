-- state showing the countdown screen
-- inherit from the BaseState class
CountdownState = Class{__includes = BaseState}

-- variable to count down every x seconds
COUNTDOWN_THRESHOLD = 0.5

-- in the init function set up two fields for count (the number from which to count down) and timer (to keep track of the passage of time)
function CountdownState:init()
  self.count = 3
  self.timer = 0
  -- immediately play the countdown sound
  sounds['countdown']:play()
end


-- in the update(dt) function update self.timer and once it goes past the treshold decrement the count field
function CountdownState:update(dt)
  self.timer = self.timer + dt
  if self.timer > COUNTDOWN_THRESHOLD then
    --play the countdown sound for every decrement
    sounds['countdown']:play()
    -- set self.timer to be the excess past the threshold
    self.timer = self.timer % COUNTDOWN_THRESHOLD
    -- decrement count
    self.count = self.count - 1

    -- check if count has reached 0 and if so transition to the play state
    if self.count == 0 then
      gStateMachine:change('play')
    end
  end
end


-- in the render function, display the countdown right in the middle of the screen
function CountdownState:render()
  love.graphics.setFont(hugeFont)
  love.graphics.printf(
    tostring(self.count),
    0,
    VIRTUAL_HEIGHT / 2 - 32,
    VIRTUAL_WIDTH,
    'center'
  )

end
