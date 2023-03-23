function onCreate()
	-- background shit
	makeLuaSprite('bg', 'stages/store', -100, -400)
	addLuaSprite('bg')
	setScrollFactor('bg', 0.9, 0.9);
	scaleObject('bg', 4.5, 5.5);
	setProperty('bg.antialising', false);
end

function onCreatePost()
	if songName == 'Shop' then
		setProperty('timeTxt.visible', false);
		setProperty('iconP1.visible', false);
		setProperty('iconP2.visible', false);
		setProperty('healthBar.visible', false);
		setProperty('healthBarBG.visible', false);
		setProperty('scoreTxt.visible', false);
	end
end