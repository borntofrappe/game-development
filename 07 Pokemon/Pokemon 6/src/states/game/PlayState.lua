PlayState = Class({__includes = BaseState})

function PlayState:init(pokemon)
  self.tiles = PlayState:initTiles()

  self.player =
    Player(
    {
      column = 3,
      row = 6,
      pokemon = pokemon,
      stateMachine = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["walking"] = function()
            return PlayerWalkingState(self.player)
          end
        }
      )
    }
  )
  self.player:changeState("idle")
end

function PlayState:update(dt)
  Timer.update(dt)

  if love.keyboard.wasPressed("escape") then
    gStateStack:push(
      FadeState(
        {
          color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
          duration = 0.5,
          opacity = 1,
          callback = function()
            gStateStack:pop()
            gStateStack:push(StartState())
            gStateStack:push(
              FadeState(
                {
                  color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                  duration = 0.5,
                  opacity = 0,
                  callback = function()
                  end
                }
              )
            )
          end
        }
      )
    )
  end

  if love.keyboard.wasPressed("h") or love.keyboard.wasPressed("H") then
    gStateStack:push(DialogueState("Your pokemon has been healed.\nAssuming you have one..."))
  end

  self.player:update(dt)
end

function PlayState:render()
  for k, tile in pairs(self.tiles) do
    tile:render()
  end

  self.player:render()
end

function PlayState:initTiles()
  local tiles = {}

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      table.insert(tiles, Tile(column, row, TILE_BACKGROUND))
      if row > ROWS - ROWS_GRASS then
        table.insert(tiles, Tile(column, row, TILE_GRASS))
      end
    end
  end

  return tiles
end
