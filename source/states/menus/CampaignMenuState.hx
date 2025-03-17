package states.menus;

import backend.util.CacheUtil;
import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.GeneralUtil;
import flixel.FlxG;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;

/**
 * State that displays the campaign menu with the client's progress.
 */
class CampaignMenuState extends FlxTransitionableState {
    
    var testText:FlxText;
	
	override public function create() {
		super.create();

		camera.fade(FlxColor.BLACK, 0.4, true);
		testText = new FlxText(0, 0, 'Hello, world!');
		testText.color = FlxColor.BLACK;
		testText.size = 64;
		add(testText);

        GeneralUtil.playMenuMusic();
		
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
            GeneralUtil.fadeIntoState(new PlayState(), Constants.TRANSITION_DURATION);
        }
    }
}
