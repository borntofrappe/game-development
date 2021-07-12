PlayState = BaseState:new()

local CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
local CANVAS_HEIGHT = WINDOW_HEIGHT

function PlayState:new()
  love.graphics.setBackgroundColor(COLORS.background.r, COLORS.background.g, COLORS.background.b)

  local players = {}

  local column, row
  for i = 1, 2 do
    local c, r
    repeat
      c = math.random(COLUMNS)
      r = math.random(ROWS)
    until c ~= column or r ~= row

    column = c
    row = r
    table.insert(players, Player:new(column, row, "player-" .. i))
  end

  local canvases = self:getCanvases(players)

  local this = {
    ["players"] = players,
    ["canvases"] = canvases
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayState:getCanvases(players)
  local canvases = {}

  for i, player in ipairs(players) do
    local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    love.graphics.setCanvas(canvas)

    love.graphics.push()

    love.graphics.translate(((player.offset.column) - 1) * CELL_SIZE * -1, (player.offset.row - 1) * CELL_SIZE * -1)
    love.graphics.translate(CANVAS_WIDTH / 2 - CELL_SIZE / 2, CANVAS_HEIGHT / 2 - CELL_SIZE / 2)

    love.graphics.setColor(COLORS["play-area"].r, COLORS["play-area"].g, COLORS["play-area"].b)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    player:render()

    love.graphics.pop()

    love.graphics.setCanvas()
    table.insert(canvases, canvas)
  end

  return canvases
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("right") then
    self.players[2].offset.column = self.players[2].offset.column + 1
    self.players[2].cell.column = self.players[2].cell.column + 1
    self.canvases = self:getCanvases(self.players)
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1)
  for i, canvas in ipairs(self.canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end

  love.graphics.setColor(COLORS.background.r, COLORS.background.g, COLORS.background.b)
  love.graphics.setLineWidth(2)
  love.graphics.line(CANVAS_WIDTH, 0, CANVAS_WIDTH, CANVAS_HEIGHT)
end

function PlayState:updateCanvases()
end
