function ai(dt)
    for i = 1, #SPRITES do     
        local sprite = SPRITES[i]
        if (sprite.health <= 0) then
            sprite.state = 10
            sprite.block = false
        else
            sprite.frameTimer = sprite.frameTimer + dt*sprite.walkAnimationSpeed
            sprite.strafeSpeed = 0
            local dx = player.x - sprite.x
            local dy = player.y - sprite.y

            local dist = math.sqrt(dx*dx + dy*dy)
            
            if (dist > 3) then
                local angle = math.atan2(dy, dx)
                sprite.rot = angle + steerAwayFromWalls(sprite)
                sprite.speed = 40
                local numWalkSprites = 4
                if math.floor(sprite.frameTimer) > numWalkSprites then
                    sprite.frameTimer = 1 
                end
                sprite.state = math.floor(sprite.frameTimer) 
            else
                sprite.state = 0
                sprite.speed = 0
            end
            if (sprite.hit) then
                aiHandleHit(sprite, dt)
            end
            move(SPRITES[i], dt)
        end
    end

end

function aiHandleHit(sprite, dt)
    sprite.hitPause = sprite.hitPause - dt
    if (sprite.hitPause <= 0) then
        sprite.hit = false
        sprite.hitPause = 0.2
    else
        sprite.state = 5
    end
end

function steerAwayFromWalls(sprite)
    local vector = 0

    for i,v in ipairs(wallPositions) do
        local dx = sprite.x - v["x"]
        local dy = sprite.y - v["y"]
        local dist = math.sqrt(dx*dx + dy*dy)
        if (dist < 1.4) then
            vector = vector - dist/2
        end
    end

    return vector
end
