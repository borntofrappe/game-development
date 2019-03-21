-- create a class of LevelMaker
LevelMaker = Class{}

-- the class is responsible for the creation of the levels in so far as it returns a table of bricks
-- create a function on the class to create the level

function LevelMaker.createMap(level)
  -- initialize an empty table
  local bricks = {}

  -- pick a number of rows and columns at random
  maxRows = math.min(5, math.floor(level / 5) + 3)
  maxColumns = math.min(10, math.floor(level / 5) + 4)
  local numRows = math.random(2, maxRows)
  local numCols = math.random(3, maxColumns)

  -- loop through the rows and columns as to add one brick for each cell
  for row = 1, numRows do
    for col = 1, numCols do
      -- create a flag to randomly skip a cell
      -- skip a brick with a 33% possibility
      skipFlag = math.random(1, 3) == 2 and true or false


      if not skipFlag then
        -- create a flag to determine whether the brick is included through a locked version
        lockedFlag = false
        -- include the locked variant starting with level 5 and with 10% of probability
        if level >= 5 and math.random(10) == 2 then
          lockedFlag = true
        end
        -- if locked specify the values for the locked brick (22nd sprite in the brick's table)
        if lockedFlag then
          brick = Brick(
            -- same position of the ordinary bricks
            (col - 1) * 32 + (VIRTUAL_WIDTH - numCols * 32) / 2,
            row * 16,
            -- first color and tier
            1,
            1,
            -- true to have the locked integer refer to the 22nd brick
            true
          )

        else
          -- if not locked include a brick choosing a tier and color
          -- for the tier and color, have the value picked at random, between 1 and a value up to the highest tier and color
          -- up to the highest, but influenced by the level, with higher levels having increasing variety
          maxTier = math.min(3, math.floor(level / 3))
          maxColor = math.min(4, math.floor(level / 4))
          tier = math.random(1, maxTier + 1)
          color = math.random(1, maxColor + 1)

          -- create a brick through an instance of the brick class
          -- class instantiatd with an x and y coordinate, as well as the color and tier of the brick
          brick = Brick(
            --[[
              horizontally: considering that each brick is 32px wide, you can center the different columns with a bit of math
              starting from (col -1) *  32, which can be 0 and multiple of 32 to separate each brick from one another
              adding as much as to center, which is based on the remaining space (virtual width to which the space occupied by the columns is removed, divided by two)
            ]]
            (col - 1) * 32 + (VIRTUAL_WIDTH - numCols * 32) / 2,
            --[[
              vertically: considering that each brick is 16px tall, increase the row value by 16px
            ]]
            row * 16,
            color,
            tier,
            -- false describing the fact that the brick is not locked
            false
          )
        end

        -- insert the brick in the table
        table.insert(bricks, brick)
      end


    end
  end

  -- if bricks is an empty table, add a single brick in the center of the screen
  if #bricks == 0 then
    table.insert(bricks, Brick(VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 8 - 8, 1, 1))
  end

  return bricks

end