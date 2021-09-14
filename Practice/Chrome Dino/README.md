# Chrome Dino

Google Chrome offers a [neat endless scroller](https://en.wikipedia.org/wiki/Dinosaur_Game) when the browser is offline. Here I try to replicate the essence of the game and mainly practice with a state machine for the game and the game's entities (the player).

## Resources

### Spritesheet

In the `res/graphics` sub-folder you find two images for the game assets, one describing the ground and one the world's elements — the dinosaur, various type of cactus, a cloud and a pterodactylus.

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

In terms of color, the assets use a relatively bright grey: 0.42, 0.42, 0.42.

### Sounds

The game has but two sound bytes, describing the player jumping and colliding with one of the world's entities.

### Libraries

The `push` library helps to scale the small textures while preserving the pixelated look.

`Timer` and `Animation` help to manage time events and sprite animation.

## Source

### States

The project is managed with a couple of state machines, one for the game and one for the dinosaur.

### Shader

The project allows to experiment with a shader in order to simulate a day and night cycle.

The shader is defined to consider every pixel and subtract the rgb components by the white color `1`

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

```

In this manner white pixels become black, grey pixels increase in brightness.
