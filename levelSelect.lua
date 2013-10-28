-------------------------------------------------------------------------
--MiniGames
--murmic productions
--Created by Micheal Murray

--LinkedIn  http://lnkd.in/S3zgtF
--Behance   http://www.behance.net/mickmur

--This game is developed to meet the assignment brief as outlined in 'assignment_brief.txt'

--CoronaSDK version 2013.1202 was used to build the minigames.apk
--The minigames.apk has only been tested on a Nexus 4 device

--The insect character sprite is taken from the Platformer Storyboard template provided by
--T and G Apps Ltd., Created by Jamie Trinder
--www.tandgapps.co.uk

--All other artwork and design was created by Micheal Murray

--All sound effects are from soundbible.com
-------------------------------------------------------------------------

------------------------------------
-- ***  Level Select  ***
------------------------------------

----Provide access to the three minigames----

------------------------------------------------
-- *** SETUP ***
------------------------------------------------

--Setup storyboard and create a scene.
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


--Variables etc we need
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight 
local button = {}--array to hold the buttons level select

--Set up some of the sounds we want to use....
local tapChannel, tapSound


------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	print( "levelSelect: createScene event")
	local screenGroup = self.view

	--Load sound.
	tapSound = audio.loadSound("sounds/tapsound.wav")


	------------------------------------------------
	-- *** Create the background ***
	------------------------------------------------
	--Background image
	local bgMenu = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene1_menu" ) )
	bgMenu.x = _W * 0.5; bgMenu.y = _H * 0.5
	screenGroup:insert( bgMenu )


	------------------------------------------------
	-- *** Create the level buttons ***
	------------------------------------------------
	--Function to handle level select button clicked
	local function levelTouched( event )
		--Play the sound
		tapChannel = audio.play( tapSound )
		--Now change to the selected level. 
		storyboard.gotoScene( "levels.level"..event.target.id, "slideLeft", 400 )
	end --end levelTouched
	
	--Create the level select buttons 
	--(transparent, sit on top of bgMenu, reactive to user touch)
	for i=1,amountOfLevels do
		button[i] = display.newRect( 0, 0, 120, 100 )
		button[i]:setReferencePoint( display.CenterReferencePoint )
		button[i].x = ( 120 * i ) + i; button[i].y = 130
		button[i].alpha = 0.01
		button[i].id = i; --used to identify which level should be loaded
		button[i]:addEventListener( "tap", levelTouched )
		screenGroup:insert( button[i] )
	end --end for
	
end --end createScene


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "levelSelect: enterScene event" )

	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "levelSelect: exitScene event" )
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "levelSelect: destroying view" )
	audio.dispose( tapSound ); tapSound = nil;
end


-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


--Return the scene to storyboard.
return scene