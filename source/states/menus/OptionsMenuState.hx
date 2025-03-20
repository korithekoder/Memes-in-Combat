package states.menus;

import backend.util.SaveUtil;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.GeneralUtil;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * State that displays the options menu/
 */
class OptionsMenuState extends FlxTransitionableState {

    var text:FlxText;

    override function create() {
        super.create();

        text = new FlxText('no options?\n*insert sad megamind picture here*');
        text.color = FlxColor.BLACK;
        text.size = 64;
        text.updateHitbox();
        text.alignment = FlxTextAlign.CENTER;
        text.x = (FlxG.width / 2) - (text.width / 2);
        text.y = (FlxG.height / 2) - (text.height / 2);
        add(text);

        #if DISCORD_ALLOWED
        if (ClientPrefs.options.discordRPC) {
		    DiscordClient.setPresence('Viewing Options Screen');
        }
		#end
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

		if (Controls.binds.UI_BACK_JUST_PRESSED) {
            GeneralUtil.fadeIntoState(new MainMenuState(), Constants.TRANSITION_DURATION);
        }
    }
}
