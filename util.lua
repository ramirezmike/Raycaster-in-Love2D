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
