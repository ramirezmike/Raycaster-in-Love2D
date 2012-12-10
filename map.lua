mapProp = {
    tileSize = 64,
    mapWidth = 0,
    mapHeight = 0,
    miniMapScale = 6,
    displayMap = false,
    map = {}
}

wallPositions = {}

function makeWallPositions()
    wallPositions = {}
    for i,v in ipairs(mapProp.map) do
        if (v > 0) then
            table.insert(wallPositions,{
                x = positionXFromArrayIndex(i), 
                y = positionYFromArrayIndex(i) 
            })
        end
    end
end

function saveMapToDisk(map)
    local mapString = "map = {"  
    for i = 1, #map - 1 do
        mapString = mapString .. tostring(map[i]) .. ","
    end
    mapString = mapString .. tostring(map[#map]) .. "} \n return map"

    local file = (io.open("map02.lua", "w"))
    file:write(mapString)
    file:close()
end

function loadMapFromDisk(mapName)
    chunk = love.filesystem.load(mapName) 
    mapProp.map = chunk()
    mapProp.mapWidth =  (math.sqrt(table.getn(map)))
    mapProp.mapHeight = (math.sqrt(table.getn(map)))
    makeWallPositions()
    print ("MAP : " .. tostring(#map))
    print ("MAP : " .. tostring(mapProp.mapWidth))
end

function loadMapFromRoom(room)
    mapProp.map = room
    local size = math.sqrt(#mapProp.map)
    mapProp.mapWidth = size 
    mapProp.mapHeight = size 
    makeWallPositions()
    print ("MAP : " .. tostring(#room))
    print ("MAP : " .. tostring(mapProp.mapHeight))
end
