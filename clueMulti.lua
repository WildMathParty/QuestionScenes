local composer = require( "composer" )
 
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

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        for i = 1, #event.params -1 do -- For every question in clue (-1 for clue type identifier)
            questionTexts[i] = display.newText({
                text = event.params[i+1][2],
                x = display.contentCenterX,
                y = display.contentCenterY - 200,
                width = 256,
                font = native.systemFont,   
                fontSize = 18,
                align = "center"
            })
            sceneGroup:insert(questionTexts[i])
        end
 
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

        for i = 1, #questionTexts do
            questionTexts[i]:removeSelf()
            questionTexts[i] = nil
        end
        questionTexts = {}
 
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