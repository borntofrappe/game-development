VictoryState = Class({__includes = BaseState})

local DELAY = 5
local COUNTDOWN = 3
local COUNTDOWN_SPEED = 1.1

function VictoryState:init()
  self.delay = DELAY
  self.time = 0
  self.countdown = COUNTDOWN
end

function VictoryState:enter(params)
  self.cards = params.cards
  self.level = params.level
  self.topY = params.topY
  self.bottomY = params.bottomY
end

function VictoryState:update(dt)
  if self.delay > 0 then
    self.delay = math.max(0, self.delay - dt)
  else
    self.time = self.time + dt
    if self.time >= (1 / COUNTDOWN_SPEED) then
      self.time = self.time % (1 / COUNTDOWN_SPEED)
      self.countdown = self.countdown - 1

      if self.countdown == 0 then
        gStateMachine:change(
          "start",
          {
            level = self.level
          }
        )
      end
    end
  end

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "start",
      {
        level = self.level
      }
    )
  end
end

function VictoryState:render()
  for k, card in pairs(self.cards) do
    card:render()
  end

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("It's a match! Congrats!", 0, self.topY - gFonts["normal"]:getHeight(), VIRTUAL_WIDTH, "center")

  if self.delay == 0 then
    love.graphics.setFont(gFonts["small"])
    love.graphics.printf("Back to title in " .. self.countdown, 0, self.bottomY, VIRTUAL_WIDTH, "center")
  end
end
