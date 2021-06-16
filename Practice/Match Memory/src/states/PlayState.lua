PlayState = Class({__includes = BaseState})

local SYMBOLS_PER_DIFFICULTY = 6
local CARDS_INITIAL = 2
local CARDS_PER_DIFFICULTY = 2

local COLUMNS = 4
local GRID_PADDING = 25
local GRID_WIDTH = VIRTUAL_WIDTH - GRID_PADDING * 2
local GRID_HEIGHT = VIRTUAL_HEIGHT - GRID_PADDING * 2

function PlayState:enter(params)
  self.difficulty = params.difficulty or 1
  local numberSymbols = self.difficulty * SYMBOLS_PER_DIFFICULTY
  local numberCards = self.difficulty * CARDS_PER_DIFFICULTY + CARDS_INITIAL

  local COLUMN_SIZE = math.floor(GRID_WIDTH / COLUMNS)
  local ROWS = math.floor(numberCards * 2 / COLUMNS)
  local ROW_SIZE = math.floor(GRID_HEIGHT / ROWS)

  self.ROWS = ROWS
  self.COLUMNS = COLUMNS
  self.COLUMN_SIZE = COLUMN_SIZE
  self.ROW_SIZE = ROW_SIZE

  local cards = {}

  local positions = {}
  local symbols = {}

  for i = 1, numberCards do
    local symbol

    repeat
      symbol = math.random(numberSymbols)
    until not symbols[symbol]
    symbols[symbol] = true

    for j = 1, 2 do
      local position
      repeat
        position = math.random(numberCards * 2)
      until not positions[position]
      positions[position] = true

      local column = (position - 1) % COLUMNS
      local row = math.floor((position - 1) / COLUMNS)

      local x = math.floor(column * COLUMN_SIZE)
      local y = math.floor(row * ROW_SIZE)

      local key = "c" .. column .. "r" .. row
      cards[key] = Card(x, y, symbol)
    end
  end

  self.cards = cards

  self.column = 0
  self.row = 0

  self.cards["c" .. self.column .. "r" .. self.row]:focus()

  self.revealed = nil
  self.match = nil
end

function PlayState:getKey(column, row)
  return "c" .. self.column .. "r" .. self.row
end

function PlayState:focus(dc, dr)
  self.cards[self:getKey(self.column, self.row)]:blur()

  self.column = (self.column + dc) % self.COLUMNS
  self.row = (self.row + dr) % self.ROWS

  self.cards[self:getKey(self.column, self.row)]:focus()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("up") then
    self:focus(0, -1)
  end

  if love.keyboard.waspressed("down") then
    self:focus(0, 1)
  end

  if love.keyboard.waspressed("left") then
    self:focus(-1, 0)
  end

  if love.keyboard.waspressed("right") then
    self:focus(1, 0)
  end

  if love.keyboard.waspressed("return") then
    local key = self:getKey(self.column, self.row)
    if self.cards[key].isMatched then
      return
    end

    if self.match then
      if self.cards[self.match].symbol ~= self.cards[self.revealed].symbol then
        self.cards[self.match]:hide()
        self.cards[self.revealed]:hide()
      else
        self.cards[self.match]:match()
        self.cards[self.revealed]:match()
      end
      self.match = nil
      self.revealed = nil
    end

    if self.revealed then
      if self.revealed == key then
        self.cards[key]:hide()
        self.revealed = nil
      else
        self.cards[key]:reveal()
        self.match = key
      end
    else
      self.cards[key]:reveal()
      self.revealed = key
    end
  end

  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        difficulty = self.difficulty
      }
    )
  end
end

function PlayState:render()
  love.graphics.setColor(0.1, 0.1, 0.1)

  -- love.graphics.line(
  --   GRID_PADDING,
  --   GRID_PADDING,
  --   GRID_PADDING + GRID_WIDTH,
  --   GRID_PADDING,
  --   GRID_PADDING + GRID_WIDTH,
  --   GRID_HEIGHT + GRID_PADDING,
  --   GRID_PADDING,
  --   GRID_HEIGHT + GRID_PADDING,
  --   GRID_PADDING,
  --   GRID_PADDING
  -- )

  love.graphics.translate(math.floor(GRID_PADDING + self.COLUMN_SIZE / 2), math.floor(GRID_PADDING + self.ROW_SIZE / 2))
  for k, card in pairs(self.cards) do
    card:render()
  end
end
