local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--[[
Have progress/segments along top of screen for each multichoice question
Can move left or right along question by swiping
Can switch to specific question by tapping progress/segments
Final segment has submit button
Each question is either multi choice or combination
Selected buttons change colour scheme
Multichoice can only select one button, and switch between choices
Combination can select any number of buttons
Need every question correct to complete
Possibly add option to show user which questions they've got wrong

Create rectangle over screen or use runtime. Xstart and x to see if swipe left/right
transition.to bring next/chosen question over to screen
]]

-- Define vars for scope
local questionTexts = {}
local questionButtons = {}
--[[local testObj = display.newRect(display.contentCenterX, display.contentCenterY, 75, 75)
local testObjSec = display.newRect(display.contentCenterX + display.actualContentWidth, display.contentCenterY, 75, 75)
testObj:setFillColor(1,0,0)
local objGroup = display.newGroup()
objGroup:insert(testObj)
objGroup:insert(testObjSec)]]
local objGroup = display.newGroup()
local tempX
local isButtonPressed = {}
local enterButton
local answerKey = {}
local questionWidget
local questionSegments = {}
local buttonTexts = {}

local function enterButtonEvent(event)
    if(event.phase == "ended") then
        local check = true
        for k,v in pairs(isButtonPressed) do
            if(v ~= answerKey[k]) then
                check = false
            end
            --print("KEY: "..k.." | ".."VALUE: "..tostring(v).." vs: "..tostring(answerKey[k]))
        end
        if(check == true) then
            composer.gotoScene("controller")
        else
            print("aww")
        end
    end
end
--[[local function screenTouch()
    print("test")
end]]

local function swipeEventHandler(event)
    if(event.phase == "began") then
        tempX = objGroup.x
    elseif(event.phase == "moved") then
        objGroup.x = event.x - event.xStart + tempX
    elseif(event.phase == "ended" or event.phase == "ended") then
        --print(objGroup.x .. "<<")
        --print(objGroup.x - ((objGroup.x+display.actualContentWidth/2)%(display.actualContentWidth) - display.actualContentWidth/2))
        --objGroup.x = objGroup.x - ((objGroup.x+display.actualContentWidth/2)%(display.actualContentWidth) - display.actualContentWidth/2)
        local moveX = objGroup.x - ((objGroup.x+display.actualContentWidth/2)%(display.actualContentWidth) - display.actualContentWidth/2)
        if(moveX > 0) then
            moveX = 0
        elseif(moveX < -display.actualContentWidth * (#questionTexts-1)) then
            moveX = -display.actualContentWidth * (#questionTexts-1)
        end
        transition.to(objGroup, {
            x = moveX,
            time = 200
        })
        questionWidget:setActiveSegment((moveX/-320)+1)
    end
end

local function onSegmentPress(event)
    transition.to(objGroup, {
        x = -(event.target.segmentNumber-1) * display.actualContentWidth,
        time = 200
    })
end

local function handleButtonEvent(event)
    if(event.phase == "ended") then
        if(string.find(event.target.id, "multi") ~= nil) then
            for k,v in pairs(isButtonPressed) do
                if(string.starts(k, string.sub(event.target.id, 1, string.find(event.target.id, "i"))) and k ~= event.target.id) then
                    isButtonPressed[k] = false
                    questionButtons[k]:setFillColor(0.5,0,0)
                end
            end
        end
        if(isButtonPressed[event.target.id]) then
            isButtonPressed[event.target.id] = false
            event.target:setFillColor(0.5,0,0)
        else
            isButtonPressed[event.target.id] = true
            event.target:setFillColor(1,1,1)
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

    --[[screenButton = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    screenButton.alpha = 0
    screenButton.isHitTestable = true
    sceneGroup:insert(screenButton)
    screenButton:toFront()
    screenButton:addEventListener("touch", screenTouch)]]

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

        Runtime:addEventListener("touch", swipeEventHandler)

        for i = 1, #event.params -1 do -- For every question in clue (-1 for clue type identifier)
            questionTexts[i] = display.newText({
                text = event.params[i+1][2],
                x = display.contentCenterX + display.actualContentWidth*(i-1),
                y = display.contentCenterY - 200,
                width = 256,
                font = native.systemFont,   
                fontSize = 18,
                align = "center"
            })
            sceneGroup:insert(questionTexts[i])
            objGroup:insert(questionTexts[i])
            questionSegments[i] = tostring(i)

            for j = 1, #event.params[i+1] -2 do
                questionButtons[i .. event.params[i+1][1] ..j] = widget.newButton({  
                    id = i .. event.params[i+1][1] ..j,      
                    --label = event.params[i+1][j+2][1],
                    onEvent = handleButtonEvent,
                    emboss = false,
                    labelAlign = "center",
                    --fontSize = 10,
                    -- Properties for a rounded rectangle button
                    shape = "roundedRect",
                    x = display.contentCenterX + ((i-1) * display.actualContentWidth) + 100 * ((j-1)%3) - 100,
                    y = display.contentCenterY + (((j-1) - (j-1)%3)/3)*100 - 100,
                    width = 75,
                    height = 75,
                    cornerRadius = 2,
                    fillColor = { default={0.5,0,0,1}, over={1,0.1,0.7,0.4} },
                    strokeColor = { default={0,0.4,1,1}, over={0.8,0.8,1,1} },
                    strokeWidth = 4
                })
                isButtonPressed[i .. event.params[i+1][1] ..j] = false
                answerKey[i .. event.params[i+1][1] ..j] = event.params[i+1][j+2][2]
                sceneGroup:insert(questionButtons[i .. event.params[i+1][1] ..j])
                objGroup:insert(questionButtons[i .. event.params[i+1][1] ..j])

                buttonTexts[i .. event.params[i+1][1] ..j] = display.newText({
                    text = event.params[i+1][j+2][1],
                    x = display.contentCenterX + ((i-1) * display.actualContentWidth) + 100 * ((j-1)%3) - 100,
                    y = display.contentCenterY + (((j-1) - (j-1)%3)/3)*100 - 100,
                    width = 70,
                    height = 70,
                    align = "center",
                    font = native.systemFont,
                    fontSize = 14
                })
                sceneGroup:insert(buttonTexts[i .. event.params[i+1][1] ..j])
                objGroup:insert(buttonTexts[i .. event.params[i+1][1] ..j])
                buttonTexts[i .. event.params[i+1][1] ..j]:setFillColor(0,0,0)

                print(string.len(event.params[i+1][j+2][1]))
                

            end
        end

        objGroup.x = 0
        questionWidget = widget.newSegmentedControl({
            x = display.contentCenterX,
            y = display.contentCenterY - 250,
            segments = questionSegments,
            onPress = onSegmentPress
        })
 
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

        Runtime:removeEventListener("touch", swipeEventHandler)

        for i = 1, #questionTexts do
            questionTexts[i]:removeSelf()
            questionTexts[i] = nil
        end
        questionTexts = {}

        isButtonPressed = {}
        answerKey = {}
        questionSegments = {}
        questionWidget:removeSelf()
        questionWidget = nil

        for k,v in pairs(questionButtons) do
            questionButtons[k]:removeSelf()
            questionButtons[k] = nil
            buttonTexts[k]:removeSelf()
            questionButtons[k] = nil
            --isButtonPressed[k] = nil
            --answerKey[k] = nil
        end
 
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