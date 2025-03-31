package objects.ui.options;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Object used for creating new options. Note that this class is `abstract` because
 * it is intended to be extended to and create other kinds of options!
 */
abstract class Option extends FlxTypedGroup<FlxSprite> {
    
    /**
     * The name of the option.
     */
    public var name(get, never):String;
    private var _name:String;

    /**
     * The client preference to change when `this` option changes.
     * (Some examples might be `dialogueAnimations`, `discordRPC`, etc.)
     */
    public var option(get, never):String;
    private var _option:String;

    /**
     * A brief description of the option.
     */
    public var description:String;

    /**
     * A callback function to be executed when the option is selected.
     */
    public var onSelected:Void -> Void;

    /**
     * Constructor.
     * 
     * @param name        The name of the option.
     * @param option      The value or identifier of the option.
     * @param description The client preference to change when `this` option changes.
     *                    (Some examples might be `dialogueAnimations`, `discordRPC`, etc.)
     * @param onSelected  A callback function to be executed when the option is selected.
     */
    public function new(name:String, option:String, description:String, onSelected:Void -> Void) {
        super();
        this._name = name;
        this._option = option;
        this.description = description;
        this.onSelected = onSelected;
    }

    // ------------------------------
    //      GETTERS AND SETTERS
    // ------------------------------

    @:noCompletion
    public inline function get_name():String {
        return this._name;
    }

    @:noCompletion
    public inline function get_option():String {
        return this._option;
    }
}
