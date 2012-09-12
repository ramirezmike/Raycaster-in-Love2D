function love.mousepressed(x, y, button)
    if button == "l" then
        if not (love.mouse.isGrabbed()) then
            love.mouse.setVisible(false)
            love.mouse.setGrab(true)
        else
            wallPushDirection = player.rot
            if not (map[selectedWall] == 5) then
                pushWall(selectedWall)
            end
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
    if key == 'a' then
        player.strafeSpeed  = -1
    end
    if key == 'd' then
        player.strafeSpeed  = 1
    end
    if key == "lshift" then
        player.moveSpeed = 8
    end
    if key == 'x' then
    --    wallPushDirection = player.rot
    --    if not (map[selectedWall] == 5) then
    --        pushWall(selectedWall)
    --    end
    end
    if key == 'c' then
        changeTexture()
    end
    if key == 'm' then
        displayMap = not(displayMap)
    end
    if key == 'tab' then
        displayDebug = not(displayDebug)
    end
    if key == 'escape' then
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
    end
    if key == 'd' then
        player.strafeSpeed  = 0
    end
    if key == "lshift" then
        player.moveSpeed = 4
    end
end


