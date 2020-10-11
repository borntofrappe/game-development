BattleMenuState = Class({__includes = BaseState})

function BattleMenuState:init(def)
  self.selection =
    Selection(
    {
      ["options"] = {
        {
          ["text"] = "Fight",
          ["callback"] = function()
            -- battle
          end
        },
        {
          ["text"] = "Run",
          ["callback"] = function()
            gStateStack:push(
              DialogueState(
                {
                  ["text"] = {"You run away safely."},
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
                            gStateStack:pop()
                            gStateStack:pop()
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
  self.selection:update(dt)
end

function BattleMenuState:render()
  self.selection:render()
end
