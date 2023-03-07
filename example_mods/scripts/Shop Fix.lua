-- Thanks for downloading this! If you need help don't be afraid to DM me on Discord!
-- XooleDev#7217
-- You are allowed to use this for your mod as long as you credit me. (And I'd like to see the mod once it finishes.)
local SelectX = 990
local SelectY = -150

local CanSelect

SelectAmount = 1
SelectAmountBack = -1

local MaxProductLimit = 6
local MinProductLimit = 1

local ProductSelected
local ProductPrice

local GotProduct1
local GotProduct2
local GotProduct3
local GotProduct4
local GotProduct5
local GotProduct6

local TextNum

function onCreate()
	initSaveData('VS Astoria', 'Weeks')
	flushSaveData('VS Astoria')
	MoneyAmount = getDataFromSave('VS Astoria', 'Money') -- Do NOT Remove Money, unless you're changing all the variables.

	local Music = getPropertyFromClass('ClientPrefs', 'shopMusic')

	if songName == 'Shop' then
		function onStartCountdown()
			if not allowCountdown then
				return Function_Stop
			end
		
			if allowCountdown then
				return Function_Continue
			end
		end
		playMusic(Music, 0.8, true)

		setProperty('camHUD.visible', false)
		makeLuaSprite('ShopControls', 'ui/shopinfo', -40, -230)
		addLuaSprite('ShopControls', true)
		setScrollFactor('ShopControls', 1, 1);

		if lowQuality then
			makeLuaSprite('ShopProducts', 'ui/ShopProducts', 800, -100)
		else
			makeLuaSprite('ShopProducts', 'ui/ShopProductsNew', 800, -100)
		end
		addLuaSprite('ShopProducts', true)
		setScrollFactor('ShopProducts', 1, 1);
		
		makeLuaSprite('ProductAbout', 'ui/ProductAbout', 910, 720)
		addLuaSprite('ProductAbout', true)
		setScrollFactor('ProductAbout', 1, 1);

		makeLuaText('ProductsDescription', 'Hey! Wanna buy somethin?', 0, 610, 750)
		setObjectCamera('ProductsDescription', 'game')
		setTextFont('ProductsDescription', 'NotoSans-Regular')
		setTextSize('ProductsDescription', 46)
		addLuaText('ProductsDescription', true)

		makeLuaText('ProductPriceText', '???', 0, 1600, 750)
		setObjectCamera('ProductPriceText', 'game')
		setTextFont('ProductPriceText', 'NotoSans-Regular')
		setTextSize('ProductPriceText', 46)
		addLuaText('ProductPriceText', true)

		makeLuaText('PlayersMoney', '???', 0, 610, 800)
		setObjectCamera('PlayersMoney', 'game')
		setTextFont('PlayersMoney', 'NotoSans-Regular')
		setTextSize('PlayersMoney', 46)
		addLuaText('PlayersMoney', true)

		ProductSelected = 0

		return Function_Continue;
	end
end

function onUpdate()
	if songName == 'Shop' then
		if keyJustPressed('pause') then
			exitMenu()
		end

		GotProduct1 = getDataFromSave('VS Astoria', 'GotProduct1')
		GotProduct2 = getDataFromSave('VS Astoria', 'GotProduct2')
		GotProduct3 = getDataFromSave('VS Astoria', 'GotProduct3')
		GotProduct4 = getDataFromSave('VS Astoria', 'GotProduct4')
		GotProduct5 = getDataFromSave('VS Astoria', 'GotProduct5')
		GotProduct6 = getDataFromSave('VS Astoria', 'GotProduct6')

		setTextString('ProductPriceText', 'Cost: '..ProductPrice)
		setTextString('PlayersMoney', '$'..MoneyAmount)

		if MoneyAmount == 'Money' then
			MoneyAmount = 0
		end

		if keyboardJustPressed('SPACE') then
			if MoneyAmount >= ProductPrice then
				if ProductSelected == 1 then -- 1
					if GotProduct1 == 1 then
						
					else
						GotProduct1 = 1
						BuyProduct1()
					end
				elseif ProductSelected == 2 then
					if GotProduct2 == 1 then

					else
						GotProduct2 = 1
						BuyProduct2()
					end
				elseif ProductSelected == 3 then
					if GotProduct3 == 1 then

					else
						GotProduct3 = 1
						BuyProduct3()
					end
				elseif ProductSelected == 4 then
					if GotProduct4 == 1 then

					else
						GotProduct4 = 1
						BuyProduct4()
					end
				elseif ProductSelected == 5 then
					if GotProduct5 == 1 then

					else
						GotProduct5 = 1
						BuyProduct5()
					end
				elseif ProductSelected == 6 then
					if GotProduct6 == 1 then

					else
						GotProduct6 = 1
						BuyProduct6()
					end
				end
			else
				playSound('YouCant');
			end
		end

		if keyboardJustPressed('RIGHT') or keyboardJustPressed('LEFT') then

			if ProductSelected >= MaxProductLimit and keyboardJustPressed('RIGHT') then
				SelectX = 1090
				SelectY = -70
				ProductSelected = 1
			elseif ProductSelected <= MinProductLimit and keyboardJustPressed('LEFT') then
				SelectX = 1450
				SelectY = 400
				ProductSelected = 6
			else
				if keyboardJustPressed('RIGHT') then
					ProductSelected = ProductSelected + SelectAmount
				end
				if keyboardJustPressed('LEFT') then
					ProductSelected = ProductSelected + SelectAmountBack
				end
			end
			if ProductSelected == 1 then
				ProductPrice = 350
				SelectX = 1090
				SelectY = -70
			elseif ProductSelected == 2 then
				ProductPrice = 300
				SelectX = 1430
				SelectY = -110
			elseif ProductSelected == 3 then
				ProductPrice = 300
				SelectX = 1760
				SelectY = -60
			elseif ProductSelected == 4 then
				ProductPrice = 255
				SelectX = 1270
				if lowQuality then
					SelectY = 130
				else
					SelectY = 160
				end
			elseif ProductSelected == 5 then
				ProductPrice = 350
				SelectX = 1660
				SelectY = 190
			elseif ProductSelected == 6 then
				ProductPrice = 500
				SelectX = 1450
				SelectY = 400
			end
			removeLuaSprite('selectIcon')
			playSound('select');
			makeLuaSprite('selectIcon', 'ui/Select', SelectX, SelectY)
			addLuaSprite('selectIcon', true)
		end
		if ProductSelected == 1 then
			setTextString('ProductsDescription', "Careful, it's sharp.")
		elseif ProductSelected == 2 then
			setTextString('ProductsDescription', "Want some headphones? I don't need 'em anymore.")
		elseif ProductSelected == 3 then
			setTextString('ProductsDescription', 'A replica I made with my 3D Printer.')
		elseif ProductSelected == 4 then
			setTextString('ProductsDescription', 'Heard you needed a new microphone.')
		elseif ProductSelected == 5 then
			setTextString('ProductsDescription', 'Got this one from an arcade down the road.')
		elseif ProductSelected == 6 then
			setTextString('ProductsDescription', 'You sure you want that?')
		end

		if GotProduct1 == 1 then
			
		else
			setDataFromSave('VS Astoria', 'GotProduct1', 0)
			saveFile('weeks/weekShuriken.json', [[
		{
			"songs": [
				[
					"Shuriken Fight",
					"sgnew",
					[
						73,
						73,
						73
					]
				]
			],
			"hiddenUntilUnlocked": true,
			"hideFreeplay": true,
			"weekBackground": "stage",
			"difficulties": "Hard, Insane",
			"weekCharacters": [
				"dad",
				"bf",
				"gf"
			],
			"storyName": "stop reading my files",
			"weekName": "Shuriken Fight",
			"freeplayColor": [
				146,
				113,
				253
			],
			"hideStoryMode": true,
			"weekBefore": "weekV",
			"startUnlocked": true
		}
			]])
		end
		if GotProduct2 == 1 then
			
		else
			saveFile('weeks/weekVibe.json', [[
				{
					"songs": [
						[
							"Vibe",
							"sgnew",
							[
								73,
								73,
								73
							]
						]
					],
					"hiddenUntilUnlocked": true,
					"hideFreeplay": true,
					"weekBackground": "stage",
					"difficulties": "Hard",
					"weekCharacters": [
						"dad",
						"bf",
						"gf"
					],
					"storyName": "stop reading my files",
					"weekName": "Vibe",
					"freeplayColor": [
						146,
						113,
						253
					],
					"hideStoryMode": true,
					"weekBefore": "weekV",
					"startUnlocked": true
				}
					]])
			end
			if GotProduct3 == 1 then

			else
				saveFile('weeks/weekBlitz.json', [[
					{
						"songs": [
							[
								"Bestie Blitz",
								"AMNew",
								[
									255,
									0,
									255
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": true,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "Bestie Blitz",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
				end
			if GotProduct4 == 1 then

			else
				saveFile('weeks/weekSing.json', [[
					{
						"songs": [
							[
								"Sing",
								"sgnew",
								[
									73,
									73,
									73
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": true,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "Sing",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
				end
			if GotProduct5 == 1 then
				
			else
				saveFile('weeks/weekI.json', [[
					{
						"songs": [
							[
								"I",
								"AMNew",
								[
									255,
									0,
									255
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": true,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "I",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
				end
			if GotProduct6 == 1 then
				
			else
				saveFile('weeks/weekMeme.json', [[
		{
			"storyName": "Oh god what have you unleashed",
			"difficulties": "Hard",
			"hideFreeplay": true,
			"weekBackground": "",
			"freeplayColor": [
				146,
				113,
				253
			],
			"weekBefore": "weekV",
			"startUnlocked": true,
			"weekCharacters": [
				"amm",
				"bf",
				""
			],
			"songs": [
				[
					"Amazing Meme",
					"AMM",
					[
						255,
						0,
						255
					]
				],
				[
					"Pixel",
					"AMM",
					[
						255,
						0,
						255
					]
				],
				[
					"Bro",
					"AMM",
					[
						255,
						0,
						255
					]
				]
			],
			"hideStoryMode": true,
			"weekName": "Amazing Meme",
			"hiddenUntilUnlocked": false
		}
						]])
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if keyJustPressed('pause') and songName == 'Shop' then
		exitMenu();
	end
end

function exitMenu()
	setDataFromSave('VS Astoria', 'Money', MoneyAmount)
	exitSong(true);
end

function onEndSong()
	playSound('chaching');
	if songName == 'Extreme' or songName == 'Shuriken Fight' or storyDifficulty == 1 then
		MoneyAmount = MoneyAmount + math.random(200, 250)
	elseif songName == 'Shuriken Fight' and storyDifficulty == 1 then
		MoneyAmount = MoneyAmount + math.random(300, 350)
	elseif songName == 'Storm Safety' then
	MoneyAmount = MoneyAmount + math.random(250, 300)
	else
	MoneyAmount = MoneyAmount + math.random(100, 150)
	end
	setDataFromSave('VS Astoria', 'Money', MoneyAmount)
end


function BuyProduct1()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign1', 'ui/sold', 1050, -30)
	scaleObject('SoldSign1', 2, 1.8)
	addLuaSprite('SoldSign1', true)
	setProperty('SoldSign1.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct1', 1)
	saveFile('weeks/weekShuriken.json', [[
		{
			"songs": [
				[
					"Shuriken Fight",
					"sgnew",
					[
						73,
						73,
						73
					]
				]
			],
			"hiddenUntilUnlocked": true,
			"hideFreeplay": false,
			"weekBackground": "stage",
			"difficulties": "Hard, Insane",
			"weekCharacters": [
				"dad",
				"bf",
				"gf"
			],
			"storyName": "stop reading my files",
			"weekName": "Shuriken Fight",
			"freeplayColor": [
				146,
				113,
				253
			],
			"hideStoryMode": true,
			"weekBefore": "weekV",
			"startUnlocked": true
		}
			]])
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end

function BuyProduct2()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign2', 'ui/sold', 1360, -30)
	scaleObject('SoldSign2', 2, 1.8)
	addLuaSprite('SoldSign2', true)
	setProperty('SoldSign2.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct2', 1)
	saveFile('weeks/weekVibe.json', [[
		{
			"songs": [
				[
					"Vibe",
					"sgnew",
					[
						73,
						73,
						73
					]
				]
			],
			"hiddenUntilUnlocked": true,
			"hideFreeplay": false,
			"weekBackground": "stage",
			"difficulties": "Hard",
			"weekCharacters": [
				"dad",
				"bf",
				"gf"
			],
			"storyName": "stop reading my files",
			"weekName": "Vibe",
			"freeplayColor": [
				146,
				113,
				253
			],
			"hideStoryMode": true,
			"weekBefore": "weekV",
			"startUnlocked": true
		}
			]])
end

function BuyProduct3()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign3', 'ui/sold', 1700, -30)
	scaleObject('SoldSign3', 2, 1.8)
	addLuaSprite('SoldSign3', true)
	setProperty('SoldSign3.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct3', 1)
	saveFile('weeks/weekBlitz.json', [[
					{
						"songs": [
							[
								"Bestie Blitz",
								"AMNew",
								[
									255,
									0,
									255
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": false,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "Bestie Blitz",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end

function BuyProduct4()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign4', 'ui/sold', 1190, 240)
	scaleObject('SoldSign4', 2, 1.8)
	addLuaSprite('SoldSign4', true)
	setProperty('SoldSign4.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct4', 1)
	saveFile('weeks/weekSing.json', [[
					{
						"songs": [
							[
								"Sing",
								"sgnew",
								[
									73,
									73,
									73
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": false,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "Sing",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end

function BuyProduct5()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign5', 'ui/sold', 1590, 240)
	scaleObject('SoldSign5', 2, 1.8)
	addLuaSprite('SoldSign5', true)
	setProperty('SoldSign5.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct5', 1)
	saveFile('weeks/weekI.json', [[
					{
						"songs": [
							[
								"I",
								"AMNew",
								[
									255,
									0,
									255
								]
							]
						],
						"hiddenUntilUnlocked": true,
						"hideFreeplay": false,
						"weekBackground": "stage",
						"difficulties": "Hard",
						"weekCharacters": [
							"dad",
							"bf",
							"gf"
						],
						"storyName": "stop reading my files",
						"weekName": "I",
						"freeplayColor": [
							146,
							113,
							253
						],
						"hideStoryMode": true,
						"weekBefore": "weekV",
						"startUnlocked": true
					}
						]])
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end

function BuyProduct6()
	playSound('chaching');
	MoneyAmount = MoneyAmount - ProductPrice

	makeLuaSprite('SoldSign6', 'ui/sold', 1390, 480)
	scaleObject('SoldSign6', 2, 1.8)
	addLuaSprite('SoldSign6', true)
	setProperty('SoldSign6.alpha', 0.5)

	setDataFromSave('vsa', 'GotProduct6', 1)
	saveFile('weeks/weekMeme.json', [[
		{
			"storyName": "Oh god what have you unleashed",
			"difficulties": "Hard",
			"hideFreeplay": false,
			"weekBackground": "",
			"freeplayColor": [
				146,
				113,
				253
			],
			"weekBefore": "weekV",
			"startUnlocked": true,
			"weekCharacters": [
				"amm",
				"bf",
				""
			],
			"songs": [
				[
					"Amazing Meme",
					"AMM",
					[
						255,
						0,
						255
					]
				],
				[
					"Pixel",
					"AMM",
					[
						255,
						0,
						255
					]
				],
				[
					"Bro",
					"AMM",
					[
						255,
						0,
						255
					]
				]
			],
			"hideStoryMode": false,
			"weekName": "Amazing Meme",
			"hiddenUntilUnlocked": false
		}
						]])
	-- Here you put in week stuff from SaveFile. Can't really show an example, so look at this.
	-- https://gamebanana.com/tuts/15414
	-- Make sure the one here is SHOWING in Freeplay, or in Story Mode if doing a week.
end