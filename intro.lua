introDelay = 0
introScreen = 1
creditsDisplaying = false 

INTRO_TEXT = {
    [1] = "'Santa Claus isn't real.'", 
    [2] = 4,
    [3] = "That's what they say.",
    [4] = 2,
    [5] = "A lie to do his work",
    [6] = 2,
    [7] = "while he profits from his royalties.",
    [8] = 3,
    [9] = "He's a Greedy St. Nick.",
    [10] = 3
}

CREDIT_TEXT = {
    [1] = "You Win!", 
    [2] = 3,
    [3] = "Santa has been defeated!",
    [4] = 3,
    [5] = "yay..",
    [6] = 3,
    [7] = "Programmer: Michael Ramirez",
    [8] = 3,
    [9] = "Music & SFX: Michael Ramirez (except reversed Sugar Plum Fairy track)",
    [10] = 4,
    [11] = "(Programmer) Art: Michael Ramirez (except for Nutcracker, Jack and 12 Days sprites)",
    [12] = 4,
    [13] = "Special thanks to my girlfriend, Krystal! Thanks for being patient!",
    [14] = 4,
    [15] = "Thanks for playing my game! :D",
    [16] = 3
}

function drawIntro()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",0,0,screenWidth,screenHeight)
    love.graphics.setColor(255,255,255)
    if (creditsDisplaying) then
        love.graphics.printf(CREDIT_TEXT[introScreen],0,screenHeight/2,screenWidth,'center') 
    else
        love.graphics.printf(INTRO_TEXT[introScreen],0,screenHeight/2,screenWidth,'center') 
    end
end

function introManagement(dt)
    if (creditsDisplaying) then
        introDelay = introDelay + dt
        if (introDelay > CREDIT_TEXT[introScreen+1]) then
            introDelay = 0
            introScreen = introScreen + 2
        end
        if (introScreen > #CREDIT_TEXT) then
            introDisplaying = false
            creditsDisplaying = false
            return
        end
    else
        introDelay = introDelay + dt
        if (introDelay > INTRO_TEXT[introScreen+1]) then
            introDelay = 0
            introScreen = introScreen + 2
        end
        if (introScreen > #INTRO_TEXT) then
            introDisplaying = false
            return
        end
    end
end

function setupCredits()
    introDisplaying = true
    creditsDisplaying = true
    introDelay = 0
    introScreen = 1
    restartGame()
end
