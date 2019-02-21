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

The assignment given at the end of the lecture concerns mainly powerups, as available in the `breakout,png` asset. That being said, there are three specific expansions foreseen by the lecturer:

- [x] have the paddle shrink or increase in size.

- [x] have a powerup include two additional balls, colliding with the wall, bricks, paddle. In this instance only when every ball is lost a heath point is removed.

- use the locked brick in conjunction with the key item. The idea is to have the key being a powerup which unlocks the brick. Only by picking up the key it should be possible to destroy said a brick.

### Assignment #1 - Powerups

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

### Assignment #2 - Powerup #9

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

### PlayState.lua

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
