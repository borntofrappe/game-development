BattleMessageState = Class({__includes = BaseState})

function BattleMessageState:init(def)
  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.chunks = def.chunks or {}
  self.textBox =
    TextBox(
    {
      ["chunks"] = self.chunks,
      ["x"] = 4,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = 56
    }
  )

  self.interval =
    Timer.every(
    1.5,
    function()
      self.textBox:next()
    end
  )

  self.textBox.callback = function()
    self.interval:remove()
    self.callback()
  end
end

function BattleMessageState:update(dt)
  Timer.update(dt)
end

function BattleMessageState:render()
  self.textBox:render()
end
