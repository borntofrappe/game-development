TitleState = BaseState:new()

local CUTSCENE_DELAY = 1
local CUTSCENE_TWEEN = 4

local MESSAGE_DELAY = 1

local ROOM_PADDING = 8
local TITLE_MARGIN_BOTTOM = 8

function TitleState:enter()
  local yEnd = VIRTUAL_HEIGHT / 2
  self.enemy = Enemy:new(VIRTUAL_WIDTH / 2 - SPRITE_SIZE / 2, VIRTUAL_HEIGHT, nil, "walking-up")

  self.title = {
    ["text"] = "Berzerk",
    ["y"] = yEnd - TITLE_MARGIN_BOTTOM - gFonts.large:getHeight()
  }

  local text = "Intruder alert!"
  self.message = nil

  Timer:after(
    CUTSCENE_DELAY,
    function()
      Timer:tween(
        CUTSCENE_TWEEN,
        {
          [self.enemy] = {["y"] = VIRTUAL_HEIGHT / 2}
        },
        function()
          self.enemy:changeState("idle")
          Timer:after(
            MESSAGE_DELAY,
            function()
              self.message = Message:new(self.enemy.y + self.enemy.height + 8, text)
            end
          )
        end
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()
    gStateStack:push(
      TransitionState:new(
        {
          ["callback"] = function()
            gStateStack:pop()
            gStateStack:push(PlayState:new())
          end
        }
      )
    )
  end

  -- update only the animation as the y coordinate is updated separately in the tween animation
  self.enemy.currentAnimation:update(dt)
end

function TitleState:render()
  love.graphics.setColor(0.09, 0.09, 0.09)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setColor(0.427, 0.459, 0.906)
  love.graphics.setLineWidth(4)
  love.graphics.line(
    VIRTUAL_WIDTH / 3,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_WIDTH - ROOM_PADDING,
    ROOM_PADDING,
    VIRTUAL_WIDTH - ROOM_PADDING,
    VIRTUAL_HEIGHT - ROOM_PADDING,
    VIRTUAL_WIDTH * 2 / 3,
    VIRTUAL_HEIGHT - ROOM_PADDING
  )

  love.graphics.setColor(0.824, 0.824, 0.824)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, VIRTUAL_WIDTH, "center")

  self.enemy:render()

  if self.message then
    self.message:render()
  end
end
