package states.menus;

import flixel.FlxSubState;
import substates.options.GameplaySettingsSubState;
import backend.util.PathUtil;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import objects.ui.ClickableText;
import flixel.group.FlxGroup.FlxTypedGroup;
#if DISCORD_ALLOWED
import backend.api.DiscordClient;
#end
import backend.Controls;
import backend.data.ClientPrefs;
import backend.data.Constants;
import backend.util.GeneralUtil;
import flixel.addons.transition.FlxTransitionableState;

/**
 * State that displays the options menu.
 */
class OptionsMenuState extends FlxTransitionableState {

    var options:Array<String> = [
        'Gameplay',
        'Controls',
        'Other'
    ];

    var optionsGroup:FlxTypedGroup<ClickableText>;

    var optionsOnSelect:Map<String, Void -> Void>;

    override function create() {
        super.create();

        // for testing (maybe idk) :p
        FlxG.camera.bgColor = FlxColor.PINK;

        optionsOnSelect = [
            'Gameplay' => () -> _openOptionsMenu(new GameplaySettingsSubState())
        ];

        optionsGroup = new FlxTypedGroup<ClickableText>();
        add(optionsGroup);

        var newX:Float = FlxG.width + 20;
        var newY:Float = FlxG.height / 2;

        for (_ in 0...Std.int(options.length / 2)) {
            newY -= 93;  // 93 is the exact height of each option text
        }

        for (optn in options) {
            var mewingStreak:ClickableText = new ClickableText();
            mewingStreak.text = optn;
            mewingStreak.size = 64;
            mewingStreak.color = FlxColor.WHITE;
            mewingStreak.updateHitbox();
            mewingStreak.setPosition(newX, newY);
            mewingStreak.setHoverBounds((FlxG.width - 330), FlxG.width, newY, newY + mewingStreak.height);
            mewingStreak.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
            mewingStreak.onClick = optionsOnSelect.get(optn);
            mewingStreak.onHover = () -> {
                FlxG.sound.play(PathUtil.ofSound('blip'));
                FlxTween.cancelTweensOf(mewingStreak);
                FlxTween.tween(mewingStreak, { x: (FlxG.width - 330) - 80 }, 0.2, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
            };
            mewingStreak.onHoverLost = () -> {
                FlxTween.cancelTweensOf(mewingStreak);
                FlxTween.tween(mewingStreak, { x: (FlxG.width - 330) }, 0.2, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
            };
            optionsGroup.add(mewingStreak);
            newY += mewingStreak.height + 10;
        }

        var newTime:Float = 0.3;
        for (mbr in optionsGroup.members) {
            new FlxTimer().start(newTime, (_) -> {
                FlxTween.tween(mbr, { x: (FlxG.width - 330) }, 0.5, { type: FlxTweenType.PERSIST, ease: FlxEase.quadOut });
            });
            newTime += 0.2;
        }

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

    override function closeSubState() {
        super.closeSubState();
        optionsGroup.visible = true;
    }

    private function _openOptionsMenu(substate:FlxSubState):Void {
        optionsGroup.visible = false;
        openSubState(substate);
    }
}
