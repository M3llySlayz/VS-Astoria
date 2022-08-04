//THIS IS AN UPCOMING FEATURE! GO AWAY LMAO
package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import flixel.input.keyboard.FlxKey;

class ExtrasState extends MusicBeatState
{
    var camFollow:FlxObject;
	var camFollowPos:FlxObject;
    private var camGame:FlxCamera;

    public static var curSelected:Int = 0;
    var stuff:FlxTypedGroup<Alphabet>;


override function create()
	{
    camGame = new FlxCamera();
    FlxG.cameras.reset(camGame);
    camera.zoom = 1.85;
    CoolUtil.cameraZoom(camera, 1, .5, FlxEase.sineOut, ONESHOT);

    transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
        bg.color = 0xFFfd719b;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var hours:Int = Date.now().getHours();

		if(hours > 18) {
			bg.color = 0x6939ff;
		} else if(hours < 18) 0xFFfd719b;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

        if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				CoolUtil.cameraZoom(camera, 3, 3, FlxEase.backOut, ONESHOT);
			}
        }
    }