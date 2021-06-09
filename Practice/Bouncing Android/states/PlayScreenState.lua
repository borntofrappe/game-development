PlayScreenState = Class {__includes = BaseState}

function PlayScreenState:init()
  self.score = 0
  self.interval = 3
  self.timer = 0

  self.android = Android()
  self.lollipopPairs = {LollipopPair()}
end

function PlayScreenState:update(dt)
  self.timer = self.timer + dt

  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    table.insert(self.lollipopPairs, LollipopPair())
  end

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:update(dt)

    for i, lollipop in pairs(lollipopPair.lollipops) do
      if self.android:collides(lollipop) then
        self.android.collided = true
        break
      end
    end

    if not lollipopPair.scored and self.android.x - self.android.width / 2 > lollipopPair.x + lollipopPair.width then
      lollipopPair.scored = true
      self.score = self.score + 1
    end

    if not lollipopPair.visible then
      table.remove(self.lollipopPairs, k)
    end
  end

  if self.android.collided then
    gStateMachine:change(
      "gameover",
      {
        score = self.score,
        android = self.android,
        lollipopPairs = self.lollipopPairs
      }
    )
  else
    self.android:update(dt)
  end

  for i, parallax in ipairs(gParallax) do
    parallax[2] = (parallax[2] + parallax[3] * dt) % WINDOW_WIDTH
  end
end

function PlayScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax[1]], -parallax[2], 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end

  self.android:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.print(self.score, 8, 8)
end
