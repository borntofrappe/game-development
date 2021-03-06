# Angry Birds 8

## StartState

The speed applied to the bodies, both at the beginning of the simulation and at an interval, is reduced to lessen the importance of the simulation itself. The opacity of the background behind the title is also increased, to have the white text pop more on the bright background.

## Alien

Creating a dedicated class for the alien in useful especially as aliens are created in more than a single file.

The code previously split in the `init` and `render` functions is essentially moved into `Alien:init()` and `Alien:render()`. The only precaution is given to use half the alien width for the radius of the circular shapes.

```lua
local shape =
  self.type == "square"
  and
    love.physics.newRectangleShape(self.width, self.height)
  or
    love.physics.newCircleShape((self.width) / 2)
```

_Please note_: instead of expecting the start and play state to create an instance of the class by passing the arguments in a specific order, I decided to have a table contain the desired values, and have the `init` function deconstruct the values at the moment of the initialization.

```lua
function Alien:init(def)
  local world = def.world
  self.x = def.x
  -- ...
end
```
