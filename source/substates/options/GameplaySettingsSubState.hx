package substates.options;

import flixel.FlxG;
import objects.ui.OptionSelectionList;
import backend.Controls;
import objects.ui.options.OptionCheckBox;
import flixel.FlxSubState;

/**
 * Sub state that displays the settings for the gameplay preferences.
 */
class GameplaySettingsSubState extends FlxSubState {
    
    var options:Array<OptionCheckBox> = [
        new OptionCheckBox(20, (FlxG.height / 2), 'Dialogue Animations', 'dialogueAnimations'),
        new OptionCheckBox(20, (FlxG.height / 2) + 200, 'Discord Rich Presence', 'discordRPC'),
        new OptionCheckBox(20, (FlxG.height / 2) + 400, 'Discord Rich Presence', 'test')
    ];

    var selectionList:OptionSelectionList;

    override function create() {
        super.create();

        selectionList = new OptionSelectionList(SelectionScrollType.STICK_OUT, SelectionAlignType.LEFT, 200);
        add(selectionList);

        for (o in options) {
            selectionList.add(o);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.binds.UI_BACK_JUST_PRESSED) {
            close();
        }
    }
}
