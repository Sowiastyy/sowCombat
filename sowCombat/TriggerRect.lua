-- TriggerRect.lua
local TriggerRect = {}
TriggerRect.__index = TriggerRect

--- Constructor for creating new TriggerRect
---@param x number The x position of the TriggerRect
---@param y number The y position of the TriggerRect
---@param w number The width of the TriggerRect
---@param h number The height of the TriggerRect
---@param angle number The angle of rotation for the TriggerRect
---@param life number The life duration of the TriggerRect
---@return table Returns a new TriggerRect object
function TriggerRect:new(x, y, w, h, angle, life)
    local newTriggerRect = {x = x, y = y, width = w, height = h, angle = angle, life=life or 0}
    setmetatable(newTriggerRect, TriggerRect)
    return newTriggerRect
end

local function rotatedRectanglesCollide(r1X, r1Y, r1W, r1H, r1A, r2X, r2Y, r2W, r2H, r2A)
    local r1HW = r1W / 2
    local r1HH = r1H / 2
    local r2HW = r2W / 2
    local r2HH = r2H / 2

    local r1CX = r1X + r1HW
    local r1CY = r1Y + r1HH
    local r2CX = r2X + r2HW
    local r2CY = r2Y + r2HH

    local cosR1A = math.cos(r1A)
    local sinR1A = math.sin(r1A)
    local cosR2A = math.cos(r2A)
    local sinR2A = math.sin(r2A)

    local r1RX =  cosR2A * (r1CX - r2CX) + sinR2A * (r1CY - r2CY) + r2CX - r1HW
    local r1RY = -sinR2A * (r1CX - r2CX) + cosR2A * (r1CY - r2CY) + r2CY - r1HH
    local r2RX =  cosR1A * (r2CX - r1CX) + sinR1A * (r2CY - r1CY) + r1CX - r2HW
    local r2RY = -sinR1A * (r2CX - r1CX) + cosR1A * (r2CY - r1CY) + r1CY - r2HH

    local cosR1AR2A = math.abs(cosR1A * cosR2A + sinR1A * sinR2A)
    local sinR1AR2A = math.abs(sinR1A * cosR2A - cosR1A * sinR2A)
    local cosR2AR1A = math.abs(cosR2A * cosR1A + sinR2A * sinR1A)
    local sinR2AR1A = math.abs(sinR2A * cosR1A - cosR2A * sinR1A)

    local r1BBH = r1W * sinR1AR2A + r1H * cosR1AR2A
    local r1BBW = r1W * cosR1AR2A + r1H * sinR1AR2A
    local r1BBX = r1RX + r1HW - r1BBW / 2
    local r1BBY = r1RY + r1HH - r1BBH / 2

    local r2BBH = r2W * sinR2AR1A + r2H * cosR2AR1A
    local r2BBW = r2W * cosR2AR1A + r2H * sinR2AR1A
    local r2BBX = r2RX + r2HW - r2BBW / 2
    local r2BBY = r2RY + r2HH - r2BBH / 2
    return r1X < r2BBX + r2BBW and r1X + r1W > r2BBX and r1Y < r2BBY + r2BBH and r1Y + r1H > r2BBY and
    r2X < r1BBX + r1BBW and r2X + r2W > r1BBX and r2Y < r1BBY + r1BBH and r2Y + r2H > r1BBY

end
--- Check collision of TriggerRect with hitbox
---@param hitbox table The hitbox to check for collision
---@return boolean Returns true if hitbox collides with TriggerRect, otherwise false
function TriggerRect:collisionWithHitbox(hitbox)
    if rotatedRectanglesCollide(
        hitbox.x, hitbox.y, hitbox.width, hitbox.height, 0,
        self.x, self.y, self.width, self.height, self.angle)
    then
        return true
    end

    return false
end
function TriggerRect:update(dt)
    self.life = self.life - dt
    if self.life <= 0 then
        self.isDead = true
    end
end
function TriggerRect:destroy()
    self.isDead=true
end
function TriggerRect:draw()
    love.graphics.setColor(1, 1, 1)  -- white
    love.graphics.push()  
    love.graphics.translate(self.x + self.width / 2, self.y + self.height / 2)  -- move origin to center of rectangle
    love.graphics.rotate(self.angle)  -- rotate 
    love.graphics.rectangle("line", - self.width / 2, - self.height / 2, self.width, self.height)  -- draw rectangle around origin
    love.graphics.pop()  -- revert origin and rotation to previous state
end
return TriggerRect
