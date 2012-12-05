function ai(dt)
    for i = 1, #SPRITES do     
        local sprite = SPRITES[i]
        sprite.frameTimer = sprite.frameTimer + dt*sprite.walkAnimationSpeed
        sprite.strafeSpeed = 0
        local dx = player.x - sprite.x
        local dy = player.y - sprite.y

        local dist = math.sqrt(dx*dx + dy*dy)
        
        if (dist > 3) then
            local angle = math.atan2(dy, dx)
            sprite.rotDeg = angle * 180 / math.pi
            sprite.rot = angle
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
        move(SPRITES[i], dt)
    end

end
