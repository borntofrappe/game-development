SetState = BaseState:new()

local PADDING = 6
local TWEEN_ANIMATION = 1.25
local DELAY_GO_STATE = 1.25

function SetState:enter(params)
  self.tiles = params.tiles
  self.car = params.car
  self.tilesOffset = {
    ["value"] = params.tilesOffset,
    ["speed"] = OFFSET_SPEED_DEFAULT
  }

  self.message = {
    ["text"] = "Set",
    ["x"] = -VIRTUAL_WIDTH,
    ["y"] = VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight()
  }

  self.isSet = false
  self.isExiting = false

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.car] = {["x"] = PADDING},
      [self.tilesOffset] = {["speed"] = OFFSET_SPEED_SET}
    },
    function()
      Timer:tween(
        TWEEN_IN,
        {
          [self.message] = {["x"] = 0}
        },
        function()
          self.isSet = true
          Timer:after(
            DELAY_GO_STATE,
            function()
              self.isExiting = true
              Timer:tween(
                TWEEN_OUT,
                {
                  [self.message] = {["x"] = VIRTUAL_WIDTH}
                },
                function()
                  gStateMachine:change(
                    "go",
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

function SetState:update(dt)
  Timer:update(dt)

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH
  end

  self.car:update(dt)

  if love.keyboard.waspressed("return") and self.isSet and not self.isExiting then
    Timer:reset()
    self.isExiting = true
    Timer:tween(
      TWEEN_OUT,
      {
        [self.message] = {["x"] = VIRTUAL_WIDTH}
      },
      function()
        gStateMachine:change(
          "go",
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

function SetState:render()
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
