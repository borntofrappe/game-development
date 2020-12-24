BattleMenuState = Class({__includes = BaseState})

function BattleMenuState:init(def)
  self.hasSelected = false
  self.playerPokemon = def.playerPokemon
  self.wildPokemon = def.wildPokemon

  self.playerPokemonHealth = def.playerPokemonHealth
  self.wildPokemonHealth = def.wildPokemonHealth

  self.isPlayerFaster = self.playerPokemon.stats.speed >= self.wildPokemon.stats.speed
  local chunks = {
    string.sub(self.playerPokemon.name, 1, 1):upper() .. string.sub(self.playerPokemon.name, 2, -1) .. " attacks!",
    string.sub(self.wildPokemon.name, 1, 1):upper() .. string.sub(self.wildPokemon.name, 2, -1) .. " attacks!"
  }
  self.chunks = {}
  if self.isPlayerFaster then
    self.chunks = chunks
  else
    for i = #chunks, 1, -1 do
      table.insert(self.chunks, chunks[i])
    end
  end
  self.textBox =
    TextBox(
    {
      ["chunks"] = self.chunks,
      ["x"] = 4,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = 56
    }
  )

  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.selection =
    Selection(
    {
      ["options"] = {
        {
          ["text"] = "Fight",
          ["callback"] = function()
            self.hasSelected = true
            self.textBox:show()
            if self.isPlayerFaster then
              local damage = math.max(1, self.playerPokemon.stats.attack - self.wildPokemon.stats.defense)
              self.wildPokemon.stats.hp = math.max(0, self.wildPokemon.stats.hp - damage)
              self.wildPokemonHealth:setValue(self.wildPokemon.stats.hp)
              Timer.tween(
                1,
                {
                  [self.wildPokemonHealth] = {
                    fillWidth = self.wildPokemonHealth.width / self.wildPokemonHealth.max * self.wildPokemonHealth.value
                  }
                }
              ):finish(
                function()
                  self.textBox:next()
                  local damage = math.max(1, self.wildPokemon.stats.attack - self.playerPokemon.stats.defense)
                  self.playerPokemon.stats.hp = math.max(0, self.playerPokemon.stats.hp - damage)
                  self.playerPokemonHealth:setValue(self.playerPokemon.stats.hp)

                  Timer.tween(
                    1,
                    {
                      [self.playerPokemonHealth] = {
                        fillWidth = self.playerPokemonHealth.width / self.playerPokemonHealth.max *
                          self.playerPokemonHealth.value
                      }
                    }
                  ):finish(
                    function()
                      self.textBox:hide()
                      self.hasSelected = false
                    end
                  )
                end
              )
            else
              local damage = math.max(1, self.wildPokemon.stats.attack - self.playerPokemon.stats.defense)
              self.playerPokemon.stats.hp = math.max(0, self.playerPokemon.stats.hp - damage)
              self.playerPokemonHealth:setValue(self.playerPokemon.stats.hp)

              Timer.tween(
                1,
                {
                  [self.playerPokemonHealth] = {
                    fillWidth = self.playerPokemonHealth.width / self.playerPokemonHealth.max *
                      self.playerPokemonHealth.value
                  }
                }
              ):finish(
                function()
                  self.textBox:next()
                  local damage = math.max(1, self.playerPokemon.stats.attack - self.wildPokemon.stats.defense)
                  self.wildPokemon.stats.hp = math.max(0, self.wildPokemon.stats.hp - damage)
                  self.wildPokemonHealth:setValue(self.wildPokemon.stats.hp)

                  Timer.tween(
                    1,
                    {
                      [self.wildPokemonHealth] = {
                        fillWidth = self.wildPokemonHealth.width / self.wildPokemonHealth.max *
                          self.wildPokemonHealth.value
                      }
                    }
                  ):finish(
                    function()
                      self.textBox:hide()
                      self.hasSelected = false
                    end
                  )
                end
              )
            end
          end
        },
        {
          ["text"] = "Run",
          ["callback"] = function()
            gStateStack:push(
              DialogueState(
                {
                  ["chunks"] = {"You run away safely."},
                  ["x"] = 4,
                  ["y"] = VIRTUAL_HEIGHT - 56 - 4,
                  ["width"] = VIRTUAL_WIDTH - 8,
                  ["height"] = 56,
                  ["callback"] = function()
                    gStateStack:push(
                      FadeState(
                        {
                          color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                          duration = 0.5,
                          opacity = 1,
                          callback = function()
                            gStateStack:pop()
                            self.callback()
                            gStateStack:push(
                              FadeState(
                                {
                                  color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                  duration = 0.5,
                                  opacity = 0,
                                  callback = function()
                                  end
                                }
                              )
                            )
                          end
                        }
                      )
                    )
                  end
                }
              )
            )
          end
        }
      },
      ["option"] = 1
    }
  )
end

function BattleMenuState:update(dt)
  Timer.update(dt)
  if not self.hasSelected then
    self.selection:update(dt)
  end
end

function BattleMenuState:render()
  if not self.hasSelected then
    self.selection:render()
  else
    self.textBox:render()
  end
end
