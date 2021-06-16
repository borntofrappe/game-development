PlayState = Class({__includes = BaseState})

local SYMBOLS_PER_DIFFICULTY = 6
local CARDS_PER_DIFFICULTY = 3

function PlayState:init()
end

function PlayState:enter(params)
  self.difficulty = params.difficulty or 1
  local symbols = self.difficulty * SYMBOLS_PER_DIFFICULTY
  local options = self.difficulty * OPTIONS_PER_DIFFICULTY

  local cards = {}
  local indexes = {}
  local types = {}

  for i = 1, options do
    local symbol

    repeat
      symbol = math.random(symbols)
    until not types[symbol]

    types[symbol] = true

    for j = 1, 2 do
      local index
      repeat
        index = math.random(options * 2)
      until not indexes[index]

      indexes[index] = true
      local angle = math.rad(index * 360 / (options * 2))
      table.insert(cards, Card(angle, symbol))
    end
  end

  self.cards = cards
end

function PlayState:update(dt)
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

  love.graphics.translate(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
  for i, card in ipairs(self.cards) do
    card:render()
  end
end
