DialogueState = Class({__includes = BaseState})

function DialogueState:init(def)
  local def = def or {}

  self.chunks = def.chunks or {"MISSING CHUNK"}
  self.chunk = def.chunk or 1

  self.callback = def.callback or function()
      gStateStack:pop()
    end

  self.x = def.x or 4
  self.y = def.y or 4
  self.padding = def.padding or 4

  self.width = def.width or VIRTUAL_WIDTH - 8
  self.height = def.height

  if not self.height then
    local maxLines = 1
    for i, t in ipairs(self.chunks) do
      local lines = 1
      for n in string.gmatch(t, "\n") do
        lines = lines + 1
      end
      if lines > maxLines then
        maxLines = lines
      end
    end
    self.height = 16 * maxLines + 8
  end

  self.textBox =
    TextBox(
    {
      ["chunks"] = self.chunks,
      ["x"] = self.x,
      ["y"] = self.y,
      ["padding"] = self.padding,
      ["width"] = self.width,
      ["height"] = self.height,
      ["callback"] = self.callback
    }
  )
end

function DialogueState:update(dt)
  self.textBox:update(dt)
end

function DialogueState:render()
  self.textBox:render()
end
