local path = ... .. '.' 
local TriggerRect = require("sowCombat.TriggerRect")
local TriggerBullet = {}
TriggerBullet.__index = TriggerBullet

TriggerBullet.draw = TriggerRect.draw
TriggerBullet.collisionWithHitbox = TriggerRect.collisionWithHitbox
TriggerBullet.destroy = TriggerRect.destroy
function TriggerBullet:new(x, y, w, h, angle, life,  speed)
    local obj = TriggerRect:new(x, y, w, h, angle, life)
    obj.speed = speed or 10
    setmetatable(obj, TriggerBullet)
    return obj
end

function TriggerBullet:update(dt)
    -- Calculate new position
    self.x = self.x + self.speed * math.cos(self.angle) * dt
    self.y = self.y + self.speed * math.sin(self.angle) * dt
    
    self.life = self.life - dt
    if self.life <= 0 then
        self.isDead = true
    end
end

return TriggerBullet
