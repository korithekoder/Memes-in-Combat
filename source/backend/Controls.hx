package backend;

import backend.data.ClientPrefs;
import flixel.FlxG;

/**
 * Core class for handling when the user presses a certain control.
 * 
 * There are two ways you can get if a bind is held down or just pressed/released:
 * 
 * ```haxe
 * Controls.binds.YOUR_BIND_PRESSED; // Held down
 * Controls.binds.YOUR_BIND_JUST_PRESSED; // Just pressed
 * Controls.binds.YOUR_BIND_JUST_RELEASED; // Just released
 * ```
 * 
 * ***OR***
 * 
 * ```haxe
 * Controls.pressed('your_bind_id'); // Held down
 * Controls.justPressed('your_bind_id'); // Just pressed
 * Controls.justReleased('your_bind_id'); // Just released
 * ```
 * 
 * It doesn't really matter how you do it, but if you would like to make your
 * bind(s) its own variable, you can do so with the following format:
 * 
 * ```haxe
 * // Notice how the variables are public and non static, while
 * // the functions are private and inline. Technically inline isn't
 * // required, but it's very good for preformance since it's just
 * // a simple return statement
 * public var YOUR_BIND_PRESSED(get, never):Bool;
 * public var YOUR_BIND_JUST_PRESSED(get, never):Bool;
 * public var YOUR_BIND_JUST_RELEASED(get, never):Bool;
 * private inline function get_YOUR_BIND_PRESSED():Bool return pressed('your_bind_id');
 * private inline function get_YOUR_BIND_JUST_PRESSED():Bool return justPressed('your_bind_id');
 * private inline function get_YOUR_BIND_JUST_RELEASED():Bool return justReleased('your_bind_id');
 * ```
 */
class Controls {

    // Movement (pressed)
    public var M_UP_PRESSED(get, never):Bool;
    public var M_LEFT_PRESSED(get, never):Bool;
    public var M_DOWN_PRESSED(get, never):Bool;
    public var M_RIGHT_PRESSED(get, never):Bool;
    private inline function get_M_UP_PRESSED():Bool return pressed('m_up');
    private inline function get_M_LEFT_PRESSED():Bool return pressed('m_left');
    private inline function get_M_DOWN_PRESSED():Bool return pressed('m_down');
    private inline function get_M_RIGHT_PRESSED():Bool return pressed('m_right');

    // Other (just pressed)
    public var FULLSCREEN_JUST_PRESSED(get, never):Bool;
    private inline function get_FULLSCREEN_JUST_PRESSED():Bool return justPressed('fullscreen');

    /**
     * Object used to get the pressed, just pressed and just released controls.
     */
    public static var binds:Controls;
    
    /**
     * Check if the user is holding down a certain control.
     * @param bind The bind to check.
     * @return     If the said bind is being held down.
     */
    public static inline function pressed(bind:String):Bool {
        return FlxG.keys.anyPressed([ClientPrefs.get_controlsKeyboard().get(bind)]);
    }

    /**
     * Check if the user just pressed a certain control.
     * @param bind The bind to check.
     * @return     If the said bind was just pressed.
     */
    public static inline function justPressed(bind:String):Bool {
        return FlxG.keys.anyJustPressed([ClientPrefs.get_controlsKeyboard().get(bind)]);
    }

    /**
     * Check if the user just released a certain control.
     * @param bind The bind to check.
     * @return     If the said bind just released.
     */
    public static inline function justReleased(bind:String):Bool {
        return FlxG.keys.anyJustReleased([ClientPrefs.get_controlsKeyboard().get(bind)]);
    }
}
