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
--***  Level3  ***
------------------------------------

----Drop an object on a moving character----
--Tap platforms to remove them.
--Use physics engine to force objects to fall.
--Play audio notifications on game over events.
--Show a menu button that allows to return to the main screen.

------------------------------------------------
-- *** SETUP ***
------------------------------------------------
--Setup storyboard
local storyboard = require("storyboard")
local scene = storyboard.newScene()
--sounds/tapsound--Set up some of the sounds we want to use....
local tapChannel, suspenseChannel,  hitChannel, overChannel
local tapSound, suspenseSound, hitSound, overSound
--Variables etc we need
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight
--button variables
local buttonHome
local btnWidth, btnHeight, btnAlpha = 80, 60, 0.01
local animationAllowed = false
--platforms and objects
local platforms = {}
local objects = {}
local ground, character
local transTimer --timer handle for character movement (transition)
local platformsTapped = 0 --counter 
local gameOver = false --boolean flag

--Enable physics
local physics = require("physics")
physics.start();
--physics.setDrawMode( "hybrid" )

--function to stop the transTimer
local function stopTransTimer() 
	if transTimer then
		transition.cancel(transTimer)
		transTimer = nil
	end
end

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
	--suspenseSound = audio.loadSound("sounds/incomingSuspense.mp3")
	hitSound = audio.loadSound("sounds/evilLaughMale6.mp3")
	overSound = audio.loadSound("sounds/failedAttempt.wav")

	------------------------------------------------
	-- *** Create the background ***
	------------------------------------------------
	--Background image
	local bgDrop = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex( "scene4_drop" ) )
	bgDrop.x = _W * 0.5; bgDrop.y = _H * 0.5
	screenGroup:insert( bgDrop )
	
	
	------------------------------------------------
	-- *** Create the home button and handler ***
	------------------------------------------------
	--Homeutton touch event handler
	local function buttonTouched(event)
		
		print( "buttonTouched: " .. event.target.id )
		-- check if home button
		if (event.target.id == "home") then
			--check phase
			 if (event.phase == "ended") then 
			 	--Play the tap sound
				tapChannel = audio.play( tapSound )
				--flag game as over
				gameOver = true
				--go back to level select screen
				storyboard.gotoScene("levelSelect", "slideRight", 400)
			 end --end phase if
		end --end id if
		
		return true --stop event propagation to underlying objects

	end --end buttonTouched
	
	--Create home button
	--use tap event, simpler
	buttonHome = display.newRect( 0, 0, btnWidth, btnHeight )
	buttonHome.id ="home"; buttonHome.alpha = btnAlpha
	buttonHome:addEventListener( "touch", buttonTouched )
	screenGroup:insert( buttonHome )
	
	------------------------------------------------
	-- *** Create the removePlatform handler ***
	------------------------------------------------
	local function removePlatform(event)
		--create a local handle to the event.target
		local target = event.target
		-- check if a platform was tapped
		if ( target.id == "platform" ) then
			print("Platform tapped")
			--Play the sound
			tapChannel = audio.play( tapSound )
			--remove the platform
			target:removeSelf(); target=nil
			--increment number of platforms tapped
			platformsTapped = platformsTapped + 1 
			--SHOULD MOVE TO COLLISIONS FOR BETTER IMPLEMENTATION
			--Current implementation eg.:
			-- When platforms are tapped quickly, three platforms tapped but only second one hits the ground => game over

		end --end id if
		return true --stop event propagation to underlying objects
	end
	
	------------------------------------------------
	-- *** Create the Platforms, Objects, Ground and Character ***
	------------------------------------------------
	local xOffset, yOffset = 125, 40 --initial positioning of the platforms
	for i=1,3 do
		--create platforms
		platforms[i] = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex( "scene4_platform" ) )
		platforms[i].x = 105 + (i-1)*xOffset
		platforms[i].y = 70 + (i%2)*yOffset --raise middle platform
		platforms[i].id = "platform"
		screenGroup:insert(platforms[i])
		physics.addBody( platforms[i], "static" )
		platforms[i]:addEventListener("tap", removePlatform )
		--create objects
		objects[i] = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex( "scene4_weight" ) )
		objects[i].x = 105 + (i-1)*xOffset
		objects[i].y = 15 + (i%2)*yOffset --raise middle weight
		objects[i].id = "weight"
		screenGroup:insert(objects[i])
		physics.addBody( objects[i], "dynamic", { density=2, bounce=0.0,  friction=0.3, isFixedRotation = true } )
	end
	
	--create ground platform
	ground = display.newRect( 0, 229, 480, 5 )
	screenGroup:insert(ground)
	ground.alpha = 0.01; ground.id="ground"
	physics.addBody( ground, "static", { friction=0.3 }  )
	
	--create character
	character = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex( "scene4_insectSprite" ) )
	character.range = 280 --how far the character can move
	character.x = _W/2 - character.range/2; character.y = 210
	character.id = "insect"
	screenGroup:insert(character)
	physics.addBody( character, "dynamic" )
	
end --end createScene


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "level1: enterScene event" )
	
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
	
	--------------------------------------------
	-- *** CREATE A LOOP TO CONTROL CHARACTER TRANSITIONING ***
	--Controls the movement of the character
	--------------------------------------------
	--Create two move functions for the character
	local characterFlip, characterFlop
	--on complete of the first move, the callback funtion is used to fire move2, which inturn fires move1.. etc ... FLIP / FLOP
	function characterFlip(e)
		if not gameOver then	
			print("CharacterFlip")
			--flip the character image
			character.xScale = -character.xScale
			--move the character to the edge of its range
			transTimer = transition.to( character, { time=2000, x=(character.x + character.range), onComplete=characterFlop } )
			--flip the range direction
			character.range = -character.range
		end
	end
	function characterFlop(e)
		if not gameOver then		
			print("CharacterFlop")
			--flip the character image
			character.xScale = -character.xScale
			--move the character to the edge of its range
			transTimer = transition.to( character, { time=2000, x=(character.x + character.range), onComplete=characterFlip } )
			--flip the range direction
			character.range = -character.range
		end
	end
	--start flip flopping!
	characterFlip()
	
	------------------------------------------------
	-- *** Create the collision detection and handling ***
	------------------------------------------------
	function onCollision(event)
		--only handle collisions if game is still in progress
		if not gameOver	then
			--create handle to both collision objects
			local name1 = event.object1.id
			local name2 = event.object2.id
			--functions to enable removing the physics properties of the weight if it misses
			local removeBody1 = function()
				physics.removeBody( event.object1 )
			end
			local removeBody2 = function()
				physics.removeBody( event.object2 )
			end
			--determine phase of collision
			if ( event.phase == "began" ) then
				--determine if object hits ground
				if name1 == "ground" or name2 == "ground" then
					--remove the physics on the weight to prevent further collisions with insect
					if name1 == "ground" and name2 == "weight" then 
						timer.performWithDelay(10, removeBody2, 1)
						if  ( platformsTapped >= 3 ) then
							print("Platforms hit"..platformsTapped)
							--play lose notification
							overChannel = audio.play( overSound )
							timer.performWithDelay( 400, stopTransTimer, 1 )
						end
					elseif name1 == "weight" and name2 == "ground" then 
						timer.performWithDelay(10, removeBody1, 1)
						if  ( platformsTapped >= 3 ) then
							print("Platforms hit"..platformsTapped)
							--play lose notification
							overChannel = audio.play( overSound )
							timer.performWithDelay( 400, stopTransTimer, 1 )
						end
					end --end if ground and weight --this code should be refactored
				end
				
				--determine if insect is hit
				if name1 == "insect" or name2 == "insect" then 
					print("Collision began: "..name1.." and "..name2)
					--check if collision is with a weight
					if name1 == "weight" or name2 == "weight" then
						--remove the insect and stop transition timer
						stopTransTimer()
						--function to remove the character, called with timed delay to avoid collision conflict
						local function removeCharacter() 
							if character then 
								character:removeSelf()
								character = nil
							end
						end
						timer.performWithDelay(10, removeCharacter, 1)
						--notify of the win
						hitChannel = audio.play(hitSound)
						gameOver = true
						print("Evil has been crushed")
					end
				end
				
			elseif ( event.phase == "ended" ) then
				if name1 == "insect" or name2 == "insect" then 
					print("Collision ended: "..name1.." and "..name2)
				end
			end
		end
	end
	Runtime:addEventListener("collision", onCollision)
	

	
	
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "level1: exitScene event" )
	stopTransTimer()
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