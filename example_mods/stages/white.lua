function onCreate()
makeLuaSprite('flash', '', 0, 0);
makeGraphic('flash',1280,720,'ffffff')
  addLuaSprite('flash', false);
  setLuaSpriteScrollFactor('flash',0,0)
  setProperty('flash.scale.x',2)
  setProperty('flash.scale.y',2)
  setProperty('flash.alpha',0)
setProperty('flash.alpha',1)
end