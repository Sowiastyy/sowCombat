-- Import Combat class from Combat.lua
local Combat = require("sowCombat")

-- Create fresh instance of Combat
local combat = Combat:new()

-- Declare global variables for player and enemy
local player
local enemy

-- love.load is a default Love2D function where we set up our game initially
function love.load()
    -- Set up groups for our different object categories
    -- In this case we have a player, an enemy, and a wall

    -- Specify the player's attributes
    combat:setGroup('player')
    combat:Hitbox(100, 50, 50, 50) -- The hitbox for our player. Parameters: X position, Y position, width, and height

    -- Specify the wall's attributes
    combat:setGroup('wall') -- The hitbox for the wall.
    combat:Hitbox(300, 100, 50, 200).onCollision = function (self, trigger)
        trigger:destroy()
    end

    -- Specify the enemy's attributes
    combat:setGroup('enemy')
    combat:Hitbox(200, 300, 50, 50) -- The hitbox for our enemy.

    combat:setGroup('enemyAttack')
    combat:TriggerArea(225, 325, 75, 20,  {0, 1}) -- The trigger area for our enemy's attack.

    -- Establish the rules for our combat, player can attack enemy and wall so does enemy
    combat:setRule('playerAttack', {"enemy", "wall"})
    combat:setRule('enemyAttack', {"player", "wall"})

    -- Retrieve the player and enemy hitboxes
    player = combat.hitboxes['player'][1]
    player.hp = 100
    player.onCollision = function (self, trigger)
        player.hp=player.hp-1
        trigger:destroy()
    end

    enemy = combat.hitboxes['enemy'][1]
    enemy.hp = 100
    enemy.onCollision = function (self, trigger)
        enemy.hp=enemy.hp-1
        trigger:destroy()
    end
end

-- when a love.update function is called, we want our player to move according to button presses, and we want to check for any collisions
function love.update(dt)  
    local xMove, yMove = 0, 0
    if love.keyboard.isDown("w") then
        yMove=yMove-2
    end
    if love.keyboard.isDown("s") then
        yMove=yMove+2
    end
    if love.keyboard.isDown("a") then
        xMove=xMove-2
    end
    if love.keyboard.isDown("d") then
        xMove=xMove+2
    end
    player:move(xMove, yMove)
   
    -- Check for collisions
    combat:update(dt)

end

function love.mousepressed(x, y, button)
    -- Actions for left mouse clicks
    if button == 1 then
        local playerCenterX = player.x + (player.width / 2)
        local playerCenterY = player.y + (player.height / 2)
        combat:setGroup('playerAttack')

        -- Create new TriggerArea
        local newTriggerArea = combat:TriggerArea(playerCenterX, playerCenterY, 75, 2, {0, 1})
        
        -- Define sector direction 
        newTriggerArea.sector[1] = math.atan2(y - playerCenterY, x - playerCenterX)-0.5+math.pi
        newTriggerArea.sector[2] = newTriggerArea.sector[1] + 1  -- sector length is 1
    end
    
    -- Actions for right mouse clicks
    if button == 2 then
    -- Create new TriggerBullet when right mouse button is clicked
        local playerCenterX = player.x + (player.width / 2)
        local playerCenterY = player.y + (player.height / 2)
        combat:setGroup('playerAttack')

        local newTriggerBullet = combat:TriggerBullet(playerCenterX, playerCenterY, 20, 10, 0, 3, 1000)
        newTriggerBullet.angle = math.atan2(y - playerCenterY, x - playerCenterX) 
    end
end

-- Draw the scene
function love.draw()
    combat:draw()
    -- Display HP level
    love.graphics.print("HP: "..(player.hp or 100))
    love.graphics.print("Enemy HP: "..(enemy.hp or 100), 0, 30)
end
