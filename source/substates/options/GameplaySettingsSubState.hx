package substates.options;

import objects.substates.OptionsDisplaySubState;
import flixel.FlxG;
import objects.ui.options.OptionCheckBox;

/**
 * Sub state that displays the settings for the gameplay preferences.
 */
class GameplaySettingsSubState extends OptionsDisplaySubState {

    public function addOptions() {
        options = [
            'Dialogue Animations',
            #if DISCORD_ALLOWED
            'Discord Rich Presence',
            #end
            'Blah Blah Blah',
            'afsdfsdff'
        ];
        optionIds = [
            'dialogueAnimations',
            #if DISCORD_ALLOWED
            'discordRPC',
            #end
            'test',
            'sfsdfafAAFSFAFA'
        ];

        var newY:Float = (FlxG.height / 2);

        for (o in 0...options.length) {
            var youDeadBuiltLikeAnApple:OptionCheckBox = new OptionCheckBox(20, newY, options[o], optionIds[o], false);
            _selectionList.add(youDeadBuiltLikeAnApple);
            newY += 200;
        }
    }
}
