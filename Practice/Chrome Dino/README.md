# Chrome Dino

Google Chrome provides the game [Dinosaur Jump](https://en.wikipedia.org/wiki/Dinosaur_Game), also known as Chrome Dino, when the browser is offline. The goal of this project is to replicate the essence of the endless scroller starting from a pixelated spritesheet.

![Chrome Dino in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Chrome%20Dino/chrome-dino.gif)

## Resources

### Spritesheet

In the `res/graphics` sub-folder you find two images, one for the ground and one for the world's elements — the dinosaur, various type of cactus, a cloud and a pterodactylus.

The size of the assets is particularly relevant in the context of `Utils.lua`, when dividing the larger texture in multiple quads, but the information is also useful to position the elements and detect a collision.

| Asset           | Width | Height |
| --------------- | ----- | ------ |
| ground          | 352   | 8      |
| dino (idle)     | 16    | 16     |
| dino (running)  | 16    | 16     |
| dino (ducking)  | 21    | 11     |
| dino (stopped)  | 16    | 16     |
| cactus (normal) | 9     | 12     |
| cactus (large)  | 11    | 18     |
| cloud           | 18    | 6      |
| bird            | 16    | 15     |

In terms of color the assets lean on a relatively bright grey: `0.42, 0.42, 0.42`. The same rgb combination is used when rendering the score.

### Libraries

The `push` library helps to scale the small textures while preserving the pixelated look.

`Timer` and `Animation` help to manage time events and sprite animation.

## Source

### Collidables

In the play state the game adds the cacti and bird starting from a series of buckets.

```lua
local COLLIDABLE_BUCKETS = {
    {
        ["cactus"] = 5,
        ["cacti"] = 1
    },
    {
        ["cactus"] = 5,
        ["cacti"] = 3,
        ["bird"] = 1
    },
        -- ...
}
```

For each bucket, the script populates a table with as many options as specified by the key value pairs. The idea is to then pick from a bucket considering where the scroll speed fits between the minimum and maximum value. In this manner it is possible to add variety and more complex structures as the game progresses and the dinosaur gains speed.

### Collision

An AABB test comparing the bounding box of the dinosaur and collidables proves to be exceedingly strict when detecting a collision. To be more merciful, and provide a slightly more accurate estimation, I decided to compute a hit radius for each object, and compare the distance between the center of the shapes instead. The value is computed considering the diagonal of the rectangle making up the objects, and reducing the value by an arbitrary amount.

```lua
local hitRadius = ((width ^ 2 + height ^ 2) ^ 0.5) / 3
```

Remove the comments in the various `:render` functions to highlight the area describing a collision.

```lua
love.graphics.setColor(0, 1, 0, 0.5)
love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, self.hitRadius)
```

### Shader

At an interval, the idea is to have the game simulate the passing of time by moving from day to night and vice-versa. The appearance is modified with a shader, modifying the pixel value by subtracting the rgb component from pure white.

```lua
shader =
    love.graphics.newShader [[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
        vec4 pixel = color * Texel(texture, texture_coords);
        pixel.r =  1.0 - pixel.r;
        pixel.g =  1.0 - pixel.g;
        pixel.b =  1.0 - pixel.b;
        return pixel;
    }
]]
```

Pure white becomes pure black, from `1, 1, 1` to `0, 0, 0`, while the assets and the score gain a brighter tint of grey, from `0.42, 0.42, 0.42` to `0.58, 0.58, 0.58`.

### Score

The score is saved to and read from local storage through the `love.filesystem` module.

In `Score.lua`, the component initializing and rendering the high score and the current value, the idea is to immediately read the record from a prescribed `.lst` file in a given folder. If such a file does not exist, the idea is to create one with a value of `0`.

In `StoppedState.lua` then, when the game considers the current score, the idea is to override the value if need be. It is not necessary to read the contents of the file as the previous record is already considered in the score component.

In both instances, `love.filesystem.setIdentity` selects a specific folder, while `love.filesystem.write` saves the data to the given file. The information is retrieved from a constant describing the file path.

```lua
FILE_PATH = "chrome-dino/highscores.lst"
```
