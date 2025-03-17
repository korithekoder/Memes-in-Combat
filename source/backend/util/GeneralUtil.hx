package backend.util;

import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxG;

/**
 * Utility class which holds functions that don't fit into any other category.
 */
class GeneralUtil {

    /**
     * Fades into a state with a cool transition effect.
     * @param state The states to switch to.
     */
    public static function fadeIntoState(state:FlxState, duration:Float):Void {
        FlxG.camera.fade(FlxColor.BLACK, duration, false, () -> {
            FlxG.switchState(state);
        });
    }

    /**
     * Play menu music ***if*** it hasn't already started.
     */
    public static function playMenuMusic():Void {
        if (CacheUtil.canPlayMenuMusic) {
            FlxG.sound.playMusic(PathUtil.ofMusic('Jam Out By Myself'), 1, true);
            CacheUtil.canPlayMenuMusic = false;
        }
    }
}
