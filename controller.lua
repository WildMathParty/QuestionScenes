local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- TODO:    Add more clue types - ~~~multi choice, memory
--          Find out what widget to use to show how many multichoice questions in a clue

-- clueNum is the current clue number the player is on. Used to get next clue on iteration and to finish hunt when above number of clues
local clueNum

-- Table contains all the clues in current hunt. Placeholder for database. Edit this to change clues
local clueTable = {
    -- The Knuckles Quiz
    {"clueString", "Sonic the Hedgehog's friend, Knuckles, is what species of anthropomorphic animal?", "echidna"},
    {"cluePicker", "What year was Knuckles' debut game released?", "1994", {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}, {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}, {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}, {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}},
    {"clueJigsaw", "Images/knuckles.png", 2, 4, 600, 600},
    {"clueMulti", {"multi", "Which is Knuckles' signature move?", {"Turn into an enchilada", false}, {"Climb Walls", true}, {"Fly by spinning his tail", false}, {"Run around at the speed of sound", false}}},
    {"clueString", "Who created Knuckles the echidna?", "takashi yuda"},
    {"cluePicker", "Knuckles is, 'rougher than the rest of them. The best of them, tougher than ...' what?", "leather", {"y", "u", "k", "l"}, {"o", "j", "e", "z"}, {"x", "g", "p", "a"}, {"t", "c", "o", "m"}, {"w", "h", "p", "s"}, {"e", "l", "n", "f"}, {"s", "b", "r", "e"}},    
    {"clueJigsaw", "Images/echidna.jpg", 4, 4, 550, 360},
    {"clueMulti", {"combi", "Which of thes games was Knuckles in?", {"Sonic the Hedgehog", false}, {"Sonic the Hedgehog 2", false}, {"Sonic the Hedgehog 3", true}, {"Sonic Blast", true}, {"Sonic Shuffle", true}, {"Sonic Rush", false}, {"Sonic Chronicles", true}, {"Sonic Mania", true}, {"Sonic Unleashed", false}}}
}

--[[        CLUE FORMAT
simple string question, string answer
{"clueString", "The question asked", "the answer in lowercase"}

string question, combination lock-like answer. Can be numbers for code or letters to spell word, but both must be strings
{"cluePicker", "The question asked", "the answer", {"option 1.1", "1.2", "1.3", "1.4", "1.5"}, {"2.1" ..} ..}

jigsaw question, takes picture and cuts it into specified x and y pieces, then scrambles them. User switches pieces to get full image and submits
{"clueJigsaw", "Image file location", x pieces, y pieces, x pixels, y pixels}

multichoice question, two types: multichoice, single button can be selected and submitted, and combination, any number of buttons. Full question can use multiple of each
{"clueMulti", {"multi/combi", "The question asked", {"Choice text", true/false}, ..}, ..}
multi questions must only have a single true choice and the rest false
]]


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Sets the current clue number to 0
    clueNum = 0
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

        -- Iterates clue number by 1 every time scene is shown, which is when hunt starts and every time a clue is solved
        clueNum = clueNum + 1
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
        -- If clue number is larger than number of clues, resets clue number to 0 and returns to menu
        if(clueNum > #clueTable) then
            clueNum = 0
            composer.gotoScene("menu", {params={[[
Congratulations!
You have completed every clue.
I hope you enjoyed, and you can press below to replay.]]}})
        else
            -- Else goes to the next clue type scene using the clue table and current clue, passing parameters of rest of that clue table field
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