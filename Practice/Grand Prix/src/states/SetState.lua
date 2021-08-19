SetState = BaseState:new()

local PADDING = 6
local TWEEN_ANIMATION = 1.5
local OFFSET_SPEED_SET = 0.5
local OFFSET_SPEED_PLAY = 2.5
local ANIMATION_INTERVAL_SET = 0.3
local ANIMATION_INTERVAL_PLAY = 0.08
local DELAY_PLAY = 1.5

function SetState:enter(params)
  self.tiles = params.tiles
  self.car = params.car
  self.tilesOffset = {
    ["value"] = params.tilesOffset.value,
    ["speed"] = params.tilesOffset.speed
  }

  self.isSet = false
  self.message = string.upper("Go!")

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.car] = {["x"] = PADDING},
      [self.tilesOffset] = {["speed"] = params.tilesOffset.speed * OFFSET_SPEED_SET}
    },
    function()
      self.isSet = true

      Timer:tween(
        DELAY_PLAY,
        {
          [self.tilesOffset] = {["speed"] = params.tilesOffset.speed * OFFSET_SPEED_PLAY}
        },
        function()
          gStateMachine:change(
            "play",
            {
              ["tiles"] = self.tiles,
              ["car"] = self.car,
              ["tilesOffset"] = self.tilesOffset
            }
          )
        end
      )
    end
  )
end

function SetState:update(dt)
  Timer:update(dt)

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH
  end

  self.car.animation:update(dt)
end

function SetState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  self.car:render()

  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.06, 0.07, 0.19)

  if self.isSet then
    love.graphics.printf(self.message, 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  else
    love.graphics.printf("Set", 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  end
end
