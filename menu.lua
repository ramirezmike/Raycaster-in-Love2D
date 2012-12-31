function drawMenu()
    love.graphics.setFont(menuFont)
    love.graphics.draw(p,screenWidth/2,-130)
    love.graphics.draw(q,screenWidth/2,-200)
    love.graphics.setColor(50,50,50,200)
    love.graphics.rectangle("fill", 100,screenHeight/2,screenWidth - 200,screenHeight/2)
    for i,v in ipairs(MENU_BUTTONS) do
        love.graphics.setColor(200,100,100,v["opacity"])
        love.graphics.rectangle("fill", v["x"],v["y"],v["width"],v["height"])
        love.graphics.setColor(200,200,200,255)
        love.graphics.print(v["label"], v["x"]+130,v["y"]+15)
    end
    love.graphics.setFont(titleFont,190)
    love.graphics.setColor(250,150,150)
    love.graphics.print("GREEDY ST. NICK",71,100,0,3,3)
    love.graphics.setFont(menuFont)
end

function drawPauseMenu()
    love.graphics.setFont(menuFont)
    love.graphics.setColor(50,50,50,200)
    love.graphics.rectangle("fill", 100,screenHeight/2,screenWidth - 200,screenHeight/2)
    for i,v in ipairs(MENU_BUTTONS) do
        love.graphics.setColor(200,100,100,v["opacity"])
        love.graphics.rectangle("fill", v["x"],v["y"],v["width"],v["height"])
        love.graphics.setColor(200,200,200,255)
        love.graphics.print(v["label"], v["x"]+130,v["y"]+15)
    end
    love.graphics.print("(be careful) Mouse Sensitivity: " .. player.mouseSpeed, 225,215)
end
function mouseOverButton(pointX,pointY,rectX,rectY,rectWidth,rectHeight)
    return pointX > rectX and pointY > rectY and pointX < rectX + rectWidth and pointY < rectY + rectHeight
end

function addButton(label,func) 
    MENU_BUTTONS[#MENU_BUTTONS + 1] = {
        label = label,
        x = 150,
        y = 300 + (#MENU_BUTTONS * 50),
        width = 340,
        height = 40,
        opacity = 100,
        func = func
    }
end

function loadMainMenu()
    MENU_BUTTONS = {}
    particleTime = 0
    titleFont = love.graphics.newImageFont("titleFont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
    menuFont = love.graphics.newFont()
    addButton("Start Game", function () startGame()end )
    addButton("Quit Game", function () love.event.quit()end )
end

function loadPauseMenu()
    MENU_BUTTONS = {}
    addButton("Resume Game", function () gamePaused = false end)
    addButton("Mouse Sensitivity +", function () player.mouseSpeed = player.mouseSpeed + 0.01 end)
    addButton("Mouse Sensitivity -", function () player.mouseSpeed = player.mouseSpeed - 0.01 end)
    addButton("Quit Game", function () love.event.quit()end )
end

function menuButtonClick(x,y)
    for i, v in ipairs(MENU_BUTTONS) do
        if (mouseOverButton(x,y,v["x"],v["y"],v["width"],v["height"])) then
            v["func"]()
        end
    end
end

function menuButtonHover()
    local x, y = love.mouse.getPosition()
    for i, v in ipairs(MENU_BUTTONS) do
        if (mouseOverButton(x,y,v["x"],v["y"],v["width"],v["height"])) then
            v["opacity"] = 255
        else
            v["opacity"] = 100
        end
    end
end

function particleTimer(dt)
    particleTime = particleTime + dt
    if (particleTime > 10) then
        p:setSprite(cashImg)
    end
end
