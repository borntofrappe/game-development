PlayState = BaseState:create()

function PlayState:enter()
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

  local p2 =
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

  self.instructions = {
    ["alpha"] = 1,
    ["messages"] = {}
  }

  for i, p in ipairs({p1, p2}) do
    p.translate = {
      ["column"] = -(p.column - math.floor(world.translate.columns / 4)),
      ["row"] = -(p.row - math.floor(world.translate.rows / 2))
    }

    local text = ""
    local keys = {"up", "left", "down", "right"}
    for j, key in ipairs(keys) do
      local whitespace = j == 1 and "\n\n" or " "
      text = text .. p.keys[key] .. whitespace
    end
    table.insert(
      self.instructions.messages,
      {
        ["text"] = text,
        ["color"] = {
          ["r"] = p.color.r,
          ["g"] = p.color.g,
          ["b"] = p.color.b
        }
      }
    )
  end

  self.world = world
  self.p1, self.p2 = p1, p2

  self.canvases = self:getCanvases()
  self:updateCanvases()

  Timer:after(
    1.5,
    function()
      for i, p in ipairs({p1, p2}) do
        if p.d.c == 0 and p.d.r == 0 then
          local dc = p.column - world.columns / 2
          local dr = p.row - world.rows / 2

          if math.abs(dc) > math.abs(dr) then
            p.d.c = dc > 0 and -1 or 1
          else
            p.d.r = dr > 0 and -1 or 1
          end
        end
      end
      Timer:tween(
        0.5,
        {
          [self.instructions] = {["alpha"] = 0}
        }
      )
    end
  )
end

function PlayState:update(dt)
  for i, p in ipairs({self.p1, self.p2}) do
    p:update(dt)
  end

  if love.keyboard.wasPressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  Timer:update(dt)
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  for i, canvas in ipairs(self.canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end

  love.graphics.setBlendMode("alpha")
  love.graphics.setFont(gFonts["normal"])
  for i, message in ipairs(self.instructions.messages) do
    love.graphics.setColor(message.color.r, message.color.g, message.color.b, self.instructions.alpha)
    love.graphics.printf(
      message.text,
      (i - 1) * CANVAS_WIDTH,
      WINDOW_HEIGHT / 4 - gFonts["normal"]:getHeight(),
      CANVAS_WIDTH - CELL_SIZE,
      "center"
    )
  end
end

function PlayState:getCanvases()
  local canvases = {}
  local world = self.world
  local p1, p2 = self.p1, self.p2

  for i, p in ipairs({p1, p2}) do
    local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
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
      local isGameover = false
      local winner = nil

      local world = self.world
      local p1, p2 = self.p1, self.p2

      for i, p in ipairs({p1, p2}) do
        local otherP = p == p1 and p2 or p1
        if p.d.c ~= 0 or p.d.r ~= 0 then
          p.column = p.column + p.d.c
          p.row = p.row + p.d.r

          p.translate.column = p.translate.column - p.d.c
          p.translate.row = p.translate.row - p.d.r

          local doesOverlap = false
          if not doesOverlap then
            for i, tail in ipairs(p.trail) do
              if tail.column == p.column and tail.row == p.row then
                doesOverlap = true
                break
              end
            end
          end

          if not doesOverlap then
            for i, tail in ipairs(otherP.trail) do
              if tail.column == p.column and tail.row == p.row then
                doesOverlap = true
                break
              end
            end
          end

          if p.column < 1 or p.column > world.columns or p.row < 1 or p.row > world.rows or doesOverlap then
            isGameover = true
            winner = p == p1 and p2 or p1
          end

          if isGameover then
            if self.p1.column == self.p2.column and self.p1.row == self.p2.row then
              winner = nil

              for i, p in ipairs({self.p1, self.p2}) do
                p.column = p.column + p.d.c
                p.row = p.row + p.d.r
                p.translate.column = p.translate.column - p.d.c
                p.translate.row = p.translate.row - p.d.r
              end
            end
            break
          else
            table.insert(
              p.trail,
              {
                ["column"] = p.column,
                ["row"] = p.row
              }
            )
          end
        end
      end

      if isGameover then
        gSounds["gameover"]:stop()
        gSounds["gameover"]:play()
        Timer:reset()
        Timer:after(
          1,
          function()
            gStateMachine:change(
              "gameover",
              {
                ["winner"] = winner
              }
            )
          end
        )
      else
        self.canvases = self:getCanvases()
      end
    end
  )
end
