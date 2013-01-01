function love.mousepressed(x, y, button)
    if (introDisplaying) then
        introDisplaying = false
        return
    end
    if (sceneChange) then
        sceneChange = false
        gamePaused = false
        gameRunning = true
    end
    if button == "l" then
        if (gameRunning and not(gamePaused)) then
            if not (love.mouse.isGrabbed()) then
                love.mouse.setGrab(true)
                love.mouse.setVisible(false) 
            else
    --            wallPushDirection = player.rot
    --            if not (mapProp.map[selectedWall] == 5) then
         --           pushWall(selectedWall)
     --           end
                player.firing = true
            end
        end
        if (mainMenuDisplaying or gamePaused) then
            menuButtonClick(x,y)
        end
    end
    if button == "r" then
        if (gameRunning and not(gamePaused)) then
            if (player.secondary ~= 13) then
                player.secondFiring = true 
            end
        end
    end
end

function love.mousereleased(x, y, button)
    if button == "l" then
        if (gameRunning and not(gamePaused)) then
            player.firing = false
        end
    end
end

function love.keypressed(key, unicode)
    if (introDisplaying) then
        introDisplaying = false
    end

    if (sceneChange) then
        sceneChange = false
        gamePaused = false
        gameRunning = true
    end
    if key == 'escape' then
        if not (mainMenuDisplaying) then
            gamePaused = not(gamePaused)
        end
        if (gamePaused) then
            love.mouse.setVisible(true) 
            love.mouse.setGrab(false)
        end
    end
    if not (gamePaused) and not (mainMenuDisplaying) then
        if key == 'w' or key == 'up' then
            player.speed = 1
        end
        if key == 's' or key == 'down' then
            player.speed = -1
        end
        if key == 'left' then
            player.dir = -1
        end
        if key == 'right' then
            player.dir = 1
        end


        if key == ' ' then
            mapGenManagement()
        end

        if key == 'i' then
--            generateMap()
--            changeLevel()
--            createSpecialItem(player)
--            spawnEnemies(5)
--            player.health = player.health - 1
--            testItemDrop(player)
--            player.health = player.health - 0.1
        end

        if key == 'u' then
--            testItemDrop(player)
--            player.secondaryRecharge = true
        end
        if key == 'a' then
            player.strafeSpeed  = -1
            down = love.keyboard.isDown('d') 
            if (down) then
                player.strafeSpeed  = -1
            end
        end
        if key == 'd' then
            player.strafeSpeed  = 1
            down = love.keyboard.isDown('a') 
            if (down) then
                player.strafeSpeed  = 1
            end
        end
        if key == "lshift" then
--            player.moveSpeed = 8
        end
        if key == 'x' then
        --    wallPushDirection = player.rot
        --    if not (map[selectedWall] == 5) then
        --        pushWall(selectedWall)
        --    end
--           for i,v in ipairs(bullets) do 
--                table.remove(bullets,i)
--           end
        end
    end
end

function love.keyreleased(key, unicode)
    if not (gamePaused) then
        if key == 'w' or key == 'up' then
            player.speed = 0
        end
        if key == 's' or key == 'down' then
            player.speed = 0
        end
        if key == 'left' then
            player.dir = 0
        end
        if key == 'right' then
            player.dir = 0
        end
        if key == 'a' then
            player.strafeSpeed  = 0
            down = love.keyboard.isDown('d') 
            if (down) then
                player.strafeSpeed  = 1
            end
        end
        if key == 'd' then
            player.strafeSpeed  = 0
            down = love.keyboard.isDown('a') 
            if (down) then
                player.strafeSpeed  = -1
            end
        end
--        if key == "lshift" then
--            player.moveSpeed = 4
--        end
    end
end
