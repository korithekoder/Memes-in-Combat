package backend.data;

import backend.util.PathUtil;
import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;

/**
 * Private class that holds all of the user's options.
 */
@:structInit class SaveVariables {

    /**
     * Should the game minimize its volume when the window is out of focus?
     */
    public var minimizeVolume:Bool = true;

    /**
     * Should the game display in the client's Discord "Activity" box?
     */
    public var discordRPC:Bool = true;

    /**
     * Should the dialogue boxes use animations when writing text?
     */
     public var dialogueAnimations:Bool = true;
}

/**
 * Class that handles, modifies and stores the user's
 * preferences and settings.
 * 
 * When you are updating a setting, do *NOT* do it
 * manually. Instead, use `setClientPreference()` to update a user's preference(s)
 * or `setClientControl()` to change a bind.
 * 
 * Controls are saved in their own variable, *NOT* in `options`.
 * 
 * The way controls are created is with this structure: `'keybind_id' => FlxKey.YOUR_KEY`.
 * To create a control, go to `backend.data.Constants`, search for `DEFAULT_CONTROLS_KEYBOARD`
 * and then add your controls accordingly.
 * 
 * To access controls, use `backend.Controls`. (**TIP**: Read `backend.Controls`'s
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

    // -----------------------------
    //            METHODS
    // -----------------------------

    /**
     * Sets a user's option.
     * 
     * @param setting The setting to be set.
	 * @param value   The value to set it to.
     */
	public static function setClientPreference(setting:String, value:Dynamic):Void {
        try {
			Reflect.setField(_options, setting, value);
        } catch (e:Exception) {
            FlxG.log.warn("Attempted to change non-existent option \"" + setting + "\", ignoring change...");
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
            FlxG.log.warn("Attempted to change non-existent bind \"" + bindId + "\", ignoring change...");
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
        optionsData.bind(Constants.OPTIONS_SAVE_BIND_ID, PathUtil.getSavePath());
        controlsData.bind(Constants.CONTROLS_SAVE_BIND_ID, PathUtil.getSavePath());

        // Load options
        if (optionsData.data.options != null)
            _options = optionsData.data.options;
        else
            _options = _defaultOptions;

        for (optn in Reflect.fields(_defaultOptions)) {
            if (!Reflect.hasField(_options, optn)) {
                Reflect.setField(_options, optn, Reflect.field(_defaultOptions, optn));
            }
        }

        // Load controls
        if (controlsData.data.keyboard != null)
            _controlsKeyboard = controlsData.data.keyboard;
        else
            _controlsKeyboard = Constants.DEFAULT_CONTROLS_KEYBOARD;

        // Check if the user has any new controls
        // (this is for when new controls are added in an update!)
        for (key in Constants.DEFAULT_CONTROLS_KEYBOARD.keys()) {
            if (!_controlsKeyboard.exists(key)) {
                _controlsKeyboard.set(key, Constants.DEFAULT_CONTROLS_KEYBOARD.get(key));
            }
        }

        // Set the volume to the last used volume the user had
        if (optionsData.data.lastVolume != null)
            FlxG.sound.volume = optionsData.data.lastVolume;
        else
            FlxG.sound.volume = 1.0;

        // Set the volume keys
        FlxG.sound.volumeUpKeys = [controlsKeyboard.get('v_up')];
        FlxG.sound.volumeDownKeys = [controlsKeyboard.get('v_down')];
        FlxG.sound.muteKeys = [controlsKeyboard.get('v_mute')];

        FlxG.log.add("Loaded all client preferences and controls successfully.");

        // Respectfully close the saves to
        // prevent data leaks
        optionsData.close();
        controlsData.close();
    }
}
