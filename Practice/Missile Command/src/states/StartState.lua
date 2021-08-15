StartState = BaseState:new()

function StartState:enter()
  local titleWidth = gTextures.title:getWidth()
  local titleHeight = gTextures.title:getHeight()
  local gapHeight = 6 -- size of the gap
  local gapOffsetY = 24 -- where the title is split in two
  local gapOffsetX = 256 -- where the letter e in missile begins

  local title = {
    ["x"] = math.floor(WINDOW_WIDTH / 2 - titleWidth / 2),
    ["y"] = WINDOW_HEIGHT / 2 - titleHeight
  }

  self.title = title

  local missileWidth = 18
  local missileHeight = 4
  local missile = {
    ["x"] = self.title.x - missileWidth - 2,
    ["y"] = self.title.y + gapOffsetY + gapHeight / 2 - missileHeight / 2,
    ["width"] = missileWidth,
    ["height"] = missileHeight,
    ["delay"] = 1,
    ["tween"] = 3
  }

  self.missile = missile

  self.instruction = {
    ["isVisibile"] = false,
    ["delay"] = 0.8
  }

  Timer:after(
    self.missile.delay,
    function()
      Timer:tween(
        self.missile.tween,
        {
          [self.missile] = {["x"] = self.title.x + gapOffsetX}
        },
        function()
          Timer:after(
            self.instruction.delay,
            function()
              self.instruction.isVisibile = true
            end
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()
    gStateMachine:change("serve")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.title, self.title.x, self.title.y)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", self.missile.x, self.missile.y, self.missile.width, self.missile.height)

  if self.instruction.isVisibile then
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf("Play", 0, WINDOW_HEIGHT * 3 / 4 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
  end
end
