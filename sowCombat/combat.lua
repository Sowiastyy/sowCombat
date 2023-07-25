--combat.lua
local Combat = {}
Combat.__index = Combat
local path = ... .. '.' 
--Requirements 
local TriggerRect = require(path.."TriggerRect")
local TriggerArea = require(path.."TriggerArea")
local TriggerBullet = require (path.."TriggerBullet")
local Hitbox = require(path.."Hitbox")

function Combat.new()
  local self = setmetatable({}, Combat)
  self.hitboxes = {default = {}}
  self.triggers = {default = {}}
  self.currentGroup = 'default'
  self.collisionRules = {}
  self.spawnpoints = {}
  return self
end

function Combat:addSpawnpoint(x, y, triggerType)
  local spawnpoint = {x = x, y = y, triggerType = triggerType}
  
  -- Set a metatable for spawnpoint to define its function behavior
  setmetatable(spawnpoint, 
      {
          __call = function(sp, ...)
              return self[sp.triggerType](self, sp.x, sp.y, ...)
          end 
      }
  )

  table.insert(self.spawnpoints, spawnpoint)
  
  return spawnpoint
end

function Combat:setGroup(group, type)
  self.currentGroup = group
  if type then
    self[type][group] = self[type][group] or {}
  else
    self.hitboxes[group] = self.hitboxes[group] or {}
    self.triggers[group] = self.triggers[group] or {}
  end
end

function Combat:setRule(triggerGroup, hitboxGroups)
  self.collisionRules[triggerGroup] = hitboxGroups
end

function Combat:createAndAddObject(ObjectType, parameters, typeBox) 
  local object = ObjectType:new(unpack(parameters))
  table.insert(self[typeBox][self.currentGroup], object)
  return object
end

function Combat:TriggerRect(...)
  return self:createAndAddObject(TriggerRect, {...}, 'triggers')
end

function Combat:TriggerBullet(...)
  return self:createAndAddObject(TriggerBullet, {...}, 'triggers')
end

function Combat:Hitbox(...)
  return self:createAndAddObject(Hitbox, {...}, 'hitboxes')
end

function Combat:TriggerArea(...)
  return self:createAndAddObject(TriggerArea, {...}, 'triggers')
end

function Combat:checkGroupCollisions(group)
  local hitboxGroups = self.collisionRules[group] or {"default"}
  for _, key in ipairs(hitboxGroups) do
    for j, hitbox in ipairs(self.hitboxes[key]) do
      for i, trigger in ipairs(self.triggers[group]) do
        if trigger.collisionWithHitbox then
          if trigger:collisionWithHitbox(hitbox) then
            print("Object " .. j .. " collided with hitbox " .. i)
            if hitbox.onCollision then hitbox:onCollision(trigger) end
          end
        end
      end
    end
  end
end

function Combat:updateTriggers(dt)
  for group, triggers in pairs(self.triggers) do
    for i, trigger in ipairs(triggers) do
      if trigger.update then
        trigger:update(dt)
        if trigger.isDead then
          table.remove(triggers, i)
        end
      end
    end
  end
end

function Combat:update(dt)
  for group in pairs(self.triggers) do
    self:checkGroupCollisions(group)
  end
  self:updateTriggers(dt)
end

function Combat:draw()
  for _, group in pairs(self.triggers) do
    for _, obj in ipairs(group) do
      obj:draw()
    end
  end
  
  for _, group in pairs(self.hitboxes) do
    for _, obj in ipairs(group) do
      obj:draw()
    end
  end
end

return Combat
