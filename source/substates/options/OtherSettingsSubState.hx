package substates.options;

import flixel.FlxG;
import objects.ui.options.OptionCheckBox;
import objects.substates.OptionsDisplaySubState;

class OtherSettingsSubState extends OptionsDisplaySubState {

    public function addOptions() {
        options = [
            #if desktop
            'Minimize Volume on Lost Focus',
            #end
        ];
        optionIds = [
            #if desktop
            'minimizeVolume',
            #end
        ];

        var newY:Float = (FlxG.height / 2);

        for (o in 0...options.length) {
            var youreSoSkibidi_NO_STOP_GET_OUT_OF_MY_HEAD:OptionCheckBox = new OptionCheckBox(20, newY, options[o], optionIds[o], false);
            _selectionList.add(youreSoSkibidi_NO_STOP_GET_OUT_OF_MY_HEAD);
            newY += 200;
        }
    }
}
