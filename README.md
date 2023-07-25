# sowCombat.lua
## This library allows for the creation of simple combat mechanics in a 2D game created with Love2D. It uses simple geometric principles for hitbox detection and interaction.

## Features
Creating hitboxes for different categories of objects (players, enemies, walls, etc.).
Establishing combat rules (e.g., player can attack enemy and wall so does enemy).
Checking for collisions and updating object state accordingly.
Responding to user interaction, such as movement and attacks.
Getting Started
To import the Combat class from Combat.lua file and create a new instance, use the code below:

    local Combat = require("sowCombat")
    local combat = Combat:new()
In the love.load() function, set up different object categories:

setGroup() function is used to specify the category of the object.
Hitbox() function sets the hitbox for an object with parameters: X position, Y position, width, and height.

    function love.load()
        combat:setGroup('player')
        combat:Hitbox(100, 50, 50, 50) -- Player's hitbox

        combat:setGroup('wall')
        combat:Hitbox(300, 100, 50, 200) -- Wall's hitbox
    
        combat:setGroup('enemy')
        combat:Hitbox(200, 300, 50, 50) -- Enemy's hitbox
    
        combat:setGroup('enemyAttack')
        combat:TriggerArea(225, 325, 75, 20,  {0, 1}) -- Trigger area for enemy's attack
    
        -- Set the rules
        combat:setRule('playerAttack', {"enemy", "wall"})
        combat:setRule('enemyAttack', {"player", "wall"})
    end
To handle player movement and collision checks, make sure to update the game's state in love.update():

    function love.update(dt)  
        local xMove, yMove = 0, 0
        if love.keyboard.isDown("w") then
            yMove=yMove-2
        end
        if love.keyboard.isDown("a") then
            xMove=xMove-2
        end
        -- Other movement code here
    
        -- Check for collisions
        combat:update(dt)
    end
Interaction with the mouse is handled in love.mousepressed(). This function allows the player to initiate attacks:

    function love.mousepressed(x, y, button)
        if button == 1 then
            local playerCenterX = player.x + (player.width / 2)
            local playerCenterY = player.y + (player.height / 2)
            combat:setGroup('playerAttack')
            local newTriggerArea = combat:TriggerArea(playerCenterX, playerCenterY, 75, 2, {0, 1})
            newTriggerArea.sector[1] = math.atan2(y - playerCenterY, x - playerCenterX)-0.5+math.pi
            newTriggerArea.sector[2] = newTriggerArea.sector[1] + 1  -- sector length is 1
        end
        -- Other mouse input code here
    end
Finally, to visualize the game state, use the draw() function and Love2D's native drawing methods:

    function love.draw()
        combat:draw()
        love.graphics.print("HP: "..(player.hp or 100))
        love.graphics.print("Enemy HP: "..(enemy.hp or 100), 0, 30)
    end
  
## Documentation
For more information, make sure to read the Love2D documentation on its different modules and functionalities.
## Preview
![img](https://github.com/Sowiastyy/sowCombat/blob/master/preview.PNG)
## Contributions
Contributions are welcome. Please feel free to fork this repository and create pull requests!

Note: This README was generated for a specific implementation of combat in Love2D for my projects. Modifications may be necessary depending on the specifics of your project.
