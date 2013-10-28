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
-- ***  Level1  ***
------------------------------------

----Move a character within the screen bounds----
--UI area contained at the bottom of the screen.
--UI consists of four arrows to move character.
--Show a menu button that allows to return to the main screen.

------------------------------------------------
-- *** SETUP ***
------------------------------------------------
--Setup storyboard
local storyboard = require("storyboard")
local scene = storyboard.newScene()
--sounds/tapsound--Set up some of the sounds we want to use....
local tapChannel, tapSound

--Variables etc we need
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight
--button variables
local buttonHome, buttonUp, buttonDown, buttonLeft, buttonRight
local btnWidth, btnHeight, btnAlpha = 80, 60, 0.01
--UFO and movement variables
local ufo
local moveTimerVertical, moveTimerHorizontal
local moveSpeed = 10
--Boundary variables, prevent ufo moving into UI area
local bottomOffset = 97

------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	print( "level1: createScene event")
	local screenGroup = self.view

	--Load sound.
	tapSound = audio.loadSound("sounds/tapsound.wav")

	------------------------------------------------
	-- *** Create the background ***
	------------------------------------------------
	--Background image
	local bgUFO = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene2_ufo" ) )
	bgUFO.x = _W * 0.5; bgUFO.y = _H * 0.5
	screenGroup:insert( bgUFO )
	
	
	------------------------------------------------
	-- *** Create move functions ***
	------------------------------------------------
	local moveVertical = function ()
		--check direction
		if ( ufo.vertDir == "up" ) then
			--check boundary
			if ( ufo.y <= 0 + ufo.halfHeight ) then
				ufo.y = ufo.halfHeight
			else ufo:translate( 0, -moveSpeed )
			end --end if boundary
		
		else --move down
			--check boundary
			if ( ufo.y >= _H - ufo.halfHeight - bottomOffset) then
				ufo.y = _H - ufo.halfHeight - bottomOffset
			else ufo:translate( 0, moveSpeed )
			end --end if boundary
		end --end if ufo.vertDir

	end --end moveVertical function

	local moveHorizontal = function ()
		--check direction
		if ( ufo.horizDir == "left" ) then
			--check boundary
			if ( ufo.x <= 0 + ufo.halfWidth ) then
				ufo.x = ufo.halfWidth
			else ufo:translate( -moveSpeed, 0 )
			end --end if boundary
			
		else --move right
			--check boundary
			if ( ufo.x >= _W - ufo.halfWidth ) then
				ufo.x = _W - ufo.halfWidth
			else ufo:translate( moveSpeed, 0 )
			end --end if boundary
		end --end if dir

	end --end moveHorizontal function
	
	------------------------------------------------
	-- *** Create the buttons and handlers ***
	------------------------------------------------
	--Button touch event handler
	local function buttonTouched(event)
		--create event.target reference
		local target = event.target
		-- move vertical button handler
		if (target.id == "moveVertical") then
			--check phase of touch event
			if ( event.phase == "began" ) then
				--print("Move vertical: move "..target.dir.." began")
				--set focus
				display.getCurrentStage():setFocus( target, event.id)
				target.isFocus = true
				--cancel existing Vertical movement timer
				if moveTimerVertical then 
					--print("moveTimerVertical "..target.dir.."cancelled")
					timer.cancel( moveTimerVertical ); 
					moveTimerVertical = nil; 
				end
				--set ufo direction
				ufo.vertDir = target.dir
				--start movement
				--print("moveTimerVertical: "..target.dir.." began")
				moveTimerVertical = timer.performWithDelay( 10, moveVertical, 0)
			
			elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
				--print("Move vertical: move phase ended")
				--remove focus
				display.getCurrentStage():setFocus( target, nil )
				target.isFocus = false;
				--cancel timers
				if moveTimerVertical then 
					--print("moveTimerVertical "..target.dir.."cancelled")
					timer.cancel( moveTimerVertical ); 
					moveTimerVertical = nil; 
				end
			end --end phase if

		-- move Horizontal button handler
		elseif (target.id == "moveHorizontal") then
			--check phase of touch event
			if ( event.phase == "began" ) then
				--print("Move horizontal: move "..target.dir.." began")
				--set focus
				display.getCurrentStage():setFocus( target, event.id )
				target.isFocus = true
				--cancel existing Vertical movement timer
				if moveTimerHorizontal then 
					--print("moveTimerHorizontal "..target.dir.."cancelled")
					timer.cancel( moveTimerHorizontal ); 
					moveTimerHorizontal = nil; 
				end
				--set ufo direction
				ufo.horizDir = target.dir
				--start movement
				--print("moveTimerHorziontal: "..target.dir.." began")
				moveTimerHorizontal = timer.performWithDelay( 10, moveHorizontal, 0)
			
			elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
				--print("Move horizontal: move phase ended")
				--remove focus
				display.getCurrentStage():setFocus( target, nil )
				target.isFocus = false;
				--cancel timers
				if moveTimerHorizontal then 
					--print("moveTimerHorizontal: "..target.dir.." cancelled")
					timer.cancel( moveTimerHorizontal ); 
					moveTimerHorizontal = nil; 
				end
			end --end phase if
		
		-- home button handler
		elseif (target.id == "home") then
			print("buttonTouched: HOME")
			--Play the sound
			tapChannel = audio.play( tapSound )
			--go back to level select screen
			storyboard.gotoScene("levelSelect", "slideRight", 400)
		
		end --end id if

		return true --stop event propagation to underlying objects

	end --end buttonTouched
	--need to refactor the buttonTouched() code
	
	--Create move buttons
	--use touch events, as move buttons can remain pressed for time durations
	buttonUp = display.newRect( 0, 225, btnWidth, btnHeight-10 )
	buttonUp.id = "moveVertical"; buttonUp.dir ="up"
	buttonUp.alpha = btnAlpha
	buttonUp:addEventListener( "touch", buttonTouched )
	screenGroup:insert( buttonUp )
	buttonDown = display.newRect( 0, 276, btnWidth, btnHeight-10 )
	buttonDown.id = "moveVertical"; buttonDown.dir ="down"
	buttonDown.alpha = btnAlpha
	buttonDown:addEventListener( "touch", buttonTouched )
	screenGroup:insert( buttonDown )
	buttonLeft = display.newRect( 359, 245, btnWidth-20, btnHeight )
	buttonLeft.id = "moveHorizontal"; buttonLeft.dir ="left"
	buttonLeft.alpha = btnAlpha
	buttonLeft:addEventListener( "touch", buttonTouched )
	screenGroup:insert( buttonLeft )
	buttonRight = display.newRect( 420, 245, btnWidth-20, btnHeight )
	buttonRight.id = "moveHorizontal"; buttonRight.dir ="right"
	buttonRight.alpha = btnAlpha
	buttonRight:addEventListener( "touch", buttonTouched )
	screenGroup:insert( buttonRight )
	--Create home button
	--use tap event, simpler
	buttonHome = display.newRect( 0, 0, btnWidth, btnHeight )
	buttonHome.id ="home"; buttonHome.alpha = btnAlpha
	buttonHome:addEventListener( "tap", buttonTouched )
	screenGroup:insert( buttonHome )
	
	------------------------------------------------
	-- *** Create the UFO ***
	------------------------------------------------
	ufo = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("ufo") )
	ufo.x = _W/2; ufo.y = _H/2 - 50;
	ufo.halfHeight = 28; ufo.halfWidth = 52;
	screenGroup:insert(ufo);

end --end createScene


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "level1: enterScene event" )
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "level1: exitScene event" )
	--cancel all timers
	for key,value in pairs(timer._runlist) do 
		timer.cancel( value )
	end
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "level1: destroying view" )
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