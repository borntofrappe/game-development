LevelMaker = Class {}

function LevelMaker.generate(width, height)
  local tiles = {}
  local objects = {}
  local entities = {}

  local tileset = math.random(#gFrames["tiles"])
  local topperset = math.random(#gFrames["tops"])
  local colorBushesAndCacti = math.random(#gFrames["bushes_and_cacti"])
  local colorJumpBlocks = math.random(#gFrames["jump_blocks"])

  local hasLock = false
  local hasKey = false
  local colorKeyAndLock = math.random(#gFrames["keys_and_locks"])
  local colorFlag = colorKeyAndLock

  for x = 1, width do
    tiles[x] = {}

    local rows_sky = ROWS_SKY

    local showLock = math.random(50) == 1 or x > width * 2 / 5
    local showKey = math.random(50) == 1 or x > width * 3 / 5

    if not hasLock and showLock then
      hasLock = true
      local lock =
        GameObject(
        {
          x = x,
          y = rows_sky - 1,
          texture = "keys_and_locks",
          color = colorKeyAndLock,
          variety = 2,
          isSolid = true,
          isLock = true,
          onCollide = function()
          end,
          onDisappear = function(obj)
            gSounds["powerup-reveal"]:play()

            local flag =
              GameObject(
              {
                x = obj.x + 0.5,
                y = obj.y - 2,
                width = FLAG_WIDTH,
                height = FLAG_HEIGHT,
                texture = "flags",
                color = colorFlag,
                variety = 1
              }
            )
            table.insert(objects, flag)

            local pole =
              GameObject(
              {
                x = obj.x,
                y = obj.y - 2,
                width = POLE_WIDTH,
                height = POLE_HEIGHT,
                texture = "poles",
                color = colorFlag,
                variety = 1,
                isSolid = true,
                onCollide = function()
                end
              }
            )
            table.insert(objects, pole)
          end
        }
      )
      table.insert(objects, lock)
    elseif not hasKey and showKey then
      hasKey = true
      local isKeyHidden = math.random(2) == 1
      if isKeyHidden then
        table.insert(
          objects,
          GameObject(
            {
              x = x,
              y = rows_sky - 3,
              texture = "jump_blocks",
              color = colorJumpBlocks,
              variety = 1,
              isSolid = true,
              wasHit = false,
              onCollide = function(obj)
                if not obj.wasHit then
                  obj.wasHit = true
                  gSounds["powerup-reveal"]:play()
                  local key =
                    GameObject(
                    {
                      x = obj.x,
                      y = obj.y - 1,
                      texture = "keys_and_locks",
                      color = colorKeyAndLock,
                      variety = 1,
                      isConsumable = true,
                      isKey = true,
                      onConsume = function(obj, player)
                        gSounds["pickup"]:play()
                        player.score = player.score + 300
                      end
                    }
                  )
                  table.insert(objects, key)
                else
                  gSounds["empty-block"]:play()
                end
              end
            }
          )
        )
      else
        local key =
          GameObject(
          {
            x = x,
            y = rows_sky - 1,
            texture = "keys_and_locks",
            color = colorKeyAndLock,
            variety = 1,
            isConsumable = true,
            isKey = true,
            onConsume = function(obj, player)
              gSounds["pickup"]:play()
              player.score = player.score + 200
            end
          }
        )
        table.insert(objects, key)
      end
    else
      local isChasm = math.random(8) == 1
      if isChasm then
        rows_sky = height + 1
      else
        local isPillar = math.random(8) == 1
        if isPillar then
          rows_sky = rows_sky - 2
        else
          local hasCreature = math.random(8) == 1
          if hasCreature then
            local type = math.random(6)
            local creature =
              Creature(
              {
                x = (x - 1) * TILE_SIZE,
                y = (rows_sky - 1 - 1) * TILE_SIZE,
                width = TILE_SIZE,
                height = TILE_SIZE,
                texture = "creatures",
                direction = "left",
                type = type
              }
            )
            table.insert(entities, creature)
          end
        end

        local hasBushOrCactus = math.random(8) == 1
        if hasBushOrCactus then
          local variety = math.random(#gFrames["bushes_and_cacti"][colorBushesAndCacti])
          table.insert(
            objects,
            GameObject(
              {
                x = x,
                y = rows_sky - 1,
                texture = "bushes_and_cacti",
                color = colorBushesAndCacti,
                variety = variety
              }
            )
          )
        end

        local hasJumpBlock = math.random(12) == 1
        if hasJumpBlock then
          table.insert(
            objects,
            GameObject(
              {
                x = x,
                y = rows_sky - 3,
                texture = "jump_blocks",
                color = colorJumpBlocks,
                variety = 1,
                isSolid = true,
                wasHit = false,
                onCollide = function(obj)
                  if not obj.wasHit then
                    obj.wasHit = true
                    local hasGem = math.random(2) == 1
                    if hasGem then
                      local colorGem = math.random(#gFrames["gems"])
                      local gem =
                        GameObject(
                        {
                          x = obj.x,
                          y = obj.y - 1,
                          texture = "gems",
                          color = colorGem,
                          variety = 1,
                          isConsumable = true,
                          onConsume = function(obj, player)
                            gSounds["pickup"]:play()
                            player.score = player.score + 100
                          end
                        }
                      )
                      table.insert(objects, gem)
                      gSounds["powerup-reveal"]:play()
                    else
                      gSounds["empty-block"]:play()
                    end
                  else
                    gSounds["empty-block"]:play()
                  end
                end
              }
            )
          )
        end
      end
    end

    for y = 1, height do
      local tile =
        Tile(
        {
          x = x,
          y = y,
          id = y < rows_sky and TILE_SKY or TILE_GROUND,
          tileset = tileset,
          isTopper = y == rows_sky,
          topperset = topperset
        }
      )

      tiles[x][y] = tile
    end
  end

  local tileMap = TileMap(width, height)
  tileMap.tiles = tiles

  local level =
    GameLevel(
    {
      objects = objects,
      tileMap = tileMap,
      entities = entities
    }
  )
  return level
end
