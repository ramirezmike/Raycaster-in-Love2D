function drawStrip(texX,height,texture,stripIdx,dist,screenHeight)
    local stripTop = math.floor((screenHeight - height)/2 + 0.5)
    local stripBottom = math.floor((screenHeight + height)/2 + 0.5)
    texX = math.floor(texX*64)
    love.graphics.drawq(wallsImgs,QUADS[texture][texX],stripIdx,stripTop,0,1,height/64)
end

function castRays()
    local stripIdx = 0
    for i = 0,numRays - 1 do
        --where does ray go?
        local rayScreenPos = (-numRays/2 + i) 
        -- distance from viewer to point on screen
        local rayViewDist = math.sqrt(rayScreenPos*rayScreenPos + viewDist*viewDist)

        --angle of ray, relative to viewing direction
        --right triangle: a = sin(A) * c
        local rayAngle = math.asin(rayScreenPos / rayViewDist)
        
        castSingleRay(
            player.rot + rayAngle,
            stripIdx
            );

        stripIdx = stripIdx + 1
    end
end

function castSingleRay(rayAngle, stripIdx )
    --make sure angle is between 0 and 360 degrees
    rayAngle = rayAngle % twoPI
    if (rayAngle < 0) then
        rayAngle = rayAngle + twoPI
    end
    --moving right/left? up/down? angle quadrant determines this
    local right = (rayAngle > twoPI * 0.75) or (rayAngle < twoPI * 0.25)
    local up = (rayAngle < 0) or (rayAngle > math.pi)

    local angleSin = math.sin(rayAngle)
    local angleCos = math.cos(rayAngle)

    local vHit = false
    local dist = 0 -- distance to block hit
    local xHit = 0 -- x and y for hit
    local yHit = 0
    local texture
    local textureX --x-coord on texture of the block
    local wallX -- (x,y) coords of block
    local wallY
    
    -- first check against vertical mapp/wall lines
    -- move to the right or left edge of the block we're standing in
    -- moving in 1 map units, step horizontally
    -- the amount we move verticalically is determined by the slope of the ray
    -- which is simply defined as sin(angle)/cos(angle) 

    local slope = angleSin / angleCos
    local dX
    if right then dX = 1 else dX = -1 end
    local dY = dX * slope
    local x
    if right then x = math.ceil(player.x) else x = math.floor(player.x) end
    local y = player.y + (x - player.x) * slope

    while (x >= 0 and x < mapWidth and y >= 0 and y < mapHeight) do
        local wallX
        if right then
            wallX = math.floor(x)
        else
            wallX = math.floor(x - 1)
        end
        local wallY = math.floor(y)

        --is point inside wall block?

        k = 1+(math.floor(wallY) * mapWidth) + math.floor(wallX)
        if (map[k] > 0) then
            local distX = x - player.x
            local distY = y - player.y
            dist = distX*distX + distY*distY

            texture = (map[k]-1)
            textureX = y % 1

            if (not right) then
                textureX = 1 - textureX
            end
  
            xHit = x
            yHit = y
            vHit = true
            break
        end

        x = x + dX
        y = y + dY
    end



    local slope = angleCos / angleSin
    local dY
    if (up) then dY = -1 else dY = 1 end
    local dX = dY * slope

    local y
    if (up) then y = math.floor(player.y) else y = math.ceil(player.y) end
    local x = player.x + (y - player.y) * slope
  
    while (x >= 0 and x < mapWidth and y >= 0 and y < mapHeight) do
        local wallY
        if (up) then
            wallY = math.floor(y - 1)
        else
            wallY = math.floor(y)
        end
        local wallX = math.floor(x)
        k = 1+(math.floor(wallY) * mapWidth) + math.floor(wallX)
        if (map[k] > 0) then
            local distX = x - player.x
            local distY = y - player.y
            local blockDist = distX*distX + distY*distY
            if(dist == 0 or blockDist < dist) then
            texture = (map[k]-1)
                dist = blockDist
                xHit = x
                yHit = y
                vHit = false
                textureX = x % 1
                if (up) then
                    textureX = 1 - textureX
                end
            end
            break
        end
        x = x + dX
        y = y + dY
    end
    if (dist)then
        dist = math.sqrt(dist)
        dist = dist * math.cos(player.rot - rayAngle)

        height = math.floor(viewDist / dist+0.5)
        drawStrip(textureX,height,texture,stripIdx,dist,screenHeight)
    end
end

function drawRay(vHit,rayX, rayY)
    if vHit then
        love.graphics.setColor(125,0,0)
    else
        love.graphics.setColor(155,0,0)
    end 
    love.graphics.setLineWidth(2)
    love.graphics.line(
        player.x * miniMapScale,
        player.y * miniMapScale,
        rayX * miniMapScale,
        rayY * miniMapScale
        )
    love.graphics.setLineWidth(1)
end 
