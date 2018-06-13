local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- clueNum is the current clue number the player is on. Used to get next clue on iteration and to finish hunt when above number of clues
local clueNum

-- Table contains all the clues in current hunt. Placeholder for database. Edit this to change clues
local clueTable = {
    {"clueJigsaw", "Images/colourCat.jpg", 4, 3, 960, 682},
    --{"clueJigsaw", "Images/colourDog.jpg", 2, 6, 798, 634},
    --{"cluePicker", "What are the first four numbers?", "1234", {"1", "2", "3", "4", "5"}, {"1", "2", "3", "4", "5"}, {"1", "2", "3", "4", "5"}, {"1", "2", "3", "4", "5"}},
    --{"clueString", "What is the second letter?", "b"}
}
--[[        CLUE FORMAT
simple string question, string answer
{"clueString", "The question asked", "the answer in lowercase"}

string question, combination lock-like answer. Can be numbers for code or letters to spell word, but both must be strings
{"cluePicker", "The question asked", "the answer", {"1.1", "1.2", "1.3", "1.4", "1.5"}, {"1", "2", "3", "4", "5"}, {"1", "2", "3", "4", "5"}, {"1", "2", "3", "4", "5"}}

]]


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    clueNum = 0
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

        clueNum = clueNum + 1
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
        if(clueNum > #clueTable) then
            clueNum = 0
            composer.gotoScene("menu")
        else
            composer.gotoScene(clueTable[clueNum][1], {params = clueTable[clueNum]})
        end
 
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