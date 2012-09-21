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

function isBlocking(x,y)
    if (y < 0 or y > mapProp.mapHeight or x < 0 or x > mapProp.mapWidth) then
        return true
    end
    if (spriteMap[indexFromCoordinates(x,y)] > 0) then
        return true
    else

    local i = 1+(math.floor(y) * mapProp.mapWidth) + math.floor(x)
    return (mapProp.map[i] > 0)
    end
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
       SPRITEQUAD[i] = love.graphics.newQuad(mapProp.tileSize+1, 0+(i*mapProp.tileSize), 
        mapProp.tileSize, mapProp.tileSize,imagesPerWidth*mapProp.tileSize, imagesPerHeight*mapProp.tileSize) 
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
    love.graphics.print("selWallY   : "..tostring(math.floor(positionYFromArrayIndex(selectedWall) + 0.5)), 10, 85)
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

function move(dt)
    local moveStep = player.speed * player.moveSpeed * dt
    local strafeStep = player.strafeSpeed * math.pi/2

    local mouseLook = 0
    if (love.mouse.isGrabbed()) then
        mouseLook = love.mouse.getX()
        mouseLook = (screenWidth/2) - mouseLook
        mouseLook = mouseLook * player.mouseSpeed * dt
        mouseLook = mouseLook * -1
        love.mouse.setPosition(screenWidth/2,screenHeight/2)
    end

    convertPlayerRotation() -- make sure player is within 360 degrees

    player.rot = player.rot + (player.dir * player.rotSpeed * dt) + mouseLook
    local newX = player.x + math.cos(player.rot ) * moveStep
    local newY = player.y + math.sin(player.rot ) * moveStep
    newX = newX + math.cos(player.rot + math.abs(strafeStep)) * player.strafeSpeed*player.moveSpeed * dt
    newY = newY + math.sin(player.rot + math.abs(strafeStep)) * player.strafeSpeed*player.moveSpeed * dt

    if not (isBlocking(newX,player.y)) then player.x = newX end
    if not (isBlocking(player.x,newY)) then player.y = newY end
end

function drawBackground()
    for i = 1, screenWidth do
       love.graphics.drawq(bgImg,BGQUAD[1],i,0,0,1,1)
    end
end
