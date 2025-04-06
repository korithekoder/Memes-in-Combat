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
    
    var options:Map<String, String> = [
        'Dialogue Animations' => 'dialogueAnimations',
        #if DISCORD_ALLOWED
        'Discord Rich Presence' => 'discordRPC',
        #end
        'Blah Blah Blah' => 'test',
        'afsdfsdff' => 'sfsdfafAAFSFAFAFA'
    ];

    var selectionList:OptionSelectionList;

    override function create() {
        super.create();

        selectionList = new OptionSelectionList(SelectionScrollType.STICK_OUT, SelectionAlignType.LEFT, 200);
        add(selectionList);

        var newY:Float = (FlxG.height / 2);
        var keys:Array<String> = [];

        for (k in options.keys()) {
            keys.push(k);
        }

        #if desktop
        keys.reverse();
        #end

        for (o in keys) {
            var youDeadBuiltLikeAnApple:OptionCheckBox = new OptionCheckBox(20, newY, o, options.get(o), false);
            selectionList.add(youDeadBuiltLikeAnApple);
            newY += 200;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.binds.UI_BACK_JUST_PRESSED || FlxG.mouse.justPressedRight) {
            close();
        }
    }
}
