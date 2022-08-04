function onEvent(n,v1,v2)


	if n == 'Flash PNG' then

	   makeLuaSprite('cries', v2, cameraX - 1000, cameraY - 300);
	    addLuaSprite('cries', true);
		doTweenAlpha('flTw','cries',0,v1,'linear')
        playSound('boom', 1.2)
	end



end