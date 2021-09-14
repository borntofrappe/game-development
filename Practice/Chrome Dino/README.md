# Chrome Dino

Google Chrome offers a [neat endless scroller](https://en.wikipedia.org/wiki/Dinosaur_Game) when the browser is offline.

## res

### Spritesheet

Color 0.42\*3

- ground 256 pixels by 10

- dinosaur 16 by 16 for the idle, walking and gameover states, 21 by 11 for the ducked down version

- cacti 12 by 16 for the two smaller versions, 15 by 24 for the larger piece

- cloud 25 by 8

- bird 19 by 16

<!-- ### Sound bytes -->

### lib

Timer library to manage delays, tweens, intervals

push library to scale the window while preserving pixelated look

Animation library to manage sprite animation

## src

State stack to manage the game. Global values for the dinosaur, ground coordinates and score

State machine to manage the dinosaur and its possible states.

## ShoPping LiSt

- shader: flip the color palette to simulate the day and night cycle

```lua
local shader =
    love.graphics.newShader [[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
        vec4 pixel = Texel(texture, texture_coords);
        pixel.r = 1.0 - pixel.r;
        pixel.g = 1.0 - pixel.g;
        pixel.b = 1.0 - pixel.b;
        return pixel;
    }
]]

love.graphics.setShader(shader)
love.graphics.setShader()
```

- sounds | jumping, stopping soundbyte
