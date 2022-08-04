---@class Button : string
---@author: Cherif#0815
---@version RELEASE v1

-- Read README.md before using, If you use this script that means that you have read the README.md and will follow the license

-- Keyboards
azerty = {
Z = {y = -1, x = 0},
 Q = {y = 0, x = -1},
  S = {y = 1, x = 0},
   D = {y = 0, x = 1},
}
qwerty = {
W = {y = -1, x = 0},
 A = {y = 0, x = -1},
  S = {y = 1, x = 0},
   D = {y = 0, x = 1},
} -- This Script Was High Efforted and Im (Cherif) tired >:(, wow def didn't take a long time cleaning it
--

--[[ Stage Editor ]] --[[ Credits Page {

        Cherif  | new Owner, ALL Functions, Lua Buttons, Keyboard support, multiple path support, Cleaning the script, Creator of script (99.99999999999999999999999999999999% mine)
        Stilic  | Past owner, uh ogHideHud thingy

        Mouse Overlaps object function | By Cherif and Raltyro (Fix by dragshot)
        Index Search | By Super

		SPECIAL THANKS TO
		Raltyro for helping me :D
     }
]]
-- [[Preferences]] --
local preferences = {
    defaultSpeed = 1,
    keyboard = azerty,
    paths = {
        "assets/images/",
        "assets/shared/images/",
        "mods/images/"
    }
}
-- [[Variables]] -- Do not touch

preferences.Speed = preferences.keyboard == azerty and 'M' or 'SEMICOLON'
local defaultZoom = 1
local Make = {}
local Button = {Main = {}, Extras = {Properties = {}}, ExtraProperties = {}}
local Section = {}
local _Sections = {}
local _Storage = {}
local Stage = {Save = {}}
local _Groups = {}
local _ButtonData = {}
local _TypeStuff = {
    _removeTagTxt = "Insert Sprite Tag Here",
    _sprTxt = "Insert Sprite Name Here",
    _sprTagTxt = "Insert Sprite Tag Here",
    _animNTxt = "Insert Animation Name Here",
    _animTxt = "Insert Sprite Animation in XML Here",
    _animTagTxt = "Insert Sprite Tag Here",
    _FPStxt = "FPS",
    _graphTxt = "Insert Graphic Tag Here",
    _hexTxt = "Insert Hex Code Here",
    _heightTxt = "Insert Height Here",
    _widthTxt = "Insert Width Here",
    _textTag = "Insert Text Tag Here",
    _textTxt = "Insert Text Here",
    _hex2Txt = "Insert Hex Code Here",
    _sizeTxt = "Insert Size Here",
    _sprTagTxt3 = "Insert Sprite Tag Here",
    _aniName = "Insert Animation Tag Here",
    _alpha = 'ALPHA',
    _angle = 'ANGLE',
    _order = 'ORDER',
    _ScrollY = 'SCROLL-Y',
    _ScrollX = 'SCROLL-X',
    _ScaleY = 'Scale-Y',
    _ScaleX = 'Scale-X',
    _CameraX = '0',
    _CameraY = '0'
}
local _OnMenu = {
    normalMenu = true,
    onFAni = false,
    onText = false,
    onGraph = false,
    onRe = false,
    onMe = false,
    onAni = false,
    onInfo = false,
    onExit = false
}

local animSection = false
local GivenAName = false
local isLooped = false
local isPixelStage = false

local clickEscape = false
local isLoadedNone
local autoSaving = false

local stageTxt = ""

local anims = {}
local curObjects = {"dad", "gf", "boyfriend"}
local charData = {
    dad = {
        camOffsets = {
            x = 0,
            y = 0
        }
    },
    gf = {
        camOffsets = {
            x = 0,
            y = 0
        }
    },
    boyfriend = {
        camOffsets = {
            x = 0,
            y = 0
        }
    }
}
local curObj = 1
local newObjects = {}

keyList = {
    ZERO = "0",
    ONE = "1",
    TWO = "2",
    THREE = "3",
    FOUR = "4",
    FIVE = "5",
    SIX = "6",
    SEVEN = "7",
    EIGHT = "8",
    NINE = "9",
    NUMPADZERO = "0",
    NUMPADONE = "1",
    NUMPADTWO = "2",
    NUMPADTHREE = "3",
    NUMPADFOUR = "4",
    NUMPADFIVE = "5",
    NUMPADSIX = "6",
    NUMPADSEVEN = "7",
    NUMPADEIGHT = "8",
    NUMPADNINE = "9",
    NUMPADMINUS = "-",
    SPACE = " ",
    MINUS = "-",
    SEMICOLON = "/",
    SLASH = "/",
    COMMA = "_",
    PERIOD = '.'
}

for i = 97, 122 do
    local char = string.char(i)
    local upper = char:upper()
    keyList[upper] = char
end
local upperListKeys = {
    SEMICOLON = '.',
} -- ok

-- [[Functions]] --

-- [Mouse Overlaps] --

---@param cam string
---@param spr string
local function mouseOverlaps(spr, cam)
    local mx, my = getMouseX(cam or 'other'), getMouseY(cam or 'other')

    local x, y, w, h = getProperty(spr .. '.x'), getProperty(spr .. '.y'),
                       getProperty(spr .. '.width'),
                       getProperty(spr .. '.height')

    return mx >= x and mx <= x + w and my >= y and my <= y + h;
end

-- [Math Swap] --
function math.swap(value) -- the more it is the less it is the less it is the more it is
    return (2/value) * 100
end

-- [Table Find] --

---@param tab table
---@param el any
local function tablefind(tab,el)
	for index, value in pairs(tab) do
	    if value == el then
	    return index
      end
   end
end

-- [String to Bool] --

---@param str string
local function tobool(str)
    return string.lower(str) == 'true' and true or string.lower(str) == 'false' and false
end

-- [Table To String] -- (used for saving data only)

local function approriateStr(str,isIndex) -- Made by raltyro
    if isIndex then
        local wrap = false

        if str:find(' ') or str:find('    ') or str:find('"') or str:find("'") then wrap = true end
        local c = approriateStr(str)

        return wrap and "["..c..(string.sub(c,#c,#c) == "]" and " ]" or "]") or str
    else
        local v = '"'

        if str:find(v) then
            v = "'"
            if str:find(v) then
                v = "[["
                if str:find("]]") then
                    v = nil
                end
            end
        end

        if v ~= nil then
            return v..str..(v == "[[" and "]]" or v)
        end
    end
end
function strThing(s,i)
    local str = ""
    for i = 1,i do
        str = str .. s
    end
    return str
end
local tableToStr = nil
tableToStrLIMITTABLES = 4
function tableToStr(t,cln,x)
    if type(x) == "number" and (x or 0) >= tableToStrLIMITTABLES then return "Limited" end
    local count,indexNumber = 0,true
    for i,v in pairs(t) do
        count = count + 1
        if type(i) ~= "number" or type(v) == "table" then indexNumber = false end
    end
    if count < 8 and indexNumber then cln = false end
    
    local a = 1+(type(x) == "number" and x or 0)
    local str = --[[(cln and strThing("    ",a-1) or "")..]]"{"..(cln and "\n" or "")
    
    for i,v in pairs(t) do
        if cln then str = str..strThing("    ",a) end
        if type(i) == "string" then
            str = str..approriateStr(i,true)..' = '
        end
        if type(v) == "table" then
            str = str..tableToStr(v,cln,a)
        else
            str = str..(type(v) == "string" and (approriateStr(v) or "") or tostring(v))
        end
        
        str = str..(cln and ",\n" or ",")
    end
    if count > 0 then str = str:sub(1,#str-(cln and 2 or 1)) else if cln then str = str:sub(1,#str-1) end end

    str = str..((cln and count and "\n" or "")..(cln and strThing("    ",a-1) or "").."}")
    return str
end

-- [Make Table] -- (used for saving data only)

function makeTable(tbl)
    return setmetatable(tbl,{
    __index=function(tbl,key)
        if(table[key])then 
            return table[key]
        else
            return tbl[key]
        end
    end,
    __tostring=tableToStr
})
end

-- [Check if Player Is Typing] --


local function checkOntype(str) ---@param str string
	local shift = pr('pressed' ,"SHIFT")
	for i,v in pairs(keyList) do
		if (pr("justPressed", i)) then
			if (shift) then
				v = upperListKeys[i] or string.upper(v)
			end
			str = str .. v
		end
	end
	
	if (pr("justPressed", "BACKSPACE")) then
		str = str:sub(1, -2)
	end
	
	return str
end

-- [Get & Set Property Quickly] --

local function getQuick(w)---@param w string
	return{
		getProperty(w..'.x'),
		getProperty(w..'.y')
    }
end

---@param w string
---@param a integer (optional)
---@param b integer (optional)
local function setQuick(w, a, b)
	setProperty(w..'.y', b)
	setProperty(w..'.x', a)
end

-- [Make Quick Sprite] --

---@param tag string
---@param spr string
---@param cam string
---@param add boolean
---@param isGraphic boolean
---@param isAnimated boolean
---@param w integer
---@param h integer
---@param hex string
local function makeQuickSprite(tag, spr, cam, add, isGraphic, isAnimated, w, h, hex)
	if not isGraphic and not isAnimated then
		makeLuaSprite(tag, spr)
		setObjectCamera(tag, cam)
	elseif isGraphic and not isAnimated then
		makeLuaSprite(tag, '')
		makeGraphic(tag, w, h, hex)
		setObjectCamera(tag, cam)
	elseif not isGraphic and isAnimated then
		makeAnimatedLuaSprite(tag, spr)
		setObjectCamera(tag, cam)
	end
    if add then
        addLuaSprite(tag, true)
    end
end

-- [Make Quick Text] --

---@param t string
---@param txt string
---@param s integer (optional)
---@param cam string
---@param x integer
---@param y integer
---@param add boolean
local function makeQuickText(t, txt, s, cam, x, y, add)
    makeLuaText(t, txt or '',0,0,0)
    setQuick(t, x, y)
    setTextSize(t, s)
    setObjectCamera(t, cam or 'other')
    if add then
        addLuaText(t, true)
    end
end

-- [Groups] --
---@param grp string
---@param stuff table
---@param seperationx integer
---@param seperationy integer
local function makeGroup(grp, stuff, seperationx, seperationy)
  _Groups[grp] = {sep = {x = seperationx, y = seperationy}}
  for q, p in pairs(stuff) do
    table.insert(_Groups[grp], p)
    setProperty(p..'.x', seperationx ~= nil and seperationx * #stuff or getProperty(p..'.x'))
    setProperty(p..'.y', seperationy ~= nil and seperationy * #stuff or getProperty(p..'.y'))
  end
end

-- [] --

function setGroupProperty(w, a, b)
    for i = 1, #_Groups[w] do
        setProperty(_Groups[w][i]..'.'..a, a ~= ('alpha' or 'visible') and b or b + (_Groups[w]['seperation'][a] * i))
    end
end

-- [Make Info Text] --
function makeInfoTxt()
    makeQuickText('extraInfo', '', 36, 'other', 850, 118, true)
    setProperty('extraInfo.visible', false)
    makeQuickText('info', '', 23, 'other', 0, 0, true)
    end
    
-- [Update info Text] --
    
function updateInfoTxt()
    setTextString('info', curObjects[curObj]..'\n X:'..getProperty(curObjects[curObj]..'.x')..'\n Y:'..getProperty(curObjects[curObj]..'.y')..'\n Movement Speed: '..preferences.defaultSpeed..'\n\n\n\n\n\n\n\n Camera Zoom:'.. defaultZoom.."\n\nPixel Stage:"..tostring(isPixelStage)..'\n')
    setTextString('extraInfo', curObjects[curObj]..'\n Visible: '..tostring(getProperty(curObjects[curObj]..'.visible'))..'\n Alpha: '..getProperty(curObjects[curObj]..'.alpha')..'\n Order: '..tostring(getObjectOrder(curObjects[curObj]))..'\n'..'Scale-X: '..getProperty(curObjects[curObj]..'.scale.x')..'\n'..'Scale-Y: '..getProperty(curObjects[curObj]..'.scale.y')..'\n'..'Angle: '..tostring(getProperty(curObjects[curObj]..'.angle'))..'\nFlip-X: '..tostring(getProperty(curObjects[curObj]..'.flipX'))..'\n'..'Flip-Y: '..tostring(getProperty(curObjects[curObj]..'.flipY'))..'\nAnialiasing: '..tostring(getProperty(curObjects[curObj]..'.antialiasing'))..'\n ScrollFactor: '..tostring(getProperty(curObjects[curObj]..'.scrollFactor.x'))..','..tostring(getProperty(curObjects[curObj]..'.scrollFactor.y'))..'\n')
    if curObjects[curObj] == 'dad' or curObjects[curObj] == 'gf' or curObjects[curObj] == 'boyfriend' then
        makeQuickText('camInfo', [==[
            Camera Offsets = []==].. charData[curObjects[curObj]]['camOffsets']['x']..', '..charData[curObjects[curObj]]['camOffsets']['y']..'] -- '..curObjects[curObj]..'\n', 30, 'other', 0, 0, true)
    else
        removeLuaText('camInfo')
    end
    if pr('pressed', 'SHIFT') then
        setProperty('info.visible', false)
        setProperty('camInfo.visible', true)
    else
        setProperty('info.visible', true)
        setProperty('camInfo.visible', false)
    end
end


-- [Table Contains] --

---@param list table
---@param x any
local function contains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

-- [Check if File Exists] --

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

-- [Quick Key Press Check] --

function pr(type, key)
    if getPropertyFromClass('flixel.FlxG', 'keys.'..type..'.'..key) then
        return true;
    end
end

-- [Check if all sections are false] --

function menuCheck()
    if (not _OnMenu.onAni and not _OnMenu.onFAni and not _OnMenu.onGraph and not _OnMenu.onMe and not _OnMenu.onRe and not _OnMenu.onText) then
        return true
    end
end

-- [Check if File exists in Paths] --

function fileCheck(file)
  for i = 1, #preferences.paths do
    if (file_exists(preferences.paths[i]..file..'.png')) then
       return true
    end
  end
end

-- [Change Object] --

---@param who integer (optional)
local function changeO(who)
 if menuCheck() then
	curObj = curObj + who
	
	if curObj > #curObjects then
		curObj = 1
	elseif curObj <= 0 then
		curObj = #curObjects
	end
  end
end

-- [Change Zoom] --

---@param who integer
local function zoomCam(who)
    if menuCheck() and not _OnMenu.onInfo then
        setProperty('camera.zoom', getProperty('camera.zoom')+who)
    end
end

-- [Change Speed] --

---@param who integer
local function changeS(who)
    if menuCheck() and not _OnMenu.onInfo then
      preferences.defaultSpeed = preferences.defaultSpeed + who
  
      if preferences.defaultSpeed <= 0 then
          preferences.defaultSpeed = 0
      end
   end
end

-- [Move Object] --

---@param obj string (optional)
---@param tox integer
---@param toy integer
local function move(obj, tox, toy)
	if menuCheck() and not _OnMenu.onInfo then
		local x, y = getProperty(obj..'.x'), getProperty(obj..'.y')
		setProperty(obj..'.y', y + toy)
        setProperty(obj..'.x', x + tox)
	end
end

-- [Make Buttons] --

---@param tag Button
---@param w integer
---@param h integer
---@param txt string (optional)
---@param h1 string (optional)
---@param h2 string (optional)
---@param txtsize integer
---@param x integer
---@param y integer
---@param what string
---@param func function (optional)
---@param var any
---@param section any
function Button:Make(tag, w, h, txt, h1, h2, h3, txtsize, x, y, func, what, var, section) -- New data feature?
    var = var or nil
    func = func or nil
    _ButtonData[tag] = {
        text = txt,
        width = w,
        height = h,
        hex1 = h1,
        hex2 = h2,
        onFocusHex = h3,
        textSize = txtsize,
        X = x,
        Y = y,
        trigger = what == 'button' and func or nil,
        btnType = what == 'type' and 'type' or 'button',
        variable = what == 'type' and var or nil,
        variableText = what == 'type' and _TypeStuff['_'..var] or nil,
        menu = section
    } --mmmmm

    local rTag = 'stmk:'..tag
    makeQuickSprite(rTag, '', 'hud', true, true, false, w, h, h1)
    setQuick(rTag, x, y)
    makeQuickSprite(rTag..'_2', '', 'hud', true, true, false, w-20, h-20, h2)
    setProperty(rTag..'_2.x', getProperty(rTag..'.x') + getProperty(rTag..'.width')/2  - getProperty(rTag..'_2.width')/2)
    setProperty(rTag..'_2.y', getProperty(rTag..'.y') + getProperty(rTag..'.height')/2  - getProperty(rTag..'_2.height')/2)
    makeQuickText(rTag..'_3', txt, txtsize, 'hud', getProperty(rTag..'_2.x'), getProperty(rTag..'_2.y'), true)
    setProperty(rTag..'_3.x', getProperty(rTag..'_2.x') + getProperty(rTag..'_2.width')/2  - getProperty(rTag..'_3.width')/2)
    setProperty(rTag..'_3.y', getProperty(rTag..'_2.y') + getProperty(rTag..'_2.height')/2  - getProperty(rTag..'_3.height')/2)
end

--* [Update Button Data] *--

function Button:UpdateData() -- Checks if mouse overlaps one of the buttons and does its function better than the old one haha
    for _, _b in pairs(_ButtonData) do
        if _OnMenu[_b.menu] == true then
            if _b.btnType == "button" then
                if mouseOverlaps("stmk:" .. _, "hud") then
                    setTextColor("stmk:" .. _ .. "_3", _b.onFocusHex)
                    if mouseClicked("left") then
                        _b.trigger()
                    end
                else
                    setTextColor("stmk:" .. _ .. "_3", "FFFFFF")
                end
            elseif _b.btnType == "type" then
                if mouseOverlaps("stmk:" .. _, "hud") then
                    setTextBorder("stmk:".._.."_3", 40, "ff0365")
                    if _TypeStuff["_" .. _b.variable] == _b.variableText then
                        _TypeStuff["_" .. _b.variable] = ""
                    end
                    _TypeStuff["_" .. _b.variable] = checkOntype(_TypeStuff["_" .. _b.variable])
                else
                    setTextBorder("stmk:".._.."_3", 2, "000000")
                    if _TypeStuff["_" .. _b.variable] == "" or _TypeStuff["_" .. _b.variable] == " " then
                        _TypeStuff["_" .. _b.variable] = _b.variableText
                    end
                end
                setTextString("stmk:".._.."_3", _TypeStuff["_" .. _b.variable])
                setTextAlignment("stmk:".._.."_3", 'center')
            end
        else
            if  _b.btnType == "type" then
                _TypeStuff["_" .. _b.variable] = _b.variableText
            end
        end
    end
end

--* [Tween Button] *--

---@param what string
---@param tag string
---@param button Button
---@param x integer (optional)
---@param duration integer (optional)
---@param ease string
---@param FlxType string
function Button:Tween(what ,tag, button, x, duration, ease, FlxType)
    button = 'stmk:'..button
    if string.lower(what) == 'x' then
      doTween('X', tag..'_1', button, x, duration, ease, FlxType)
      doTween('X', tag..'_2', button..'_2', x + getProperty(button..'.width')/2  - getProperty(button..'_2.width')/2, duration, ease, FlxType)
      doTween('X', tag..'_3', button..'_3', x + 9 + getProperty(button..'_2.width')/2  - getProperty(button..'_3.width')/2, duration, ease, FlxType)
    end
  
    if string.lower(what) == 'y' then
      doTween('Y', tag..'_1', button, x, duration, ease, FlxType)
      doTween('Y', tag..'_2', button..'_2', x + getProperty(button..'.height')/2  - getProperty(button..'_2.height')/2, duration, ease, FlxType)
      doTween('Y', tag..'_3', button..'_3', x + 9 + getProperty(button..'_2.height')/2  - getProperty(button..'_3.height')/2, duration, ease, FlxType)
    end
end


-- [Make Stage Name Selection] --

function selectStageName()
    if not GivenAName then
        makeQuickSprite('stageSelect', '', 'other', true, true, false, 4000, 4000, '000000')
        setProperty('stageSelect.alpha', 0.5)
        makeQuickText('stageGuideSelectTxt', 'Please Enter Your Stage Name here', 27, 'other', 0, 50, true)
        screenCenter('stageGuideSelectTxt', 'x')
        makeQuickText('stageSelectTxt', '', 22, 'other', 0, 0, true)
        screenCenter('stageSelectTxt', 'xy')
    end
end

-- [Make Section] --

---@param name string
---@param section string
---@param hex string
---@param hex1 string
---@param hex2 string
---@param hex3 string
---@param btns table
function Section:Make(part, name, section, hex, hex1, hex2, hex3, btns) -- may look small but in the core its huge
    _Sections[name] = {
        open = function()
            makeLuaSprite("gardiant", "")
            makeGraphic("gardiant", 4000, 4000, hex)
            setObjectCamera("gardiant", "hud")
            setProperty("gardiant.alpha", 0.4)
            addLuaSprite("gardiant", true)
            _OnMenu[section] = true
            _OnMenu.normalMenu = false
            for _, _b in pairs(btns) do
                Button:Make(_, _b.width, _b.height, _b.text, hex1, hex2, hex3, _b.txtsize, _b.x, _b.y, _b.func, _b.what, _b.var, section)
            end
        end,
        buttons = btns,
        menu = section,
        from = part,
        close = function()
            removeLuaSprite("gardiant", true)
            for s, t in pairs(_Sections[name].buttons) do
                removeLuaSprite("stmk:" .. s)
                removeLuaSprite("stmk:" .. s .. "_2")
                removeLuaText("stmk:" .. s .. "_3")
            end
            _OnMenu[section] = false
            _OnMenu.normalMenu = true
        end
    }
end

-- [*LOAD STAGE DATA*] --

function Stage:loadData()
    local stageData = dofile('mods/stages/'..stageTxt..'.lua')
    newObjects = stageData[1]
    for a, _ in pairs(stageData[1]) do
        table.insert(curObjects, a)
    end
    defaultZoom = stageData[3].defaultZoom
    isPixelStage = stageData[3].isPixelStage
    for _, __ in pairs(stageData[1]) do
        if not __.isText then
            if not __.isGraphic then
                if not __.animated then
                    makeLuaSprite(_, __.image, __.x, __.y)
                else
                    makeAnimatedLuaSprite(_, __.image, __.x, __.y)  
                    for _p, a in pairs(__.animations) do
                        addAnimationByPrefix(_, _p, a.animation, a.FPS, a.loop)
                    end
                end
            else
                makeLuaSprite(_, "", __.x, __.y)
                makeGraphic(_, __.width, __.height, __.hex)
            end
            addLuaSprite(_, true)
        else
            makeLuaText(_, __.text, 0, __.x, __.y)
            setTextSize(_, __.size)
            setTextColor(_, __.hex)
            addLuaText(_, true)
        end
        setObjectCamera(_, __.camera)
        setScrollFactor(_, __.scrollX, __.scrollY)
        setProperty(_..'.flipX', __.flipX)
        setProperty(_..'.flipY', __.flipY)
        setProperty(_..'.alpha', __.alpha)
        setProperty(_..'.visible', __.visible)
        setProperty(_..'.scale.x', __.scaleX)
        setProperty(_..'.scale.y', __.scaleY)
        setObjectOrder(_, __.order)
    end
    for _, __ in pairs(stageData[2]) do
        setQuick(_, __.x, __.y)
        setScrollFactor(_, __.scrollX, __.scrollY)
        setProperty(_..'.flipX', __.flipX)
        setProperty(_..'.flipY', __.flipY)
        setProperty(_..'.alpha', __.alpha)
        setProperty(_..'.visible', __.visible)
        setProperty(_..'.scale.x', __.scaleX)
        setProperty(_..'.scale.y', __.scaleY)
        setProperty(_..'.angle', __.angle)
        setObjectOrder(_, __.order)
    end
    charData = stageData[2]
end

-- [[MAIN STUFF]] --

-- [All Button & Section Functions] --

function Button:MakeMain()
    Button:Make('OpenMain', 30, 80, '>', '8704fb', '901afa', '7400db', 16, getProperty('info.x')-5, getProperty('info.y')+120, function()
        if getTextString('stmk:OpenMain_3') == '>' then
            Button.Main:open()
            setTextString('stmk:OpenMain_3', '<')
        else
            Button.Main:close()
            setTextString('stmk:OpenMain_3', '>')
        end
    end,
    'button', nil, 'normalMenu')

    Button:Make('AddSprite', 120, 80, '\nAdd\nSprite\n', '8263f6', '7151e7', '6544dd', 22, getProperty('info.x')-520, getProperty('info.y')+120, function()
        animSection = false
        _Sections["AddSprite"].open()
        Button.Main:close()
    end,
    'button', nil, 'normalMenu')

    Button:Make('AddAnimatedSprite', 120, 80, '\nAdd\nAnimated\nSprite\n', '1e57d4', '3469dd', '2455c2', 20, getProperty('info.x')-390, getProperty('info.y')+120, function()
        animSection = true
        _Sections["AddSprite"].open()
        Button.Main:close()
    end,
    'button', nil, 'normalMenu')
    Button:Make('AddAnimation', 120, 80, '\nAdd\nAnimation\n', 'f22264', 'e93b72', 'cc2e60', 18, getProperty('stmk:AddAnimatedSprite.x')+130, getProperty('info.y')+120, function()
        _Sections["AddAnimation"].open()
        Button.Main:close()
    end,
    'button', nil, 'normalMenu')
    Button:Make('RemoveSprite', 120, 80, '\nRemove\nSprite\n', 'feaf74', 'fcc298', 'ffa25e', 22, getProperty('stmk:AddAnimation.x')+130, getProperty('info.y')+120, function()
        _Sections["RemoveSprite"].open()
        Button.Main:close()
    end,
    'button', nil, 'normalMenu')
    Button:Make('AutoSave', 100, 40, 'AUTOSAVE: FALSE', '4896ca', '489fca', 'fa96ca', 12, 7, 661, function()
        if getTextString('stmk:AutoSave_3') == 'AUTOSAVE: FALSE' then
            autoSaving = true
            autoSave()
            setTextString('stmk:AutoSave_3', 'AUTOSAVE: TRUE')
        else
            autoSaving = false
            setTextString('stmk:AutoSave_3', 'AUTOSAVE: FALSE')
        end
    end,
    'button', nil, 'normalMenu')
end

function Button.Main:open()
    Button:Tween('X', 'OpenMainTwn:Open', 'OpenMain', 525, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddSpriteTwn:Open', 'AddSprite', 10, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddAnimatedSpriteTwn:Open', 'AddAnimatedSprite', 140, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddAnimationTwn:Open', 'AddAnimation', 270, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'RemoveSpriteTwn:Open', 'RemoveSprite', 400, 1.2, 'quintOut', 'persist')
end

function Button.Main:close()
    Button:Tween('X', 'OpenMainTwn:Close', 'OpenMain', getProperty('info.x')-5, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddSpriteTwn:Close', 'AddSprite', getProperty('info.x')-520, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddAnimatedSpriteTwn:Close', 'AddAnimatedSprite', getProperty('info.x')-390, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'AddAnimationTwn:Close', 'AddAnimation', getProperty('info.x')-260, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'RemoveSpriteTwn:Close', 'RemoveSprite', getProperty('info.x')-130, 1.2, 'quintOut', 'persist')
end

function Button:MakeExtras()
    Button:Make('OpenExtras', 30, 80, '>', '83f3ff', '68ebf9', '4aebfc', 16, getProperty('info.x')-5, 341, function()
        if getTextString('stmk:OpenExtras_3') == '>' then
            Button.Extras:open()
            setTextString('stmk:OpenExtras_3', '<')
        else
            Button.Extras:close()
            setTextString('stmk:OpenExtras_3', '>')
        end
    end,
    'button', nil, 'normalMenu')
    Button:Make('MakeGraphic', 120, 80, '\nMake\nGraphic\n', '4afccd', '68f9d3', '43efc2', 22, getProperty('stmk:OpenExtras.x')-260, 341, function()
        _Sections["MakeGraphic"].open()
        Button.Extras:close()
    end,
    'button', nil, 'normalMenu')
    Button:Make('MakeText', 120, 80, '\nMake\nText\n', '59ff95', '43ef81', '19ff6d', 22, getProperty('stmk:MakeGraphic.x')+130, 341, function()
        _Sections["MakeText"].open()
        Button.Extras:close()
    end,
    'button', nil, 'normalMenu')
    Button.Extras:MakeProperties()
end

function Button.Extras:open()
    Button:Tween('X', 'OpenExtrasTwn:Open', 'OpenExtras', getProperty('info.x')+265, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'MakeGraphicTwn:Open', 'MakeGraphic', 10, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'MakeTextTwn:Open', 'MakeText', 140, 1.2, 'quintOut', 'persist')
end

function Button.Extras:close()
    Button:Tween('X', 'OpenExtrasTwn:Closee', 'OpenExtras', getProperty('info.x')-5, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'MakeGraphicTwn:Close', 'MakeGraphic', getProperty('info.x')-265, 1.2, 'quintOut', 'persist')
    Button:Tween('X', 'MakeTextTwn:Close', 'MakeText', getProperty('info.x')-130, 1.2, 'quintOut', 'persist')
end

function Button.Extras:MakeProperties()
    Button:Make('OpenExtras2', 80, 30, '▼', '83ffa3', '57f680', '36fd6a', 16, 1200, 0, function()
        if getTextString('stmk:OpenExtras2_3') == '▼' then
            Button.ExtraProperties:open()
            setTextString('stmk:OpenExtras2_3', '▲')
        else
            Button.ExtraProperties:close()
            setTextString('stmk:OpenExtras2_3', '▼')
        end
    end,
    'button', nil, 'normalMenu')
    Button:Make('ExtraInfo', 80, 40, 'Info', '57f680', '36fd6a', '83ffa3', 16, 1200, -50, function()
        _Sections['ExtraInfo'].open()
        setProperty('extraInfo.visible', true)
        Button.ExtraProperties:close()
        setObjectCamera('info', 'hud')
    end,
    'button', nil, 'normalMenu')
    Button:Make('Events', 80, 40, 'SOON', '57f680', '36fd6a', '83ffa3', 16, 1200, -100, function()
    end,
    'button', nil, 'normalMenu')
end

function Button.ExtraProperties:open()
    Button:Tween('Y', 'OpenExtras2Twn:Open', 'OpenExtras2', 140, 1.2, 'quintOut', 'persist')
    Button:Tween('Y', 'ExtraInfoTwn:Open', 'ExtraInfo', 90, 1.2, 'quintOut', 'persist')
    Button:Tween('Y', 'Events:Open', 'Events', 40, 1.2, 'quintOut', 'persist')
end

function Button.ExtraProperties:close()
    Button:Tween('Y', 'OpenExtras2Twn:Close', 'OpenExtras2', 0, 1.2, 'quintOut', 'persist')
    Button:Tween('Y', 'ExtraInfoTwn:Close', 'ExtraInfo', -50, 1.2, 'quintOut', 'persist')
    Button:Tween('Y', 'Events:Open', 'Events', -100, 1.2, 'quintOut', 'persist')
end

function Section:MakeAll() -- help 💀
    Section:Make(
        "Main",
        "AddSprite", --- cough and animated too
        "onMe",
        '8263f6',
        '5c1bd3',
        '5119b8',
        '8263f6',
        {
            ["camOther"] = {
                width = 260,
                height = 100,
                text = "Camera: Other",
                txtsize = 30,
                x = 823,
                y = 500,
                what = "button",
                var = nil,
                func = function()
                    Make:Sprite(_TypeStuff._sprTagTxt, _TypeStuff._sprTxt, 'other')
                end
            },
            ["camHud"] = {
                width = 260,
                height = 100,
                text = "Camera: Hud",
                txtsize = 30,
                x = 823,
                y = 340,
                what = "button",
                var = nil,
                func = function()
                    Make:Sprite(_TypeStuff._sprTagTxt, _TypeStuff._sprTxt, 'hud')
                end
            },
            ["camGame"] = {
                width = 260,
                height = 100,
                text = "Camera: Game",
                txtsize = 30,
                x = 823,
                y = 170,
                what = "button",
                var = nil,
                func = function()
                    Make:Sprite(_TypeStuff._sprTagTxt, _TypeStuff._sprTxt, 'game')
                end
            },
            ["TypeSprTag"] = {
                width = 300,
                height = 100,
                text = _TypeStuff._sprTagTxt,
                txtsize = 14,
                x = 223,
                y = 270,
                what = "type",
                func = nil,
                var = 'sprTagTxt'
            },
            ["TypeSpr"] = {
                width = 300,
                height = 100,
                text = _TypeStuff._sprTxt,
                txtsize = 14,
                x = 223,
                y = 400,
                what = "type",
                func = nil,
                var = 'sprTxt'
            }
        }
    )    

    Section:Make(
        "Main",
        "AddAnimation",
        "onAni",
        'e93b72', 
        'f22264', 
        'cc2e60',
        "cc2e60",
        {
            ["Confirm"] = {
                width = 240,
                height = 100,
                text = "Confirm",
                txtsize = 32,
                x = 823,
                y = 400,
                what = 'button',
                var = nil,
                func = function()
                    Make:Animation(_TypeStuff._animTagTxt, _TypeStuff._animNTxt, _TypeStuff._animTxt, _TypeStuff._FPStxt, tobool(string.lower(string.gsub(getTextString('stmk:Looped_3'), 'Looping: ', ''))))
                end
            },
            ["TypeSpriteTag"] = {
                width = 300,
                height = 100,
                text = "Insert Sprite Tag Here",
                txtsize = 14,
                x = 223,
                y = 180,
                what = 'type',
                var = 'animTagTxt',
                func = nil
            },
            ["TypeAnimationTag"] = {
                width = 300,
                height = 100,
                text = "Insert Animation Name Here",
                txtsize = 14,
                x = 400,
                y = 340,
                what = 'type',
                var = 'animNTxt',
                func = nil
            },
            ["TypeAnimation"] = {
                width = 300,
                height = 100,
                text = "Insert Sprite Animation in XML Here",
                txtsize = 14,
                x = 60,
                y = 340,
                what = 'type',
                var = 'animTxt',
                func = nil
            },
            ["TypeFPS"] = {
                width = 300,
                height = 100,
                text = "FPS",
                txtsize = 20,
                x = 400,
                y = 476,
                what = 'type',
                var = 'FPStxt',
                func = nil
            },
            ["Looped"] = {
                width = 300,
                height = 100,
                text = "Looping: FALSE",
                txtsize = 27,
                x = 60,
                y = 476,
                what = 'button',
                var = '',
                func = function()
                    if string.lower(string.gsub(getTextString('stmk:Looped_3'), 'Looping: ', '')) == 'false' then
                        setTextString('stmk:Looped_3', "Looping: TRUE")
                    else
                        setTextString('stmk:Looped_3', "Looping: FALSE")
                    end
                end
            }
        }
    )
    Section:Make(
        "Main",
        "RemoveSprite",
        "onRe",
        "ffa25e",
        'fcc298',
        'feaf74', 
        'ffa25e',
        {
            ["TypeSprTag2"] = {
                width = 300,
                height = 100,
                text = "Insert Sprite Tag Here",
                txtsize = 14,
                x = 400,
                y = 300,
                what = 'type',
                var = 'removeTagTxt',
                func = nil
            },
            ["Confirm2"] = {
                width = 200,
                height = 100,
                text = "Remove",
                txtsize = 32,
                x = 800,
                y = 300,
                what = 'button',
                var = nil,
                func = function()
                    removeSprite(_TypeStuff._removeTagTxt)
                end
            }
        }
    )
    Section:Make(
        "Extras",
        "MakeText",
        "onText",
        "19ff6d",
        '43ef81',
        '59ff95', 
        '19ff6d',
        {
            ["TypeTextTag"] = {
                width = 300,
                height = 100,
                text = "Insert Text Tag Here",
                txtsize =  14,
                x = 223,
                y = 170,
                what = 'type',
                var = 'textTag',
                func = nil
            },
            ["TypeText"] = {
                width = 600,
                height = 100,
                text = "Insert Text Here",
                txtsize =  14,
                x = 70,
                y = 500,
                what = 'type',
                var = 'textTxt',
                func = nil
            },
            ["TypeHex"] = {
                width = 300,
                height = 100,
                text = "Insert Hex code Here",
                txtsize =  14,
                x = 223,
                y = 390,
                what = 'type',
                var = 'hexTxt',
                func = nil
            },
            ["TypeSize"] = {
                width = 300,
                height = 100,
                text = "Insert Size Here",
                txtsize =  14,
                x = 223,
                y = 280,
                what = 'type',
                var = 'sizeTxt',
                func = nil
            },
            ["camOther2"] = {
                width = 260,
                height = 100,
                text = "Camera: Other",
                txtsize = 30,
                x = 823,
                y = 500,
                what = "button",
                var = nil,
                func = function()
                    Make:Text(_TypeStuff._textTag, _TypeStuff._textTxt, tonumber(_TypeStuff._sizeTxt), _TypeStuff._hexTxt, 'other')
                end
            },
            ["camHud2"] = {
                width = 260,
                height = 100,
                text = "Camera: Hud",
                txtsize = 30,
                x = 823,
                y = 340,
                what = "button",
                var = nil,
                func = function()
                    Make:Text(_TypeStuff._textTag, _TypeStuff._textTxt, tonumber(_TypeStuff._sizeTxt), _TypeStuff._hexTxt, 'hud')
                end
            },
            ["camGame2"] = {
                width = 260,
                height = 100,
                text = "Camera: Game",
                txtsize = 30,
                x = 823,
                y = 170,
                what = "button",
                var = nil,
                func = function()
                    Make:Text(_TypeStuff._textTag, _TypeStuff._textTxt, tonumber(_TypeStuff._sizeTxt), _TypeStuff._hexTxt, 'game')
                end
            } -- cry about it
        }
    )
    Section:Make(
        "Extras",
        "MakeGraphic",
        "onGraph",
        '43efc2',
        '68f9d3', 
        '4afccd', 
        '43efc2',
        {
            ["TypeGraphicTag"] = {
                width = 300,
                height = 100,
                text = "Insert Graphic Tag Here",
                txtsize =  14,
                x = 223,
                y = 170,
                what = 'type',
                var = 'graphTxt',
                func = nil
            },
            ["TypeHex2"] = {
                width = 300,
                height = 100,
                text = "Insert Hex Code Here",
                txtsize =  14,
                x = 223,
                y = 500,
                what = 'type',
                var = 'hex2Txt',
                func = nil
            },
            ["TypeWidth"] = {
                width = 150,
                height = 100,
                text = "Insert Width Here",
                txtsize =  14,
                x = 220,
                y = 320,
                what = 'type',
                var = 'widthTxt', 
                func = nil
            },
            ["TypeHeigth"] = {
                width = 150,
                height = 100,
                text = "Insert Height Here",
                txtsize =  14,
                x = 375,
                y = 320,
                what = 'type',
                var = 'heightTxt',
                func = nil
            },
            ["camOther3"] = {
                width = 260,
                height = 100,
                text = "Camera: Other",
                txtsize = 30,
                x = 823,
                y = 500,
                what = "button",
                var = nil,
                func = function()
                    Make:Graphic(_TypeStuff._graphTxt, tonumber(_TypeStuff._widthTxt), tonumber(_TypeStuff._heightTxt), _TypeStuff._hex2Txt, 'other')
                end
            },
            ["camHud3"] = {
                width = 260,
                height = 100,
                text = "Camera: Hud",
                txtsize = 30,
                x = 823,
                y = 340,
                what = "button",
                var = nil,
                func = function()
                    Make:Graphic(_TypeStuff._graphTxt, tonumber(_TypeStuff._widthTxt), tonumber(_TypeStuff._heightTxt), _TypeStuff._hex2Txt, 'hud')
                end
            },
            ["camGame3"] = {
                width = 260,
                height = 100,
                text = "Camera: Game",
                txtsize = 30,
                x = 823,
                y = 170,
                what = "button",
                var = nil,
                func = function()
                    Make:Graphic(_TypeStuff._graphTxt, tonumber(_TypeStuff._widthTxt), tonumber(_TypeStuff._heightTxt), _TypeStuff._hex2Txt, 'game')
                end
            } -- cry about it
        }
    )
    Section:Make(
        'ExtraProperties',
        'ExtraInfo',
        'onInfo',
        '83ffa3',
        '57f680',
        '36fd6a',
        '83ffa3',
        {
           ['FLIP-X'] = {
            width = 200,
            height = 80,
            text = 'Flip-X',
            txtsize = 20,
            x = 65,
            y = 125,
            what = "button",
            var = nil,
            func = function()
                if getProperty(curObjects[curObj]..'.flipX') == false then
                    setProperty(curObjects[curObj]..'.flipX', true)
                else
                    setProperty(curObjects[curObj]..'.flipX', false)
                end
            end
           },
           ['FLIP-Y'] = {
            width = 200,
            height = 80,
            text = 'Flip-Y',
            txtsize = 20,
            x = 275,
            y = 125,
            what = "button",
            var = nil,
            func = function()
                if getProperty(curObjects[curObj]..'.flipY') == false then
                    setProperty(curObjects[curObj]..'.flipY', true)
                else
                    setProperty(curObjects[curObj]..'.flipY', false)
                end
            end
           },
           ['VISIBLE'] = {
            width = 200,
            height = 80,
            text = 'Visible',
            txtsize = 20,
            x = 65,
            y = 215,
            what = "button",
            var = nil,
            func = function()
                if getProperty(curObjects[curObj]..'.visible') == false then
                    setProperty(curObjects[curObj]..'.visible', true)
                else
                    setProperty(curObjects[curObj]..'.visible', false)
                end
            end
           },
           ['ALPHA'] = {
            width = 200,
            height = 80,
            text = 'ALPHA',
            txtsize = 20,
            x = 275,
            y = 215,
            what = "type",
            var = 'alpha',
            func = nil
           },
           ['ANGLE'] = {
            width = 200,
            height = 80,
            text = 'ANGLE',
            txtsize = 20,
            x = 65,
            y = 305,
            what = "type",
            var = 'angle',
            func = nil
           },
           ['ORDER'] = {
            width = 200,
            height = 80,
            text = 'ORDER',
            txtsize = 20,
            x = 275,
            y = 305,
            what = "type",
            var = 'order',
            func = nil
           },
           ['SCROLL-Y'] = {
            width = 200,
            height = 80,
            text = 'Scroll-Y',
            txtsize = 20,
            x = 275,
            y = 395,
            what = "type",
            var = 'ScrollY',
            func = nil
           },
           ['SCROLL-X'] = {
            width = 200,
            height = 80,
            text = 'Scroll-X',
            txtsize = 20,
            x = 65,
            y = 395,
            what = "type",
            var = 'ScrollX',
            func = nil
           },
           ['SCALE-X'] = {
            width = 200,
            height = 80,
            text = 'Scale-X',
            txtsize = 20,
            x = 65,
            y = 485,
            what = "type",
            var = 'ScaleX',
            func = nil
           },
           ['SCALE-Y'] = {
            width = 200,
            height = 80,
            text = 'Scale-Y',
            txtsize = 20,
            x = 275,
            y = 485,
            what = "type",
            var = 'ScaleY',
            func = nil
           },
           ['ANTIALIASING'] = {
            width = 200,
            height = 80,
            text = 'Antialiasing',
            txtsize = 20,
            x = 169,
            y = 575,
            what = "button",
            var = nil,
            func = function()
                if getProperty(curObjects[curObj]..'.antialiasing') == false then
                    setProperty(curObjects[curObj]..'.antialiasing', true)
                else
                    setProperty(curObjects[curObj]..'.antialiasing', false)
                end
            end
           },
        }
    )
    Section:Make(
        'ExtraProperties',
        'ESCAPE',
        'onExit',
        '000000',
        'FFcaFF',
        'ca488a',
        '599ca9',
        {
            ['YES'] = {
                width = 100,
                height = 40,
                text = 'Leave',
                txtsize = 14,
                x = 459,
                y = 374,
                what = 'button',
                var = nil,
                func = function()
                    setPropertyFromClass('ClientPrefs', 'hideHud', ogHideHud)
                    setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)
                    endSong(true)
                end
            },
            ['NO'] = {
                width = 100,
                height = 40,
                text = 'Stay',
                txtsize = 14,
                x = 678,
                y = 374,
                what = 'button',
                var = nil,
                func = function()
                    _OnMenu.onExit = true
                    _Sections['ESCAPE'].close()
                end
            }
        }
    )
end

function Make:Sprite(tag, spr, camera)
    if newObjects[tag] ~= nil then
        setObjectCamera(tag, camera) -- imagine if people didnt know about this
        debugPrint(tag .. "'s Camera Has Been Changed To " .. camera)
        playSound("confirmMenu", 0.5)        
        newObjects[tag].camera = camera
    else
        if _TypeStuff._sprTagTxt == "Insert Sprite Tag Here" or _TypeStuff._sprTxt == "Insert Sprite Name Here" then
            debugPrint("Invalid Sprite Output Did you Forget To Give Your Sprite A Name?")
            playSound("cancelMenu", 0.6)
        else
            if fileCheck(spr) then
                if animSection then
                    makeAnimatedLuaSprite(tag, spr)
                else
                    makeLuaSprite(tag, spr)
                end
                setObjectCamera(tag, camera)
                addLuaSprite(tag, true)
                debugPrint(tag .. " Has Been Created")
                playSound("confirmMenu", 0.5)

                newObjects[tag] = {
                    image = spr,
                    camera = camera,
                    isAnimated = animSection,
                    isText = false,
                    isGraphic = false,
                    x = 0,
                    y = 0
                }
                table.insert(curObjects, tag)
            else
                debugPrint("Sprite Doesn't Exist, Did You Type The Name Correctly?")
                playSound("cancelMenu", 0.6)
            end
        end
    end
end

function Make:Animation(spr, tag, name, fps, looped)
    fps = (tonumber(fps) == nil) and 24 or fps
    if spr == "Insert Sprite Tag Here" then
        debugPrint("Sprite Does Not Exist")
        playSound("cancelMenu", 0.6)
    else
        if newObjects[spr] == nil then
            debugPrint("Sprite Does Not Exist")
            playSound("cancelMenu", 0.6)
        else
            if newObjects[spr].animated == false then
                debugPrint("Sprite Isn't Animated")
                playSound("cancelMenu", 0.6)
            else
                if tag == "Insert Animation Name Here" then
                    debugPrint("Invalid Animation Name Output, Did you forget to give Your Animation A Name?")
                    playSound("cancelMenu", 0.6)
                else
                    if name == "Insert Sprite Animation in XML Here" then
                        debugPrint(
                            "Invalid Animation ID Output, Did you forget To type Your Animation Name In the XML?"
                        )
                        playSound("cancelMenu", 0.6)
                    else
                        debugPrint('Animation: '..tag.. ', Has Been Added')
                        playSound("confirmMenu", 0.6)
                        addAnimationByPrefix(spr, tag, name, fps, looped)
                        if newObjects[spr]["animations"] == nil then
                            newObjects[spr]["animations"] = {
                                [tag] = {
                                    ["animation"] = name,
                                    ["FPS"] = fps,
                                    ["loop"] = looped
                                }
                            }
                        else
                            newObjects[spr]["animations"][tag] = {
                                ["animation"] = name,
                                ["FPS"] = fps,
                                ["loop"] = looped
                            }
                        end
                    end
                end
            end
        end
    end
end

function Make:Text(tag, text, size, hex, camera)
    hex = hex == 'Insert Hex code Here' and 'FFFFFF' or hex
    if newObjects[tag] ~= nil then
        if text ~= nil and text ~= getTextString(tag) then
            setTextString(tag, text)
            debugPrint(tag..'\'s Text Has Been Changed')
            newObjects[tag].text = text
        end
        newObjects[tag].hex = hex
        setTextColor(tag, hex)
        if size ~= nil and size ~= getTextSize(tag) then
            setTextSize(tag, size)
            debugPrint(tag..'\'s Size Has Been Changed To '..size)
            newObjects[tag].size = size
        end
        setObjectCamera(tag, camera)
        debugPrint(tag..'\'s Camera Has Been Changed To '..camera)
        playSound('confirmMenu', 0.6)
        newObjects[tag].camera = camera
    else
        if tag == "Insert Text Tag Here" then
            debugPrint('Invalid Text Output, Did You Forget To Give Your Text A Tag?')
            playSound('cancelMenu', 0.6)
        else
            if text == "Insert Text Here" then
                debugPrint('Invalid Text Output, Did You Forget To Give Your Text A Text?')
                playSound('cancelMenu', 0.6)
            else
                if size < 1 or tonumber(size) == nil then
                    debugPrint('ERROR #99823, Objects That Have Size Data Of é075A Cannot Be Registered')
                    playSound('cancelMenu', 0.6)
                else
                    makeLuaText(tag, text, 0, 0, 0)
                    setTextSize(tag, tonumber(size))
                    addLuaText(tag, true)
                    setObjectCamera(tag, camera)
                    setTextColor(tag, hex)
                    newObjects[tag] = {
                        camera = camera,
                        size = size,
                        hex = hex,
                        text = text,
                        x = 0,
                        y = 0,
                        isText = true
                    }
                    debugPrint(tag..' Has Been Created')
                    playSound('confirmMenu', 0.6)
                    table.insert(curObjects, tag)
                end
            end
        end
    end
end

function Make:Graphic(tag, width, height, hex, camera)
    hex = hex == 'Insert Hex Code Here' and 'FFFFFF' or hex
    if newObjects[tag] ~= nil then
        if hex ~= 'Insert Hex Code Here' then
            setProperty(tag..'.color', getColorFromHex(hex))
            newObjects[tag].hex = hex
        end
        if width ~= 'Insert Width Here' then
            setProperty(tag..'.width', tonumber(width))
            newObjects[tag].width = tonumber(width)
        end
        if height ~= 'Insert Height Here' then
            setProperty(tag..'.height', tonumber(height))
            newObjects[tag].height = tonumber(height)
        end
        setObjectCamera(tag, camera)
        debugPrint(tag..'\'s Properties And Camera Has Been Changed To '..camera)
        playSound('confirmMenu')
        newObjects[tag].camera = camera
    else
        if tag == 'Insert Graphic Tag Here' then
            debugPrint('Invalid Graphic Output, Did You Forget To Give Your Graphic  a Name?')
            playSound('cancelMenu')
        else
            if width == 'Insert Height Here' or width < 0 or height == 'Insert Height Here' or height < 0 or tonumber(width) == nil or tonumber(height) == nil then
                debugPrint('ERROR #99823, Objects That Have Size Data Of é075A Cannot Be Registered')
                playSound('cancelMenu')
            else
                makeLuaSprite(tag, '', 0, 0)
                makeGraphic(tag, width, height, hex)
                setObjectCamera(tag, camera)
                addLuaSprite(tag, true)
                debugPrint(tag..' Has Been Created')
                playSound('confirmMenu', 0.6)

                newObjects[tag] = {
                    camera = camera,
                    width = width,
                    height = height,
                    hex = hex,
                    x = 0,
                    y = 0,
                    isGraphic = true,
                    isAnimated = false,
                    isText = false
                }
                table.insert(curObjects, tag)
            end
        end
    end
end

function removeSprite(tag)
    if newObjects[tag] == nil then
        debugPrint('Sprite Doesn\'t Exist, Did You Type Its Name Correctly?')
    else
        curObj = 1
        if newObjects[tag].isText then
            removeLuaText(tag)
        else
            removeLuaSprite(tag)
        end
        newObjects[tag] = nil
        table.remove(curObjects, tablefind(curObjects, tag))
        debugPrint(tag..' Has Been Removed')
    end
end

function onCreate()
    ogHideHud = getPropertyFromClass('ClientPrefs', 'hideHud')
end

function onCreatePost()
    playMusic('offsetSong', 0.5, true)
    makeQuickText('stmk:watermark', 'Cherry\'s Stage Editor RELEASE V1\n', 14, 'other', 3, 696, true)
    setPropertyFromClass("Main", "fpsVar.visible", false)
    setPropertyFromClass('ClientPrefs', 'hideHud', true)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end

-- [] --

function onStartCountdown()
    selectStageName()
    makeInfoTxt()
    Button:MakeMain()
    Button:MakeExtras()
    Section:MakeAll()
    return Function_Stop;
end

-- [] --

function onUpdate()
    local pep, si = pcall(function()
    setObjectOrder("watermark", 1055869)
    -- [Stage Name Selection] --
    if not GivenAName then 
        stageTxt = checkOntype(stageTxt)
        setTextString("stageSelectTxt", stageTxt)
        screenCenter("stageSelectTxt", "xy")
        makeQuickText("caretPos", "_", 22, "other", 0, 0, true)
        setQuick(
            "caretPos",
            getProperty("stageSelectTxt.width") + getProperty("stageSelectTxt.x"),
            getProperty("stageSelectTxt.y")
        )
        if pr("justPressed", "ENTER") then
            if stageTxt == "" then
                debugPrint("Your Stage Does Not Have A Name")
                playSound("cancelMenu", 0.6)
                stageTxt = "stage1" 
            else
                if file_exists('mods/stages/'..stageTxt..'.lua') then
                    Stage:loadData()
                else
                    boyfriendPos, girlFriendPos, dadPos, camPos = getQuick('boyfriend'), getQuick('gf'), getQuick('dad'), getQuick('camFollow')
                end
                removeLuaSprite("stageSelect")
                removeLuaText("stageSelectTxt")
                removeLuaText("stageGuideSelectTxt")
                removeLuaText("caretPos")
                GivenAName = true

                if stageTxt == "kitty go kitty glow" then
                    kittyGlow()
                end
            end
        end
    else
        Button:UpdateData()
        defaultZoom = getProperty("camera.zoom")
        -- [Update Positions] -- it sucks ass
            local _______chars = {'dad', 'gf', 'boyfriend'}
            for i = 1, 3 do
                charData[_______chars[i]].x = getProperty(_______chars[i]..'.x')
                charData[_______chars[i]].y = getProperty(_______chars[i]..'.y')
                charData[_______chars[i]].antialiasing = getProperty(_______chars[i]..'.antialiasing')
                charData[_______chars[i]].scrollX = getProperty(_______chars[i]..'.scrollFactor.x')
                charData[_______chars[i]].scrollY = getProperty(_______chars[i]..'.scrollFactor.y')
                charData[_______chars[i]].scaleX = getProperty(_______chars[i]..'.scale.x')
                charData[_______chars[i]].scaleY = getProperty(_______chars[i]..'.scale.y')
                charData[_______chars[i]].order = getObjectOrder(_______chars[i])
                charData[_______chars[i]].angle = getProperty(_______chars[i]..'.angle')
                charData[_______chars[i]].alpha = getProperty(_______chars[i]..'.alpha')
                charData[_______chars[i]].visible = getProperty(_______chars[i]..'.visible')
            end
            for _O, _P in pairs(newObjects) do
                if _O == curObjects[curObj] then
                    newObjects[curObjects[curObj]].x = getProperty(curObjects[curObj]..'.x')
                    newObjects[curObjects[curObj]].y = getProperty(curObjects[curObj]..'.y')
                    newObjects[curObjects[curObj]].antialiasing = getProperty(curObjects[curObj]..'.antialiasing')
                    newObjects[curObjects[curObj]].order = getObjectOrder(curObjects[curObj])
                    newObjects[curObjects[curObj]].scrollX = getProperty(curObjects[curObj]..'.scrollFactor.x')
                    newObjects[curObjects[curObj]].scrollY = getProperty(curObjects[curObj]..'.scrollFactor.y')
                    newObjects[curObjects[curObj]].scaleX = getProperty(curObjects[curObj]..'.scale.x')
                    newObjects[curObjects[curObj]].scaleY = getProperty(curObjects[curObj]..'.scale.y')
                    newObjects[curObjects[curObj]].angle = getProperty(curObjects[curObj]..'.angle')
                    newObjects[curObjects[curObj]].visible = getProperty(curObjects[curObj]..'.visible')
                    newObjects[curObjects[curObj]].alpha  = getProperty(curObjects[curObj]..'.alpha')
                end
            end
            updateInfoTxt()
        --- [Pressed Stuff] --
        for _, __ in pairs(preferences.keyboard) do
            if pr("pressed", _) then
                move(curObjects[curObj], preferences.defaultSpeed * __.x, preferences.defaultSpeed * __.y)
            end
        end
        -- move("camFollow", (preferences.defaultSpeed+1) * -1, 0)
        if pr('pressed', 'SHIFT') then
            for i, v in pairs(charData)do
                if i == curObjects[curObj] then
                    if pr("pressed", "RIGHT") then
                        charData[curObjects[curObj]]['camOffsets'].x = charData[curObjects[curObj]]['camOffsets'].x + preferences.defaultSpeed+1
                    end
                    if pr("pressed", "LEFT") then
                        charData[curObjects[curObj]]['camOffsets'].x = charData[curObjects[curObj]]['camOffsets'].x + (preferences.defaultSpeed+1) * -1
                    end
                    if pr("pressed", "UP") then
                        charData[curObjects[curObj]]['camOffsets'].y = charData[curObjects[curObj]]['camOffsets'].y + (preferences.defaultSpeed+1) * -1
                    end
                    if pr("pressed", "DOWN") then
                        charData[curObjects[curObj]]['camOffsets'].y = charData[curObjects[curObj]]['camOffsets'].y + preferences.defaultSpeed+1
                    end
                    if charData[curObjects[curObj]]['camOffsets'] == nil then
                        charData[curObjects[curObj]]['camOffsets'] = {
                            y = getProperty('camFollow.y'),
                            x = getProperty('camFollow.x')
                        }
                    else
                        if getProperty('camFollow.y') ~= charData[curObjects[curObj]]['camOffsets'].y or getProperty('camFollow.x') ~= charData[curObjects[curObj]]['camOffsets'].x then
                            setQuick('camFollow', charData[curObjects[curObj]]['camOffsets'].x, charData[curObjects[curObj]]['camOffsets'].y)
                        end
                    end
                end
            end
        else
            if pr("pressed", "RIGHT") then
                move("camFollow", (preferences.defaultSpeed+1), 0)
            end
            if pr("pressed", "LEFT") then
                move("camFollow", (preferences.defaultSpeed+1) * -1, 0)
            end
            if pr("pressed", "DOWN") then
                move("camFollow", 0, (preferences.defaultSpeed+1))
            end
            if pr("pressed", "UP") then
                move("camFollow", 0, (preferences.defaultSpeed+1)* -1)
            end
        end
        if pr("justPressed", "I") then
            zoomCam(preferences.defaultSpeed / 100)
        end
        if pr("justPressed", "O") then
            zoomCam((preferences.defaultSpeed / 100) * -1)
        end

        if pr("justPressed", preferences.Speed) then
            changeS(1)
        end
        if pr("justPressed", "L") then
            changeS(-1)
        end

        if pr("justPressed", "T") then
            changeO(-1)
        end
        if pr("justPressed", "Y") then
            changeO(-1)
        end

        if pr("justPressed", "P") then
            isPixelStage = not isPixelStage
        end

        if pr("justPressed", "X") then
            if menuCheck() and not _OnMenu.onInfo then
                restartSong(true)
            end
        end
        if pr("justPressed", "ESCAPE") then
            if menuCheck() and not _OnMenu.onInfo then
                _OnMenu.onExit = true
                _Sections['ESCAPE'].open()
            end
        end
        if pr("justPressed", "ENTER") then
            if menuCheck() and not _OnMenu.onInfo then
                Stage.Save:Lua()
                Stage.Save:Json()
                debugPrint(stageTxt..' Has Been Saved, Thank You For Using Cherry\'s Stage Editor!')
                playSound('confirmMenu')
            end
        end
        if pr("justPressed", "ESCAPE") then
            for _, _s in pairs(_Sections) do
                if _OnMenu[_s.menu] == true and not _OnMenu['onExit'] then
                   _s.close()
                   Button[_s.from]["open"]()
                   setProperty('extraInfo.visible', false)
                   setObjectCamera('info', 'other')
                end
            end
        end
        if _OnMenu.onInfo then -- no dont even ask
            if tonumber(_TypeStuff._angle) ~= nil then
                setProperty(curObjects[curObj]..'.angle', _TypeStuff._angle)
            else
                setProperty(curObjects[curObj]..'.angle', getProperty(curObjects[curObj]..'.angle'))
            end
            if tonumber(_TypeStuff._order) ~= nil then
                setObjectOrder(curObjects[curObj], _TypeStuff._order)
            else
                setObjectOrder(curObjects[curObj], getObjectOrder(curObjects[curObj]))
            end
            if tonumber(_TypeStuff._ScrollX) ~= nil then
                setProperty(curObjects[curObj]..'.scrollFactor.x', _TypeStuff._ScrollX)
            else
                setProperty(curObjects[curObj]..'.scrollFactor.x', getProperty(curObjects[curObj]..'.scrollFactor.x'))
            end
            if tonumber(_TypeStuff._ScrollY) ~= nil then
                setProperty(curObjects[curObj]..'.scrollFactor.y', _TypeStuff._ScrollY)
            else
                setProperty(curObjects[curObj]..'.scrollFactor.y', getProperty(curObjects[curObj]..'.scrollFactor.y'))
            end
            if tonumber(_TypeStuff._ScaleX) ~= nil then
                setProperty(curObjects[curObj]..'.scale.x', _TypeStuff._ScaleX)
            else
                setProperty(curObjects[curObj]..'.scale.x', getProperty(curObjects[curObj]..'.scale.x'))
            end
            if tonumber(_TypeStuff._ScaleY) ~= nil then
                setProperty(curObjects[curObj]..'.scale.y', _TypeStuff._ScaleY)
            else
                setProperty(curObjects[curObj]..'.scale.y', getProperty(curObjects[curObj]..'.scale.y'))
            end
            setProperty(curObjects[curObj]..'.alpha', tonumber(_TypeStuff._alpha) ~= nil and tonumber(_TypeStuff._alpha) or getProperty(curObjects[curObj]..'.alpha'))
        end
    end
end) if not pep then debugPrint(si) end
end

-- [Saving the stage woohoo] --

function Stage.Save:Lua()
    local stageData = {}
    stageData = newObjects

    local src = "local DataDDS = {\n isPixelStage = "..tostring(isPixelStage)..",\n defaultZoom = "..tostring(defaultZoom).. "}\n local stageData = ".. tableToStr(stageData, true) .. '\n local charData ='..tableToStr(charData, true) .. [==[

--[--------------------------------------------------------------------]--

function loadData()
    for _s, _d in pairs(stageData) do
        if not _d.isText then
            if not _d.isGraphic then
                if not _d.animated then
                    makeLuaSprite(_s, _d.image, _d.x, _d.y)
                else
                    makeAnimatedLuaSprite(_s, _d.image, _d.x, _d.y)
                    for _, a in pairs(_d.animations) do
                        addAnimationByPrefix(_s, _, a.animation, a.FPS, a.loop)
                    end
                end
            else
                makeLuaSprite(_s, "", _d.x, _d.y)
                makeGraphic(_s, _d.width, _d.height, _d.hex)
            end
            addLuaSprite(_s, true)
        else
            makeLuaText(_s, _d.text, 0, _d.x, _d.y)
            setTextSize(_s, _d.size)
            setTextColor(_s, _d.hex)
            addLuaText(_s, true)
        end
        setObjectCamera(_s, _d.camera)
        setScrollFactor(_s, _d.scrollX, _d.scrollY)
        setProperty(_s..'.flipX', _d.flipX)
        setProperty(_s..'.flipY', _d.flipY)
        setProperty(_s..'.alpha', _d.alpha)
        setProperty(_s..'.visible', _d.visible)
        setProperty(_s..'.scale.x', _d.scaleX)
        setProperty(_s..'.scale.y', _d.scaleY)
        setObjectOrder(_s, _d.order)
    end
end

function loadCharData()
    for _s, _d in pairs(charData) do
        setScrollFactor(_s, _d.scrollX, _d.scrollY)
        setProperty(_s..'.flipX', _d.flipX)
        setProperty(_s..'.flipY', _d.flipY)
        setProperty(_s..'.alpha', _d.alpha)
        setProperty(_s..'.angle', _d.angle)
        setProperty(_s..'.visible', _d.visible)
        setProperty(_s..'.scale.x', _d.scaleX)
        setProperty(_s..'.scale.y', _d.scaleY)
        setObjectOrder(_s, _d.order)
    end
end

function onCreate()
    loadData()
end

function onCreatePost()
    loadCharData()
end

-- Made By Cherif's Stage Editor
        
return {stageData, charData, DataDDS}

]==]

    local path = 'mods/stages/'..stageTxt..'.lua'
    local luaFile = io.open(path, 'wb')
    luaFile:write(src)
    luaFile:close()
end

function Stage.Save:Json()
    local yay
    if isLoadedNone then
        yay = 0
    else
        yay = 350
    end
    local stjs = [==[
{
    "directory" : "",
    "defaultZoom": ]==]..tostring(defaultZoom)..','..
    "\n\"isPixelStage\":".. tostring(isPixelStage)..','..

           "\n\n\"boyfriend\": ["..getProperty('boyfriend.x').. ', '..getProperty('boyfriend.y')-yay.."],"..
           "\n\"girlfriend\": ["..getProperty('gf.x').. ', '..getProperty('gf.y').."],"..
           "\n\"opponent\": ["..getProperty('dad.x').. ', '..getProperty('dad.y').."],\n"..
           "\n\"camera_boyfriend\": ["..(charData['boyfriend']['camOffsets'].x)-(getMidpointX('boyfriend')-100)..', '..(charData['boyfriend']['camOffsets'].y)-(getMidpointY('boyfriend')-100).."],"..
           "\n\"camera_opponent\": ["..(charData['dad']['camOffsets'].x)-(getMidpointX('dad')+150)..', '..(charData['dad']['camOffsets'].y)-(getMidpointY('dad')-100).."],"..
           "\n\"camera_girlfriend\": ["..charData['gf']['camOffsets'].x..', '..charData['gf']['camOffsets'].y.."]"..
    "\n}\n"

    local path = 'mods/stages/'..stageTxt..'.json'
    local jsonFile = io.open(path, 'wb')
    jsonFile:write(stjs)
    jsonFile:close()
end


-- [] --
function onGameOver()
    return Function_Stop;
end
-- [] --

function autoSave()
    if autoSaving then
        Stage.Save:Json()
        Stage.Save:Lua()
        runTimer('autoSave', 3)
    end
end

---------------------------------------- 

-- [Cherif's Tween Thing] --

local tweeners = {}

function doTween(typis, tagg, var, val, dur, ease, typ, func, count)
    count = count or 0
    typ = typ or "persist"
    func = func or function()
            return "ok"
        end
    if string.lower(typ) == "backwards" then
        _G["doTween" .. typis](tagg, var, getProperty(var .. "." .. string.lower(typis)), dur, ease)
        setProperty(var .. "." .. string.lower(typis), val)
    else
        _G["doTween" .. typis](tagg, var, val, dur, ease)
    end
    
    tweeners[tagg .. "Data"] = {
        twnType = typis,
        tag = tagg,
        variable = var,
        value = val,
        duration = dur,
        ease = ease,
        FlxType = typ,
        pastVal = getProperty(var .. "." .. string.lower(typis)),
        onComplete = func,
        Repeat = count,
        Repeated_Times = 0
    }
end


function onTweenCompleted(tag)
    local pe, su =
        pcall(
        function()
            for _, q in pairs(tweeners) do
                if tag == q.tag then
                    if string.lower(q.FlxType) == "oneshot" then
                        table.remove(tweeners, tablefind(tweeners, tag .. "Data"))
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "pingpong" then
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "looping" then
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                        q.onComplete()
                    end
                    if string.lower(q.FlxType) == "persist" or string.lower(q.FlxType) == "backwards" then
                        q.onComplete()
                        q.finished = true
                    end
                end
                --pingpong
                if q.Repeat == 0 then
                    if tag == q.tag .. "BACK" then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "FORTH", q.variable, q.value, q.duration, q.ease)
                    end
                    if tag == q.tag .. "FORTH" then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                    end
                else
                    if tag == q.tag .. "BACK" and q.Repeated_Times ~= q.Repeat then
                        q.Repeated_Times = q.Repeated_Times + 1
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "FORTH", q.variable, q.value, q.duration, q.ease)
                    end
                    if tag == q.tag .. "FORTH" and q.Repeated_Times ~= q.Repeat then
                        q.onComplete()
                        _G["doTween" .. q.twnType](q.tag .. "BACK", q.variable, q.pastVal, q.duration, q.ease)
                    end
                end

                if q.Repeat == 0 then
                    if tag == q.tag .. "LOOP" then
                        q.onComplete()
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                    end
                else
                    if tag == q.tag .. "LOOP" and q.Repeated_Times ~= q.Repeat then
                        q.Repeated_Times = q.Repeated_Times + 1
                        q.onComplete()
                        setProperty(q.variable .. "." .. string.lower(q.twnType), q.pastVal)
                        _G["doTween" .. q.twnType](q.tag .. "LOOP", q.variable, q.value, q.duration, q.ease)
                    end
                end
            end
        end
    )
    if not pe then
        debugPrint(su)
    end
end

local catFlip = false
function kittyGlow()
    playMusic('kitiGo', 1)
    makeQuickSprite('vl', 'cats/bglol', 'hud', true)
    makeQuickSprite('vl2', 'cats/bg2lol', 'hud', true)
    setQuick('vl2', 0, getProperty('vl.height') * -1)
    makeQuickSprite('clod', 'cats/cloud', 'other', true)
    scaleObject('clod', 0.4, 0.4)
    screenCenter('clod')
    setProperty('clod.y', getProperty('clod.y')+1000)
    makeQuickSprite('kity', 'cats/kiti', 'other', true)
    screenCenter('kity', 'x')
    setProperty('kity.y', 400)
    makeQuickSprite('guhhh', 'cats/guh', 'other', true)
    setQuick('guhhh', 400, 1000)
    runTimer('omgTmr', 43)
    doTween(
        "Y",
        "omg",
        "kity.scale",
        0.8,
        0.4,
        "circIn",
        "looping",
        function()
            catFlip = not catFlip
            setProperty("kity.flipX", catFlip)
            setProperty("kity2.flipX", catFlip)
        end
    )
    runTimer('firstTimer', 13.8)
    runTimer('secondTimer', 23)
    runTimer('thirdTimer', 25)
    runTimer('betweenTimer', 20)
end

function onTimerCompleted(t)
    if t == "omgTmr" then
        doTween("Y", 'huh', 'guhhh', -1000, 6, 'smoothStepIn', 'persist')
    end
    if t == 'firstTimer' then
        doTween("Y", "kity2Twn:1", "kity2", 400, 1, "smoothStepInOut")
        doTween("Y", "kityTwn:1", "kity", 400, 1, "smoothStepInOut")
        makeQuickSprite("kity2", "cats/kiti", "other", true)
        setProperty("kity2.y", getProperty("kity.y"))
        setProperty("kity2.x", getProperty("kity.x") + 100)
        setProperty("kity.x", getProperty("kity.x") - 100)
        doTween('Y', "wyw", 'kity2.scale', 0.8, 0.4, "circIn", "looping")
    end
    if t == 'secondTimer' then
        doTween("Y", "cloudTwn:3", "clod", -290, 1, "quintOut", "persist")
        doTween("Y", "kityTwn:2", "kity", -250, 1, "quintOut", "persist")
        doTween("Y", "kity2Twn:2", "kity2", -250, 1, "quintOut", "persist")
        -- doTween("Y", "cloudTwn", "clod", 400, 0.15, "smoothStepInOut")
    end
    if t == 'thirdTimer' then
        doTween("Y", "cloudTwn:4", "clod", 400, 1.4, "quintOut", "persist")
        doTween("Y", "kity2Twn:3", "kity2", 400, 0.6, "smoothStepInOut")
        doTween("Y", "kityTwn:3", "kity", 400, 0.6, "smoothStepInOut")
        doTween("Y", "vl2Twn:2", "vl2", 0, 0.4, "smoothStepIn", "persist")
        doTween("Y", "vlTwn:2", "vl", 1000, 0.7, "smoothStepIn", "persist")
        makeLuaSprite("lee2", "cats/lee", 1000, 0)
        addLuaSprite("lee2")
        setObjectCamera("lee2", "other")
        makeLuaSprite("lee", "cats/lee", 100, 0)
        addLuaSprite("lee")
        setObjectCamera("lee", "other")
        doTween("Y", "oka", "lee2.scale", 0.9, 0.38, "circOut", "looping")
        doTween(
            "Y",
            "oka2",
            "lee.scale",
            0.9,
            0.38,
            "circOut",
            "looping",
            function()
                setProperty("lee.flipX", not getProperty("lee.flipX"))
                setProperty("lee2.flipX", not getProperty("lee2.flipX"))
            end
        )
    end
    if t == 'betweenTimer' then
        doTween("Y", "xxx", "clod", getProperty("kity.y"), 0.15, "smoothStepInOut")
        doTween("X", "cloudTwn:2", "clod.scale", 0.48, 0.2, "bounceOut", "oneshot")
    end
    if t == 'autoSave' then
        autoSave()
    end
end