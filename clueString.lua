local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- Defines variables for scope
local clueText
local inputBox
local enterButton
local clueAnswer

-- When submit button pressed 
local function handleButtonEvent(event)
    if(event.phase == "ended") then
        -- Checks if user's entered guess is same as clue answer
        if(inputBox.text:lower() == clueAnswer) then
            -- If so, removes keyboard and returns to controller scene to iterate to next clue
            native.setKeyboardFocus(nil)
            composer.gotoScene("controller")
        else
            -- Else prints to console both user's guess and correct answer for bugtesting
            print(inputBox.text:lower() .. " and " .. clueAnswer)
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

    -- Creates text at top of screen which displays the question
    clueText = display.newText({
        text = "Receiving clue",            -- Placeholder text
        x = display.contentCenterX,
        y = display.contentCenterY - 200,
        width = 256,
        font = native.systemFont,   
        fontSize = 18,
        align = "center"
    })
    sceneGroup:insert(clueText)

    -- Creates the submit button to check user guess
    enterButton = widget.newButton({        
        label = "SUBMIT",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        x = display.contentCenterX,
        y = display.contentCenterY + 20,
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

        -- Changes the question text and the unshown clue answer based on passed parameters from controller
        clueText.text = event.params[2]
        clueAnswer = event.params[3]

        -- Creates the text field user types guess into. In show not create as native objects can't be hidden
        inputBox = native.newTextField(display.contentCenterX, display.contentCenterY - 100, 256, 64)
 
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

        -- Removes the text field if it exists
        if(inputBox) then
            inputBox:removeSelf()
            inputBox = nil
        end
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
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