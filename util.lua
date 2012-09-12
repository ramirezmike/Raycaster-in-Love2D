function indexFromCoordinates(x,y)
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
    else

    local i = 1+(math.floor(y) * mapProp.mapWidth) + math.floor(x)
    return (map[i] > 0)
    end
end


function drawMiniMap()
    miniMapWidth = mapProp.mapWidth * mapProp.miniMapScale
    miniMapHeight = mapProp.mapHeight * mapProp.miniMapScale

    mapOffsetX = 500
    mapOffsetY = 340

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
            local wall = map[i]
   
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
