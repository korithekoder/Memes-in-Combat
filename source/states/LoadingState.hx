package states;

import flixel.FlxSprite;
import backend.data.Constants;
import backend.util.GeneralUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;

/**
 * State that is switched to before the play state.
 * This is for creating the setup and caching.
 */
class LoadingState extends FlxTransitionableState {

    var bg:FlxSprite;

    override function create() {
        super.create();

        FlxG.sound.music.stop();

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width + 50, FlxG.height + 50);
        bg.color = FlxColor.BLACK;
        add(bg);

        new FlxTimer().start(0.5, (_) -> { 
            GeneralUtil.fadeIntoState(new PlayState(), Constants.TRANSITION_DURATION, false);
        });
    }
}
