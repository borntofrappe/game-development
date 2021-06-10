PlayScreenState = Class {__includes = BaseState}

local SIZE_MULTIPLIER = 1.5
local PADDING = 10
local INTERVAL = 3

function PlayScreenState:init()
  self.score = 0
  self.interval = INTERVAL
  self.timer = 0

  self.android = Android()
  self.lollipopPairs = {LollipopPair()}

  self.size = gFonts.normal:getWidth("10") * SIZE_MULTIPLIER
  self.padding = PADDING
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
    parallax.offset = (parallax.offset + parallax.speed * dt) % WINDOW_WIDTH
  end
end

function PlayScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax.key], -parallax.offset, 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end

  self.android:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.padding, self.padding, self.size, self.size, 4)

  love.graphics.setColor(0.17, 0.17, 0.17)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    self.score,
    self.padding,
    self.padding + self.size / 2 - gFonts.normal:getHeight() / 2,
    self.size,
    "center"
  )
end
