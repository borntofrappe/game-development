PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.width = 100
  self.height = 10
  self.map = LevelMaker.generate(self.width, self.height)
  self.background = math.random(#gFrames.backgrounds)
  self.tileset = math.random(#gFrames.tiles)
  self.topperset = math.random(#gFrames.tops)

  self.camX = 0
  self.camY = 0

  self.player =
    Player(
    {
      x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
      y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
      width = PLAYER_WIDTH,
      height = PLAYER_HEIGHT,
      texture = "character",
      stateMachine = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["walking"] = function()
            return PlayerWalkingState(self.player)
          end,
          ["jump"] = function()
            return PlayerJumpState(self.player)
          end,
          ["falling"] = function()
            return PlayerFallingState(self.player)
          end
        }
      )
    }
  )

  self.player:changeState("idle")
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  self.player:update(dt)

  self.camX =
    math.max(
    0,
    math.min(self.width * TILE_SIZE - VIRTUAL_WIDTH, self.player.x + self.player.width / 2 - VIRTUAL_WIDTH / 2)
  )

  if self.player.x <= 0 then
    self.player.x = 0
  elseif self.player.x >= self.width * TILE_SIZE - self.player.width then
    self.player.x = self.width * TILE_SIZE - self.player.width
  end
end

function PlayState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  love.graphics.translate(-math.floor(self.camX), 0)

  for x, column in ipairs(self.map) do
    for y, tile in ipairs(column) do
      love.graphics.draw(
        gTextures["tiles"],
        gFrames["tiles"][self.tileset][tile.id],
        (x - 1) * TILE_SIZE,
        (y - 1) * TILE_SIZE
      )
      if tile.topper then
        love.graphics.draw(
          gTextures["tops"],
          gFrames["tops"][self.topperset][1],
          (x - 1) * TILE_SIZE,
          (y - 1) * TILE_SIZE
        )
      end
    end
  end

  self.player:render()
end
