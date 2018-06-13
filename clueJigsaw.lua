local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local mask
local jigsawImage
local xPieces
local yPieces
local jigsawPieces = {}
local jigsawFinished = {}
local picX
local picY
local firstPress

local enterButton
local function enterButtonEvent(event)
    if(event.phase == "ended") then
        local check = true
        for i = 1, xPieces do
            for j = 1, yPieces do
                if(jigsawFinished[i][j] ~= jigsawPieces[i][j].anchorX .. " " .. jigsawPieces[i][j].anchorY) then
                    print(jigsawPieces[i][j].anchorX .. " " .. jigsawPieces[i][j].anchorY)
                    check = false
                end
            end
        end
        if(check == true) then
            composer.gotoScene("controller")
        end
    end
end

local howToPlayButton
local function howToPlayButtonEvent(event)
    if(event.phase == "ended") then
        --Overlay composer scene
    end
end

local function swapPieces(firstRandX, firstRandY, secondRandX, secondRandY)
    local firstItem = jigsawPieces[firstRandX][firstRandY]
    local firstX = firstItem.x
    local firstY = firstItem.y

    local secondItem = jigsawPieces[secondRandX][secondRandY]
    local secondX = secondItem.x
    local secondY = secondItem.y

    jigsawPieces[firstRandX][firstRandY] = secondItem
    jigsawPieces[firstRandX][firstRandY].x = firstX
    jigsawPieces[firstRandX][firstRandY].y = firstY

    jigsawPieces[secondRandX][secondRandY] = firstItem
    jigsawPieces[secondRandX][secondRandY].x = secondX
    jigsawPieces[secondRandX][secondRandY].y = secondY
end

local function touchPiece(event)
    if(event.phase == "ended") then
        if(firstPress ~= nil) then
            local firstRandX
            local firstRandY
            local secondRandX
            local secondRandY

            for i = 1, #jigsawPieces do
                if(table.indexOf(jigsawPieces[i], firstPress)) ~= nil then
                    firstRandX = i
                    firstRandY = table.indexOf(jigsawPieces[i], firstPress)
                end
                if(table.indexOf(jigsawPieces[i], event.target)) ~= nil then
                    secondRandX = i
                    secondRandY = table.indexOf(jigsawPieces[i], event.target)
                end
            end
            swapPieces(firstRandX, firstRandY, secondRandX, secondRandY)
            firstPress = nil
        else
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

    mask = graphics.newMask("Images/maskHundred.png")

    howToPlayButton = widget.newButton({        
        label = "?",
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

        jigsawImage = event.params[2]
        xPieces = event.params[3]
        yPieces = event.params[4]
        picX = event.params[5]/(event.params[5]/display.actualContentWidth)
        picY = event.params[6]/(event.params[5]/display.actualContentWidth)

        --event.params[5] / display.actualContentWidth

        for i = 1, xPieces do
            jigsawPieces[i] = {}
            jigsawFinished[i] = {}

            for j = 1, yPieces do
                local curPiece

                curPiece = display.newImageRect(jigsawImage, picX, picY)

                curPiece:setMask(mask)
                curPiece.maskScaleX = (picX/xPieces)/100
                curPiece.maskScaleY = (picY/yPieces)/100
                curPiece.maskX = (-(picX/2) + picX/(xPieces*2)) + (picX/xPieces)*(i-1)
                curPiece.maskY = (-(picY/2) + picY/(yPieces*2)) + (picY/yPieces)*(j-1)

                curPiece.anchorX = (curPiece.maskX + picX/2)/picX
                curPiece.anchorY = (curPiece.maskY + picY/2)/picY
                curPiece.x = curPiece.maskX + display.contentCenterX
                curPiece.y = curPiece.maskY + display.contentCenterY
                sceneGroup:insert(curPiece)

                curPiece:addEventListener("touch", touchPiece)

                jigsawPieces[i][j] = curPiece
                jigsawFinished[i][j] = curPiece.anchorX .. " " .. curPiece.anchorY
            end
        end

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