# Space Debris

Lift a spaceship vertically to avoid incoming debris.

![Space Debris in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Space%20Debris/space-debris.gif)

## Resources

Starting from the static resources used in the project, the `res` folder includes the font and audio files initialized in `love.load`. The folder also includes the `push` library to scale the screen without loosing the pixelated style allowed by the images and the images themselves in `res/graphics`. I've designed the image to describe the player and the obstacles respectively; `particle.png` finally provides the image repeated through the particle system.

## Particle system

The game includes particle system through two dedicated classes: `Thruster` and `Collision`.

For the thruster, the idea is to initialize one particle system for the player, and emit particles only as the spaceship is lifted upwards.

```lua
function Thruster:emit(x, y)
  self.particleSystem:setPosition(x, y)
  self.particleSystem:emit(PARTICLES)
end
```

The `emit` function is called following a press on the up arrow key, and through the `Spaceship:thrust` method responsible for actually moving the spaceship.

```lua
function Spaceship:thrust()
  self.dy = self.dy - THRUST
  self.thruster:emit(
    -- bottom of the spaceship
  )
end
```

For the collision, the idea is to intialize and immediately emit a set of particles. As the game moves to the gameover state, the idea is to initialize an instance of the class.

```lua
function GameoverState:enter()
  self.collision = Collision:new(
    -- params
  )
end
```

`Collision:new` then sets up the necessary properties and emanates the desired particles.

```lua
function Collision:new(--)
  local particleSystem = -- ..

  particleSystem:emit(PARTICLES)
end
```

In both instances, and to show the actual particles, it is necessary to:

1. update the particles with delta time

   ```lua
   self.particleSystem:update(dt)
   ```

2. render the system through `love.graphics.draw`

   ```lua
   love.graphics.draw(self.particleSystem)
   ```

## Persistent data

The game keeps track of the score in terms of the number of seconds the play state lasts. The value is saved locally to a `.lst` file, si that it is possible to highlight the record on successive session.

### Record

In the record state, the idea is to simply read the highest number of seconds stored in the prescribed folder and file. The record is initialized with two hyphen characters.

```lua
self.record = "--"
```

The value is then overriden with the result found in the chosen location, considering the very first line.

```lua
love.filesystem.setIdentity(FOLDER)
  if love.filesystem.getInfo(FILE) then
    -- consider the iterator love.filesystem.lines(FILE)
    -- update self.record
  end
end
```

This means that, in the moment there is no existing file, the state highlights the string `-- seconds` by default.

### Gameover

The gameover state is similar to the record state in that it checks if a file exist and then reads the content from the very first line. The only difference is that it is here necessary to write the possible high score locally.

`self.hasHishScore` is used as a controlling variable.

```lua
if self.hasHighScore then
  love.filesystem.write(FILE, self.seconds)
end
```

`love.filesystem.write` helps to save the value and it does so following two particular cases:

1. there is no existing file

2. there is a file, and the first line describes a number lower than the current value

Consider that the score is stored and read as a string. To compare the values Lua provides the `tonumber` function, converting string to number — in this instance a float with two decimal points.

```lua
-- current score v previous high score
if tonumber(self.seconds) > tonumber(highScore) then
end
```

## Lua

The project does **not** include the class library introduced in the course. Object oriented programming is here implemented with Lua syntax and specifically the syntax relating to metatables. The common trait of each class is the `new` function, and how this method initializes each instance through a dedicated table.

```lua
ClassName = {}

function ClassName:new()
  local this = {
    -- attributes
  }

  self.__index = self
  setmetatable(this, self)

  return this
end
```

The structure allows to implement basic inheritance by leaning on the method directly. This feat is highlighted in the different states, all based on `BaseState`.

```lua
PlayState = BaseState:new()
```

As the state is initialized, it picks up the methods first described by the parent construct.
