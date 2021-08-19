StartState = BaseState:new()

local DELAY_ANIMATION = 1
local TWEEN_ANIMATION = 1.5
local DELAY_READY = 0.5

local OFFSET_SPEED = 40

function StartState:enter()
  self.title = {
    ["text"] = string.upper("Grand Prix"),
    ["y"] = VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2
  }

  self.tiles = Tiles:new()
  self.car = Car:new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 1)
  self.car.x = -self.car.size
  self.car.y = VIRTUAL_HEIGHT / 2 - self.car.size / 2

  self.tilesOffset = 0
  self.isReady = false

  Timer:after(
    DELAY_ANIMATION,
    function()
      Timer:tween(
        TWEEN_ANIMATION,
        {
          [self.car] = {["x"] = VIRTUAL_WIDTH / 2 - self.car.size / 2}
        },
        function()
          Timer:after(
            DELAY_READY,
            function()
              self.isReady = true
            end
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  self.tilesOffset = self.tilesOffset + OFFSET_SPEED * dt
  if self.tilesOffset >= VIRTUAL_WIDTH then
    self.tilesOffset = self.tilesOffset % VIRTUAL_WIDTH
  end

  self.car:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("right") then
    self.car.color = self.car.color == #gQuads["cars"] and 1 or self.car.color + 1
  end

  if love.keyboard.waspressed("left") then
    self.car.color = self.car.color == 1 and #gQuads["cars"] or self.car.color - 1
  end

  if love.keyboard.waspressed("return") and self.isReady then
    gStateMachine:change(
      "set",
      {
        ["tiles"] = self.tiles,
        ["car"] = self.car,
        ["tilesOffset"] = {
          ["value"] = self.tilesOffset,
          ["speed"] = OFFSET_SPEED
        }
      }
    )
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  self.car:render()

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  if self.isReady then
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf("Ready", 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  end
end
