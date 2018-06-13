local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- Defines variables for scope
local clueText
local pickerWheel
local enterButton
local clueAnswer
local columnData = {}

-- When submit button pressed
local function handleButtonEvent(event)
    if(event.phase == "ended") then
        -- Gets the values user chose from picker wheel, and stores them in a single string
        local values = pickerWheel:getValues()
        local inputList = ""
        for i = 1, #values do
            inputList = inputList .. values[i].value
        end

        -- If user's guess is the same as the answer, returns to controller scene to iterate to next clue, else prints guess and answer for bugtest
        if(inputList:lower() == clueAnswer) then
            composer.gotoScene("controller")
        else
            print(inputList .. " and " .. clueAnswer)
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

    -- Creates the question text at top of screen
    clueText = display.newText({
        text = "Receiving clue",                -- Placeholder text
        x = display.contentCenterX,
        y = display.contentCenterY - 200,
        width = 256,
        font = native.systemFont,   
        fontSize = 18,
        align = "center"
    })
    sceneGroup:insert(clueText)

    -- Creates the submit button
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

    --[[pickerWheel = widget.newPickerWheel({
        x = display.contentCenterX, 
        y = display.contentCenterY + 200,
        style = "resizable",
        width = 240,
        rowHeight = 24,
        fontSize = 14,
        columns = {}{
            {
            align = "center",
            width = 80,
            labelPadding = 10,
            startIndex = 1,
            labels = { "S", "M", "L", "XL", "XXL" }
            },{
            align = "center",
            width = 80,
            labelPadding = 10,
            startIndex = 1,
            labels = { "S", "M", "L", "XL", "XXL" }
            },{
            align = "center",
            width = 80,
            labelPadding = 10,
            startIndex = 1,
            labels = { "S", "M", "L", "XL", "XXL" }
            }
        }
    })
    sceneGroup:insert(pickerWheel)]]--
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

        -- Sets the question text and unshown clue answer to parameters passed by controller
        clueText.text = event.params[2]
        clueAnswer = event.params[3]

        -- For every picker wheel column (all passed parameters except 3)
        for i = 1, #event.params - 3 do
            -- Column data for that column is set as passed parameters or default displays
            columnData[i] = {
                align = "center",                   -- Centrally aligned
                width = 240 / (#event.params - 3),  -- Width is set width divided by number of columns
                labelPadding = 10,                  -- Set label padding
                startIndex = 1,                     -- Default label selected is first in order
                labels = event.params[i+3]          -- Labels are the passed parameter
            }
        end

        -- Creates the picker wheel using column data created
        pickerWheel = widget.newPickerWheel({
            x = display.contentCenterX, 
            y = display.contentCenterY - 100,
            style = "resizable",
            width = 240,
            rowHeight = 24,
            fontSize = 14,
            columns = columnData
        })
        sceneGroup:insert(pickerWheel)

 
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

        -- Deletes picker wheel and clears column data
        if(pickerWheel) then
            pickerWheel = nil
        end
        if(columnData) then
            columnData = {}
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