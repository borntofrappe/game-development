# Pong 11

Index:

- [Audio](#audio)

Snippet:

- main.lua

Small note: the audio files reference in `main.lua` are present in the Resources folder, to avoid repetition, but in the file they are located in a `sounds` folder, sibling to `main.lua`.

## Audio

Including audio is a simple matter of initializing variables in the `load()` function and later access them where needed. Where needed, using an audio file is a matter of calling the `:play()` function on them.

Once more: in the `load()` function:

```lua
 sounds = {
      ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
      ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }
```

The values for the sound files are here stored in a table (you can think of it as the counterpart in lua to JavaScript objects). Tables are structured as follows:

```lua
tableName = { -- notice the curly brackets
  ['propertyName'] = propertyValue, -- I call them property but they are perhaps better labeled as fields
}
```

For audio files, the values are created through the `love.audio.newSource()` function, accepting the path and the type of the audio file. The type refers to the way the sound is imported in the application, and by setting it to `static` it means that the audio files are included upfront in the `load()` function.

```lua
audioFile = love.audio.newSource(path, type)
```

Once a table is created, you can access its values either through dot or bracket notation.

```lua
tableName.propertyName
tableName['propertyName']
```

And you can play the audio as follows:

```lua
tableName['propertyName']:play()
```

Once you know how it is a matter of placing the audio files where needed:

- when the ball hits a paddle;

- when the ball hits a wall;

- when a point is scored.
