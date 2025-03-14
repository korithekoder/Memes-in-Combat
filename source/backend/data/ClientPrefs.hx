package backend.data;

import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;

/**
 * Private class that holds all of the user's options.
 */
@:structInit class SaveVariables {

    /**
     * Should the game minimize its volume when the winodw is out of focus?
     */
    public var minimizeVolume:Bool = true;
}

/**
 * Class that handles, modifies and stores the user's
 * preferences and settings.
 * 
 * When you are updating a setting, do *NOT* do it
 * manually. Instead, use `setClientPreference()` to update a user's prefence(s)
 * or `setClientControl()` to change a bind.
 * 
 * Controls are saved in their own variable, *NOT* in `options`.
 * 
 * The way controls are created is with this structure: `'keybind_id' => FlxKey.YOUR_KEY`.
 * To create a control, go to `backend.data.Constants`, search for `DEFAULT_CONTROLS_KEYBOARD`
 * and then add your controls accordingly.
 * 
 * To access controls, use `backend.data.Controls`. (**TIP**: Read `backend.data.Controls`'s
 * documentation for accessing if binds are pressed!)
 */
class ClientPrefs {

    /**
     * The user's settings and preferences. Note that this does not include
     * the user's controls, that is in its own respective variable.
     */
    public static var options(get, never):SaveVariables;
    private static var _options:SaveVariables = {};
    private static var _defaultOptions:SaveVariables = {};

	/**
	 * Controls set by the user for the keyboard.
	 */
    public static var controlsKeyboard(get, never):Map<String, FlxKey>;
	private static var _controlsKeyboard:Map<String, FlxKey>;

    // ------------------------------
    //      GETTERS AND SETTERS
    // ------------------------------

    public static inline function get_options():SaveVariables {
        return _options;
    }

    public static inline function get_controlsKeyboard():Map<String, FlxKey> {
        return _controlsKeyboard;
    }

    public static inline function get_defaultOptions():SaveVariables {
        return _defaultOptions;
    }

    public static inline function get_defaultControls():Map<String, FlxKey> {
		return Constants.DEFAULT_CONTROLS_KEYBOARD;
    }

    /**
     * Sets a user's option.
     * 
     * @param setting The setting to be set.
	 * @param value   The value to set it to.
     */
	public static function setClientPrefrence(setting:String, value:Dynamic):Void {
        try {
			Reflect.setField(_options, setting, value);
        } catch (e:Exception) {
            FlxG.log.warn("Attempted to change non-existant option \"" + setting + "\", ignoring change...");
        }
    }

    /**
     * Set a specific key bind for the user.
     * 
     * @param bindId The bind to be set.
     * @param newKey The key to set it to.
     */
	public static function setClientControl(bindId:String, newKey:FlxKey):Void {
        if (_controlsKeyboard.exists(bindId)) {
			_controlsKeyboard.set(bindId, newKey);
        } else {
            FlxG.log.warn("Attempted to change non-existant bind \"" + bindId + "\", ignoring change...");
        }
    }

    /**
     * Load and obtain all of the user's options and controls.
     */
    public static function loadAll():Void {
        // Create the binds
        var optionsData:FlxSave = new FlxSave();
        var controlsData:FlxSave = new FlxSave();

        // Connect to the saves
        optionsData.bind(Constants.OPTIONS_SAVE_BIND_ID);
        controlsData.bind(Constants.CONTROLS_SAVE_BIND_ID);

        // Load options
        if (optionsData.data.options != null)
            _options = optionsData.data.options;
        else
            _options = _defaultOptions;

        // Load controls
        if (controlsData.data.keyboard != null)
            _controlsKeyboard = controlsData.data.keyboard;
        else
            _controlsKeyboard = Constants.DEFAULT_CONTROLS_KEYBOARD;

        // Respectfully close the saves to
        // prevent data leaks
        optionsData.close();
        controlsData.close();
    }
}
