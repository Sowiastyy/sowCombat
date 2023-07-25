-- hitbox.lua

local Hitbox = {}
Hitbox.__index = Hitbox

function Hitbox:new(x, y, width, height)
  self = setmetatable({}, Hitbox)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  return self
end

function Hitbox:set(x, y, width, height)
  self.x = x
  self.y = y
  if width and height then
    self.width = width
    self.height = height
  end
end

function Hitbox:move(x, y)
  self.x = self.x+x
  self.y = self.y+y
end

function Hitbox:draw()
    love.graphics.setColor(1, 1, 1)  -- white
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
return Hitbox
