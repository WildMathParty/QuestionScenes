local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- TODO: ~~~Move input box so that can still read over keyboard
--       ~~~Have feedback on jigsaw so can tell what first tap is
--       Add more clue types - multi choice, memory
--       ~~~Have winning message at end

-- clueNum is the current clue number the player is on. Used to get next clue on iteration and to finish hunt when above number of clues
local clueNum

-- Table contains all the clues in current hunt. Placeholder for database. Edit this to change clues
local clueTable = {
    {"clueMulti", {"multi", "test1"}, {"combi", "test2"} },  
    {"clueString", "What famous Japanese character did Domino's Pizza collaberate with?", "hatsune miku"},
    {"cluePicker", "What year did this collaberation take place?", "2013", {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}},
    {"clueJigsaw", "Images/hatsune.jpg", 5, 2, 269, 493},
    {"clueString", "What song did Hatsune Miku perform on the pizza box?", "luv4night"},
    {"cluePicker", "From the menu to the order, it looks very ...", "cute", {"s", "c", "q", "i", "n"}, {"f", "a", "l", "m", "u"}, {"p", "r", "z", "t", "y"}, {"e", "o", "b", "d", "x"}},
    {"clueJigsaw", "Images/miku.jpg", 4, 3, 907, 720}--[[
    {"clueString", "What is the capital of New Zealand?", "wellington"},
    {"cluePicker", "What year was the Treaty of Waitangi signes?", "1840", {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}, {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}},
    {"clueJigsaw", "Images/beehive.jpg", 3, 3, 694, 491},
    {"clueString", "Who discovered New Zealand?", "abel tasman"},
    {"cluePicker", "What is New Zealand's national bird?", "kiwi", {"s", "b", "k", "i", "n"}, {"i", "t", "l", "m", "u"}, {"p", "r", "w", "a", "y"}, {"e", "o", "c", "d", "i"}},
    {"clueJigsaw", "Images/tui.jpg", 4, 3, 800, 533}]]
}
--[[        CLUE FORMAT
simple string question, string answer
{"clueString", "The question asked", "the answer in lowercase"}

string question, combination lock-like answer. Can be numbers for code or letters to spell word, but both must be strings
{"cluePicker", "The question asked", "the answer", {"option 1.1", "1.2", "1.3", "1.4", "1.5"}, {"2.1" ..} ..}

jigsaw question, takes picture and cuts it into specified x and y pieces, then scrambles them. User switches pieces to get full image and submits
{"clueJigsaw", "Image file location", x pieces, y pieces, x pixels, y pixels}
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