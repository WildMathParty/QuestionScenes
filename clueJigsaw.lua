local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- Defines variables for scope
local mask
local jigsawImage
local xPieces
local yPieces
local jigsawPieces = {}
local jigsawFinished = {}
local picX
local picY
local firstPress

-- when submit button pressed
local enterButton
local function enterButtonEvent(event)
    if(event.phase == "ended") then
        -- When pressed, creates a check set to true, and iterates through every jigsaw piece. 
        -- If the x and y origins (unique for each piece) are different to the correct ordered versions, check changed to false 
        local check = true
        for i = 1, xPieces do
            for j = 1, yPieces do
                if(jigsawFinished[i][j] ~= jigsawPieces[i][j].anchorX .. " " .. jigsawPieces[i][j].anchorY) then
                    print(jigsawPieces[i][j].anchorX .. " " .. jigsawPieces[i][j].anchorY)
                    check = false
                end
            end
        end
        -- If check is still true, all pieces must be correct, so returns to controller scene to iterate to next clue
        if(check == true) then
            composer.gotoScene("controller")
        end
    end
end

-- When how to play button pressed
local howToPlayButton
local function howToPlayButtonEvent(event)
    if(event.phase == "ended") then
        --Overlay composer scene
    end
end

-- Creates the swap jigsaw pieces function. Takes two pairs of keys and values for jigsaw piece table
local function swapPieces(firstRandX, firstRandY, secondRandX, secondRandY)
    -- Both jigsaw pieces, and their x and y, saved to seperate variables
    local firstItem = jigsawPieces[firstRandX][firstRandY]
    local firstX = firstItem.x
    local firstY = firstItem.y

    local secondItem = jigsawPieces[secondRandX][secondRandY]
    local secondX = secondItem.x
    local secondY = secondItem.y

    -- Swaps those variables around, thus switching the pieces
    jigsawPieces[firstRandX][firstRandY] = secondItem
    jigsawPieces[firstRandX][firstRandY].x = firstX
    jigsawPieces[firstRandX][firstRandY].y = firstY

    jigsawPieces[secondRandX][secondRandY] = firstItem
    jigsawPieces[secondRandX][secondRandY].x = secondX
    jigsawPieces[secondRandX][secondRandY].y = secondY
end

-- Creates the function on tapping a jigsaw piece
local function touchPiece(event)
    if(event.phase == "ended") then
        -- If there is no previously tapped piece
        if(firstPress ~= nil) then
            -- Define vars for scope
            local firstRandX
            local firstRandY
            local secondRandX
            local secondRandY

            -- For every row in the jigsaw
            for i = 1, #jigsawPieces do
                -- If the previously tapped piece or tapped piece exists there, saves it's keys and values
                if(table.indexOf(jigsawPieces[i], firstPress)) ~= nil then
                    firstRandX = i
                    firstRandY = table.indexOf(jigsawPieces[i], firstPress)
                end
                if(table.indexOf(jigsawPieces[i], event.target)) ~= nil then
                    secondRandX = i
                    secondRandY = table.indexOf(jigsawPieces[i], event.target)
                end
            end
            -- Runs swap piece function on those pieces using their keys and values, then resets previously tapped piece
            swapPieces(firstRandX, firstRandY, secondRandX, secondRandY)
            firstPress = nil
        else
            -- Set this as the previously tapped piece
            firstPress = event.target
        end
    end
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Creates mask from image in folder of 104*104 png of 4 pixel black border and 100 pixel white square
    mask = graphics.newMask("Images/maskHundred.png")

    -- Creates how to play button
    howToPlayButton = widget.newButton({        
        label = "?",                        -- Question mark label so button can be small
        onEvent = howToPlayButtonEvent,
        emboss = false,
        -- Properties for a circle button
        shape = "circle",
        left = 20,
        top = -20,
        radius = 12,
        cornerRadius = 2,
        fillColor = { default={0.5,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={0,0.4,1,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })
    sceneGroup:insert(howToPlayButton)

    -- Creates submit button
    enterButton = widget.newButton({        
        label = "SUBMIT",
        onEvent = enterButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        x = display.contentCenterX,
        y = display.contentCenterY + 180,
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={0.5,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={0,0.4,1,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    })
    sceneGroup:insert(enterButton)
    
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

        -- Sets variables as passed parameters
        jigsawImage = event.params[2]                                           -- Image used for jigsaw
        xPieces = event.params[3]                                               -- Number of pieces across
        yPieces = event.params[4]                                               -- Number of pieces down
        picX = event.params[5]/(event.params[5]/display.actualContentWidth)     -- Jigsaw width in pixels
        picY = event.params[6]/(event.params[5]/display.actualContentWidth)     -- Jigsaw height in pixels
        -- Pixel width and height calculated by dividing picture width by screen width

        -- For every piece across
        for i = 1, xPieces do
            -- Creates a table with table for that row in jigsaw table and completed jigsaw table
            jigsawPieces[i] = {}
            jigsawFinished[i] = {}

            -- For every piece down
            for j = 1, yPieces do
                -- Curpiece just faster to type, is currently iterated piece. Creates the full image with the set width/height
                local curPiece
                curPiece = display.newImageRect(jigsawImage, picX, picY)
                
                -- Applies the 100*100 mask. Scales width and height by (image size/number of pieces)/mask size
                -- Locates mask x and y by (-(image size/2) + imagesize/(number of pieces*2)) + (image size/number of pieces)*(current piece number)
                -- Complex calculation just centers the mask on the current piece's x and y in relation to jigsaw piece size
                curPiece:setMask(mask)                                                  
                curPiece.maskScaleX = (picX/xPieces)/100                               
                curPiece.maskScaleY = (picY/yPieces)/100
                curPiece.maskX = (-(picX/2) + picX/(xPieces*2)) + (picX/xPieces)*(i-1)
                curPiece.maskY = (-(picY/2) + picY/(yPieces*2)) + (picY/yPieces)*(j-1)

                -- Sets anchor to the same point that mask is centred (mask is in pixels, anchor is in percentage of picture)
                -- Sets x and y to offset the new centre point
                curPiece.anchorX = (curPiece.maskX + picX/2)/picX
                curPiece.anchorY = (curPiece.maskY + picY/2)/picY
                curPiece.x = curPiece.maskX + display.contentCenterX
                curPiece.y = curPiece.maskY + display.contentCenterY
                sceneGroup:insert(curPiece)

                -- Adds touch listener to all pieces, adds the piece to the jigsaw table at key and value location
                -- Adds anchor points to finished table at same location. Unique anchor points for all pieces, so used to check if jigsaw correctly solved
                curPiece:addEventListener("touch", touchPiece)
                jigsawPieces[i][j] = curPiece
                jigsawFinished[i][j] = curPiece.anchorX .. " " .. curPiece.anchorY
            end
        end

        -- Swaps two random pieces, (number of pieces * 2) times
        for i = 1, (xPieces*yPieces)*2 do
            local firstRandX = math.random(xPieces)
            local firstRandY = math.random(yPieces)
            local secondRandX = math.random(xPieces)
            local secondRandY = math.random(yPieces)
            swapPieces(firstRandX, firstRandY, secondRandX, secondRandY)
        end

        --[[for i = 1, #jigsawPieces do
            for j = 1, #jigsawPieces[i] do
                table.insert(jigsawScramble, jigsawPieces[i][j])
            end
        end

        for i = 1, #jigsawPieces do
            for j = 1, #jigsawPieces[i] do
                local ranItem = jigsawScramble[math.random(#jigsawScramble)]
                local oldX = jigsawPieces[i][j].x
                local oldY = jigsawPieces[i][j].y

                jigsawPieces[i][j] = ranItem
                jigsawPieces[i][j].x = 
                table.remove(ranItem)                
            end
        end]]
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

        -- Clears out the jigsaw piece and completed jigsaw tables
        for i = 1, #jigsawPieces do
            for j = 1, #jigsawPieces[i] do
                jigsawPieces[i][j]:removeSelf()
                jigsawPieces[i][j] = nil
            end
        end
        jigsawPieces = {}
        jigsawFinished = {}
        
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene