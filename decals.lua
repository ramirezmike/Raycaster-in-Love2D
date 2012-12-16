function renderDecals()
    local plyr = player
    local floor = math.floor
    local sqrt = math.sqrt
    local atan2 = math.atan2
    local vDist = viewDist
    local cos = math.cos
    local tan = math.tan
    local scrHeight = screenHeight
    local scrWidth = screenWidth
    local mTileSize = mapProp.tileSize

    for i,v in ipairs(DECALS) do
        if (v["visible"] == true) then
            local dx = v["x"] - plyr.x
            local dy = v["y"] - plyr.y

            local dist = sqrt(dx*dx + dy*dy)
            local spriteAngle = atan2(dy, dx) - plyr.rot
            local spriteSize = vDist / (cos(spriteAngle) * dist) 
            local spriteX = tan(spriteAngle) * vDist
            local top = (scrHeight - spriteSize)/2
            local left = (scrWidth/2 + spriteX - spriteSize/2)
            local z = -floor(dist*10000)
            local state = v["state"]
            drawCalls[#drawCalls+1] =
            {
            
                z = z,
                x = left,
                y = top + v["verticalPosition"],
                dist = dist,
                sx = spriteSize / mTileSize,
                sy = spriteSize / 64,
                quad = SPRITEQUAD[4][state]
            }
            v["visible"] = false
        end
    end
end

function manageDecals(dt)
    for i,v in ipairs(DECALS) do
        v["decay"] = v["decay"] - dt
        if (v["decay"] <= 0) then
            table.remove(DECALS, i)
        end
    end
end
