DinoDuckingState = BaseState:new()

function DinoDuckingState:new(dino)
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end
