introDelay = 0
introScreen = 1
INTRO_TEXT = {
    [1] = "This is a test", 
    [2] = 2,
    [3] = "This is another test",
    [4] = 4
}

function drawIntro()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,screenWidth,screenHeight)
    love.graphics.setColor(255,255,255)
    love.graphics.print(INTRO_TEXT[introScreen],screenWidth/2,screenHeight/2) 
end

function introManagement(dt)
    introDelay = introDelay + dt
    print (introDelay)
    if (introDelay > INTRO_TEXT[introScreen+1]) then
        introDelay = 0
        introScreen = introScreen + 2
    end
    if (introScreen > #INTRO_TEXT) then
        introDisplaying = false
        return
    end
end

