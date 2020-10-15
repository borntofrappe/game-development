BattleTurnState = Class({__includes = BaseState})

function BattleTurnState:init(def)
  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.player = def.player

  self.p1 = def.p1
  self.p2 = def.p2

  self.textBox =
    TextBox(
    {
      ["chunks"] = {
        string.sub(self.p1.name, 1, 1):upper() .. string.sub(self.p1.name, 2, -1) .. " attacks!",
        string.sub(self.p2.name, 1, 1):upper() .. string.sub(self.p2.name, 2, -1) .. " attacks!"
      },
      ["x"] = 4,
      ["y"] = VIRTUAL_HEIGHT - 56 - 4,
      ["padding"] = 4,
      ["width"] = VIRTUAL_WIDTH - 8,
      ["height"] = 56
    }
  )

  self.pExp = def.pExp
  self.p1Health = def.p1Health
  self.p2Health = def.p2Health

  local tweenDirection = self.p1 == self.player.pokemon and 1 or -1
  local tweenOffset = 10

  local damage = math.max(1, self.p1.stats.attack - self.p2.stats.defense)
  self.p2.stats.hp = math.max(0, self.p2.stats.hp - damage)
  self.p2Health:setValue(self.p2.stats.hp)

  Timer.tween(
    0.08,
    {
      [self.p1] = {x = self.p1.x + tweenOffset * tweenDirection}
    }
  ):finish(
    function()
      gSounds["hit"]:play()
      Timer.tween(
        0.08,
        {
          [self.p1] = {x = self.p1.x + tweenOffset * tweenDirection * -1},
          [self.p2] = {x = self.p2.x + tweenOffset * tweenDirection}
        }
      ):finish(
        function()
          Timer.tween(
            0.08,
            {
              [self.p2] = {x = self.p2.x + tweenOffset * tweenDirection * 1 * -1}
            }
          )
          Timer.tween(
            0.8,
            {
              [self.p2Health] = {fillWidth = self.p2Health.width / self.p2Health.max * self.p2Health.value}
            }
          ):finish(
            function()
              if self.p2.stats.hp == 0 then
                self:checkSide(self.p2)
              else
                self.textBox:next()
                local damage = math.max(1, self.p2.stats.attack - self.p1.stats.defense)
                self.p1.stats.hp = math.max(0, self.p1.stats.hp - damage)
                self.p1Health:setValue(self.p1.stats.hp)

                Timer.tween(
                  0.08,
                  {
                    [self.p2] = {x = self.p2.x + tweenOffset * tweenDirection * -1}
                  }
                ):finish(
                  function()
                    gSounds["hit"]:play()
                    Timer.tween(
                      0.08,
                      {
                        [self.p2] = {x = self.p2.x + tweenOffset * tweenDirection},
                        [self.p1] = {x = self.p1.x + tweenOffset * tweenDirection * -1}
                      }
                    ):finish(
                      function()
                        Timer.tween(
                          0.08,
                          {
                            [self.p1] = {x = self.p1.x + tweenOffset * tweenDirection}
                          }
                        )
                        Timer.tween(
                          0.8,
                          {
                            [self.p1Health] = {
                              fillWidth = self.p1Health.width / self.p1Health.max * self.p1Health.value
                            }
                          }
                        ):finish(
                          function()
                            if self.p1.stats.hp == 0 then
                              self:checkSide(self.p1)
                            else
                              self.callback()
                            end
                          end
                        )
                      end
                    )
                  end
                )
              end
            end
          )
        end
      )
    end
  )
end

function BattleTurnState:update(dt)
  Timer.update(dt)
end

function BattleTurnState:render()
  self.textBox:render()
end

function BattleTurnState:checkSide(p)
  if p == self.player.pokemon then
    Timer.tween(
      0.05,
      {
        [self.player.pokemon] = {x = -self.player.pokemon.width}
      }
    ):finish(
      function()
        gStateStack:push(
          DialogueState(
            {
              ["chunks"] = {"You fainted."},
              ["x"] = 4,
              ["y"] = VIRTUAL_HEIGHT - 56 - 4,
              ["padding"] = 4,
              ["width"] = VIRTUAL_WIDTH - 8,
              ["height"] = 56,
              ["callback"] = function()
                gSounds["battle_music"]:stop()
                gSounds["field_music"]:play()
                gStateStack:push(
                  FadeState(
                    {
                      ["color"] = {["r"] = 0, ["g"] = 0, ["b"] = 0},
                      ["duration"] = 0.5,
                      ["opacity"] = 1,
                      ["callback"] = function()
                        gStateStack:pop()
                        gStateStack:pop()
                        gStateStack:pop()
                        self.callback()

                        self.player.pokemon.stats.hp = self.player.pokemon.baseStats.hp
                        gSounds["heal"]:play()
                        gStateStack:push(
                          DialogueState(
                            {
                              ["chunks"] = {"Your pokemon has been healed.\nTry again."}
                            }
                          )
                        )

                        gStateStack:push(
                          FadeState(
                            {
                              ["color"] = {["r"] = 0, ["g"] = 0, ["b"] = 0},
                              ["duration"] = 0.5,
                              ["opacity"] = 0
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
    )
  else
    Timer.tween(
      0.05,
      {
        [p] = {x = VIRTUAL_WIDTH}
      }
    ):finish(
      function()
        gSounds["battle_music"]:stop()
        gSounds["victory"]:play()
        gStateStack:push(
          DialogueState(
            {
              ["chunks"] = {"Victory!"},
              ["x"] = 4,
              ["y"] = VIRTUAL_HEIGHT - 56 - 4,
              ["padding"] = 4,
              ["width"] = VIRTUAL_WIDTH - 8,
              ["height"] = 56,
              ["callback"] = function()
                local exp = math.random(5, 15)

                gStateStack:push(
                  BattleMessageState(
                    {
                      ["chunks"] = {"You earned " .. exp .. " experience points!"},
                      ["callback"] = function()
                        self.player.pokemon.exp =
                          math.min(self.player.pokemon.exp + exp, self.player.pokemon.expToLevel)
                        self.pExp:setValue(self.player.pokemon.exp)
                        gSounds["exp"]:play()
                        Timer.tween(
                          1,
                          {
                            [self.pExp] = {fillWidth = self.pExp.width / self.pExp.max * self.pExp.value}
                          }
                        ):finish(
                          function()
                            if self.player.pokemon.exp == self.player.pokemon.expToLevel then
                              gSounds["levelup"]:play()
                              local levelUpIncrements = self.player.pokemon:levelUp()
                              gStateStack:push(
                                BattleMessageState(
                                  {
                                    ["chunks"] = {"Congratulations! Level up!"},
                                    ["callback"] = function()
                                      local levelUpMessage = {}
                                      for i, levelUpIncrement in ipairs(levelUpIncrements) do
                                        local stat = levelUpIncrement.stat
                                        local valueIncrement = levelUpIncrement.value
                                        local valueStat =
                                          sat == "hp" and self.player.pokemon.baseStats[stat] or
                                          self.player.pokemon.stats[stat]

                                        table.insert(
                                          levelUpMessage,
                                          stat:upper() ..
                                            ": " ..
                                              valueStat - valueIncrement ..
                                                " + " .. valueIncrement .. " = " .. valueStat
                                        )
                                      end
                                      gStateStack:push(
                                        BattleMessageState(
                                          ({
                                            ["chunks"] = levelUpMessage,
                                            ["callback"] = function()
                                              gSounds["victory"]:stop()
                                              gSounds["field_music"]:play()
                                              gStateStack:push(
                                                FadeState(
                                                  {
                                                    ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                                    ["duration"] = 0.5,
                                                    ["opacity"] = 1,
                                                    ["callback"] = function()
                                                      gStateStack:pop()
                                                      gStateStack:pop()
                                                      gStateStack:pop()
                                                      gStateStack:pop()
                                                      gStateStack:pop()
                                                      gStateStack:pop()
                                                      self.callback()
                                                      gStateStack:push(
                                                        FadeState(
                                                          {
                                                            ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                                            ["duration"] = 0.5,
                                                            ["opacity"] = 0
                                                          }
                                                        )
                                                      )
                                                    end
                                                  }
                                                )
                                              )
                                            end
                                          })
                                        )
                                      )
                                    end
                                  }
                                )
                              )
                            else
                              gSounds["victory"]:stop()
                              gSounds["field_music"]:play()
                              gStateStack:push(
                                FadeState(
                                  {
                                    ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                    ["duration"] = 0.5,
                                    ["opacity"] = 1,
                                    ["callback"] = function()
                                      gStateStack:pop()
                                      gStateStack:pop()
                                      gStateStack:pop()
                                      gStateStack:pop()
                                      self.callback()
                                      gStateStack:push(
                                        FadeState(
                                          {
                                            ["color"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
                                            ["duration"] = 0.5,
                                            ["opacity"] = 0
                                          }
                                        )
                                      )
                                    end
                                  }
                                )
                              )
                            end
                          end
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
    )
  end
end
