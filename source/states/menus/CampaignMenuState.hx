package states.menus;

import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.CacheUtil;
import backend.util.GeneralUtil;
import backend.util.PathUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.display.CampaignYearIcon;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end

/**
 * State that displays the campaign menu with the client's progress.
 */
class CampaignMenuState extends FlxTransitionableState {
    
	var campaignYears:FlxTypedGroup<CampaignYearIcon>;

    var accessDeniedVolume:Float = 0.2;
    var accessDeniedAttempts:Int = 0;

    var michaelJordan:FlxSprite;

    var currentYear:Int = 0;
    var canScroll:Bool = true;
    var hasSelectedYear:Bool = false;
	
	override public function create() {
		super.create();

		// Play the menu music
        GeneralUtil.playMenuMusic();

		// Create the campaign years
		campaignYears = new FlxTypedGroup<CampaignYearIcon>();
        add(campaignYears);

		// Generate the campaign years and their respective display objects
		var newY:Float = (FlxG.height / 2) - 100;
		for (y in Constants.CAMPAIGN_YEARS) {
            var baseColor = (y[1] != null) ? y[1] : FlxColor.WHITE;
            var baseOutlineColor = (y[2] != null) ? y[2] : FlxColor.BLACK;
            var unlocked = CacheUtil.unlockedYears.contains(y[0]);

			if (!unlocked) baseColor = FlxColor.BLACK;
			if (!unlocked) baseOutlineColor = FlxColor.WHITE;

			campaignYears.add(new CampaignYearIcon(FlxG.width + 40, newY, y[0], baseColor, baseOutlineColor, unlocked));
            newY += 220;
        }

		// Tween the campaign years to add a nice effect
        var yearTime:Float = 0.25;
        for (year in campaignYears.members) {
            for (obj in year.members) {
                new FlxTimer().start(yearTime, (_) -> {
                    FlxTween.tween(obj, { x: obj.x - 350 }, 0.5, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
                });
            }
            yearTime += 0.25;
        }

        // Create the Michael Jordan sprite
        michaelJordan = new FlxSprite(0, 0);
        michaelJordan.visible = false;
        add(michaelJordan);

		// Set the Discord rich presence
		#if DISCORD_ALLOWED
        if (ClientPrefs.options.discordRPC) {
		    DiscordClient.setPresence('Viewing Campaign Menu');
        }
		#end
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!michaelJordan.visible) {
            // Check if the user wants to go back to the main menu or play the selected year
			if (Controls.binds.UI_BACK_JUST_PRESSED) { // Go back to the main menu
                GeneralUtil.fadeIntoState(new MainMenuState(), Constants.TRANSITION_DURATION);
            } else if (Controls.binds.UI_SELECT_JUST_PRESSED) {  // Play the selected year
				var year:CampaignYearIcon = campaignYears.members[currentYear];

                // Check if the year is unlocked
                if (CacheUtil.unlockedYears.contains(year.year)) {
                    // Make sure the user can't scroll through the years
                    // when one was selected
                    hasSelectedYear = true;
                    // If the year is unlocked, tween the other years and go to the play state
                    for (y in campaignYears.members) {
                        if (y != year) {
                            GeneralUtil.tweenSpriteGroup(y, { alpha: 0.3 }, 0.35, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
                        }
                    }

					// Assign the selected year for the loading state
					CacheUtil.selectedYear = year.get_year();

                    // Center the selected year
                    for (obj in year) {
                        FlxTween.tween(obj, { x: (FlxG.width / 2) - (obj.width / 2) }, 0.6, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
                    }

                    // Fade into the play state
                    new FlxTimer().start(1.5, (_) -> {
						GeneralUtil.fadeIntoState(new LoadingState(), Constants.TRANSITION_DURATION, false);
                    });
                } else {
                    // *insert access denied sfx here*
                    FlxG.camera.shake(0.02, 0.1);
                    FlxG.sound.play(PathUtil.ofSound('nope'), accessDeniedVolume);
                    accessDeniedVolume += 0.2;
                    accessDeniedAttempts++;
                }  
            }
        }

        if (!michaelJordan.visible && !hasSelectedYear) {
            // Scroll through the years
            if (Controls.binds.UI_DOWN_PRESSED) {
                if (canScroll && !(currentYear >= campaignYears.length - 1)) {
                    FlxG.sound.play(PathUtil.ofSound('blip'));
                    currentYear++;
                    _scroll(-1);
                }
            } else if (Controls.binds.UI_UP_PRESSED) {
                if (canScroll && !(currentYear <= 0)) {
                    FlxG.sound.play(PathUtil.ofSound('blip'));
                    currentYear--;
                    _scroll(1);
                }
            }
        }

		// Check if the user has tried to enter a locked year too many times
        // If they do, play the goofy ass Michael Jordan meme lmao
		if (accessDeniedAttempts >= 20) {

            // Add the frames to the Michael Jordan sprite
            var frames:Array<Int> = [];
            for (frm in 0...24) {
                frames.push(frm);
            }

			// Get the paths to the image and xml file
			var paths:Array<String> = PathUtil.ofSpriteSheet('lmfao/michael-jordan');

            // Stop the music and play the Michael Jordan sprite
            FlxTween.cancelTweensOf(FlxG.sound.music);
            FlxG.sound.music.volume = 0;
            FlxG.sound.play(PathUtil.ofSound('stop-it-get-some-help'));
			michaelJordan.frames = FlxAtlasFrames.fromSparrow(paths[0], paths[1]);
            michaelJordan.animation.addByIndices('michael-jordan', 'michael-jordan_', frames, '', 11, false);
            michaelJordan.animation.play('michael-jordan');
            michaelJordan.x = (FlxG.width / 2) - (michaelJordan.width / 2);
            michaelJordan.y = (FlxG.height / 2) - (michaelJordan.height / 2);
            michaelJordan.visible = true;
            accessDeniedAttempts = 0;
            accessDeniedVolume = 0.2;

            // Hide the Michael Jordan sprite after 2.4 seconds
            new FlxTimer().start(2.4, (_) -> {
                michaelJordan.visible = false;
                FlxTween.tween(FlxG.sound.music, { volume: 1 }, 1.5, { type: FlxTweenType.ONESHOT });
            });
        }
    }

    private function _scroll(dir:Int, duration:Float = 0.1):Void {
        // If the user can't scroll, just break out of the function and do nothing
        if (!canScroll) return;
        // Scroll the years to make it look :sparkles: fancy :sparkles:
        for (year in campaignYears.members) {
            for (obj in year.members) {
                FlxTween.tween(obj, { y: obj.y + (220 * dir) }, duration, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
            }
        }
        // Prevent the user from scrolling for a short period of time
        // (this is to prevent the user from scrolling too fast and breaking tweens)
        canScroll = false;
        new FlxTimer().start(duration, (_) -> canScroll = true);
    }
}
