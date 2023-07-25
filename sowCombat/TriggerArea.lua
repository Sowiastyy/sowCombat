-- Initiate class TriggerArea
local TriggerArea = {}
TriggerArea.__index = TriggerArea

--- Initialize a new TriggerArea object
---@param centerX number The x co-ordinate of the center of the TriggerArea
---@param centerY number The y co-ordinate of the center of the TriggerArea
---@param radius number The radius of the TriggerArea
---@param life number The life duration of the TriggerArea
---@param sector table The sector in which the TriggerArea exists, represented as range {start, end} in radians
---@return table Returns a new TriggerArea object
function TriggerArea:new(centerX, centerY, radius, life, sector)
    sector = sector or {0, 2*math.pi} -- Providing a default sector which is full circle if sector is not provided
    local newTriggerArea = {centerX = centerX, centerY = centerY, radius = radius, sector = sector, life = life or 0}
    setmetatable(newTriggerArea, TriggerArea)
    return newTriggerArea
end

--- Check if the TriggerArea object collides with the provided Hitbox object
---@param hitbox table The Hitbox object to check for collision
---@return boolean Returns whether collision happened or not. True if yes, false if no.
function TriggerArea:collisionWithHitbox(hitbox)
    local segments = 8 -- Number of segments per side
    local dx = hitbox.width / segments -- Step size along the x-axis
    local dy = hitbox.height / segments -- Step size along the y-axis

    -- Iterate over each side of the hitbox
    for i = 0, segments do
        local points = {
            {x = hitbox.x + i*dx, y = hitbox.y}, -- Top side
            {x = hitbox.x + i*dx, y = hitbox.y + hitbox.height}, -- Bottom side
            {x = hitbox.x, y = hitbox.y + i*dy}, -- Left side
            {x = hitbox.x + hitbox.width, y = hitbox.y + i*dy} -- Right side
        }

        for _, point in pairs(points) do
            local distanceX = self.centerX - point.x
            local distanceY = self.centerY - point.y

            -- atan2 gives result in the range of -pi to pi, adjust if necessary
            local angle = math.atan2(distanceY, distanceX)
            if angle < 0 then
                angle = angle + 2*math.pi  -- Normalize the angle to the range 0 to 2*pi
            end

            if distanceX * distanceX + distanceY * distanceY < self.radius * self.radius then
                if (self.sector[1] <= angle) and (angle <= self.sector[2]) then
                    return true -- collision
                end
            end
        end
    end

    return false -- no collision
end
--- Decreases the life of the TriggerArea object with respect to the elapsed time
---@param dt number The time in seconds since the last update
function TriggerArea:update(dt)
    self.life = self.life - dt
    if self.life <= 0 then
        self.isDead = true
    end
end
--- Marks the TriggerArea object for removal from the game state
function TriggerArea:destroy()
    self.isDead=true
end
--- Draws the TriggerArea object to the screen using LOVE's graphics functions
function TriggerArea:draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.arc("line", self.centerX, self.centerY, self.radius, self.sector[1]-math.pi, self.sector[2]-math.pi)
end

return TriggerArea
