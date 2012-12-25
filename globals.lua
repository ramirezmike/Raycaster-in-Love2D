spriteMap = {}
drawCalls = {}
QUADS = {} 
SPRITEQUAD = {}
BGQUAD = {}
bullets = {}
ITEMS = {}
DECALS = {}
SPRITES_TO_DELETE = {}
ITEMS_TO_DELETE = {}

LEVELS = {}

levelOne = {
    introText = "Frosty's Legal Department",
    floor = function (x) love.graphics.setColor(100,100,100) end,
    ceiling = function (x) love.graphics.setColor(200,200,200) end,
    regMapSize = 25,
    rooms = 4,
    door      = 1,
    wall1     = 2,
    wall2     = 3,
    obstacle  = 4,
    uDoor     = 5,
    boss      = 6,
    minEnemy  = 1,
    maxEnemy  = 2
}
    
levelTwo = {
    introText = "Jack's Nut Cracker Storage",
    floor = function (x) love.graphics.setColor(20,20,20) end,
    ceiling = function (x) love.graphics.setColor(2,2,2) end,
    regMapSize = 25,
    rooms = 4,
    door      = 7,
    wall1     = 8,
    wall2     = 9,
    obstacle  = 10,
    uDoor     = 11,
    boss      = 12,
    minEnemy  = 3,
    maxEnemy  = 3
}

levelThree = {
    introText = "St. Nick's Office",
    floor = function (x) love.graphics.setColor(20,20,20) end,
    ceiling = function (x) love.graphics.setColor(2,2,2) end,
    regMapSize = 25,
    rooms = 4,
    door      = 7,
    wall1     = 8,
    wall2     = 9,
    obstacle  = 10,
    uDoor     = 11,
    boss      = 12,
    minEnemy  = 1,
    maxEnemy  = 3
}
table.insert(LEVELS,levelOne)
table.insert(LEVELS,levelTwo)
table.insert(LEVELS,levelThree)




spriteBatch = 0
selectedWall = 0
windowWidth = love.graphics.getWidth() 
windowHeight = love.graphics.getHeight()
screenScale = 0.5
screenWidth = windowWidth / screenScale
screenHeight = windowHeight / screenScale

lastGameCycleTime = 0 
gameCycleDelay = 1000 / 60 -- 60 fps for game logic

do  
    local fov = 60 * math.pi / 180
    fovHalf = fov/2
end

viewDist = (screenWidth/2) / math.tan(fovHalf)
numRays = math.ceil(screenWidth)
displayDebug = true
twoPI = 2 * math.pi

distanceFromWalls = 0.6 
