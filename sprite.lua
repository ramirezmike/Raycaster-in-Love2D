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
    for i=1,#SPRITES do
        local sprite = SPRITES[i]
        local dx = sprite.x + 0.5 - player.x
        local dy = sprite.y + 0.5 - player.y
        
        local dist = math.sqrt(dx*dx + dy*dy)
        local spriteAngle = math.atan2(dy, dx) - player.rot

        local spriteSize = viewDist / (math.cos(spriteAngle) * dist)
        
        local spriteX = math.tan(spriteAngle) * viewDist
        local top = (screenHeight - spriteSize)/2
        local left = (screenWidth/2 + spriteX - spriteSize/2)
        local dbx = sprite.x - player.x
        local dby = sprite.y - player.y
        local blockDist = dbx*dbx + dby*dby
        local z = -math.floor(dist*10000)
        if (sprite.visible) then 
            --love.graphics.drawq(harrisImg,SPRITEQUAD[0],left,top,0,spriteSize/mapProp.tileSize,spriteSize/mapProp.tileSize)
            drawCalls[#drawCalls+1] = 
            { 
                z = z,
                x = left,
                y = top,
                dist = dist,
                sx = spriteSize / mapProp.tileSize,
                sy = spriteSize / 64,
                quad = SPRITEQUAD[0]
            }
            sprite.visible = false
        end
    end
end
