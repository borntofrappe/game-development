PlayState = Class({__includes = BaseState})

local SYMBOLS_PER_LEVEL = 6
local CARDS_INITIAL = 2
local CARDS_PER_LEVEL = 2

local COLUMNS = 4
local GRID_PADDING = 25
local GRID_WIDTH = VIRTUAL_WIDTH - GRID_PADDING * 2
local GRID_HEIGHT = VIRTUAL_HEIGHT - GRID_PADDING * 2

function PlayState:init()
  self.firstRevealed = nil
  self.secondRevealed = nil
end

function PlayState:enter(params)
  self.level = params.level or 1
  local numberSymbols = self.level * SYMBOLS_PER_LEVEL
  local numberCards = self.level * CARDS_PER_LEVEL + CARDS_INITIAL

  local COLUMN_SIZE = GRID_WIDTH / COLUMNS
  local ROWS = math.floor(numberCards * 2 / COLUMNS)
  local ROW_SIZE = GRID_HEIGHT / ROWS

  self.ROWS = ROWS
  self.COLUMNS = COLUMNS
  self.COLUMN_SIZE = COLUMN_SIZE
  self.ROW_SIZE = ROW_SIZE

  local cards = {}

  local symbols = {}
  local positions = {}

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

      local x = column * COLUMN_SIZE + GRID_PADDING + self.COLUMN_SIZE / 2
      local y = row * ROW_SIZE + GRID_PADDING + self.ROW_SIZE / 2

      local key = "c" .. column .. "r" .. row
      cards[key] = Card(x, y, symbol)
    end
  end

  self.cards = cards

  self.column = 0
  self.row = 0
  self.cards["c" .. self.column .. "r" .. self.row]:focus()
end

function PlayState:getKey(column, row)
  return "c" .. self.column .. "r" .. self.row
end

function PlayState:hasWon()
  local hasWon = true

  for k, card in pairs(self.cards) do
    if not card.isPaired then
      hasWon = false
      break
    end
  end

  return hasWon
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

    if self.cards[key].isPaired then
      if self.firstRevealed then
        if not self.cards[self.firstRevealed].isPaired then
          self.cards[self.firstRevealed]:hide()
        end

        self.firstRevealed = nil
      end
      if self.secondRevealed then
        self.secondRevealed = nil
      end
      return
    end

    if self.firstRevealed and self.secondRevealed then
      if self.cards[self.firstRevealed].symbol ~= self.cards[self.secondRevealed].symbol then
        self.cards[self.firstRevealed]:hide()
        self.cards[self.secondRevealed]:hide()
      end

      self.firstRevealed = nil
      self.secondRevealed = nil
    end

    if self.firstRevealed then
      if self.firstRevealed == key then
        self.cards[key]:hide()
        self.firstRevealed = nil
      else
        self.secondRevealed = key
        self.cards[self.secondRevealed]:reveal()

        if self.cards[self.firstRevealed].symbol == self.cards[self.secondRevealed].symbol then
          self.cards[self.firstRevealed]:match()
          self.cards[self.secondRevealed]:match()

          if self:hasWon() then
            self.cards[self.secondRevealed]:blur()

            gStateMachine:change(
              "victory",
              {
                cards = self.cards,
                level = self.level,
                topY = GRID_PADDING,
                bottomY = GRID_PADDING + GRID_HEIGHT
              }
            )
          end
        end
      end
    else
      self.firstRevealed = key
      self.cards[self.firstRevealed]:reveal()
    end
  end

  if love.keyboard.waspressed("escape") then
    gStateMachine:change(
      "start",
      {
        level = self.level
      }
    )
  end
end

function PlayState:render()
  --[[
    love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)

    love.graphics.line(
      GRID_PADDING,
      GRID_PADDING,
      GRID_PADDING + GRID_WIDTH,
      GRID_PADDING,
      GRID_PADDING + GRID_WIDTH,
      GRID_HEIGHT + GRID_PADDING,
      GRID_PADDING,
      GRID_HEIGHT + GRID_PADDING,
      GRID_PADDING,
      GRID_PADDING
    )
  --]]
  for k, card in pairs(self.cards) do
    card:render()
  end
end
