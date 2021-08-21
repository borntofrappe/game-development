ReadyState = BaseState:new()

local TWEEN_ANIMATION = 1.5
local DELAY_READY_STATE = 1

function ReadyState:enter(params)
  self.title = params.title
  self.message = {
    ["text"] = "Ready",
    ["x"] = -VIRTUAL_WIDTH
  }

  self.tiles = params.tiles
  self.tilesOffset = params.tilesOffset

  self.car = Car:new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 1)
  self.car.x = -self.car.size
  self.car.y = VIRTUAL_HEIGHT / 2 - self.car.size / 2

  self.isReady = false

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.title] = {["y"] = VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2},
      [self.car] = {["x"] = VIRTUAL_WIDTH / 2 - self.car.size / 2}
    },
    function()
      Timer:after(
        DELAY_READY_STATE,
        function()
          Timer:tween(
            TWEEN_IN,
            {
              [self.message] = {["x"] = 0}
            },
            function()
              self.isReady = true
            end
          )
        end
      )
    end
  )
end

function ReadyState:update(dt)
  Timer:update(dt)

  self.tilesOffset = self.tilesOffset + OFFSET_SPEED_DEFAULT * dt
  if self.tilesOffset >= VIRTUAL_WIDTH then
    self.tilesOffset = self.tilesOffset % VIRTUAL_WIDTH
  end

  self.car:update(dt)

  if love.keyboard.waspressed("escape") and self.isReady then
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
        ["title"] = self.title,
        ["message"] = self.message,
        ["tiles"] = self.tiles,
        ["tilesOffset"] = self.tilesOffset,
        ["car"] = self.car
      }
    )
  end
end

function ReadyState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  self.car:render()

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    self.message.text,
    self.message.x,
    VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(),
    VIRTUAL_WIDTH,
    "center"
  )
end
