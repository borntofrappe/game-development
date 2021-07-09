GameoverState = BaseState:new()

local DELAY = 3

function GameoverState:enter(params)
  self.timer = 0

  self.debris = params.debris

  local x = params.x
  local y = params.y
  local dx = params.dx
  local dy = params.dy
  self.collision = Collision:new(x, y, dx, dy, dx * 3, dy * 3)
end

function GameoverState:update(dt)
  self.timer = self.timer + dt
  if self.timer >= DELAY then
    gStateMachine:change(
      "play",
      {
        ["debris"] = self.debris
      }
    )
  end

  for k, deb in pairs(self.debris) do
    deb:update(dt)

    if deb.x < -deb.width or deb.x > VIRTUAL_WIDTH then
      table.remove(self.debris, k)
    end
  end

  self.collision:update(dt)
end

function GameoverState:render()
  for k, deb in pairs(self.debris) do
    deb:render()
  end

  self.collision:render()
end
