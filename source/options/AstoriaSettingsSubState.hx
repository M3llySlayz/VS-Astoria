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

class AstoriaSettingsSubState extends BaseOptionsMenu
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

		super();
	}
}