local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- Declare vars for scope
local backdrop
local titleText
local bodyText
local screenButton

local function screenTap()
    composer.hideOverlay("zoomOutIn", 400)
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Creates backdrop to read text over
    backdrop = display.newRect(display.contentCenterX, display.contentCenterY, 300, 200)
    backdrop:setFillColor(0.1,0.1,0.1,1)
    sceneGroup:insert(backdrop)

    -- Creates the title and body texts with placeholder text
    titleText = display.newText({
        text = "Title",                
        x = display.contentCenterX,
        y = display.contentCenterY - 70,
        width = 256,
        font = native.systemFont,   
        fontSize = 24,
        align = "center"
    })
    sceneGroup:insert(titleText)

    bodyText = display.newText({
        text = "Body",                
        x = display.contentCenterX,
        y = display.contentCenterY + 30,
        width = 256,
        font = native.systemFont,   
        fontSize = 18,
        align = "center"
    })
    sceneGroup:insert(bodyText)

    -- Listen across whole scene for tap event
    screenButton = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    screenButton.alpha = 0
    screenButton.isHitTestable = true
    sceneGroup:insert(screenButton)
    screenButton:addEventListener("tap", screenTap)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        titleText.text = event.params[1]
        bodyText.text = event.params[2]
 
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