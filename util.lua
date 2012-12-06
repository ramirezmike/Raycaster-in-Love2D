function sort(T) table.sort(T, function(a, b) return a.z < b.z end ) end

function indexFromCoordinates(x,y)
    local x = math.abs(x)
    local y = math.abs(y)
    index = 1 + (math.floor(y)*mapProp.mapWidth) + (math.floor(x))
    return index
end

function positionXFromArrayIndex(index)
    local x = (index % mapProp.mapWidth)-1
    local y = (index - x)/mapProp.mapWidth
    return x
end

function positionYFromArrayIndex(index)
    local x = (index % mapProp.mapWidth)-1
    local y = (index - x)/mapProp.mapWidth
    return y
end

function isBlocking(object, newX, newY)
    if (object.objType == "sprite") then
        return false
    end
    local x = newX
    local y = newY 
    local floor = math.floor
    local sqrt = math.sqrt

    if (y < 0 + distanceFromWalls or y > mapProp.mapHeight - distanceFromWalls or x < 0 + distanceFromWalls or x > mapProp.mapWidth - distanceFromWalls) then
        return true
    end

    for i=1,#SPRITES do
        local sprite = SPRITES[i]
        if (sprite.block == true) then
            local dx = sprite.x - x
            local dy = sprite.y - y
            local dist = sqrt(dx*dx + dy*dy)
            if (object.objType == "bullet" and SPRITES[object.origin] ~= sprite) then
                if (dist < 0.3) then
                    handleSpriteHit(sprite)
                    return true
                end
            end
            if (dist < 1 and sprite ~= object and object.objType ~= "bullet") then
                return true
            end
        end
    end

    local reg = 1+(floor(y) * mapProp.mapWidth) + floor(x)

    if (mapProp.map[reg] > 0) then
        return true
    end

    return false
end

function changeTexture()
    for i = 0,(mapProp.mapWidth*mapProp.mapHeight) do
        if (mapProp.map[i] == 4) then mapProp.map[i] = 5 end
        if (mapProp.map[i] == 3) then mapProp.map[i] = 4 end
        if (mapProp.map[i] == 2) then mapProp.map[i] = 3 end
        if (mapProp.map[i] == 1) then mapProp.map[i] = 2 end
        if (mapProp.map[i] == 5) then mapProp.map[i] = 1 end
    end 
end

function setQuads(imagesPerHeight,imagesPerWidth)
    for i=0,imagesPerHeight-1 do
        QUADS[i]= {}
        for s=0, mapProp.tileSize-1 do
            QUADS[i][s] = love.graphics.newQuad(s,0 + ((i)*mapProp.tileSize),1,mapProp.tileSize,
                mapProp.tileSize*imagesPerWidth,mapProp.tileSize*imagesPerHeight)
        end 
    end 
    for i=0,imagesPerHeight-1 do
        SPRITEQUAD[i] = {}
        for s=0,imagesPerWidth-1 do
           SPRITEQUAD[i][s] = love.graphics.newQuad(mapProp.tileSize+1+(s*mapProp.tileSize), 0+(i*mapProp.tileSize+1), 
            mapProp.tileSize, mapProp.tileSize,imagesPerWidth*mapProp.tileSize, imagesPerHeight*mapProp.tileSize) 
        end
    end
    BGQUAD[1] = love.graphics.newQuad(0,0,1,480,1,480)
--    floorQuad = love.graphics.newQuad(1,1,1,1,mapProp.tileSize,mapProp.tileSize*numberOfImages)
end 

function drawDebug()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("player.X   : "..tostring(player.x), 10, 25)
    love.graphics.print("player.Y   : "..tostring(player.y), 10, 40)
    love.graphics.print("player.R   : "..tostring(player.rot), 10, 55)
    love.graphics.print("selWallX   : "..tostring(positionXFromArrayIndex(selectedWall)), 10, 70)
--    love.graphics.print("selWallY   : "..tostring(math.floor(positionYFromArrayIndex(selectedWall) + 0.5)), 10, 85)
--    love.graphics.print("sprite.X   : "..tostring(SPRITES[1].x), 10, 100)
--    love.graphics.print("sprite.Y   : "..tostring(SPRITES[1].y), 10, 115)
end

function drawMiniMap()
    miniMapWidth = mapProp.mapWidth * mapProp.miniMapScale
    miniMapHeight = mapProp.mapHeight * mapProp.miniMapScale

    mapOffsetX = 0 --500
    mapOffsetY = 0 --340

    love.graphics.setColor(255,255,255)
    love.graphics.rectangle( "fill",
        player.x * mapProp.miniMapScale - 2 + mapOffsetX,
        player.y * mapProp.miniMapScale - 2 + mapOffsetY,
        4, 4)
    love.graphics.setColor(255,0,0)
    love.graphics.line(
        player.x * mapProp.miniMapScale + mapOffsetX,
        player.y * mapProp.miniMapScale + mapOffsetY,
        (player.x + math.cos(player.rot) * 4) * mapProp.miniMapScale + mapOffsetX,
        (player.y + math.sin(player.rot) * 4) * mapProp.miniMapScale + mapOffsetY
        )

    local i=1
    for y=0,mapProp.mapHeight-1 do
        for x=0,mapProp.mapWidth-1 do
            local wall = mapProp.map[i]
   
            if (wall>0) then
                love.graphics.setColor(0,0,200)
                love.graphics.rectangle( "fill",
                    x * mapProp.miniMapScale + mapOffsetX,
                    y * mapProp.miniMapScale + mapOffsetY,
                    mapProp.miniMapScale, mapProp.miniMapScale)
            end
            i = i + 1
        end
    end
end

function move(object, dt)
    local cos = math.cos
    local sin = math.sin
    local abs = math.abs

    local moveStep = object.speed * object.moveSpeed * dt
    local strafeStep = object.strafeSpeed * math.pi/2

    local mouseLook = 0
    if (love.mouse.isGrabbed()) then
        mouseLook = love.mouse.getX()
        mouseLook = (screenWidth/2) - mouseLook
        mouseLook = mouseLook * player.mouseSpeed * dt
        mouseLook = mouseLook * -1
        love.mouse.setPosition(screenWidth/2,screenHeight/2)
    end

    convertPlayerRotation() -- make sure player is within 360 degrees

    object.rot = object.rot + (object.dir * object.rotSpeed * dt) + mouseLook
    local newX = object.x + cos(object.rot ) * moveStep
    local newY = object.y + sin(object.rot ) * moveStep
    newX = newX + cos(object.rot + abs(strafeStep)) * object.strafeSpeed*object.moveSpeed * dt
    newY = newY + sin(object.rot + abs(strafeStep)) * object.strafeSpeed*object.moveSpeed * dt
    
    if not (isBlocking(object, newX, object.y)) then object.x = newX end
    if not (isBlocking(object, object.x, newY)) then object.y = newY end
end

function drawBackground()
    for i = 1, screenWidth do
       love.graphics.drawq(bgImg,BGQUAD[1],i,0,0,1,1)
    end
end
