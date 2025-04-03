package backend.data;

import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

/**
 * Class that holds all of the general values that do not change.
 */
final class Constants {
    
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

        // UI
        'ui_left'    => FlxKey.LEFT,
        'ui_down'    => FlxKey.DOWN,
        'ui_up'      => FlxKey.UP,
        'ui_right'   => FlxKey.RIGHT,
        'ui_select'  => FlxKey.ENTER,
        'ui_back'    => FlxKey.ESCAPE,

        // Volume
        'v_up'       => FlxKey.PLUS,
        'v_down'     => FlxKey.MINUS,
        'v_mute'     => FlxKey.F12,

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
     * The name of the save file for the player's progress.
     */
    public static final PROGRESS_SAVE_BIND_ID:String = 'progress';

    /**
     * The name of the save file for the player's progress.
     */
    public static final RANDOM_BULLSHIT_SAVE_BIND_ID:String = 'random-bullshit';

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
        ['inspired by', 'noobs in combat'],
        ['where is', 'my goddamn money'],
        ['how do you 20 pairs of pants', 'and 3 pairs of underwear?!'],
        ['"please don\'t scam meeeeeeeee"', '-dfam 3/14/2025'],
        ['"be a good kitty and stop running away"', '-kori 3/8/2025'],
        ['"little goober, STOP" -kori', '"did you say little GOONER?!" -vixen'],
        ['"*skibidi"', '-kori 3/1/2025'],
        ['"get your twink out of my house of god"', '-kira 2/24/2025'],
        ['"CUMpany"', '-dfam 2/21/2025'],
        ['"YOUCH!! *says in a zesty tone*"', '-dfam 3/16/2025'],
        ['erm', 'what the sigma'],
        ['skibidi', 'rizzler']
    ];

    /**
     * How long it takes for the fade effect to last when switching states.
     */
    public static final TRANSITION_DURATION:Float = 0.4;

    /**
     * A list of campaign years and their associated data.
     * Each entry in the array represents a campaign year and contains the following:
     * 
     * - The name of the campaign year as a `String`.
     * - An optional value (can be `null`) representing the base text color for the campaign year.
     * - Another optional value (can be `null`) representing the outline text color for the campaign year.
     * 
     * Example:
     * ```haxe
     * [
     *     ['Tutorial', null, null],  // A tutorial campaign with no additional data.
     *     ['2009', null, null],  // Campaign year 2009 with no additional data.
     *     ['2022', FlxColor.BLACK, FlxColor.WHITE]  // Campaign year 2022 with specific colors.
     * ]
     * ```
     */
    public static final CAMPAIGN_YEARS:Array<Array<Dynamic>> = [
        ['Tutorial', null, null],
        ['2009', null, null],
        ['2022', null, null]
    ];

    private function new() {}
}
