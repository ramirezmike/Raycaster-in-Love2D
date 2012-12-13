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
    drawHearts()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(hudImg,0,375,0)   
    love.graphics.setFont(mainFont)
    love.graphics.print(getDirectionInString(), 142, 432)
end

function drawHearts()
    love.graphics.setColor(255,0,0,255)
    for i=0, player.health,0.5 do
        love.graphics.rectangle("fill",218+(i*25),455,25,22)
    end
end

function loadHud()
    hudImg = love.graphics.newImage("hud.png")
    mainFont = love.graphics.newFont(35)
end
