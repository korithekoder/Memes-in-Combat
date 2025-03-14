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
}
