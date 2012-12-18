function castRays()
    local sqrt = math.sqrt
    local asin = math.asin
    local stripIdx = 0
    local rot = player.rot
    local vDist = viewDist

    for i = 0,numRays - 1 do
        --where does ray go?
        local rayScreenPos = (-numRays/2 + i) 
        -- distance from viewer to point on screen
        local rayViewDist = sqrt(rayScreenPos*rayScreenPos + vDist*vDist)

        --angle of ray, relative to viewing direction
        --right triangle: a = sin(A) * c
        local rayAngle = asin(rayScreenPos / rayViewDist)
        
        castSingleRay(
            rot + rayAngle,
            stripIdx
            );

        stripIdx = stripIdx + 1
    end
end

function castSingleRay(rayAngle, stripIdx )
    local floor = math.floor
    local ceil = math.ceil
    local sin = math.sin
    local cos = math.cos

    local plyr = player
    local vDist = viewDist

    --make sure angle is between 0 and 360 degrees
    rayAngle = rayAngle % twoPI
    if (rayAngle < 0) then
        rayAngle = rayAngle + twoPI
    end
    --moving right/left? up/down? angle quadrant determines this
    local right = (rayAngle > twoPI * 0.75) or (rayAngle < twoPI * 0.25)
    local up = (rayAngle < 0) or (rayAngle > math.pi)

    local angleSin = sin(rayAngle)
    local angleCos = cos(rayAngle)

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
    -- the amount move verticalically is determined by the slope of the ray
    -- which is sin(angle)/cos(angle) 

    local slope = angleSin / angleCos
    local dX
    if right then dX = 1 else dX = -1 end
    local dY = dX * slope
    local x
    if right then x = ceil(plyr.x) else x = floor(plyr.x) end
    local y = plyr.y + (x - plyr.x) * slope

--    local floor = math.floor
    while (x >= 0 and x < mapProp.mapWidth and y >= 0 and y < mapProp.mapHeight) do
        local wallX
        if right then
            wallX = floor(x)
        else
            wallX = floor(x - 1)
        end
        local wallY = floor(y)

        for i=1,#SPRITES do
            local sprite = SPRITES[i]
            if (sprite.wallPositionX == wallX and sprite.wallPositionY == wallY) then
                sprite.visible = true
                sprite.detected = true
            end
        end

        for i,v in ipairs(bullets) do
            if (v["bulletWallPositionX"] == wallX and v["bulletWallPositionY"] == wallY) then
                v["visible"] = true
            end
        end

        for i,v in ipairs(DECALS) do
            if (v["wallX"] == wallX and v["wallY"] == wallY) then
                v["visible"] = true
            end
        end

        --is point inside wall block?

        k = 1+(floor(wallY) * mapProp.mapWidth) + floor(wallX)
        if (mapProp.map[k] > 0) then
            local distX = x - plyr.x
            local distY = y - plyr.y
            dist = distX*distX + distY*distY

            texture = (mapProp.map[k]-1)
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
    if (up) then y = floor(plyr.y) else y = ceil(plyr.y) end
    local x = plyr.x + (y - plyr.y) * slope
  
    local floor = floor
    while (x >= 0 and x < mapProp.mapWidth and y >= 0 and y < mapProp.mapHeight) do
        local wallY
        if (up) then
            wallY = floor(y - 1)
        else
            wallY = floor(y)
        end
        local wallX = floor(x)

        for i=1,#SPRITES do
            local sprite = SPRITES[i]
            if (sprite.wallPositionX == wallX and sprite.wallPositionY == wallY) then
                sprite.visible = true
                sprite.detected = true
            end
        end

        for i,v in ipairs(bullets) do
            if (v["bulletWallPositionX"] == wallX and v["bulletWallPositionY"] == wallY) then
                v["visible"] = true
            end
        end

        for i,v in ipairs(DECALS) do
            if (v["wallX"] == wallX and v["wallY"] == wallY) then
                v["visible"] = true
            end
        end

        k = 1+(floor(wallY) * mapProp.mapWidth) + floor(wallX)
        if (mapProp.map[k] > 0) then
            local distX = x - plyr.x
            local distY = y - plyr.y
            local blockDist = distX*distX + distY*distY
            if(dist == 0 or blockDist < dist) then
            texture = (mapProp.map[k]-1)
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
        dist = dist * cos(plyr.rot - rayAngle)

        height = floor(vDist / dist+0.5)
        drawStrip(textureX,height,texture,stripIdx,dist)
    end
end

function drawStrip(texX,height,texture,stripIdx,dist)
    local scrHeight = screenHeight
    local floor = math.floor
    local stripTop = floor((scrHeight - height)/2 + 0.5)
    local stripBottom = floor((scrHeight + height)/2 + 0.5)
    texX = floor(texX*64)
--    love.graphics.drawq(wallsImgs,QUADS[texture][texX],stripIdx,stripTop,0,1,height/64)
--    spriteBatch:addq(QUADS[texture][texX],stripIdx,stripTop,0,1,height/64)
    drawCalls[stripIdx] = 
        {
            z = -floor(dist*10000), 
            x = stripIdx, 
            y = stripTop, 
--            id = math.random(1000,9999), 
            dist = dist,
 --           img = wallImg, 
            quad = QUADS[texture][texX], 
            sx = 1, 
            sy = height/64, 
            type = "wall"
        }
end


function drawRay(vHit, rayX, rayY)
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
