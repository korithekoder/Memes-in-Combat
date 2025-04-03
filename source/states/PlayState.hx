package states;

import backend.util.PathUtil;
import flixel.FlxG;
import objects.ui.DialogueBox;
import backend.Controls;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import flixel.addons.transition.FlxTransitionableState;
import states.menus.CampaignMenuState;

/**
 * State where the cool gameplay happens.
 */
class PlayState extends FlxTransitionableState {

	var dialogueBox:DialogueBox;

	override public function create() {
		super.create();

		CacheUtil.canPlayMenuMusic = true;

		dialogueBox = new DialogueBox('Tutorial-Start', 'troll');
		dialogueBox.onDialogueComplete = () -> {
			var selectedSoundtrack:String = CacheUtil.currentYearSoundtracks[FlxG.random.int(0, CacheUtil.currentYearSoundtracks.length)];
			FlxG.sound.playMusic(PathUtil.ofMusic(selectedSoundtrack));
		};
		add(dialogueBox);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (CacheUtil.isDialogueFinished) {
			if (Controls.binds.UI_BACK_JUST_PRESSED) {
				GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION, false);
			}
		}
	}
}
