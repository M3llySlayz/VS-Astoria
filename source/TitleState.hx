package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
// import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.addons.display.FlxBackdrop;

using StringTools;

typedef TitleData =
{
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var astoreckless:Bool = true;

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	#if TITLE_SCREEN_EASTER_EGG
	var easterEggKeys:Array<String> = [
		'' // 'SHADOW', 'RIVER', 'SHUBS', 'BBPANZU'
	];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	public static var updateVersion:String = '';
	

	override public function create():Void
	{
		Paths.clearUnusedMemory();

		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		// trace(path, FileSystem.exists(path));

		/*#if (polymod && !html5)
			if (sys.FileSystem.exists('mods/')) {
				var folders:Array<String> = [];
				for (file in sys.FileSystem.readDirectory('mods/')) {
					var path = haxe.io.Path.join(['mods/', file]);
					if (sys.FileSystem.isDirectory(path)) {
						folders.push(file);
					}
				}
				if(folders.length > 0) {
					polymod.Polymod.init({modRoot: "mods", dirs: folders});
				}
			}
			#end */
		/*
			if(!closedState) {
				trace('checking for update');
				var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");
				
				http.onData = function (data:String)
				{
					updateVersion = data.split('\n')[0].trim();
					var curVersion:String = MainMenuState.psychEngineVersion.trim();
					trace('version online: ' + updateVersion + ', your version: ' + curVersion);
					if(updateVersion != curVersion) {
						trace('versions arent matching!');
						mustUpdate = true;
					}
				}
				
				http.onError = function (error) {
					trace('error: $error');
				}
				
				http.request();
			}
			#end
		 */

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();


		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('funkin', 'Melly');

		ClientPrefs.loadPrefs();

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		#if TITLE_SCREEN_EASTER_EGG
		if (FlxG.save.data.psychDevsEasterEgg == null)
			FlxG.save.data.psychDevsEasterEgg = ''; // Crash prevention
		switch (FlxG.save.data.psychDevsEasterEgg.toUpperCase())
		{
			case 'SHADOW':
				titleJSON.gfx += 210;
				titleJSON.gfy += 40;
			case 'RIVER':
				titleJSON.gfx += 100;
				titleJSON.gfy += 20;
			case 'SHUBS':
				titleJSON.gfx += 160;
				titleJSON.gfy -= 10;
			case 'BBPANZU':
				titleJSON.gfx += 45;
				titleJSON.gfy += 100;
		}
		#end

		if (!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			// trace('LOADED FULLSCREEN SETTING!!');
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FOOLS
		PlayState.SONG = Song.loadFromJson('bro-hard', 'bro');
		LoadingState.loadAndSwitchState(new PlayState());
		#elseif FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		#if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode)
			{
				DiscordClient.shutdown();
			});
		}
		#end

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var titlestatebg:FlxBackdrop;
	function startIntro()
	{

		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
				diamond.persist = true;
				diamond.destroyOnNoUse = false;

				FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
					new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
				FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
					
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut; */

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (ClientPrefs.mainSong == 'Astoreckless'){
				astoreckless = true;
			}else{
				astoreckless = false;
			}
			if (FlxG.sound.music == null)
			{
				if (!astoreckless){
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				}else{
				FlxG.sound.playMusic(Paths.music('astoreckless'), 0);
				}

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}
		if (!astoreckless){
			Conductor.changeBPM(titleJSON.bpm);
		}else{
			Conductor.changeBPM(117);
		}

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();

		if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.length > 0 && titleJSON.backgroundSprite != "none")
		{
			bg.loadGraphic(Paths.image(titleJSON.backgroundSprite));
		}
		else
		{
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}

		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');

		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.setGraphicSize(Std.int(0.8));
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);

		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		switch (easterEgg.toUpperCase())
		{
			#if TITLE_SCREEN_EASTER_EGG
			case 'SHADOW':
				gfDance.frames = Paths.getSparrowAtlas('ShadowBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shadow Title Bump', 24);
				gfDance.animation.addByPrefix('danceRight', 'Shadow Title Bump', 24);
			case 'RIVER':
				gfDance.frames = Paths.getSparrowAtlas('RiverBump');
				gfDance.animation.addByIndices('danceLeft', 'River Title Bump', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'River Title Bump', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			case 'SHUBS':
				gfDance.frames = Paths.getSparrowAtlas('ShubBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shub Title Bump', 24, false);
				gfDance.animation.addByPrefix('danceRight', 'Shub Title Bump', 24, false);
			case 'BBPANZU':
				gfDance.frames = Paths.getSparrowAtlas('BBBump');
				gfDance.animation.addByIndices('danceLeft', 'BB Title Bump', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'BB Title Bump', [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
			case 'MEME':
				PlayState.SONG = Song.loadFromJson("amazing-meme", "mods/data");
				LoadingState.loadAndSwitchState(new PlayState());
			#end

			default:
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				// EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
				gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
		}
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;

		// background yo
		// don't forget to change it, weuz_ pls

		titlestatebg = new FlxBackdrop(Paths.image('loading'), 0.2, 0, true, true);
		titlestatebg.velocity.set(200, 110);
		titlestatebg.updateHitbox();
		titlestatebg.alpha = 0.5;
		titlestatebg.screenCenter(X);
		add(titlestatebg);
		titlestatebg.shader = swagShader.shader;

		add(gfDance);
		gfDance.shader = swagShader.shader;
		add(logoBl);
		logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		// trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path))
		{
			path = "mods/images/titleEnter.png";
		}
		// trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path))
		{
			path = "assets/images/titleEnter.png";
		}
		// trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path), File.getContent(StringTools.replace(path, ".png", ".xml")));
		#else
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 10);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 10);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logoBl.y = 700;
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 80}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// trace(logoBl.y);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	private static var playJingle:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
		var pressedBack:Bool = FlxG.keys.justPressed.ESCAPE || controls.BACK;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (pressedEnter)
			{
				if (titleText != null)
					titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				//FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();
				FlxTween.tween(logoBl, {y: -1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
				FlxTween.tween(gfDance, {y: 1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
				FlxTween.tween(titleText, {y: 1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
				FlxTween.tween(camera, {zoom: 3}, 3, {ease: FlxEase.backOut, type: ONESHOT});
				CoolUtil.cameraZoom(camera, 3, 3, FlxEase.backOut, ONESHOT);
				FlxG.sound.music.fadeOut();
				titlestatebg.velocity.set(400, 210);

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate)
					{
						//MusicBeatState.switchState(new OutdatedState());
					}
					else
					{
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				 FlxG.sound.play(Paths.music('titleShoot'), 0.4);
			}
			if (pressedBack)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new GameExitState());
				CoolUtil.cameraZoom(camera, 3, 3, FlxEase.backOut, ONESHOT);
			}
			// OLD EXIT:

			// if(pressedEscape) {
			// 	FlxTween.tween(logoBl, {y: -1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
			// 	FlxTween.tween(gfDance, {y: 1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
			// 	FlxTween.tween(titleText, {y: 1500}, 3, {ease: FlxEase.backInOut, type: ONESHOT});
			// 	FlxG.sound.music.fadeOut();
			// 	function Exit(timer:FlxTimer):Void
			// 	{
			// 		System.exit(0);
			// 	}
			// 	new FlxTimer().start(1.7, Exit, 0);
			// }

			#if TITLE_SCREEN_EASTER_EGG
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if (allowedKeys.contains(keyName))
				{
					easterEggKeysBuffer += keyName;
					if (easterEggKeysBuffer.length >= 32)
						easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					// trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys)
					{
						var word:String = wordRaw.toUpperCase(); // just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word))
						{
							// trace('YOOO! ' + word);
							if (FlxG.save.data.psychDevsEasterEgg == word)
								FlxG.save.data.psychDevsEasterEgg = '';
							else
								FlxG.save.data.psychDevsEasterEgg = word;
							FlxG.save.flush();

							FlxG.sound.play(Paths.sound('ToggleJingle'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {
								onComplete: function(twn:FlxTween)
								{
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							FlxG.sound.music.fadeOut();
							closedState = true;
							transitioning = true;
							playJingle = true;
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}


		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if (credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null && credGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
			logoBl.animation.play('bump', true);

		if (gfDance != null)
		{
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if (!closedState)
		{
			sickBeats++;
			
			switch (sickBeats)
			{
				case 2:
					createCoolText(['Made by'], 45);
				case 4:
					addMoreText('M3llySlayz', 45);
					addMoreText('JB', 45);
					addMoreText('BoyBot', 45);
				case 6:
					deleteCoolText();
					createCoolText(['Run', 'On'], 15);
				case 8:
					addMoreText('Psych Engine', 15);
				case 10:
					deleteCoolText();
					createCoolText(['Psych Engine by'], 45);
					addMoreText('Shadow Mario',45);
					addMoreText('RiverOaken',45);
					addMoreText('bbpanzu',45);
				case 12:
					curWacky = FlxG.random.getObject(getIntroTextShit());
					deleteCoolText();
					createCoolText([curWacky[0]]);
				case 14:
					addMoreText(curWacky[1]);
				case 16:
					deleteCoolText();
					if (astoreckless){
					curWacky = FlxG.random.getObject(getIntroTextShit());
					createCoolText([curWacky[0]]);
					}
				case 17: //ignore rn
					if (!astoreckless){
						addMoreText('FNF');
					}
				case 18:
					if (astoreckless){
					addMoreText(curWacky[1]);
					}else{
					addMoreText('VS');
					}
				case 19:
					if (!astoreckless){
					addMoreText('Astoria');
					}
				case 20:
					if (!astoreckless){
					deleteCoolText();
					}else{
					deleteCoolText();
					curWacky = FlxG.random.getObject(getIntroTextShit());
					createCoolText([curWacky[0]]);
					}
				case 22:
					if (astoreckless){
						addMoreText(curWacky[1]);
					}
				case 24:
					if (astoreckless){
						deleteCoolText();
						curWacky = FlxG.random.getObject(getIntroTextShit());
						createCoolText([curWacky[0]]);
					}
				case 26:
					if (astoreckless){
						addMoreText(curWacky[1]);
					}
				case 28:
					deleteCoolText();
					if (astoreckless){
					addMoreText('FNF');
					}
				// credTextShit.visible = true;
				case 29:
					if (astoreckless){
					addMoreText('VS');
					}
				// credTextShit.text += '\nNight';
				case 30:
					if (astoreckless){
					addMoreText('Astoria'); 
					}
					// credTextShit.text += '\nFunkin';
				case 31:
					if (astoreckless){
					skipIntro();
					}
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			if (playJingle) // Ignore deez
			{
				FlxTween.tween(logoBl, {y: -100}, 2, {ease: FlxEase.backOut, type: ONESHOT});
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxTween.tween(logoBl, {y: logoBl.y + 15}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
				});
				/*
					var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
					if (easteregg == null) easteregg = '';
					easteregg = easteregg.toUpperCase();

					var sound:FlxSound = null;
					switch(easteregg)
					{
						case 'RIVER':
							sound = FlxG.sound.play(Paths.sound('JingleRiver'));
						case 'SHUBS':
							sound = FlxG.sound.play(Paths.sound('JingleShubs'));
						case 'SHADOW':
							FlxG.sound.play(Paths.sound('JingleShadow'));
						case 'BBPANZU':
							sound = FlxG.sound.play(Paths.sound('JingleBB'));
						
						default: //Go back to normal ugly ass boring GF
							remove(ngSpr);
							remove(credGroup);
							FlxG.camera.flash(FlxColor.WHITE, 2);
							skippedIntro = true;
							playJingle = false;
							
							FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
							FlxG.sound.music.fadeIn(4, 0, 0.7);
							return;
					}

					transitioning = true;
					if(easteregg == 'SHADOW')
					{
						new FlxTimer().start(3.2, function(tmr:FlxTimer)
						{
							remove(ngSpr);
							remove(credGroup);
							FlxG.camera.flash(FlxColor.WHITE, 0.6);
							transitioning = false;
						});
					}
					else
					{
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 3);
						sound.onComplete = function() {
							FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
							FlxG.sound.music.fadeIn(4, 0, 0.7);
							transitioning = false;
						};
					}
				 */

				playJingle = false;
			}
			else // Default! Edit this one!!
			{
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);
				FlxTween.tween(logoBl, {y: -100}, 2, {ease: FlxEase.backOut, type: ONESHOT});
				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxTween.tween(logoBl, {y: logoBl.y + 15}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
				});

				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null)
					easteregg = '';
				easteregg = easteregg.toUpperCase();
				#if TITLE_SCREEN_EASTER_EGG
				if (easteregg == 'SHADOW')
				{
					FlxG.sound.music.fadeOut();
				}
				#end
			}
			skippedIntro = true;
		}
	}
}
