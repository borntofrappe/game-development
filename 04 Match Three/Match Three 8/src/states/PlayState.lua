PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.board = Board(VIRTUAL_WIDTH / 2 + 100)

  self.fadein = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.isTweening = true

  Timer.tween(
    1,Fo
    {
      [self.fadein] = {a = 0}
    }
  ):finish(
    function()
      self.isTweening = false
      self.board.selectedTile = {
        x = math. random(COLUMNS),
        y = math.random(ROWS)
      }
      self.board:updateBoard()
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
  self.board:render()

  love.graphics.setColor(self.fadein["r"], self.fadein["g"], self.fadein["b"], self.fadein["a"])
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
