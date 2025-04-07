package objects.substates;

import backend.Controls;
import flixel.FlxG;
import objects.ui.OptionSelectionList;
import flixel.FlxSubState;

abstract class OptionsDisplaySubState extends FlxSubState {
    
    /**
     * The options that will be displayed in the list.
     */
    public var options(get, set):Array<String>;
    private var _options:Array<String>;

    /**
     * The IDs of of the client preferences that is used to actually change the
     * option in the game.
     */
    public var optionIds(get, set):Array<String>;
    private var _optionIds:Array<String>;

    private var _selectionList:OptionSelectionList;

    @:noCompletion
    public function get_options():Array<String> {
        return _options;
    }

    @:noCompletion
    public function get_optionIds():Array<String> {
        return _optionIds;
    }

    @:noCompletion
    public function set_options(value:Array<String>):Array<String> {
        _options = value;
        return _options;
    }

    @:noCompletion
    public function set_optionIds(value:Array<String>):Array<String> {
        _optionIds = value;
        return _optionIds;
    }

    override function create() {
        super.create();

        _selectionList = new OptionSelectionList(SelectionScrollType.STICK_OUT, SelectionAlignType.LEFT, 200);
        add(_selectionList);

        addOptions();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.binds.UI_BACK_JUST_PRESSED || FlxG.mouse.justPressedRight) {
            close();
        }
    }

    /**
     * Abstract function that is intended to be overridden to 
     * add the options to the display.
     */
    public abstract function addOptions():Void;
}
