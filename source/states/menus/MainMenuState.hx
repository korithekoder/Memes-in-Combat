package states.menus;

import flixel.FlxBasic;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * State that displays the main menu.
 */
class MainMenuState extends FlxState {
    
    var titleText:FlxText;

    override public function create() {
        titleText = new FlxText("Memes in Combat");
        titleText.size = 90;
        titleText.color = FlxColor.WHITE;
        titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
        titleText.x = 60;
        titleText.y = 80;
        add(titleText);

        FlxTween.angle(titleText, -8, 8, 2.1, {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.quadInOut
        });
    }
}
