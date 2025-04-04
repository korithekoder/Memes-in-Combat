package states;

import backend.data.Constants;
import backend.util.AssetUtil;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * State that is switched to before the play state.
 * This is for creating the setup and caching.
 */
class LoadingState extends FlxTransitionableState {

    var bg:FlxSprite;

    override function create() {
        super.create();

        FlxG.sound.music.stop();

		// Make the screen only
		// b l a c k
        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width + 50, FlxG.height + 50);
        bg.color = FlxColor.BLACK;
        add(bg);

		// Set the current year data in the CacheUtil
		CacheUtil.currentYearData = AssetUtil.getJsonData('years/${CacheUtil.selectedYear}');
        CacheUtil.currentYearLevelData = CacheUtil.currentYearData.level;
        CacheUtil.currentYearMetadata = CacheUtil.currentYearData.metadata;
        CacheUtil.currentYearSoundtracks = CacheUtil.currentYearData.metadata.music;
        CacheUtil.currentYearMapData = CacheUtil.currentYearData.map;

		// Precache all of the music soundtracks
		AssetUtil.precacheSoundArray(CacheUtil.currentYearSoundtracks);

        new FlxTimer().start(0.5, (_) -> { 
            GeneralUtil.fadeIntoState(new PlayState(), Constants.TRANSITION_DURATION, false);
        });
    }
}
