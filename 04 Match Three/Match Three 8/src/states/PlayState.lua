PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.board = Board(VIRTUAL_WIDTH / 2 + 100)
  self.level = 1
  self.score = 0
  self.goal = 1500
  self.timer = 60

  self.fadein = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.levelText = {
    ["x"] = 0,
    ["y"] = -VIRTUAL_HEIGHT / 2 - 40
  }
  self.isTweening = true

  Timer.tween(
    1,
    {
      [self.fadein] = {a = 0}
    }
  ):finish(
    function()
      Timer.tween(
        0.5,
        {
          [self.levelText] = {y = 0}
        }
      ):finish(
        function()
          Timer.after(
            1,
            function()
              Timer.tween(
                0.5,
                {
                  [self.levelText] = {y = VIRTUAL_HEIGHT / 2 + 40}
                }
              ):finish(
                function()
                  self.isTweening = false
                  self.board.selectedTile = {
                    x = math.random(COLUMNS),
                    y = math.random(ROWS)
                  }
                  self.board:updateBoard()
                end
              )
            end
          )
        end
      )
    end
  )
end

function PlayState:update(dt)
  if not self.isTweening then
    if love.keyboard.waspressed("escape") then
      gStateMachine:change("title")
    end
    self.board:update(dt)
  end

  Timer.update(dt)
end

function PlayState:render()
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle("fill", 16, 16, 188, 140, 8)
  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle("fill", 16, 16, 188, 140, 8)
  love.graphics.setFont(gFonts["normal"])

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Level: " .. self.level, 17, 27, 188, "center")
  love.graphics.printf("Score: " .. self.score, 17, 59, 188, "center")
  love.graphics.printf("Goal: " .. self.goal, 17, 91, 188, "center")
  love.graphics.printf("Timer: " .. self.timer, 17, 123, 188, "center")

  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf("Level: " .. self.level, 16, 26, 188, "center")
  love.graphics.printf("Score: " .. self.score, 16, 58, 188, "center")
  love.graphics.printf("Goal: " .. self.goal, 16, 90, 188, "center")
  love.graphics.printf("Timer: " .. self.timer, 16, 122, 188, "center")

  self.board:render()

  if self.isTweening then
    love.graphics.setColor(self.fadein["r"], self.fadein["g"], self.fadein["b"], self.fadein["a"])
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.translate(self.levelText.x, self.levelText.y)
    love.graphics.setColor(0.42, 0.59, 0.94, 1)
    love.graphics.rectangle("fill", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 40)
    love.graphics.setFont(gFonts["medium"])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Level " .. self.level, 0, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, "center")
  end
end
