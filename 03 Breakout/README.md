# Breakout

## Preface

For the [third video](https://youtu.be/pGpn2YMXtdg) in the intro to game development @cs50, the game breakout allows to cover the following topics:

- sprite sheets (large image files, of which a desired section is shown);

- procedural generation (laying bricks with different colors);

- state (a more specific way to manage the state);

- levels (progression system, influencig the generation of the levels);

- player health (in the form of hearts);

- particle systems (aesthetical pleasing addition to highlight a collision between ball and bricks);

- collision detection (once more);

- persistent data (to show the high scores of the game).

## Introductory Remarks

The game is set to play out with the following state chart as a reference:

```text
------ start ←----------------------------------
|         |                                     |
|         |                                     |
|        ↓ ↑                                    |
|     high score ← -- enter high score ←-- game over
|                                               ↑
|                                               |
 ----→ paddle select ----→ serve  ----→ play -- |
                             |           |
                             |           |
                             ↑           |
                         victory ←-------
```

There's a rather more complex flow to the game, most notably due to the presence of the screen showing the high scores

## Update

Just like for flappy bird, I decided to introduce the final, working project in the root folder of the game's own repo. There isn't any actual update 13, but the idea is to take the preceding 12 updates and finalize the game. Starting with a revision of the codebase and continuing with the assignment.

### State

Here's the revised structure of the game.

```text
------ start ←----------------------------------
|         |                                     |
|         |                                     |
|        ↓ ↑                                    |
|     high score ← -- enter high score ←-- game over
|                                               ↑
|                                               |
 ----→ paddle select ----→ serve  ----→ play -- |
                             |           | ↑
                             |           | |
                             ↑           |  --→ pause
                         victory ←-------
```

Nothing major changed from the introductory README, except for the addition of the pause state.

### Code Changes

While going through the different files, I updated the comments and included the following changes:

- the table of high scores is no longer a global variable. In keeping in line with the course, I decided to make it a variable which is passed to any state which may need it.

- the `displayHealth` function has been modified as to accept also `maxHealth`. This allows to more easily develop a feature in which the health is increased as the game progresses.

- the way the `GameoverState` identifies a high score has been overhauled, from considering the scores in the local `lst` file to analyse the table of high score. This is a much less challenging endeavor, as looping through a table is much easier than cycling though a file of line separated names and scores.

- sound played through the different instances of the `:play()` function has been updated, to aptly consider the different choices (using for instance the `confirm` sound file when choosing a paddle, entering the high score), and most importantly to make use of other files included in the `gSounds` table. The victory and high score soundbite come particularly to mind.

## Assignment

The assignment given at the end of the lecture concerns mainly powerups, as available in the `breakout,png` asset. That being said, there are three expansions foreseen by the lecturer.

Small foreword to the assignment: I decided to tweak some of the actual requests to make for what I believe to be a more compelling gameplay. The paddle changes in size, for instance, when picking up a particular powerup. Modifications are included after each assignment, which is highllighted through _italic typeface_.

- [x] _Add a Powerup class to the game that spawns a powerup_

  - [x] _a Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and gradually descend toward the player_

  - [x] _Once collided with the Paddle, two more Balls should spawn and behave identically to the original, including all collision and scoring points for the player_. In addition to the powerup including a new ball (just one), I made use of the other quads making up the powerup. Whenever the ball destroys a brick, there's a chance to have one of these powerups spawn and one in particular achieves the doubling feat.

  - [x] _Once the player wins and proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again_.

- [x] _Grow and shrink the Paddle such that it’s no longer just one fixed size forever_. As I believe the assignment specified a rather questionable design choice (changing the size of the paddle relative to health or the score), I tied the change in size to two different powerups. As they are picked up, it is then that the paddle grows/shrinks.

- [x] _Add a locked Brick to the level spawning, as well as a key powerup_

  - [x] _The locked Brick should not be breakable by the ball normally, unless they of course have the key Powerup_

  - [x] _The key Powerup should spawn randomly just like the Ball Powerup and descend toward the bottom of the screen just the same, where the Paddle has the chance to collide with it and pick it up_

### Powerups

Starting from the first point, I decided to consider the entire last row of the texture found in `breakout.png`, and include the following alterations:

- shrink or increase the paddle size;

- add or remove a health point;

- increase or decreasse the speed of the ball;

- push the ball upwards or downwards, as a result of intensified lift or gravity.

Implementing the actual modifications is rather straightforward: modify the field values of the paddle, health or ball.

Incorporating the powerups is the actual challenge of the update, and here's how I implemented the feature.

The feature itself is inspired by the particle system, and specifically the positioning of the particle system. Just like with particle, I decided to add powerups "inside" of, connected to, the bricks. You destroy a brick, you have a chance to have a powerup spawn from the location of the brick. The powerup moves downwards. If it hits the paddle, an appropriate modification is implemented. If it goes past the bottom of the screen, the powerup disappears and nothing changes.

#### Powerup.lua

In this class I created the powerup similarly to the ball. This one createx a powerup from one of the quads retrieved from the image (more on this later). The setup is eerily similar to the ball class, except for the following:

- there exist movement in only one direction, `dy`;

- there exist a flag `inPlay` to conditionally render/update the powerup as long as the condition holds true.

In the `update(dt)` function the class updates the powerup changing its `y` coordinate and pushing the asset below the edge of the screen. The function also accounts for when a powerup currently in play goes past the bottom of the screen, by setting the boolean to false.

In the `collides(paddle)` function the class implements an AABB collision detection test to determine whether the powerup has hit the paddle.

In the `render()` function the clss renders the graphic, if in play and leveraging the `self.power` value. This is a random value which allows to identify a specific power among the `g['powerups']` table.

#### Brick.lua

Similarly to how the particle system is set up, the powerup is introduced through a `self.powerup` field. This field describes an instance of the `Powerup` class and position it at the center of the brick.

In the `init()` function include a `self.hasPowerup` boolean, which is used to display a powerup only behind a certain number of bricks, as opposed to all of them.

In the `update(dt)` function update the powerup only if the brick is no longer in play (read: destroyed) **and** the brick has a powerup, as determined through the mentioned flag.

In the `render()` function render the powerup through the connected function, and again oly if the brick has a powerup and the brick is no longer in play.

#### main.lua && Util.lua

In `main.lua` the `gFrames` table is updated with a table collecting the quads for the powerups. These quads are retrieved in `Util.lua`, with a function similar to the `GenerateQuadsBricks` one.

The 16 by 16 assets are included by slicing the quads created from the entire image, at the coordinates determining the beginning of the last row.

#### PlayState.lua

Without further specification, the powerup are introduced and moved to the bottom of the screen. It is then in the play state where the collision between the paddle and the powerup is handled.

When updating the bricks, check if an existing powerup collides with the paddle. If so, set the boolean to false (no longer rendering the powerup) and based on the value of `self.power` implement the different features.

The features are rather easy to implement. Change the size of the paddle, change the speed of the ball, change the movement of the ball. I decided to add a touch more detail, for instance by making the paddle's size alter the speed of the paddle as well. Small elements like this add a bit of subtlety which rather improves the gameplay.

### Powerup #9

The ninth asset in the powerup table can be used for the second point of the assignment: spawning additional balls. The idea is to have new balls act as the existing one would. As they spawn, they are able to collide with walls, paddle, bricks. When colliding with bricks, they allow to increase the score. The only difference introduced with multiple balls regards the removal of health points, which doesn't occur when one ball goes past the bottom of the screen, but when every ball has gone past the bottom edge of the screen.

Here's my approach, inspired this time around by the way bricks are updated and rendered on the page: instead of including the ball through a `self.ball` field, add a table of balls in `self.balls`. This table nests as many instances of the `Ball` class as dictated by the game, which means 1 by default and any additional ball added through powerup #9.

This means update #9 is ideally implemented by inserting a new ball in said table:

```lua
table.insert(self.balls, ball)
```

To achieve this feat, here's how I updated the different, reponsiblle files.

#### Ball.lua

Just like for the `Brick` class, and the `Powerup` class for that matter, I added a `self.inPlay` boolean to aptly determine whether the ball is in play or not (read: whether it has yet to go past the bottom edge of the screen).

```lua
self.inPlay = true
```

This is default-ed to true and used in the update and render function, updating and rendering the ball as long as the boolean holds true.

#### ServeState.lua

The previous instance of the `Ball` class was created in the serve state, passed to the play state and back and forth persisted between play and pause state.

When updating the game for multiple balls, create a field for `self.balls`, initializing it as an empty table.

```lua
self.balls = {}
```

To this empty table immediately add the instance of the default, single ball.

```lua
self.balls = {}
self.ball = Ball()
table.insert(self.balls, self.ball)
```

It actually makes sense to hold a specific value for the starting ball, considering the different logic of the serve and play state:

- in the serve state, there exist a single ball. Moreover, this should be fixed at the top center of the paddle.

- in the play state, there exist the possibility of multiple balls, moving on the screen based on their own values.

The serve state can therefore use `self.ball`, as earlier, and pass to the play state `self.balls`.

It is actually and even unnecessary to pass `self.ball`, as this is already included in the table.

To sum up: describe a table in which a single ball is added. Handle the single ball in the serve state, but pass the table of balls to the play state

#### PlayState.lua

In the play state there needs to be a few changes, based of the fact that there is no longer a single ball, but a table of balls. For this change any reference to `self.ball` with a for loop, looping through `self.balls` and considering every instance nested in the table.

For instance, change `self.ball:update(dt)` to:

```lua
for k, ball in pairs(self.balls) do
    ball:update(dt)
end
```

This covers how the play state is basically updated.

In `update(dt)`, the for loop is introduced to:

- update every ball;

- check for a collision between every ball and the paddle;

- check when every ball goes below the bottom edge of the screen.

- finally and in the for loop describing the bricks, check for a collision between the every ball and every brick.

In `render()`, the loop is introduced to render every single instance of the ball class.

The `update(dt)` function actually calls a function in `self.checkForLoss`. This function is created with the exact same logic of `checkForVictory`, but to determine when **every single** ball is no longer in play (read: it has gone past the bottom edge of the screen). Through this function, `update(dt)` is able to remove a health point not when every single ball goes past the bottom of the screen, but when every single one of them is gone.

### Powerup #10

The final section of the assignment relates to what I labeled as powerup #10, but most importantly the locked brick. To rapidly sum up the feature, the game should be updated to incorporate, within a reasonable amount, locked bricks which behave as follows:

- hit the brick and a powerup with the key is spawned;

- pick up the powerup to have the brick 'unlocked', and destroy-able.

One thing at a time though.

#### Util.lua

Modify the `GenerateBricks` function to incorporate one additional brick pattern.

```lua
function GenerateQuadsBricks(atlas)
-- previous bricks
local quads = table.slice(GenerateQuads(atlas, 32, 16), 1, 21)

-- add the last brick to desribe the locked pattern
local quad = love.graphics.newQuad(160, 48, 32, 16, atlas:getDimensions())
table.insert(quads, quad)
return quads
end
```

This means that the table referring to the bricks now holds one additional item, even if not included on the screen. 22 bricks, the 22nd of which desribes the locked shape, while the 21st the unlocked version.

#### LevelMaker.lua

The locked version is included through a flag not too dissimular from the boolean describing whether or not to skip a cell.

```lua
-- solid brick
if not skipFlag then
    -- create a flag to determine whether the brick is included through a locked version
    lockedFlag = math.random(1, 2) == 2 and true or false
    -- if locked specify the values for the locked brick (22nd sprite in the brick's table)
    if lockedFlag then
        brick = Brick(
        -- same position of the ordinary bricks
        (col - 1) * 32 + (VIRTUAL_WIDTH - numCols * 32) / 2,
        row * 16,
        -- last color and tier
        5,
        4,
        -- 2 to have the locked integer refer to the 22nd brick
        2
        )

    else
        -- if not locked include a brick choosing a tier and color
        -- as earlier
    end

    -- insert the brick in the table
    table.insert(bricks, brick)
end
```

Notice the addition of a `2` after the tier and color. This is used to find the specific sprite in the table. Notice also the tier and color, capped to their respective maximum value. The idea is to here have the locked brick incrementally destroyed from the most challenging pattern.

#### Brick.lua

Once the level maker has the possibility to specify the locked sprite, the `Brick` flag needs to be updated as to render the appropriate brick.

In the `init()` function the `locked` value is included in the instance of the class:

```lua
function Brick:init(x, y, color, tier, locked)
  self.locked = locked -- addition
end
```

In the `render()` function the brick is drawn adding the value of `self.locked`:

```lua
love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1) + self.locked], self.x, self.y)
```

With the now updated structure, the locked brick is successfully rendered on the screen. However, the interaction with the brick is far from complete.

##### Update

I decided to have the `locked` variable refer to a boolean. This makes for a more declarative solution, but also means that the specific pattern is included when drawing the shape on the screen.

```lua
if self.inPlay then
    -- depending on locked describe the pattern
    -- 22 or the pattern identified by the tier/color
    local pattern = self.locked and 22 or self.tier + 4 * (self.color - 1)
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][pattern], self.x, self.y)
end
```

This makes it rather easier to implement the feature behind the locked brick. If the flag is set to true, do not destroy the item. Else go ahead. I also decided to change the tier and color for the locked brick, to have it immediately destroyed (otherwise the feature would be annoyingly long).

```lua
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
```

Through the newly added boolean, the locked brick can avoid being destroyed through a simple conditional.

```lua
if not self.locked then
    -- logic to change the tier/color and ultimately destroy the brick
end
```

I also decided to include another boolean, in `self.unlocked`. This one to show the 21st sprite once the key powerup is picked up.

#### Brick States

It might be easier to understand how the feature is implemented by describing the possible states assumed by the instance(s) of the locked brick:

- locked: the brick here is displayed through the sprite number 22. Hitting the brick does not result in any change in its pattern or the score of the game. Hitting the brick causes it to enter in the _waiting_ phase, in which the key powerup is spawned and plummets towards the paddle.

- waiting: the brick does not change in terms of visuals, showing sprite number 22 still. If hit in this state, absolutely nothing ought to change. A powerup has been spawn already, and this serves as a precaution avoiding two keys for the same brick.

- unlocked: the brick changes in appearance, to sprite number 21. This state is propped by the key powerup being picked up. While in this state, hitting the brick results in its being destroyed and incrementing the score notably.

The different states are made a tad more complex considering how the stages are not entered linearly, one after another. Indeed, the states can be detailed as follows:

```lua
locked
    brick gets hit --> waiting
                        key is picked up --> unlocked
                        key is not picked up --> locked
```

Meaning that the process repeats itself if the key is not picked up in time. It is essential to account for this occurrence by basically resetting the scene: the powerup is once more set behind the brick; hitting it results in the spawning of the same type of power.

It might sound convoluted, but taking it one step at a time it is definitely easier to grasp.

#### Powerup.lua

The class is updated as to always spawn the key powerup when the brick behind it represents a locked instance.

```lua
function Powerup:init(x, y, key)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    -- through the boolean passed as third argument specify the key powerup (the boolean is true for the instances of a locked brick)
    self.key = key -- new
    self.power = self.key and 10 or math.random(9) -- modified
    self.dy = 50
    self.inPlay = true
end
```

In addition to this value, the class is made to hold another value, in `startingY`. This is used to have the original vertical coordinate of the powerup, before its position is updated as per gravity.

```lua
function Powerup:init(x, y, key)
    self.x = x
    self.y = y
    self.startingY = y -- new
    self.width = 16
    self.height = 16
    self.key = key -- new
    self.power = self.key and 10 or math.random(9) -- modified
    self.dy = 50
    self.inPlay = true
end
```

This value is used in the `update(dt)` function and specifically in the occurrence in which the powerup disappears below the edge of the window.

```lua
-- in update
if self.inPlay and self.y >= VIRTUAL_HEIGHT then
    self.inPlay = false
    -- if the powerup is for the key item, restore the y coordinate (this to have the powerup reset to its original position if the paddle fails to pick up the item)
    if self.key then
        self.y = self.startingY
    end
end
```

The idea is to have the powerup for the locked brick fundamentally return to its original position if the paddle hasn't had a chance to catch it. Inevitably, this covers the situation in which the locked brick is still locked, to have the powerup continuously spawn where the brick lies.

Finally, and perhaps most influentially, the value held in `self.inPlay` is defaulted to `false`.

```lua
function Powerup:init(x, y, key)
    self.x = x
    self.y = y
    self.startingY = y -- new
    self.width = 16
    self.height = 16
    self.key = key -- new
    self.power = self.key and 10 or math.random(9) -- modified
    self.dy = 50
    self.inPlay = false -- modified
end
```

This is part of the more declarative approach taken with the feature. Instead of having the powerup conditionally set through the `Brick` class, following the destruction of the connected brick, the idea is to have the logic baked in the `Powerup` class. From `Brick.lua` the idea is no longer to update or render the powerup when the brick is no longer in play, but only when the powerup is. Not just a matter of semantics, as will be clearer in the following file.

#### Brick.lua

Already diverging from the notes included in the update section, each instance of the `Brick` class is set up with two new fields (as opposed to three): `locked` and `unlocked`.

```lua
function Brick:init(x, y, color, tier, locked)
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    self.color = color
    self.tier = tier
    self.locked = locked -- new
    self.unlocked = false -- new
    self.inPlay = true
    -- POWERUP
    -- always add a powerup when the brick is locked
    self.hasPowerup = self.locked and true or math.random(4) == 1 and true or false -- modified
    -- powerup included in the center of the brick
    self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2, self.locked) -- modified

    -- particle system
end
```

`locked` is retrieved come the initialization of the class, in the level maker, while `unlocked` is defaulted to false.

Notice how `locked` is used also in `hasPowerup` and `powerup`. This is to make sure that a locked brick has always a powerup, and that is the key, number 10 powerup.

Before diving in the `hit()` function, and to match the changes introduced in the `Powerup` class, the `update()` and `render()` function are modified to update and render respectively the powerups, when their `inPlay` boolean resolves to true.

```lua
-- update
function Brick:update(dt)
    self.particleSystem:update(dt)

    -- the powerup is updated in its own class, conditional to its inPlay flag being set to true
    if self.powerup.inPlay then
        self.powerup:update(dt)
    end
end


-- render
function Brick:render()
    -- brick
    if self.inPlay then
        -- depending on locked describe the pattern
        -- 22 or the pattern identified by the tier/color
        local pattern = self.locked and 22 or self.unlocked and 21 or self.tier + 4 * (self.color - 1)
        love.graphics.draw(gTextures['breakout'], gFrames['bricks'][pattern], self.x, self.y)
    end

    -- powerup
    if self.powerup.inPlay then
        self.powerup:render()
    end
end
```

Notice how the logic of the powerup is specified exclusively though the powerup value of `inPlay`, and no longer the fact that the brick has been destroyed.

Notice also how the brick is drawn on screen. The inclusion of the `pattern` variable and the modification of the `love.graphics` function makes it possible to draw the locked and unlocked sprites if need be.

Back to the `Brick:hit()` function. The logic is updated to account for a binary distinction:

- the brick is locked

- the brick is not locked.

In this last instance, tha path is again forked to account for two different occurrences:

- the brick is unlocked (in other words **was** locked);

- the brick is not unlocked (in other words a normal, tier-and-color brick).

Each fork has its own logic.

- brick is locked: if the powerup is not already in play, set it to be so.

```lua
if self.locked then
    -- if the powerup is not in play (by default and when the powerup goes past the bottom of the screeen), show it
    if not self.powerup.inPlay then
        self.powerup.inPlay = true
    end
else
```

- brick is not locked, but it was: style the particle system with the last possible color in the `colorPalette` table and with the brief animation remove the brick from view.

  ```lua
  -- if locked
  else
    if self.unlocked then
        self.particleSystem:setColors(
            colorPalette[#colorPalette]['r'],
            colorPalette[#colorPalette]['g'],
            colorPalette[#colorPalette]['b'],
            0.5,
            colorPalette[#colorPalette]['r'],
            colorPalette[#colorPalette]['g'],
            colorPalette[#colorPalette]['b'],
            0
        )
        self.particleSystem:emit(80)

        -- destroy the brick by setting its flag to false
        self.inPlay = false
        -- play the appropriate sound
        gSounds['score']:stop()
        gSounds['score']:play()

    else

  end
  ```

- brick is not locked, and it never was: logic described in the project so far. Look at the tier, color and incrementally make the brick disappear. When it disappears, highligiht the powerup if the brick has one.

  ```lua
  -- if locked
  else
    -- if unlocked
    else
        -- particle system

        -- color/tier update
        if self.color > 1 then
            self.color = self.color - 1
        -- color 1, check tier
        else
        -- color 1 **and** higher tier, decrement the tier
        if self.tier > 1 then
            self.tier = self.tier - 1
        -- color 1 **and** tier 1, make the brick disappear
        else
            self.inPlay = false
            -- if the brick has a powerup, display it
            if self.hasPowerup then
            self.powerup.inPlay = true
            end
            gSounds['score']:stop()
            gSounds['score']:play()
        end
        end

  end
  ```

Notice how the powerup is shown. One at a time with a locked brick. Not at all with the unlocked variant. Depending on chane and the destruction of the brick otherwise.

#### PlayState.lua

Unexpectedly, the play state is perhaps the least-affected file. It is however responsible for the locked brick having its booleans updated, essential for the brick becoming unlocked and later destroyed.

The state is updated in the function checking for a collision between the paddle and the powerup, to account for powerup #10.

```lua
elseif brick.powerup.power == 10 then
    -- set the booleans of the brick to have it show/include the unlocked brick
    brick.locked = false
    brick.unlocked = true
end
```

As the powerup is collected, the brick is updated to show its unlocked variant.

And that's pretty much it. With the switch occurring in the play state, the `Brick` class is responsible for the brick changing in appearance, triggering the powerup, while the `Powerup` class is responsible for the actual dymanics of the powerup.

This completes the feature. However, the play state is further modified to account for the following scoring system:

- locked brick: do not change the score;

- unlocked brick: 2000 points;

- pattern-ed bricks: score dependant on the tier and color, as earlier.

#### Finishing Touches

With the feature implemented correctly, the code is updated as follows:

- include appropriate sound files (especially for the locked variant);

- modify the level maker to display locked bricks with less likelihood, and after level 5.
