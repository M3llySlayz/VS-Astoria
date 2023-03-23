package;

import flixel.util.FlxGradient;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxGradient;
import FloatToInt;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Continue', 'Retry', 'Options', 'Change Difficulty', 'Modifiers','Quit'];
	var difficultyChoices = [];
	var curSelected:Int = 0;
	var quitting:Array<String> = ['Yes', 'No'];
	var restartItems:Array<String> = ['Retry', 'Options', 'Change Difficulty', 'Modifiers', 'Quit'];

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;
	private var guy = new Character(2000, 700, PlayState.SONG.player2, true);
	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		if(CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		/*shoulda seen that comin tbh
		switch(ClientPrefs.pauseMusic){
			case 'Waiting' | 'Waiting (Impatient)' | 'Confront':
				Conductor.changeBPM(240);
			case 'Bounce':
				Conductor.changeBPM(170);
			case 'Adventure':
				Conductor.changeBPM(124);
			case 'Construct':
				Conductor.changeBPM(206);
			case 'Loop':
				Conductor.changeBPM(100);
		}*/

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var swagShader:ColorSwap = null;
		var titlestatebg:FlxBackdrop;
		swagShader = new ColorSwap();
		titlestatebg = new FlxBackdrop(Paths.image('loading'), XY);
		titlestatebg.scrollFactor.set(0.2, 0);
		titlestatebg.velocity.set(200, 110);
		titlestatebg.updateHitbox();
		titlestatebg.alpha = 0;
		titlestatebg.screenCenter(X);
		add(titlestatebg);
		titlestatebg.shader = swagShader.shader;

		var strip:FlxSprite = new FlxSprite(-666).loadGraphic(Paths.image('pauseScreenStrip'));
		strip.scrollFactor.set();
		add(strip);

		var strip2:FlxSprite = new FlxSprite(-666).loadGraphic(Paths.image('pauseScreenStripWhite'));
		strip2.scrollFactor.set();
		

		//sets the color of the strip based on opponent character
		switch (PlayState.SONG.player2){
		case 'AM' | 'AM-New' | 'AM-Newer' | 'AM-New-Rasis' | 'AM-Head' | 'AMM':
			strip2.color = 0xFFFF00FF;
			//FlxGradient.overlayGradientOnFlxSprite(strip2, strip2.width, strip2.height, [0xFFB108B1, 0xFFFF00FF], 0, 0, 0, 180, true);
		case 'AM-Red' | 'AM-Red-New':
			strip2.color = 0xFFFF0000;
		case 'Brittany' | 'Brittany-New' | 'Brittany-Newer':
			strip2.color = 0xFF452E00;
		case 'Voltage' | 'Voltage-New':
			strip2.color = 0xFF00FFFF;
		case 'SG' | 'SG-New' | 'SG-Newer':
			strip2.color = 0xFF808080;
		default:
			strip2.color = 0xFF025802;
		}

		add(strip2);

		add(guy);

		var songText:FlxText = new FlxText(20, 640, 0, "", 32);
		songText.text += 'Now Playing: ' + ClientPrefs.pauseMusic;
		songText.scrollFactor.set();
		songText.setFormat(Paths.font("vcr.ttf"), 32);
		songText.updateHitbox();
		add(songText);

		var composer:String = '';
		var composerColor:Array<Int> = [0xFFFFFFFF, 0xFF000000];

		switch(ClientPrefs.pauseMusic){
			case 'Bossfight' | 'Construct' | 'Confront' | 'Waiting (Impatient)':
				composer = 'Melly and BoyBot69';
				composerColor = [0xFFFF0000, 0xFF026902];
			case 'Adventure' | 'Bounce':
				composer = 'Melly';
				composerColor = [0xFFFF0000, 0xFFBD0000];
			case 'Waiting':
				composer = 'BoyBot69';
				composerColor = [0xFF3DD700, 0xFF026902];
		}

		var authorText:FlxText = new FlxText(20, 640+32, 0, "", 32);
		authorText.text += 'By ' + composer;
		authorText.scrollFactor.set();
		authorText.setFormat(Paths.font("vcr.ttf"), 32);
		authorText.drawFrame();
		authorText.updateHitbox();
		//authorText.color = composerColor;

		//var gradientText = new FlxSprite();
		//var gradient = FlxGradient.createGradientFlxSprite(authorText.frameWidth, authorText.frameHeight, composerColor);
		//gradientText.alphaMask(gradient.framePixels, authorText.framePixels);
		add(authorText);
		//add(gradientText);

		//but what is composer and composerColor you ask?
		

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Times you've died: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		songText.alpha = 0;
		authorText.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		songText.x = FlxG.width - (songText.width + 20);
		authorText.x = FlxG.width - (authorText.width + 20);

		FlxTween.tween(titlestatebg, {alpha: 0.5}, 0.4, {ease: FlxEase.linear});
		FlxTween.tween(strip, {x: -300}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(strip2, {x: -375}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(guy, {x: FlxG.width - (guy.width + 20), y: FlxG.height - (guy.height - 75)}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		if (ClientPrefs.pauseMusic != 'None'){
			FlxTween.tween(songText, {alpha: 1, y: songText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
			FlxTween.tween(authorText, {alpha: 1, y: authorText.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.1});
		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{

		cantUnpause -= elapsed;
		if (pauseMusic.volume < 1)
			pauseMusic.volume += 0.05 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode))
		{
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();

			}else if (menuItems == quitting){
				switch (daSelected){
					case "Yes":
						quitSong();
					case "No":
						menuItems = menuItemsOG;
						FlxG.sound.play(Paths.sound('cancelMenu'), 1);
						regenMenu();
				}
				
			}

			switch (daSelected)
			{
				case "Continue":
					FlxG.sound.play(Paths.sound('confirmMenu'), 0.3);
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					deleteSkipTimeText();
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Retry":
					restartSong();
				case "Options":
					LoadingState.loadAndSwitchState(new options.PauseOptionsState()); //made specific pause option states cause of stuff for later
				case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "Modifiers":
					menuItems = restartItems;
					guy.alpha = 0;
					regenMenu();
					openSubState(new GameplayChangersSubstate());
				case "Quit":
					switch (ClientPrefs.quitMethod){
						case 'Quick Confirm':
							if (PlayState.chartingMode){
								quitSong();
							} else {
								menuItems = quitting;
								FlxG.sound.play(Paths.sound('pauseMenu'), 0.6);
								regenMenu();
							}
						case 'Normal':
							quitSong();
						case 'Fancy Confirm':
							PlayState.deathCounter = 0;
							PlayState.seenCutscene = false;
							MusicBeatState.switchState(new SongExitState());
							PlayState.changedDifficulty = false;
							PlayState.chartingMode = false;
							PlayState.cancelMusicFadeTween();
							WeekData.loadTheFirstEnabledMod();
						}
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	public static function quitSong()
	{
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;

		WeekData.loadTheFirstEnabledMod();
		if(PlayState.isStoryMode) {
			MusicBeatState.switchState(new StoryMenuState());
		} else {
			MusicBeatState.switchState(new FreeplayState());
		}
		PlayState.cancelMusicFadeTween();
		if (!TitleState.astoreckless){
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		} else {
			FlxG.sound.playMusic(Paths.music('astoreckless'));
		}
		PlayState.changedDifficulty = false;
		PlayState.chartingMode = false;
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		if (guy.alpha == 0) guy.alpha = 1;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}else if (menuItems[i] == 'Quit'){

			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
	override function beatHit() {
		super.beatHit();
		
		guy.animation.play('idle', true);
	} 
}
