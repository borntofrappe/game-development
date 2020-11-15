# Lunar Lander

The goal of this project is to create a demo inspired by the Atari game [Lunar Lander](<https://en.wikipedia.org/wiki/Lunar_Lander_(1979_video_game)>), using Box2D and a noise function to produce terrain.

## Design

The game uses [Overpass Mono](https://fonts.google.com/specimen/Overpass+Mono) for the data, [Aldrich](https://fonts.google.com/specimen/Aldrich) for the messages shown midscreen.

Terrain covers the bottom half of the screen. It is created using `love.math.noise` in conjunction with `love.math.random`. As noticed in the `Noise` folder, `love.math.noise` provieds a sequence of random numbers which is too smooth, and the inclusion of `love.math.random` allows to modify the segments to have jagged edges.

```lua
local y = (love.math.noise(offset) * terrainHeightNoise + love.math.random() * terrainHeightRandom) * -1
```

The value is negative to have the terrain positioned away from the bottom of the screen.

Data covers the top half of the screen, displaying the score, time, but also fuel, altitude, horizontal and vertical speed. The information is divided in groups of three, aligning the text to the left. For the speed, the game also uses arrows. While it is possible to create `.png` images for these visuals, the characters ` ↑`,`↓`,`→`, and `←` provide a quick alternative (assuming the font being used has the corresponding characters).

## Development

In the `Noise`, `Box2D` and `Particles` folder I develop a series of demos which work as the foundation of the eventual game. These are useful given personal inexperience with the topic discussed in the project. Each folder has a dedicated `README` to describe the different concepts and demos, while the rest of this document is reserved to the complete demo instead.

### Data

Data is displayed in multiple steps. This is to ultimately reduce the number of hard-coded values, and display the information in the desired format (as mentioned earlier, a grid of two columns and three rows).

`displayData`, the function is used as a wrapper, a convenience to have `love.draw` use a single line.

```lua
function love.draw()
  displayData()
end
```

Itself, it calls a function to display data by specifing the relevant keys in a table.

```lua
function displayData()
  displayKeyValuePairs(
    -- first column
  )
  displayKeyValuePairs(
    -- second column
  )
end
```

`displayKeyValuePairs` is finally responsible to render the text in rows. It does so accepting a series of arguments:

```lua
function displayKeyValuePairs(keys, formattingFunctions, startX, startY, gapX, gapY)
end
```

In order:

- `keys`, a table for the type of data to actually display. This is a sequence of strings like `{"score", "time", "fuel"}`, and allows the display function to print the information in a precise order

- `formattingFunctions`, a table describing the formatting function for the value of the data. Not every value requires a formatting function, so that the table also includes `nil` values. In this instance, `displayFunction` should use the value as-in.

  _Please note_: using `nil` creates a table with "holes". This means the table is not a sequence, and the `ipairs` iterator is not able to consider the different values. It is not an issue in the specific project, but it is something of which to be aware.

- `startX` and `startY`, two variables describing where the data needs to be displayed. Multiple keys are shown from these two initial coordinates.

- `gapX` and `gapY`, two variables describing the gap between a key and it value (`gapX`), and between successive key-value pairs (`gapY`)

## State

The game mixes global variables with a state machine. This is with the ultimate goal of having a single world, initialized in `love.load` and then manipulated in the distinct states.

## isDestroyed

The function `body:isDestroyed()` is necessary to avoid having the game crash as the world tries to use/update bodies which no longer exist.

```lua
if data["fuel"] > 0 and not lander.body:isDestroyed() then
end
```

In the `StartState` then, it is helpful to have the game set up a new lander/terrain if either element is destroyed.

```lua
if lander.body:isDestroyed() then
  lander = Lander:new(world)
end
if terrain.body:isDestroyed() then
  terrain = Terrain:new(world)
end
```
