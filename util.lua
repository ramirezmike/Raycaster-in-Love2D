function indexFromCoordinates(x,y)
    index = 1 + (math.floor(y)*mapWidth) + (math.floor(x))
    return index
end

function positionXFromArrayIndex(index)
    local x = (index % mapWidth)-1
    local y = (index - x)/mapWidth
    return x
end

function positionYFromArrayIndex(index)
    local x = (index % mapWidth)-1
    local y = (index - x)/mapWidth
    return y
end

function isBlocking(x,y)
    if (y < 0 or y > mapHeight or x < 0 or x > mapWidth) then
        return true
    else

    local i = 1+(math.floor(y) * mapWidth) + math.floor(x)
    return (map[i] > 0)
    end
end
