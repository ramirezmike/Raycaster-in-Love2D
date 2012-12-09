MAPGEN_MAP = {}
MAPGEN_MAPSIZE = 0 

function generateMapWithSize(size)
    size = size * size
    MAPGEN_MAPSIZE = size
    for i=0,size do
        MAPGEN_MAP[i] = 0
    end
end 

function setSpawnRoom()
    mapSize = #MAPGEN_MAP-1
    sRoom = mapSize / 2
    print (sRoom)
    MAPGEN_MAP[sRoom] = 1
end

function printGeneratedMap()
    local mapstring = ""
    for i=0,math.sqrt(MAPGEN_MAPSIZE)-1 do
        mapstring = ""
        for j=0,math.sqrt(MAPGEN_MAPSIZE)-1 do
            local index = mapGenIndexFromCoordinates(j,i)
            mapstring = mapstring .. tostring(MAPGEN_MAP[index])
        end
        print (mapstring)
    end
end


function generateMap()
    generateMapWithSize(25)
    setSpawnRoom()
    printGeneratedMap()
end

function mapGenIndexFromCoordinates(x,y) 
    index = 1 + (math.floor(y)*(math.sqrt(MAPGEN_MAPSIZE))) + (math.floor(x))
    return index
end

function mapGenPositionXFromArrayIndex(index)
    local x = (index % mapSize)-1
    if (x==-1) then x = mapSize-1 end
    return x
end

function mapGenPositionYFromArrayIndex(index)
    local y = ((index-1) / mapSize)
    y = math.floor(y)
    return y
end
