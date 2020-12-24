Refactor the code to have the logic pertinent to the aliens in its own class.

## StartState update

The speed applied to the body, both at the beginning of the simulation and at an interval, is reduced to reduce the important of the simulation itself. The opacity of the backdrop behind the title is also increased, to have the white text pop more on the bright background.

## Alien

Creating a dedicated class for the alien in useful especially as aliens are created in more than a single file.

The code previously split in the `init` and `render` functions is essentially moved into `Alien:init()` and `Alien:render()`. The only precaution is given to use half the alien width for the radius of the circular shapes.

```lua
self.shape =
    self.type == "square" and love.physics.newRectangleShape(self.width, self.height) or
    love.physics.newCircleShape((self.width) / 2)
```

_Please note_: instead of expecting the start and play state to create an instance of the class by passing the arguments in a specific order, I decided to have a table contain the desired values, and have the `init` function deconstruct the values at the moment of the initialization.

```lua
function Alien:init(def)
  self.world = def.world
  self.x = def.x
end
```
