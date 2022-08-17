package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import PlayState;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		if (PlayState.instance != null){
			switch(PlayState.instance.dad.curCharacter){
				case 'AM-Head' | 'AM' | 'AM-New' | 'AM-New-rasis' | 'AMM' | 'AM-Real':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.MAGENTA] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				case 'AM-Red' | 'AM-Red-New':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.RED] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				case 'Brittany' | 'Brittany-New':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BROWN] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				case 'Voltage' | 'Voltage-New':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.CYAN] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				case 'SG' | 'SG-New':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.TRANSPARENT] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				case 'Donut-Man' | 'Donut-Man-New':
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BROWN] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
				default:
					transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
					transGradient.scrollFactor.set();
					add(transGradient);
			}
			}else{
				transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
				transGradient.scrollFactor.set();
				add(transGradient);
			}
		/* temporarily scrapped until some weird positioning bug is fixed

        var color:FlxColor = FlxColor.BLACK;

		credit to M1 Aether for helping me get this functional
		and to superpowers08 for making it so clean like it was SHIT before
		functional but SHIT
        if (PlayState.SONG != null && isTransIn){
            switch(PlayState.SONG.player2.toLowerCase()){
                case 'am-head' | 'am' | 'am-new' | 'am-new-rasis' | 'amm' | 'am-real':
                    color = FlxColor.MAGENTA;
                case 'am-red' | 'am-red-new':
                    color = FlxColor.RED;
                case 'brittany' | 'brittany-new':
                    color = FlxColor.BROWN;
                case 'voltage' | 'voltage-new':
                    color = FlxColor.CYAN;
                case 'sg' | 'sg-new':
                    color = FlxColor.TRANSPARENT;
                case 'donut-man' | 'donut-man-new':
                    color = FlxColor.BROWN;
				default:
					color = FlxColor.BLACK;
            }
        }
		transGradient = FlxGradient.createGradientFlxSprite(width, height, [0x0,color]);
        transGradient.scrollFactor.set();
        add(transGradient);
		*/
		transBlack = new FlxSprite().makeGraphic(width, height + 400, FlxColor.BLACK);
		transBlack.scrollFactor.set();
		add(transBlack);

		transGradient.x -= (width - FlxG.width) / 2;
		transBlack.x = transGradient.x;

		if(isTransIn) {
			transGradient.y = transBlack.y - transBlack.height;
			FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.linear});
		} else {
			transGradient.y = -transGradient.height;
			transBlack.y = transGradient.y - transBlack.height + 50;
			leTween = FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.linear});
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
			transGradient.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
		super.update(elapsed);
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}