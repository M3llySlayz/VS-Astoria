package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import haxe.Json;
import haxe.format.JsonParser;
import PlayState;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.utils.Assets;

using StringTools;

typedef DialogueCharacterFile = {
	var image:String;
	var dialogue_pos:String;
	var no_antialiasing:Bool;

	var animations:Array<DialogueAnimArray>;
	var position:Array<Float>;
	var scale:Float;
}

typedef DialogueAnimArray = {
	var anim:String;
	var loop_name:String;
	var loop_offsets:Array<Int>;
	var idle_name:String;
	var idle_offsets:Array<Int>;
}

// Gonna try to kind of make it compatible to Forever Engine,
// love u Shubs no homo :flushedh4:
typedef DialogueFile = {
	var dialogue:Array<DialogueLine>;
}

typedef DialogueLine = {
	var portrait:Null<String>;
	var expression:Null<String>;
	var text:Null<String>;
	var boxState:Null<String>;
	var speed:Null<Float>;
	var sound:Null<String>;
}

class DialogueCharacter extends FlxSprite
{
	private static var IDLE_SUFFIX:String = '-IDLE';
	public static var DEFAULT_CHARACTER:String = 'bf';
	public static var DEFAULT_SCALE:Float = 0.7;
	public var jsonFile:DialogueCharacterFile = null;
	#if (haxe >= "4.0.0")
	public var dialogueAnimations:Map<String, DialogueAnimArray> = new Map();
	#else
	public var dialogueAnimations:Map<String, DialogueAnimArray> = new Map<String, DialogueAnimArray>();
	#end

	public var startingPos:Float = 0; //For center characters, it works as the starting Y, for everything else it works as starting X
	public var isGhost:Bool = false; //For the editor
	public var curCharacter:String = 'bf';
	public var skiptimer = 0;
	public var skipping = 0;
	public function new(x:Float = 0, y:Float = 0, character:String = null)
	{
		super(x, y);

		if(character == null) character = DEFAULT_CHARACTER;
		this.curCharacter = character;

		reloadCharacterJson(character);
		frames = Paths.getSparrowAtlas('dialogue/' + jsonFile.image);
		reloadAnimations();

		antialiasing = ClientPrefs.globalAntialiasing;
		if(jsonFile.no_antialiasing == true) antialiasing = false;
	}

	public function reloadCharacterJson(character:String) {
		var characterPath:String = 'images/dialogue/' + character + '.json';
		var rawJson = null;

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(characterPath);
		if (!FileSystem.exists(path)) {
			path = Paths.getPreloadPath(characterPath);
		}

		if(!FileSystem.exists(path)) {
			path = Paths.getPreloadPath('images/dialogue/' + DEFAULT_CHARACTER + '.json');
		}
		rawJson = File.getContent(path);

		#else
		var path:String = Paths.getPreloadPath(characterPath);
		rawJson = Assets.getText(path);
		#end
		
		jsonFile = cast Json.parse(rawJson);
	}

	public function reloadAnimations() {
		dialogueAnimations.clear();
		if(jsonFile.animations != null && jsonFile.animations.length > 0) {
			for (anim in jsonFile.animations) {
				animation.addByPrefix(anim.anim, anim.loop_name, 24, isGhost);
				animation.addByPrefix(anim.anim + IDLE_SUFFIX, anim.idle_name, 24, true);
				dialogueAnimations.set(anim.anim, anim);
			}
		}
	}

	public function playAnim(animName:String = null, playIdle:Bool = false) {
		var leAnim:String = animName;
		if(animName == null || !dialogueAnimations.exists(animName)) { //Anim is null, get a random animation
			var arrayAnims:Array<String> = [];
			for (anim in dialogueAnimations) {
				arrayAnims.push(anim.anim);
			}
			if(arrayAnims.length > 0) {
				leAnim = arrayAnims[FlxG.random.int(0, arrayAnims.length-1)];
			}
		}

		if(dialogueAnimations.exists(leAnim) &&
		(dialogueAnimations.get(leAnim).loop_name == null ||
		dialogueAnimations.get(leAnim).loop_name.length < 1 ||
		dialogueAnimations.get(leAnim).loop_name == dialogueAnimations.get(leAnim).idle_name)) {
			playIdle = true;
		}
		animation.play(playIdle ? leAnim + IDLE_SUFFIX : leAnim, false);

		if(dialogueAnimations.exists(leAnim)) {
			var anim:DialogueAnimArray = dialogueAnimations.get(leAnim);
			if(playIdle) {
				offset.set(anim.idle_offsets[0], anim.idle_offsets[1]);
				//trace('Setting idle offsets: ' + anim.idle_offsets);
			} else {
				offset.set(anim.loop_offsets[0], anim.loop_offsets[1]);
				//trace('Setting loop offsets: ' + anim.loop_offsets);
			}
		} else {
			offset.set(0, 0);
			trace('Offsets not found! Dialogue character is badly formatted, anim: ' + leAnim + ', ' + (playIdle ? 'idle anim' : 'loop anim'));
		}
	}

	public function animationIsLoop():Bool {
		if(animation.curAnim == null) return false;
		return !animation.curAnim.name.endsWith(IDLE_SUFFIX);
	}
}

// TO DO: Clean code? Maybe? idk
class DialogueBoxPsych extends FlxSpriteGroup
{
	var dialogue:Alphabet;
	var dialogueList:DialogueFile = null;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;
	var bgFade:FlxSprite = null;
	var box:FlxSprite;
	var textToType:String = '';

	var arrayCharacters:Array<DialogueCharacter> = [];

	var currentText:Int = 0;
	var offsetPos:Float = -600;

	var textBoxTypes:Array<String> = ['normal', 'angry'];
	
	var curCharacter:String = "";
	//var charPositionList:Array<String> = ['left', 'center', 'right'];

	public function new(dialogueList:DialogueFile, ?song:String = null)
	{
		super();

		if(song != null && song != '') {
			FlxG.sound.playMusic(Paths.music(song), 0);
			FlxG.sound.music.fadeIn(2, 0, 1);
		}

		var songName:String = PlayState.SONG.song;
		if (songName != 'Charged'){
		bgFade = new FlxSprite(-500, -500).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		bgFade.scrollFactor.set();
		bgFade.visible = true;
		bgFade.alpha = 0;
		add(bgFade);
		}

		this.dialogueList = dialogueList;
		spawnCharacters();

		/**
		* Little bit of a rant here.	
		* If we ever decide to remaster this mod with better graphics and music and stuff, note to self here to
		* make a dialogue box editor, just for moddability.
		* I wanna end up making a whole ass fork of Psych with a lot of concepts that I come up with
		* like the time bar colors and the fade transition colors and just making the whole thing a lot more
		* customizable, y'know?
		* Like, at time of writing, Shadow Mario just released 0.6.3 and there's a new playback speed feature
		* I really wanna use that, because JB's WAR mod is built on Leather Engine and I really like the speed thing
		* Multi Key would also be cool but I'm not coding that shit lmao
		* I'm still a bit of a noob when it comes to this stuff, I'm really just learning based off of copying what
		* I see others do whenever I code, and get some help from the Psych discord (https://discord.gg/psychengine)
		* Like, you can very clearly see that from the fact that most of this mod is in .lua, because I just
		* cannot mess with hscript like this lmaooo
		* So that's why I'm not going to do the editor right now, I'm still too much of an idiot to mess with making
		* UI and JSON files (IDEK HOW TO PULL FROM A JSON FILE WTF :skull_crossbones:)
		* So yeah, if you see this while you're looking at the Github or something and you think you can help me out
		* Feel free to hit me up, Melly#7214 on discord 
		* Be in the Psych server first because I always check mutual friends/servers and if I don't have any with you
		* I immediately decline the message/friend request lmao
		* It's how I avoid scammers and stuff, don't take it personally. (please) (I'll be sad if you do :mellypensive:)
		* Alright, end of rant.
		*/

		if (PlayState.instance != null){
			switch(PlayState.instance.dad.curCharacter){
				case 'AM':
					box = new FlxSprite(500, 500);
					box.frames = Paths.getSparrowAtlas('AM Dia Box');
					box.animation.addByPrefix('normal', 'box idle', 24);
				case 'AM-Red':
					box = new FlxSprite(525, 550);
					box.frames = Paths.getSparrowAtlas('AM Dia Box');
					box.animation.addByPrefix('angry', 'box angry', 5);
				case 'Brittany':
					box = new FlxSprite(500, 500);
					box.frames = Paths.getSparrowAtlas('Brit Dia Box');
					box.animation.addByPrefix('angry', 'box angry', 24);
					box.animation.addByPrefix('normal', 'box idle', 24);
				case 'Voltage':
					box = new FlxSprite(500, 500);
					box.frames = Paths.getSparrowAtlas('Volt Dia Box');
					box.animation.addByPrefix('angry', 'box angry', 12);
					box.animation.addByPrefix('normal', 'box idle', 24);
				case 'AM-New' | 'AM-Red-New':
					box = new FlxSprite(500, 500);
					box.frames = Paths.getSparrowAtlas('AM New Dia Box');
					box.animation.addByPrefix('normal', 'box idle', 5);
					box.animation.addByPrefix('angry', 'box angry', 12);
				case 'Brittany-New':
					box = new FlxSprite(500, 475);
					box.frames = Paths.getSparrowAtlas('Brit New Dia Box');
					box.animation.addByPrefix('angry', 'box angry', 24);
					box.animation.addByPrefix('normal', 'box idle', 24);
				case 'Voltage-New':
					box = new FlxSprite(475, 500);
					box.frames = Paths.getSparrowAtlas('Volt New Dia Box');
					box.animation.addByPrefix('normal', 'box idle', 12);
				default:
					box.frames = Paths.getSparrowAtlas('speech_bubble');
					box.animation.addByPrefix('angry', 'speech bubble loud', 24);
				}
			}
					box.scrollFactor.set();
					box.antialiasing = false;
					box.animation.addByPrefix('normalOpen', 'box open', 24, false);
					box.animation.addByPrefix('angryOpen', 'box mad enter', 24, false);
					box.animation.addByPrefix('center-normal', 'box idle', 24);
					box.animation.addByPrefix('center-normalOpen', 'box open', 24, false);
					box.animation.addByPrefix('center-angry', 'box angry', 24);
					box.animation.addByPrefix('center-angryOpen', 'box mad enter', 24, false);
					box.animation.play('normal', true);
					box.visible = false;
					box.setGraphicSize(Std.int(box.width * 3.9));
					box.updateHitbox();
					add(box);

		startNextDialog();
	}

	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	public static var LEFT_CHAR_X:Float = -60;
	public static var RIGHT_CHAR_X:Float = -100;
	public static var DEFAULT_CHAR_Y:Float = 60;

	function spawnCharacters() {
		#if (haxe >= "4.0.0")
		var charsMap:Map<String, Bool> = new Map();
		#else
		var charsMap:Map<String, Bool> = new Map<String, Bool>();
		#end
		for (i in 0...dialogueList.dialogue.length) {
			if(dialogueList.dialogue[i] != null) {
				var charToAdd:String = dialogueList.dialogue[i].portrait;
				if(!charsMap.exists(charToAdd) || !charsMap.get(charToAdd)) {
					charsMap.set(charToAdd, true);
				}
			}
		}

		for (individualChar in charsMap.keys()) {
			var x:Float = LEFT_CHAR_X;
			var y:Float = DEFAULT_CHAR_Y;
			var char:DialogueCharacter = new DialogueCharacter(x + offsetPos, y, individualChar);
			char.setGraphicSize(Std.int(char.width * DialogueCharacter.DEFAULT_SCALE * char.jsonFile.scale));
			char.updateHitbox();
			char.scrollFactor.set();
			char.alpha = 0.00001;
			add(char);

			var saveY:Bool = false;
			switch(char.jsonFile.dialogue_pos) {
				case 'center':
					char.x = FlxG.width / 2;
					char.x -= char.width / 2;
					y = char.y;
					char.y = FlxG.height + 50;
					saveY = true;
				case 'right':
					x = FlxG.width - char.width + RIGHT_CHAR_X;
					char.x = x - offsetPos;
			}
			x += char.jsonFile.position[0];
			y += char.jsonFile.position[1];
			char.x += char.jsonFile.position[0];
			char.y += char.jsonFile.position[1];
			char.startingPos = (saveY ? y : x);
			arrayCharacters.push(char);
		}
	}

	public static var DEFAULT_TEXT_X = 90;
	public static var DEFAULT_TEXT_Y = 430;
	var scrollSpeed = 4500;
	var daText:Alphabet = null;
	var ignoreThisFrame:Bool = true; //First frame is reserved for loading dialogue images
	override function update(elapsed:Float)
	{
		if(ignoreThisFrame) {
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}

		var songName:String = PlayState.SONG.song;
		if(!dialogueEnded) {
			if (songName != 'Charged'){
			bgFade.alpha += 0.5 * elapsed;
			if(bgFade.alpha > 0.5) bgFade.alpha = 0.5;
			}

			if(PlayerSettings.player1.controls.ACCEPT) {
				if(!daText.finishedText) {
					if(daText != null) {
						daText.killTheTimer();
						daText.kill();
						remove(daText);
						daText.destroy();
					}
					daText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, textToType, false, true, 0.0, 0.7);
					add(daText);
					
					if(skipDialogueThing != null) {
						skipDialogueThing();
					}
				} else if(currentText >= dialogueList.dialogue.length) {
					dialogueEnded = true;
					for (i in 0...textBoxTypes.length) {
						var checkArray:Array<String> = ['', 'center-'];
						var animName:String = box.animation.curAnim.name;
						for (j in 0...checkArray.length) {
							if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
								box.animation.play(checkArray[j] + textBoxTypes[i] + 'Open', true);
							}
						}
					}

					box.animation.curAnim.curFrame = box.animation.curAnim.frames.length - 1;
					box.animation.curAnim.reverse();
					daText.kill();
					remove(daText);
					daText.destroy();
					daText = null;
					updateBoxOffsets(box);
					FlxG.sound.music.fadeOut(1, 0);
				} else {
					startNextDialog();
				}
				FlxG.sound.play(Paths.sound('dialogueClose'));
			} else if(daText.finishedText) {
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if(char != null && char.animation.curAnim != null && char.animationIsLoop() && char.animation.finished) {
					char.playAnim(char.animation.curAnim.name, true);
				}
			} else {
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if(char != null && char.animation.curAnim != null && char.animation.finished) {
					char.animation.curAnim.restart();
				}
			}

			if(box.animation.curAnim.finished) {
				for (i in 0...textBoxTypes.length) {
					var checkArray:Array<String> = ['', 'center-'];
					var animName:String = box.animation.curAnim.name;
					for (j in 0...checkArray.length) {
						if(animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open') {
							box.animation.play(checkArray[j] + textBoxTypes[i], true);
						}
					}
				}
				updateBoxOffsets(box);
			}

			if(lastCharacter != -1 && arrayCharacters.length > 0) {
				for (i in 0...arrayCharacters.length) {
					var char = arrayCharacters[i];
					if(char != null) {
						if(i != lastCharacter) {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x -= scrollSpeed * elapsed;
									if(char.x < char.startingPos + offsetPos) char.x = char.startingPos + offsetPos;
								case 'center':
									char.y += scrollSpeed * elapsed;
									if(char.y > char.startingPos + FlxG.height) char.y = char.startingPos + FlxG.height;
								case 'right':
									char.x += scrollSpeed * elapsed;
									if(char.x > char.startingPos - offsetPos) char.x = char.startingPos - offsetPos;
							}
							char.alpha -= 3 * elapsed;
							if(char.alpha < 0.00001) char.alpha = 0.00001;
						} else {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x += scrollSpeed * elapsed;
									if(char.x > char.startingPos) char.x = char.startingPos;
								case 'center':
									char.y -= scrollSpeed * elapsed;
									if(char.y < char.startingPos) char.y = char.startingPos;
								case 'right':
									char.x -= scrollSpeed * elapsed;
									if(char.x < char.startingPos) char.x = char.startingPos;
							}
							char.alpha += 3 * elapsed;
							if(char.alpha > 1) char.alpha = 1;
						}
					}
				}
			}
		} else { //Dialogue ending
			if(box != null && box.animation.curAnim.curFrame <= 0) {
				box.kill();
				remove(box);
				box.destroy();
				box = null;
			}

			if(bgFade != null && songName != 'Charged') {
				bgFade.alpha -= 0.5 * elapsed;
				if(bgFade.alpha <= 0) {
					bgFade.kill();
					remove(bgFade);
					bgFade.destroy();
					bgFade = null;
				}
			}

			for (i in 0...arrayCharacters.length) {
				var leChar:DialogueCharacter = arrayCharacters[i];
				if(leChar != null) {
					switch(arrayCharacters[i].jsonFile.dialogue_pos) {
						case 'left':
							leChar.x -= scrollSpeed * elapsed;
						case 'center':
							leChar.y += scrollSpeed * elapsed;
						case 'right':
							leChar.x += scrollSpeed * elapsed;
					}
					leChar.alpha -= elapsed * 10;
				}
			}

			if(box == null && bgFade == null) {
				for (i in 0...arrayCharacters.length) {
					var leChar:DialogueCharacter = arrayCharacters[0];
					if(leChar != null) {
						arrayCharacters.remove(leChar);
						leChar.kill();
						remove(leChar);
						leChar.destroy();
					}
				}
				finishThing();
				kill();
			}
		}
		super.update(elapsed);
	}

	var lastCharacter:Int = -1;
	var lastBoxType:String = '';
	function startNextDialog():Void
	{
		var curDialogue:DialogueLine = null;
		do {
			curDialogue = dialogueList.dialogue[currentText];
		} while(curDialogue == null);

		if(curDialogue.text == null || curDialogue.text.length < 1) curDialogue.text = ' ';
		if(curDialogue.boxState == null) curDialogue.boxState = 'normal';
		if(curDialogue.speed == null || Math.isNaN(curDialogue.speed)) curDialogue.speed = 0.05;

		var animName:String = curDialogue.boxState;
		var boxType:String = textBoxTypes[0];
		for (i in 0...textBoxTypes.length) {
			if(textBoxTypes[i] == animName) {
				boxType = animName;
			}
		}

		var character:Int = 0;
		box.visible = true;
		for (i in 0...arrayCharacters.length) {
			if(arrayCharacters[i].curCharacter == curDialogue.portrait) {
				character = i;
				break;
			}
		}
		var centerPrefix:String = '';
		var lePosition:String = arrayCharacters[character].jsonFile.dialogue_pos;
		if(lePosition == 'center') centerPrefix = 'center-';

		if(character != lastCharacter) {
			box.animation.play(centerPrefix + boxType + 'Open', true);
			updateBoxOffsets(box);
			box.flipX = (lePosition == 'left');
		} else if(boxType != lastBoxType) {
			box.animation.play(centerPrefix + boxType, true);
			updateBoxOffsets(box);
		}
		lastCharacter = character;
		lastBoxType = boxType;

		if(daText != null) {
			daText.killTheTimer();
			daText.kill();
			remove(daText);
			daText.destroy();
		}

		textToType = curDialogue.text;
		Alphabet.setDialogueSound(curDialogue.sound);
		daText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, textToType, false, true, curDialogue.speed, 0.7);
		add(daText);

		var char:DialogueCharacter = arrayCharacters[character];
		if(char != null) {
			char.playAnim(curDialogue.expression, daText.finishedText);
			if(char.animation.curAnim != null) {
				var rate:Float = 24 - (((curDialogue.speed - 0.05) / 5) * 480);
				if(rate < 12) rate = 12;
				else if(rate > 48) rate = 48;
				char.animation.curAnim.frameRate = rate;
			}
		}
		currentText++;

		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	public static function parseDialogue(path:String):DialogueFile {
		#if MODS_ALLOWED
		if(FileSystem.exists(path))
		{
			return cast Json.parse(File.getContent(path));
		}
		#end
		return cast Json.parse(Assets.getText(path));
	}

	public static function updateBoxOffsets(box:FlxSprite) { //Had to make it static because of the editors
		box.centerOffsets();
		box.updateHitbox();
		if(box.animation.curAnim.name.startsWith('angry')) {
			box.offset.set(50, 65);
		} else if(box.animation.curAnim.name.startsWith('center-angry')) {
			box.offset.set(50, 30);
		} else {
			box.offset.set(10, 0);
		}
		
		if(!box.flipX) box.offset.y += 10;
	}
}
