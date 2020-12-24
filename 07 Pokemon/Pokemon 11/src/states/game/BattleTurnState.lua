BattleTurnState = Class({__includes = BaseState})

function BattleTurnState:init(def)
  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.p1 = def.p1
  self.p2 = def.p2

  self.textBox =
    TextBox(
    {
      ["chunks"] = {
        string.sub(self.p1.name, 1, 1):upper() .. string.sub(self.p1.name, 2, -1) .. " attacks!",
        string.sub(self.p2.name, 1, 1):upper() .. string.sub(self.p2.name, 2, -1) .. " attacks!"
      },
      ["x"] = 4,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = 56
    }
  )

  self.p1Health = def.p1Health
  self.p2Health = def.p2Health

  local damage = math.max(1, self.p1.stats.attack - self.p2.stats.defense)
  self.p2.stats.hp = math.max(0, self.p2.stats.hp - damage)
  self.p2Health:setValue(self.p2.stats.hp)

  Timer.tween(
    1,
    {
      [self.p2Health] = {fillWidth = self.p2Health.width / self.p2Health.max * self.p2Health.value}
    }
  ):finish(
    function()
      self.textBox:next()
      local damage = math.max(1, self.p2.stats.attack - self.p1.stats.defense)
      self.p1.stats.hp = math.max(0, self.p1.stats.hp - damage)
      self.p1Health:setValue(self.p1.stats.hp)

      Timer.tween(
        1,
        {
          [self.p1Health] = {fillWidth = self.p1Health.width / self.p1Health.max * self.p1Health.value}
        }
      ):finish(
        function()
          self.callback()
        end
      )
    end
  )
end

function BattleTurnState:update(dt)
  Timer.update(dt)
end

function BattleTurnState:render()
  self.textBox:render()
end
