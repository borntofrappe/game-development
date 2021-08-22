WrapUpState = BaseState:new()

local TWEEN_ANIMATION = 2

function WrapUpState:enter(params)
  self.tilesBonus = params.tilesBonus
  self.tilesOffset = params.tilesOffset
  self.car = params.car
  self.cars = params.cars

  self.title = {
    ["text"] = string.upper("Grand Prix"),
    ["x"] = -VIRTUAL_WIDTH,
    ["y"] = VIRTUAL_HEIGHT / 4 - gFonts.large:getHeight() / 2
  }

  -- align the key-value pairs to the left and right of the title
  local width = gFonts.large:getWidth(self.title.text)
  local x = VIRTUAL_WIDTH / 2 - width / 2

  self.timer = {
    ["text"] = "Time",
    ["value"] = params.timer,
    ["x"] = -VIRTUAL_WIDTH,
    ["y"] = VIRTUAL_HEIGHT / 2,
    ["width"] = width
  }

  self.collisions = {
    ["text"] = "Collisions",
    ["value"] = params.collisions,
    ["x"] = -VIRTUAL_WIDTH,
    ["y"] = VIRTUAL_HEIGHT / 2 + gFonts.normal:getHeight() * 2,
    ["width"] = width
  }

  self.isWrappedUp = false
  self.isExiting = false

  Timer:tween(
    TWEEN_IN,
    {
      [self.title] = {["x"] = 0}
    },
    function()
      Timer:tween(
        TWEEN_IN,
        {
          [self.timer] = {["x"] = x}
        },
        function()
          Timer:tween(
            TWEEN_IN,
            {
              [self.collisions] = {["x"] = x}
            },
            function()
              self.isWrappedUp = true
            end
          )
        end
      )
    end
  )
end

function WrapUpState:update(dt)
  Timer:update(dt)

  if self.isExiting then
    self.car:update(dt)

    for k, car in pairs(self.cars) do
      car:update(dt)
    end
  end

  if love.keyboard.waspressed("return") and self.isWrappedUp and not self.isExiting then
    self.isExiting = true
    Timer:tween(
      TWEEN_OUT,
      {
        [self.timer] = {["x"] = VIRTUAL_WIDTH}
      },
      function()
        Timer:tween(
          TWEEN_OUT,
          {
            [self.collisions] = {["x"] = VIRTUAL_WIDTH}
          },
          function()
            -- animate the offset to reach the end of the current set and match the new set introduced by the title state
            -- not necessary to animate the cars as they scroll left with the tiles
            Timer:tween(
              TWEEN_ANIMATION,
              {
                [self.title] = {["y"] = VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() / 2},
                [self.car] = {["x"] = self.car.x + VIRTUAL_WIDTH},
                [self.tilesOffset] = {["value"] = VIRTUAL_WIDTH}
              },
              function()
                gStateMachine:change("title")
              end
            )
          end
        )
      end
    )
  end
end

function WrapUpState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  love.graphics.translate(VIRTUAL_WIDTH, 0)
  self.tilesBonus:render()
  love.graphics.pop()

  for k, car in pairs(self.cars) do
    car:render()
  end
  self.car:render()

  love.graphics.setFont(gFonts.large)
  love.graphics.setColor(0.06, 0.07, 0.19)
  love.graphics.printf(self.title.text, self.title.x, self.title.y, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.timer.text, self.timer.x, self.timer.y, self.timer.width, "left")
  love.graphics.printf(string.format("%ds", self.timer.value), self.timer.x, self.timer.y, self.timer.width, "right")
  love.graphics.printf(self.collisions.text, self.collisions.x, self.collisions.y, self.collisions.width, "left")
  love.graphics.printf(self.collisions.value, self.collisions.x, self.collisions.y, self.collisions.width, "right")
end
