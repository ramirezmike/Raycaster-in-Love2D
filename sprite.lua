function makeSpriteMap()
    for i=1,#mapProp.map do
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
        local isHit = false
        local sprite = SPRITES[i]
        sprite.wallPositionX = floor(sprite.x)
        sprite.wallPositionY = floor(sprite.y)
        if (sprite.visible) then 
            if (sprite.hit) then
                isHit = true
            end

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
                quad = SPRITEQUAD[sprite.img][sprite.state],
                hit = isHit
            }
            sprite.visible = false 
       end
    end
end

function handleSpriteHit(sprite)
    sprite.hit = true
    sprite.health = sprite.health - 1
end

function addSpriteToMap(index)
    local posX = positionXFromArrayIndex(index) 
    local posY = positionYFromArrayIndex(index) 
    
    local spriteIndex = #SPRITES + 1 
    SPRITES[spriteIndex] = {
            id = spriteIndex,
            x = posX,
            y = posY,
            img = 5,
            visible = false,
            block = true,
            speed = 0,
            dir = 0,
            rot = 0,

            bulletSpeed = 4.5,
            playerVisible = false,
            visiblityRange = 5,

            rotate = true,
            rotationDirection = 0,
            rotationAngle = 20,
            rotateDelay = 3,
            rotateDelayMax = 3,

            maxFireRate = 3,
            fireRate = 2.9,

            health = 1,
            hit = false,
            hitPause = 0.1,

            moveSpeed = 0.05,
            rotSpeed = 3,
            totalStates = 12,
            state = 0,
            wallPositionX = 0,
            wallPositionY = 0,
            objType = "sprite",
            frameTimer = 0,
            walkAnimationSpeed = 5
        }
end

function areEnemiesDead()
    for i,v in ipairs(SPRITES) do
        if (v["health"] > 0) then
            return false
        end
    end
    return true
end
