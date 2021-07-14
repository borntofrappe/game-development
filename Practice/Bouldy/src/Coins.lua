Coins = {}

function Coins:new(maze, player)
  local keys = {}
  local coins = {}

  local columns = maze.columns
  local rows = maze.rows

  while #coins < COINS do
    local column = math.random(columns)
    local row = math.random(rows)

    local key = "c" .. column .. "r" .. row
    if not keys[key] and (column ~= player.column or row ~= player.row) then
      keys[key] = true
      table.insert(coins, Coin:new(column, row))
    end
  end

  local this = {
    ["coins"] = coins
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Coins:render()
  love.graphics.setColor(COLORS.coin.r, COLORS.coin.g, COLORS.coin.b)

  for i, coin in ipairs(self.coins) do
    coin:render()
  end
end
