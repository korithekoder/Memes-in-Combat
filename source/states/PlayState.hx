package states;

import backend.util.CacheUtil;
import backend.Controls;
import backend.data.Constants;
import backend.util.GeneralUtil;
import states.menus.CampaignMenuState;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;

/**
 * State where the cool gameplay happens.
 */
class PlayState extends FlxTransitionableState {

	override public function create() {
		super.create();

		FlxG.sound.music.stop();
		CacheUtil.canPlayMenuMusic = true;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (Controls.binds.BACK_JUST_PRESSED) {
            GeneralUtil.fadeIntoState(new CampaignMenuState(), Constants.TRANSITION_DURATION);
        }
	}
}
