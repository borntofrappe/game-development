--[[
  play state

  showing:
    - a panel with the level, score, goal, timer
    - the board of tiles

  allowing to:
    - swap tiles and create matches, eventually leading up to
      - victory state, when reaching the goal [TODO]
      - gameover state, when the timer hits 0
]]

-- inherit from the BaseState class
PlayState = Class{__includes = BaseState}

-- in the init() function
function PlayState:init()
  -- set up a timer for the countdown
  self.time = 5


  -- table describing the overlay used for the fadein transition
  -- describing the overlay in terms of its color
  self.fadein = {
    r = 1,
    g = 1,
    b = 1,
    -- the alpha value is updated through Timer.tween()
    a = 1
  }

  -- table describing the value ultimately used for the overlay and the text
  self.stripe = {
    y = 0 - 36
  }

  -- boolean allowing the player to interact with the game only after the play state is introduced
  self.isPlaying = false

  --[[
    schedule of transitions
    - fade to white
      - show a stripe with the level translating it from the top of the screen to the very center of the screen
        - pause the stripe mid-screen
          - remove the stripe from view translating it to the bottom of the screen
            - set up the countdown timer
            end
          end
        end
      end
    end
  ]]
  Timer.tween(0.7, {
    [self.fadein] = { a = 0 }
  }):finish(function()
    Timer.tween(0.5, {
      [self.stripe] = { y = VIRTUAL_HEIGHT / 2 - 18}
    }):finish(function()
      Timer.after(1.25, function()
        Timer.tween(0.45, {
          [self.stripe] = { y = VIRTUAL_HEIGHT}
        }):finish(function()

          -- switch isPlaying to true to interact with the play state
          self.isPlaying = true
          Timer.every(1, function()
            self.time = self.time - 1
          end)

        end)

      end)
    end)
  end)

end

-- in the update(dt) function listen for a key press on a selection of keys
function PlayState:update(dt)
  -- include every interaction of the play state when self.isPlaying is true, meaning the play state has been introduced
  if self.isPlaying then

    -- when pressing enter increase the arbitrary value chosen for the timer
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      self.time = self.time + 2
    end

  end

  -- update the timer as long as timer is greater than 0
  if self.time > 0 then
    Timer.update(dt)
  else
    -- go to the gameover state
    gStateMachine:change('gameover')
  end
end

-- in the render() function, display a panel with information on the current game
function PlayState:render()
  -- include the text on top of a colored rectangle
  -- ! overlay the colored rectangle with yet another overlay, to darken the color
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 6 - VIRTUAL_WIDTH / 8, VIRTUAL_HEIGHT / 12, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, 5)
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 6 - VIRTUAL_WIDTH / 8, VIRTUAL_HEIGHT / 12, VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 2, 5)

  love.graphics.setFont(gFonts['normal'])
  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  -- center the strings in the rectangle, which is itself centered around VIRTUAL_WIDTH / 6
  -- vertically spread the strings evenly in the VIRTUAL_HEIGHT / 2 tall container
  -- (VIRTUAL_HEIGHT / 2) / 5
  love.graphics.printf(
    'Level: 1',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Score: 123',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 2 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Goal: 321',
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 3 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )
  love.graphics.printf(
    'Timer: ' .. tostring(self.time),
    0,
    VIRTUAL_HEIGHT / 12 + (VIRTUAL_HEIGHT / 2) / 5 * 4 - 8,
    VIRTUAL_WIDTH / 3,
    'center'
  )

  -- rectangle using self.fadein to transition from the previous state
  -- self.fadein contains one value for each of the rgba fields coloring the rectangle
  love.graphics.setColor(self.fadein.r, self.fadein.g, self.fadein.b, self.fadein.a)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)


  -- rectangle shown after the fadein transition, showing the current level
  -- use the color of the text, slightly subdued with a white overlay
  love.graphics.setColor(0.1, 0.17, 0.35, 1)
  love.graphics.rectangle('fill', 0, self.stripe.y, VIRTUAL_WIDTH, 36)
  love.graphics.setColor(1, 1, 1, 0.3)
  love.graphics.rectangle('fill', 0, self.stripe.y, VIRTUAL_WIDTH, 36)

  -- text shown on top of the overlay
  love.graphics.setFont(gFonts['big'])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(
    'Level: 1',
    0,
    self.stripe.y + 9,
    VIRTUAL_WIDTH,
    'center'
  )
end