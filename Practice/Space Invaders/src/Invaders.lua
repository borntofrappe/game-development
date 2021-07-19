Invaders = {}

local INVADERS_GRID = {
  ["columns"] = 8,
  ["rows-per-type"] = {2, 2, 1}
}

local PROJECTILE_ODDS = 3 -- 1 in 3

function Invaders:new(delayMultiplier)
  local invaders = {}

  local rows = 0
  for i, row in pairs(INVADERS_GRID["rows-per-type"]) do
    rows = rows + row
  end

  for type = 1, INVADER_TYPES do
    local rowsType = INVADERS_GRID["rows-per-type"][type]
    for row = 1, rowsType do
      for column = 1, INVADERS_GRID.columns do
        local x = WINDOW_PADDING + (column - 1) * (INVADER_WIDTH + INVADER_WIDTH / 2)
        local y = WINDOW_PADDING + (rows - row) * (INVADER_HEIGHT + INVADER_HEIGHT / 2)
        table.insert(invaders, Invader:new(x, y, type))
      end
    end
    rows = rows - rowsType
  end

  local this = {
    ["invaders"] = invaders,
    ["projectiles"] = {},
    ["projectileOdds"] = PROJECTILE_ODDS,
    ["direction"] = 1,
    ["delayMultiplier"] = delayMultiplier
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Invaders:update(player)
  local changeDirection = false
  local collideWithPlayer = false

  local projectileCoords = {
    ["y"] = 0,
    ["x"] = {}
  }

  for k, invader in pairs(self.invaders) do
    if invader.y > projectileCoords.y then
      projectileCoords.y = invader.y
      projectileCoords.x = {invader.x}
    else
      table.insert(projectileCoords.x, invader.x)
    end

    local x = invader.x + invader.width * self.direction

    if x > WINDOW_WIDTH - WINDOW_PADDING - invader.width or x < WINDOW_PADDING then
      changeDirection = true
      break
    end
  end

  if math.random(self.projectileOdds) == 1 then
    local x = projectileCoords["x"][math.random(#projectileCoords["x"])]
    local y = projectileCoords["y"]

    table.insert(self.projectiles, Projectile:new(x + INVADER_WIDTH / 2, y + INVADER_HEIGHT / 2, 1))
  end

  if changeDirection then
    self.direction = self.direction * -1

    for k, invader in pairs(self.invaders) do
      local y = invader.y + invader.height

      if y > WINDOW_HEIGHT - WINDOW_PADDING - player.height - invader.height then
        collideWithPlayer = true
        break
      end
    end
  end

  for k, invader in pairs(self.invaders) do
    Timer:after(
      self.delayMultiplier * invader.type,
      function()
        if changeDirection then
          invader.y = invader.y + invader.height
        else
          invader.x = invader.x + invader.width * self.direction
        end

        if invader.frame == INVADER_FRAMES then
          invader.frame = 1
        else
          invader.frame = invader.frame + 1
        end
      end
    )
  end

  return changeDirection, collideWithPlayer
end

function Invaders:render()
  love.graphics.setColor(1, 1, 1)
  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end

  love.graphics.setColor(1, 1, 1)
  for k, invader in pairs(self.invaders) do
    invader:render()
  end
end
