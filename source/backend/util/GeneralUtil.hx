package backend.util;

#if html5
import js.Browser;
#end
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxG;

/**
 * Utility class which holds functions that don't fit into any other category.
 */
class GeneralUtil {

    /**
     * Fades into a state with a cool transition effect.
     * 
     * @param state             The states to switch to.
     * @param duration          How long it takes to switch from one state to the next state.
     * @param playTransitionSfx Should the game play a sound when it switches states?
     */
    public static function fadeIntoState(state:FlxState, duration:Float, playTransitionSfx:Bool = true):Void {
        if (playTransitionSfx) {
            FlxG.sound.play(PathUtil.ofSound('get-out'), 1, false, false);
        }
        
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

    /**
     * Closes the entire game.
     */
    public static function closeGame():Void {
        SaveUtil.saveAll();
        #if html5
        Browser.window.close();
        #elseif desktop
        Sys.exit(0);
        #end
    }
}
