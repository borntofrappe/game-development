GameoverScreenState = Class {__includes = BaseState}

-- small delay to avoid moving too fast to the play state
local DELAY = 0.5
local SIZE_MULTIPLIER = 1.5
local PADDING = 10

function GameoverScreenState:init()
  self.size = gFonts.normal:getWidth("10") * SIZE_MULTIPLIER
  self.padding = PADDING
  self.delay = DELAY
end

function GameoverScreenState:enter(params)
  self.score = params.score
  self.android = params.android
  self.lollipopPairs = params.lollipopPairs
end

function GameoverScreenState:update(dt)
  if self.delay > 0 then
    self.delay = math.max(0, self.delay - dt)
  end

  if self.delay == 0 and love.mouse.waspressed then
    gStateMachine:change("play")
  end
end

function GameoverScreenState:render()
  love.graphics.setColor(1, 1, 1)

  for i, parallax in ipairs(gParallax) do
    love.graphics.draw(gImages[parallax.key], -parallax.offset, 0)
  end

  love.graphics.draw(gImages.moon, 64, WINDOW_HEIGHT / 2)

  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end

  self.android:render()

  love.graphics.setColor(0.9, 0.08, 0.12)
  love.graphics.rectangle("fill", self.padding, self.padding, self.size, self.size, 4)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    self.score,
    self.padding,
    self.padding + self.size / 2 - gFonts.normal:getHeight() / 2,
    self.size,
    "center"
  )
end
