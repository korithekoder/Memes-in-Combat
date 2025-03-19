package states.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import backend.util.CacheUtil;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.display.CampaignYearDisplayObject;
import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.GeneralUtil;
import flixel.FlxG;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import flixel.addons.transition.FlxTransitionableState;

/**
 * State that displays the campaign menu with the client's progress.
 */
class CampaignMenuState extends FlxTransitionableState {
    
    var campaignYears:FlxTypedGroup<CampaignYearDisplayObject>;

    var currentYear:Int = 0;
	
	override public function create() {
		super.create();

        GeneralUtil.playMenuMusic();

        campaignYears = new FlxTypedGroup<CampaignYearDisplayObject>();
        add(campaignYears);

        var newY:Float = 20;
        for (year in 0...Constants.CAMPAIGN_YEARS.length) {
            var y = Constants.CAMPAIGN_YEARS[year];
            var baseColor = (y[1] != null) ? y[1] : FlxColor.WHITE;
            var baseOutlineColor = (y[2] != null) ? y[2] : FlxColor.BLACK;
            var unlocked = CacheUtil.unlockedYears.contains(y[0]);
            campaignYears.add(new CampaignYearDisplayObject(FlxG.width + 40, newY, y[0], baseColor, baseOutlineColor, unlocked));
            newY += 220;
        }

        var yearTime:Float = 0.25;
        for (year in campaignYears.members) {
            for (obj in year.members) {
                new FlxTimer().start(yearTime, (_) -> {
                    FlxTween.tween(obj, { x: obj.x - 350 }, 0.5, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
                });
            }
            yearTime += 0.25;
        }

		#if DISCORD_ALLOWED
        if (ClientPrefs.options.discordRPC) {
		    DiscordClient.setPresence('Viewing Campaign Menu');
        }
		#end
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.binds.BACK_JUST_PRESSED) {
            GeneralUtil.fadeIntoState(new MainMenuState(), Constants.TRANSITION_DURATION);
        } else if (FlxG.keys.justPressed.ENTER) {
            GeneralUtil.fadeIntoState(new PlayState(), Constants.TRANSITION_DURATION, false);
        }
    }
}
