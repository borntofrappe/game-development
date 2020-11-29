PlayState = BaseState:create()

function PlayState:enter(params)
  local world = {
    ["columns"] = COLUMNS * 2,
    ["rows"] = ROWS * 2,
    ["translate"] = {
      ["columns"] = COLUMNS,
      ["rows"] = ROWS
    }
  }

  local p1 =
    Player:new(
    math.floor(world.columns / 4) + love.math.random(math.floor(world.columns / 2)),
    math.floor(world.rows / 4) + love.math.random(math.floor(world.rows / 2)),
    {
      ["r"] = 0.16,
      ["g"] = 0.83,
      ["b"] = 0.69
    },
    {
      ["up"] = "w",
      ["right"] = "d",
      ["down"] = "s",
      ["left"] = "a"
    }
  )

  p2 =
    Player:new(
    math.floor(world.columns / 4) + love.math.random(math.floor(world.columns / 2)),
    math.floor(world.rows / 4) + love.math.random(math.floor(world.rows / 2)),
    {
      ["r"] = 0.62,
      ["g"] = 0,
      ["b"] = 1
    },
    {
      ["up"] = "up",
      ["right"] = "right",
      ["down"] = "down",
      ["left"] = "left"
    }
  )

  for i, p in ipairs({p1, p2}) do
    p.translate = {
      ["column"] = -(p.column - math.floor(world.translate.columns / 4)),
      ["row"] = -(p.row - math.floor(world.translate.rows / 2))
    }
  end

  self.world = world
  self.p1, self.p2 = p1, p2

  self.canvases = self:getCanvases()
  self.winner = nil
  self:updateCanvases()
end

function PlayState:update(dt)
  Timer:update(dt)

  for i, p in ipairs({self.p1, self.p2}) do
    p:update(dt)
  end

  if love.keyboard.wasPressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  if self.winner then
    Timer:reset()
    gStateMachine:change(
      "victory",
      {
        ["winner"] = self.winner
      }
    )
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  for i, canvas in ipairs(self.canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end
end

function PlayState:getCanvases()
  local canvases = {}
  local world = self.world
  local p1, p2 = self.p1, self.p2

  for i, p in ipairs({p1, p2}) do
    canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.push()

    love.graphics.translate(p.translate.column * p.size, p.translate.row * p.size)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, world.columns * p.size, world.rows * p.size)

    for j, player in ipairs({p1, p2}) do
      player:render()
    end

    love.graphics.pop()

    love.graphics.setCanvas()
    canvases[i] = canvas
  end

  return canvases
end

function PlayState:updateCanvases()
  Timer:every(
    INTERVAL,
    function()
      local world = self.world
      local p1, p2 = self.p1, self.p2

      for i, p in ipairs({p1, p2}) do
        if p.d.c ~= 0 or p.d.r ~= 0 then
          local hasTrail = false
          for i, tail in ipairs(p.trail) do
            if tail.column == p.column and tail.row == p.row then
              hasTrail = true
              break
            end
          end

          if not hasTrail then
            table.insert(
              p.trail,
              {
                ["column"] = p.column,
                ["row"] = p.row
              }
            )
          else
          end
        end

        p.column = p.column + p.d.c
        p.row = p.row + p.d.r

        p.translate.column = p.translate.column - p.d.c
        p.translate.row = p.translate.row - p.d.r

        if p.column < 1 or p.column > world.columns or p.row < 1 or p.row > world.rows then
          self.winner = p == p1 and p2 or p1
        end
      end

      self.canvases = self:getCanvases()
    end
  )
end
