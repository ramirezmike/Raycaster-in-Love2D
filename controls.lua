function love.mousepressed(x, y, button)
    if button == "l" then
        if not (love.mouse.isGrabbed()) then
            love.mouse.setGrab(true)
        else
--            wallPushDirection = player.rot
--            if not (mapProp.map[selectedWall] == 5) then
     --           pushWall(selectedWall)
 --           end
            createBullet(player) 
        end
    end
end

function love.keypressed(key, unicode)
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

    if key == 'escape' or key == 'q' then
        love.event.quit()
    end

    if key == 'i' then
        loadMapFromDisk("map01.lua")
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
        player.moveSpeed = 8
    end
    if key == 'x' then
    --    wallPushDirection = player.rot
    --    if not (map[selectedWall] == 5) then
    --        pushWall(selectedWall)
    --    end
       for i,v in ipairs(bullets) do 
            table.remove(bullets,i)
       end
    end
    if key == 'c' then
        changeTexture()
    end
    if key == 'i' then
        saveMapToDisk(mapProp.map)
    end
    if key == 'm' then
        mapProp.displayMap = not(mapProp.displayMap)
    end
    if key == 'tab' then
        displayDebug = not(displayDebug)
    end
    if key == '``' then
        love.mouse.setVisible(true)
        love.mouse.setGrab(false)
    end
end

function love.keyreleased(key, unicode)
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
    if key == "lshift" then
        player.moveSpeed = 4
    end
end
