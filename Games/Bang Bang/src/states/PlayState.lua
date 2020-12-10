PlayState = BaseState:create()

function PlayState:enter()
  self.level = Level:create()
  self.menu = Menu:create(self.level)
end

function PlayState:update(dt)
  Timer:update(dt)

  self.level:update(dt)
  self.menu:update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
end

function PlayState:render()
  self.menu:render()
  self.level:render()
end
