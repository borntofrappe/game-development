# Angry Birds 10

## Target

While the instance of the alien class used to represent the player is not modified, the one dedicated to the target makes sure that the target is position at ground level. The idea is to ultimately surround this element with the obstacles introduced from `wood.png`.

## Utils

The `GenerateQuadsObstacles` function considers `wood.png` and builds a multidimensional table with horizontal and vertical shapes.

```lua
local quads = {
  ["horizontal"] = {},
  ["vertical"] = {}
}
```

Each type has also two variants, with the second describing a worn-out, damaged structure. This is not covered in the current update, but the idea is to have the solid version be destroyed only if the player achieves a certain speed. Below this threshold, the idea is to show the damaged type instead.

In `constants.lua`, I've decided to map the width and height of the obstacles in a table.

```lua
H_OBSTACLES = {
  {width = 110, height = 35},
  {width = 110, height = 35},
  {width = 70, height = 35},
  {width = 70, height = 35},
  {width = 110, height = 70},
  {width = 110, height = 70}
}

-- similar table for the vertical obstacles
```

This is useful not only when building the quads, but creating the shapes in the `Obstacle` class.

## Obstacle

The class for obstacles is eerily similar to that for aliens. The only difference comes from the way the `gFrames["obstacles"]` table is built. This is a multi-dimensional table in which you need to specify:

1. a direction

   ```lua
   gFrames["obstacles"] = {
     ["horizontal"] = {},
     ["vertical"] = {}
   }
   ```

2. a type, distinguished for its width and height

   ```lua
   gFrames["obstacles"] = {
     ["horizontal"] = {
       [1] = {},
       [2] = {},
       -- more types
     }
   }
   ```

3. a variant

   ```lua
   gFrames["obstacles"] = {
     ["horizontal"] = {
       [1] = {
         solid,
         worn-out
       }
     }
   }
   ```

By default, the idea is to use the first variant, so that the play state initializes obstacles with a direction and type only. With this values, it uses the width or height stored in the two constants, `H_OBSTACLES` and `V_OBSTACLES`, in the process of building a rectangular shape.

```lua
self.shape = love.physics.newRectangleShape(self.width, self.height)
```

## PlayState

The idea is to enclose the target in a series of obstacles. Two vertical obstacles side by side, plus one right above.

```text
 ___
|   |
|   |
| t |
```

This is achieved by carefully positioning the obstacles. For instance and for the obstacle creating the left pillar, this is positioned 55 pixels before the target, and 55px above the bottom edge of the window.

```lua
Obstacle(
  {
    world = self.world,
    x = VIRTUAL_WIDTH * 3 / 4 - 55,
    y = VIRTUAL_HEIGHT - 55,
    direction = "vertical",
    type = 1
  }
)
```

The horizontal offset is explained to have the pillar create a basis for the obstacle positioned horizontally and right above it. The vertical offset is then explained by having the specific obstacle 110 pixels tall. Remember that `x` and `y` describe the center of the bodies.

_Nifty_: comment out the line updating the world to accurately position the obstacles. Focusing on the static demos makes it easier to avoid overlap.
