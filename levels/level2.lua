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
--***  Level2  ***
------------------------------------

----Shape Matching----
--Move shaped to their matching placeholders and
--snap into place if there is a successful match.
--Play audio notification if all shapes are matched.
--Show a menu button that allows to return to the main screen.

------------------------------------------------
-- *** SETUP ***
------------------------------------------------
--Setup storyboard
local storyboard = require("storyboard")
local scene = storyboard.newScene()
--sounds/tapsound--Set up some of the sounds we want to use....
local tapChannel, tapSound, snapChannel, snapSound, winChannel, winSound
--Variables etc we need
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight
--button variables
local buttonHome
local btnWidth, btnHeight, btnAlpha = 80, 60, 0.01
--Shape references
local star7, star8p, star8s --three moveable stars, one with seven points, two with eight points
local star7d, star8pd, star8sd --three star destinations
local succesfulMatches = 0 --counter

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
	snapSound = audio.loadSound("sounds/bananaSlap.mp3")
	winSound = audio.loadSound("sounds/Ta-Da-SoundBible.com-1884170640.mp3")

	------------------------------------------------
	-- *** Create the background ***
	------------------------------------------------
	--Background image
	local bgShapes = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_shapes" ) )
	bgShapes.x = _W * 0.5; bgShapes.y = _H * 0.5
	screenGroup:insert( bgShapes )
	
	
	------------------------------------------------
	-- *** Create the touch / tap event  handlers ***
	------------------------------------------------
	--Home Button touch event handler
	local function buttonTouched(event)
		-- check if home button was tapped
		if (event.target.id == "home") then
			print("buttonTouched: HOME")
			--Play the sound
			tapChannel = audio.play( tapSound )
			--go back to level select screen
			storyboard.gotoScene("levelSelect", "slideRight", 400)
		end --end id if
		return true --stop event propagation to underlying objects
	end --end buttonTouched
	
	--Draggable star touch event handler
	local function moveStar(event)
		--create event.target and phase references
		local target = event.target
		local phase = event.phase
		-- Only move stars that are not locked into place
		if (target.id == "star") and (target.locked == false) then
			--check phase of touch event
			if ( phase == "began" ) then
				print("Star touched "..target.type)
				--set focus
				display.getCurrentStage():setFocus( target )
				target.isFocus = true
				--Store initial position
				target.x0 = event.x - target.x
				target.y0 = event.y - target.y
				
			elseif ( target.isFocus ) then
				if ( phase == "moved" ) then 
					--print("Moving star"..target.type)
					--update the current position
					target.x = event.x - target.x0
					target.y = event.y - target.y0
					
				elseif ( phase == "ended" or phase == "cancelled" ) then
					--print("Stopped moving star "..target.type)
					--declare fuzzy snap range
					local fuzzyRange = 20
					--check if star is in the right place
					if ( target.type == "8p" ) then 
						--check x coordinates
						if ( ( target.x > (star8pd.x - fuzzyRange) ) and  ( target.x < ( star8pd.x + fuzzyRange ) ) ) then
						--check y coordinates
							if ( ( target.y > (star8pd.y - fuzzyRange) ) and  ( target.y < ( star8pd.y + fuzzyRange ) ) ) then 
								--snap into place
								target.x = star8pd.x
								target.y = star8pd.y
								succesfulMatches = succesfulMatches + 1
								print("Successful Match: "..target.type )
								--lock into place
								target.locked = true
								--play audio notification
								snapChannel = audio.play( snapSound )
								if succesfulMatches >= 3 then 
									winChannel = audio.play( winSound )
								end
							end --end if y							
						end -- end if x
					elseif ( target.type == "8s" ) then
						--check x coordinates
						if ( ( target.x > (star8sd.x - fuzzyRange) ) and  ( target.x < ( star8sd.x + fuzzyRange ) ) ) then
						--check y coordinates
							if ( ( target.y > (star8sd.y - fuzzyRange) ) and  ( target.y < ( star8sd.y + fuzzyRange ) ) ) then 
								--snap into place
								target.x = star8sd.x
								target.y = star8sd.y
								succesfulMatches = succesfulMatches + 1
								print("Successful Match: "..target.type )
								--lock into place
								target.locked = true
								--play audio notification
								snapChannel = audio.play( snapSound )
								if succesfulMatches >= 3 then 
									winChannel = audio.play( winSound )
								end

							end --end if y							
						end -- end if x
					else --star.tpye = 7
						--check x coordinates
						if ( ( target.x > (star7d.x - fuzzyRange) ) and  ( target.x < ( star7d.x + fuzzyRange ) ) ) then
						--check y coordinates
							if ( ( target.y > (star7d.y - fuzzyRange) ) and  ( target.y < ( star7d.y + fuzzyRange ) ) ) then 
								--snap into place
								target.x = star7d.x
								target.y = star7d.y
								succesfulMatches = succesfulMatches + 1
								print("Successful Match: "..target.type )
								--lock into place
								target.locked = true
								--play audio notification
								snapChannel = audio.play( snapSound )
								if succesfulMatches >= 3 then 
									winChannel = audio.play( winSound )
								end
							end --end if y							
						end -- end if x
					end --end if type
					
					--NOTE: code above should be refactored

					--remove focus
					display.getCurrentStage():setFocus( nil )
					target.isFocus = false;
				end --end if phase ended or cancelled
				
				
			end --end phase if
			
		end --end id if
		return true --stop event propagation to underlying objects
	end --end moveStar
	
	------------------------------------------------
	-- *** Create the Shapes ***
	------------------------------------------------
	--local variables 
	local starLineHeight = 75 --vertical position of top line of stars
	local star_xOffset, star_yOffset = 125, 110  --for initial positioning of the stars
	--Star destinations
	star8pd = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star8pd") )
	star8pd.x = _W/2 - star_xOffset; star8pd.y = starLineHeight + star_yOffset
	star8pd.id = "star8pd"; 
	screenGroup:insert(star8pd)
	star8sd = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star8sd") )
	star8sd.x = _W/2; star8sd.y = starLineHeight + star_yOffset
	star8sd.id = "star8sd"; 
	screenGroup:insert(star8sd)
	star7d = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star7d") )
	star7d.x = _W/2 + star_xOffset; star7d.y = starLineHeight + star_yOffset
	star7d.id = "star7d"; 
	screenGroup:insert(star7d)
	--Draggable stars
	star8p = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star8p") )
	star8p.x = _W/2 + star_xOffset; star8p.y = starLineHeight
	star8p.id = "star"; star8p.type = "8p"; star8p.locked = false
	screenGroup:insert(star8p)
	star8s = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star8s") )
	star8s.x = _W/2 - star_xOffset; star8s.y = starLineHeight
	star8s.id = "star"; star8s.type = "8s"; star8s.locked = false
	screenGroup:insert(star8s)
	star7 = display.newImage( storyboard.mySpriteSheet, storyboard.spriteSheetInfo:getFrameIndex("scene3_star7") )
	star7.x = _W/2; star7.y = starLineHeight
	star7.id = "star"; star7.type = "7"; star7.locked = false
	screenGroup:insert(star7)
	--Draggable star touch listeners
	star8p:addEventListener( "touch", moveStar )
	star8s:addEventListener( "touch", moveStar )
	star7:addEventListener( "touch", moveStar )
	
	
	------------------------------------------------
	--*** Create home button ***
	------------------------------------------------
	buttonHome = display.newRect( 0, 0, btnWidth, btnHeight )
	buttonHome.id ="home"; buttonHome.alpha = btnAlpha
	--use tap event, more simple and suitable for home button
	buttonHome:addEventListener( "tap", buttonTouched )
	screenGroup:insert( buttonHome )
	
	

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