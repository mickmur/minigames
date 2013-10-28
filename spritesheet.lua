--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8e4bd934580330411c982942765809c5$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- scene4_insect1
            x=2,
            y=2,
            width=38,
            height=38,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 40,
            sourceHeight = 38
        },
        {
            -- scene4_insect2
            x=42,
            y=2,
            width=38,
            height=38,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 40,
            sourceHeight = 38
        },
        {
            -- scene4_weight
            x=82,
            y=2,
            width=58,
            height=48,

        },
        {
            -- scene4_platform
            x=142,
            y=3,
            width=94,
            height=14,

        },
        {
            -- scene4_insectSprite
            x=238,
            y=2,
            width=38,
            height=37,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 40,
            sourceHeight = 39
        },
        {
            -- scene3_star7d
            x=317,
            y=2,
            width=79,
            height=77,

        },
        {
            -- scene3_star7
            x=398,
            y=2,
            width=79,
            height=77,

        },
        {
            -- ufo
            x=2,
            y=81,
            width=104,
            height=56,

        },
        {
            -- scene3_star8sd
            x=108,
            y=81,
            width=81,
            height=81,

        },
        {
            -- scene3_star8s
            x=191,
            y=81,
            width=81,
            height=81,

        },
        {
            -- scene3_star8pd
            x=274,
            y=81,
            width=81,
            height=81,

        },
        {
            -- scene3_star8p
            x=357,
            y=81,
            width=81,
            height=81,

        },
        {
            -- scene2_ufo
            x=2,
            y=164,
            width=480,
            height=320,

        },
        {
            -- scene4_drop
            x=2,
            y=486,
            width=480,
            height=320,

        },
        {
            -- scene1_menu
            x=2,
            y=808,
            width=480,
            height=320,

        },
        {
            -- scene3_shapes
            x=2,
            y=1130,
            width=480,
            height=320,

        },
    },
    
    sheetContentWidth = 484,
    sheetContentHeight = 1452
}

SheetInfo.frameIndex =
{

    ["scene4_insect1"] = 1,
    ["scene4_insect2"] = 2,
    ["scene4_weight"] = 3,
    ["scene4_platform"] = 4,
    ["scene4_insectSprite"] = 5,
    ["scene3_star7d"] = 6,
    ["scene3_star7"] = 7,
    ["ufo"] = 8,
    ["scene3_star8sd"] = 9,
    ["scene3_star8s"] = 10,
    ["scene3_star8pd"] = 11,
    ["scene3_star8p"] = 12,
    ["scene2_ufo"] = 13,
    ["scene4_drop"] = 14,
    ["scene1_menu"] = 15,
    ["scene3_shapes"] = 16,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
