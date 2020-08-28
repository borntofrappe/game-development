RoundState = Class({__includes = BaseState})

function RoundState:enter(params)
  self.player = params.player or Player()
  self.bullet = params.bullet or nil
  self.aliens = params.aliens or self:createAliens()
  self.bullets = params.bullets or {}

  self.round = params.round or 1
  self.score = params.score or 0
  self.health = params.health or 3
  self.hits = params.hits or 0
  self.speed = params.speed or 1

  self.roundZero = self.round < 10 and "0" .. self.round or tostring(self.round)
  self.roundText = "Round\n" .. self.roundZero .. "\nReady!"

  Timer.after(
    2.5,
    function()
      gStateMachine:change(
        "play",
        {
          player = self.player,
          bullet = self.bullet,
          aliens = self.aliens,
          bullets = self.bullets,
          round = self.round,
          score = self.score,
          health = self.health,
          hits = self.hits,
          speed = self.speed
        }
      )
    end
  )
end

function RoundState:update(dt)
  Timer.update(dt)
end

function RoundState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, 1)
  love.graphics.printf(self.roundText:upper(), 0, WINDOW_HEIGHT / 2 - 36, WINDOW_WIDTH, "center")
end

function RoundState:createAliens()
  local aliens = {}

  for row = 1, ROWS do
    aliens[row] = {}
    for column = 1, COLUMNS do
      local alien = Alien(row, column)
      aliens[row][column] = alien
    end
  end

  return aliens
end
