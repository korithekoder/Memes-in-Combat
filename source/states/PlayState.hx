package states;

import objects.ui.DialogueBox;
import backend.Controls;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import states.menus.CampaignMenuState;

/**
 * State where the cool gameplay happens.
 */
class PlayState extends FlxTransitionableState {

	var dialogueBox:DialogueBox;

	override public function create() {
		super.create();

		FlxG.sound.music.stop();
		CacheUtil.canPlayMenuMusic = true;

		dialogueBox = new DialogueBox('Tutorial-Start', 'troll');
		add(dialogueBox);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.binds.UI_BACK_JUST_PRESSED) {
            GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION, false);
        }
	}
}
