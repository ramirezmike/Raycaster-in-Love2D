function makeSpriteMap()
    for i=1,#map do
        spriteMap[i] = 0
    end
    for i=1,#SPRITES do
        local sprite = SPRITES[i] 
        spriteMap[(indexFromCoordinates(sprite.x,sprite.y))] = 1
    end
end

function renderSprites()
    local floor = math.floor

    for i=1,#SPRITES do
        local sprite = SPRITES[i]
        sprite.wallPositionX = floor(sprite.x)
        sprite.wallPositionY = floor(sprite.y)
        if (sprite.visible) then 
            local dy = sprite.y - player.y -- These two had + 0.5 to fix upside down sprites..
            local dx = sprite.x - player.x
            
            local dist = math.sqrt(dx*dx + dy*dy)
            local spriteAngle = math.atan2(dy, dx) - player.rot

            local spriteSize = viewDist / (math.cos(spriteAngle) * dist)
            
            local spriteX = math.tan(spriteAngle) * viewDist
            local top = (screenHeight - spriteSize)/2
            local left = (screenWidth/2 + spriteX - spriteSize/2)
            local dbx = sprite.x - player.x
            local dby = sprite.y - player.y
            local blockDist = dbx*dbx + dby*dby
            local z = -floor(dist*10000)
            --love.graphics.drawq(harrisImg,SPRITEQUAD[0],left,top,0,spriteSize/mapProp.tileSize,spriteSize/mapProp.tileSize)
            drawCalls[#drawCalls+1] = 
            { 
                z = z,
                x = left,
                y = top,
                dist = dist,
                sx = spriteSize / mapProp.tileSize,
                sy = spriteSize / 64,
                quad = SPRITEQUAD[sprite.img][sprite.state]
            }
            sprite.visible = false 
       end
    end
end

function handleSpriteHit(sprite)
    sprite.hit = true
end
