GoState = BaseState:new()

local TWEEN_ANIMATION = 1
local DELAY_DRIVE_STATE = 1.25

function GoState:enter(params)
  self.tiles = params.tiles
  self.tilesOffset = params.tilesOffset
  self.car = params.car

  self.message = {
    ["text"] = "Go!",
    ["x"] = -VIRTUAL_WIDTH,
    ["y"] = VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight()
  }

  self.isGone = false
  self.isExiting = false

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.tilesOffset] = {["speed"] = OFFSET_SPEED_GO}
    },
    function()
      Timer:tween(
        TWEEN_IN,
        {
          [self.message] = {["x"] = 0}
        },
        function()
          self.isGone = true
          Timer:after(
            DELAY_DRIVE_STATE,
            function()
              self.isExiting = true
              Timer:tween(
                TWEEN_OUT,
                {
                  [self.message] = {["x"] = VIRTUAL_WIDTH}
                },
                function()
                  gStateMachine:change(
                    "drive",
                    {
                      ["tiles"] = self.tiles,
                      ["tilesOffset"] = self.tilesOffset,
                      ["car"] = self.car
                    }
                  )
                end
              )
            end
          )
        end
      )
    end
  )
end

function GoState:update(dt)
  Timer:update(dt)

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH
  end

  self.car:update(dt)

  if love.keyboard.waspressed("return") and self.isGone and not self.isExiting then
    self.isExiting = true
    -- remove the delay automatically moving to the drive state
    Timer:reset()
    Timer:tween(
      TWEEN_OUT,
      {
        [self.message] = {["x"] = VIRTUAL_WIDTH}
      },
      function()
        gStateMachine:change(
          "drive",
          {
            ["tiles"] = self.tiles,
            ["tilesOffset"] = self.tilesOffset,
            ["car"] = self.car
          }
        )
      end
    )
  end
end

function GoState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  self.tiles:render()
  love.graphics.pop()

  self.car:render()

  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.06, 0.07, 0.19)

  love.graphics.printf(
    self.message.text,
    self.message.x,
    VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(),
    VIRTUAL_WIDTH,
    "center"
  )
end
