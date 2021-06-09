PlayScreenState = Class {__includes = BaseState}

function PlayScreenState:init()
  self.android = Android()

  self.interval = 3
  self.timer = 0

  self.lollipops = {Lollipop()}
end

function PlayScreenState:update(dt)
  self.timer = self.timer + dt
  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    table.insert(self.lollipops, Lollipop())
  end

  for i, parallax in ipairs(gParallax) do
    parallax[2] = (parallax[2] + parallax[3] * dt) % WINDOW_WIDTH
  end

  for k, lollipop in pairs(self.lollipops) do
    lollipop:update(dt)

    if self.android:collides(lollipop) then
      self.android.collided = true
    end

    if not lollipop.visible then
      table.remove(self.lollipops, k)
    end
  end

  if self.android.collided then
    gStateMachine:change(
      "gameover",
      {
        android = self.android,
        lollipops = self.lollipops
      }
    )
  else
    self.android:update(dt)
  end
end

function PlayScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax[1]], -parallax[2], 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)

  for k, lollipop in pairs(self.lollipops) do
    lollipop:render()
  end

  self.android:render()
end
