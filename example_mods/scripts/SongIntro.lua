--easy script configs
IntroTextSize = 20	--Size of the text for the Now Playing thing.
IntroSubTextSize = 30 --size of the text for the Song Name.
IntroTagWidth = 15	--Width of the box's tag thingy.
--easy script configs



--actual script
function onCreate()

--author names
if songName == 'I' then
	author = 'Bruhba (Friday Night Voltex)\nCovered by Melly'
	IntroAuthorSize = 13
elseif songName == 'Extreme' then
	author = 'JB (VS. JB)\nRemixed by Melly'
	IntroAuthorSize = 17
elseif songName == 'Knockout' then
	author = 'Orenji Music (Indie Cross)\nCovered by Melly'
	IntroAuthorSize = 17
elseif songName == 'Pixel' then
	author = 'TheInnuendo (Lullaby)\nRemixed by Melly'
	IntroAuthorSize = 17
elseif songName == 'Shuriken Fight' then
	author = 'Redsty P\nCovered by Melly'
	IntroAuthorSize = 17
elseif songName == 'Bestie Blitz' then
	author = 'KrystalComposer (Funk Mix)\nCovered by Melly'
	IntroAuthorSize = 17
elseif songName == 'Shop' then
	close(true)
else
	author = 'Melly'
	IntroAuthorSize = 25
end

--colors
if dadName == 'AM' or dadName == 'AM-New' or dadName == 'AMM' or dadName == 'AM-New-rasis' or dadName == 'AMReal' or dadName == 'AM-Head'
or songName == 'Stellar' or songName == 'Hype' or songName == 'Amazing' or songName == 'I' or songName == 'Amazing Meme' or songName == 'Bro' or songName == 'Pixel' then
	IntroTagColor = 'ff00ec'
elseif dadName == 'AM-Red' or dadName == 'AM-Red-New'
or songName == 'RED' or songName == 'Extreme' then
	IntroTagColor = 'ff0000'
elseif dadName == 'SG' or dadName == 'SG-New' or dadName == 'SG-Newer'
or songName == 'Shuriken Fight' or songName == 'Sing' or songName == 'Vibe' then
	IntroTagColor = '626262'
elseif dadName == 'Voltage' or dadName == 'Voltage-New'
or songName == 'Charged' or songName == 'Rain Check' or songName == 'Storm Safety' or songName == 'Guitar' then
	IntroTagColor = '00ffff'
elseif dadName == 'Brittany' or dadName == 'Brittany-New'
or songName == 'Hey' or songName == 'Settle Down' or songName == 'Cool Beans' then
	IntroTagColor = '927D0F'
elseif dadName == 'Donut-Man-New' or dadName == 'Donut-Man' then
	IntroTagColor = '603E00'
else
	IntroTagColor = 'ff0000'
end
	--the tag at the end of the box
	makeLuaSprite('JukeBoxTag', 'empty', -305-IntroTagWidth, 15)
	makeGraphic('JukeBoxTag', 300+IntroTagWidth, 100, IntroTagColor)
	setObjectCamera('JukeBoxTag', 'other')
	addLuaSprite('JukeBoxTag', true)

	--the box
	makeLuaSprite('JukeBox', 'empty', -305-IntroTagWidth, 15)
	makeGraphic('JukeBox', 300, 100, '000000')
	setObjectCamera('JukeBox', 'other')
	addLuaSprite('JukeBox', true)
	
	--the text for the "Now Playing" bit
	makeLuaText('JukeBoxText', 'Now Playing:', 300, -305-IntroTagWidth, 30)
	setTextAlignment('JukeBoxText', 'left')
	setObjectCamera('JukeBoxText', 'other')
	setTextSize('JukeBoxText', IntroTextSize)
	addLuaText('JukeBoxText')
	
	--text for the song name
	makeLuaText('JukeBoxSubText', songName, 300, -305-IntroTagWidth, 50)
	setTextAlignment('JukeBoxSubText', 'left')
	setObjectCamera('JukeBoxSubText', 'other')
	setTextSize('JukeBoxSubText', IntroSubTextSize)
	addLuaText('JukeBoxSubText')

	--author
	makeLuaText('JukeBoxAuthor', 'By '..author, 300, -305-IntroTagWidth, 80)
	setTextAlignment('JukeBoxAuthor', 'left')
	setObjectCamera('JukeBoxAuthor', 'other')
	setTextSize('JukeBoxAuthor', IntroAuthorSize)
	addLuaText('JukeBoxAuthor')
end

--motion functions
function onSongStart()
	-- Inst and Vocals start playing, songPosition = 0
	doTweenX('MoveInOne', 'JukeBoxTag', 0, 1, 'CircInOut')
	doTweenX('MoveInTwo', 'JukeBox', 0, 1, 'CircInOut')
	doTweenX('MoveInThree', 'JukeBoxText', 0, 1, 'CircInOut')
	doTweenX('MoveInFour', 'JukeBoxSubText', 0, 1, 'CircInOut')
	doTweenX('MoveInFive', 'JukeBoxAuthor', 0, 1, 'CircInOut')
	runTimer('JukeBoxWait', 3, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if tag == 'JukeBoxWait' then
		doTweenX('MoveOutOne', 'JukeBoxTag', -450, 1.5, 'CircInOut')
		doTweenX('MoveOutTwo', 'JukeBox', -450, 1.5, 'CircInOut')
		doTweenX('MoveOutThree', 'JukeBoxText', -450, 1.5, 'CircInOut')
		doTweenX('MoveOutFour', 'JukeBoxSubText', -450, 1.5, 'CircInOut')
		doTweenX('MoveOutFive', 'JukeBoxAuthor', -450, 1.5, 'CircInOut')
	end
end