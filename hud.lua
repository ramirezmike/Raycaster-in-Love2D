function getDirectionInString()
    local compass = ""
    if (player.rot < ((3*3.14)/4) and player.rot > (3.14/4)) then
        compass = "S"
    end
    if (player.rot > ((5*3.14)/4) and player.rot < ((7*3.14)/4)) then
        compass = "N"
    end
    if (player.rot < ((5*3.14)/4) and player.rot > ((3*3.14)/4)) then
        compass = "W"
    end
    if (player.rot > ((7*3.14)/4) or player.rot < ((3.14)/4)) then
        compass = "E"
    end
    return compass
end

function drawHud()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(hudImg,0,375,0)   
    drawHearts()
    love.graphics.setFont(mainFont)
    love.graphics.print(getDirectionInString(), 142, 432)
end

function drawHearts()
    for i=0, player.health do
        love.graphics.draw(heartImg,220+(i*25),455,0)   
    end
end

function loadHud()
    hudImg = love.graphics.newImage("hud.png")
    heartImg = love.graphics.newImage("heart.png")
    mainFont = love.graphics.newFont(35)
end
