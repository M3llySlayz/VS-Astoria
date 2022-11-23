package;

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
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import flash.system.System;
import PlayState;

using StringTools;

class ScoringState extends MusicBeatState
{
    public static var scoreBG:FlxSprite;
    public var scoreText:FlxText;
    public var accuracyText:FlxText;
    public var songText:FlxText;
    public var rngText:FlxText;
    public var missesText:FlxText;
    public var moneyText:FlxText;

    override function create() {
		#if desktop
		DiscordClient.changePresence("Cash Money", "Getting cash", "paused");
		#end

		camera.zoom = 2.2;
		CoolUtil.cameraZoom(camera, 1, .5, FlxEase.sineOut, ONESHOT);

        var bg:FlxBackdrop = new FlxBackdrop(Paths.image('loading'), 0.2, 0, true, true);
		bg.velocity.set(200, 110);
		bg.alpha = 0.5;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

	
	}
}