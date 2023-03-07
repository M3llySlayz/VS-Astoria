package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class PauseAstoriaSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Astoria Settings';
		rpcTitle = 'Astoria Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Low Quality', //Name
			'If checked, does some funny stuff.', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('New Rating System',
		'Shows ratings underneath notes you just hit\ninstead of the middle of the screen.',
		'newSicks',
		'bool',
		false);
		addOption(option);

		var option:Option = new Option('Splitscroll',
			'If checked, your notes go down AND up. Freaky.',
			'splitScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Quit Method:',
			'How do you want the quit button to work?',
			'quitMethod',
			'string',
			'Quick Confirm',
			['Normal', 'Quick Confirm', 'Fancy Confirm']);
		addOption(option);

		var option:Option = new Option('Note Skin:',
			'Which note skin would you like to use?',
			'noteSkin',
			'string',
			'Arrows',
			['Arrows', 'Circles', 'Weird Arrows']);
		addOption(option);

		var option:Option = new Option('Pause Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Construct',
			['None', 'Bossfight', 'Construct', 'Confront', 'Waiting', 'Waiting (Impatient)', 'Bounce', 'Adventure']);
		addOption(option);

		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Shop Song:',
		"What song do you prefer for the Shop?",
		'shopMusic',
		'string',
		'Nostalgia',
		['None', 'Nostalgia', 'Guest', 'Loop']);
		addOption(option);

		option.onChange = onChangeShopMusic;

		var option:Option = new Option('Game Over Song:',
		"What song do you prefer for the Game Over?",
		'gameOverSong',
		'string',
		'A Taken L',
		['A Taken L', 'Far']);
		addOption(option);

		option.onChange = onChangeGameOverMusic;

		var option:Option = new Option('Main Menu Song:',
		"What song do you prefer for the Main Menu?",
		'mainSong',
		'string',
		'Astoreckless',
		['Astoreckless', 'the other one (bad)']);
		addOption(option);

		option.onChange = onChangeMenuMusic;

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	function onChangeShopMusic()
		{
			if(ClientPrefs.shopMusic == 'None')
				FlxG.sound.music.volume = 0;
			else
				FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.shopMusic)));
	
			changedMusic = true;
		}

	function onChangeMenuMusic()
			{
				if (ClientPrefs.mainSong == 'Astoreckless'){
					FlxG.sound.playMusic(Paths.music('astoreckless'));
				}else{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
		
				changedMusic = true;
			}
	
	function onChangeGameOverMusic() {
		FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.gameOverSong)));
		changedMusic = true;
	}

	override function destroy()
		{
			if(changedMusic){
				if (TitleState.astoreckless){
					FlxG.sound.playMusic(Paths.music('astoreckless'));
				}else{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
			}
			super.destroy();
		}
	
}