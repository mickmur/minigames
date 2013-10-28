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

--Initial Settings
display.setStatusBar( display.HiddenStatusBar ) --Hide status bar from the beginning


-- Import storyboard
local storyboard = require("storyboard")
storyboard.purgeOnSceneChange = true --So it automatically purges for us.

--Setup SpriteSheets as storyboard references => can be accessed between storyboard scenes
storyboard.spriteSheetInfo = require("spritesheet")
storyboard.mySpriteSheet = graphics.newImageSheet( "spritesheet.png", storyboard.spriteSheetInfo:getSheet() )


--Create a constantly looping background sound...
local bgSound = audio.loadStream("sounds/DoctorWho.mp3")
audio.reserveChannels(1)   --Reserve its channel
audio.play(bgSound, {channel=1, loops=-1}) --Start looping the sound.


--Activate multi-touch so we can press multiple buttons at once.
system.activate("multitouch")


--Create some level globals used in the game itself/gameWon/gameOver scenes.
_G.amountOfLevels = 3

--Function to log memory usage to the console
local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end
timer.performWithDelay( 5000, checkMemory, 0 )

--Now change scene to go to the menu.
storyboard.gotoScene( "levelSelect", "fade", 400 )
