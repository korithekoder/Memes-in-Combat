package backend.data;

import flixel.input.keyboard.FlxKey;

/**
 * Class that holds all of the general values that do not change.
 */
class Constants {
    
    /**
     * The default controls for the player. This is usually used when
     * the player wishes to reset all of their binds.
     */
	public static final DEFAULT_CONTROLS_KEYBOARD:Map<String, FlxKey> = [
        // Movement
        'm_up'       => FlxKey.W,
        'm_left'     => FlxKey.A,
        'm_down'     => FlxKey.S,
        'm_right'    => FlxKey.D,

        // Other
        'fullscreen' => FlxKey.F11
    ];
    
    /**
     * The name of the save file for the player's options.
     */
    public static final OPTIONS_SAVE_BIND_ID:String = 'options';

    /**
     * The name of the save file for the player's controls.
     */
    public static final CONTROLS_SAVE_BIND_ID:String = 'controls';

    /**
     * The splash texts that are displayed on the main menu.
     * Each array contains two strings that are displayed on the screen.
     * Note that any extra strings after the first two will be ignored.
     */
    public static final SPLASH_TEXTS:Array<Array<String>> = [
        ['we gonna do', 'this thang'],
        ['bruh', 'moment'],
        ['I', 'AM STEVE'],
        ['I am gonna', 'tickle your toes :3'],
        ['why the fuck', 'are you playing this game??'],
        ['friday night funkin', 'peak rhythm game imo'],
        ['you\'re dead built', 'like an apple'],
        ['swag shit', 'money money'],
        ['uwu', 'owo'],
        ['if you\'re reading this', 'you like men'],
        ['eeeeeeeuuuuuuuuuuuuuu', 'mmmmmmhhhhhhhhhh'],
        ['eeeeeeeeeeeeeeeeeeeeeeeee', 'eeeeeeeeeeeeeeeeeeeeeeeee'],
        ['i\'m gonna crash', 'the fuck out'],
        ['inspired by', 'noobs in combat']
    ];
}
