package states.menus;

import backend.data.Constants;
import flixel.util.FlxTimer;
import backend.util.CacheUtil;
import backend.util.PathUtil;
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
    var introText:FlxText;
    var pressAnyKeyText:FlxText;

    var introStageTimer1:FlxTimer = new FlxTimer();
    var introStageTimer2:FlxTimer = new FlxTimer();

    var chosenSplashText:Array<String> = Constants.SPLASH_TEXTS[FlxG.random.int(0, Constants.SPLASH_TEXTS.length - 1)];
    // var chosenSplashText:Array<String> = Constants.SPLASH_TEXTS[Constants.SPLASH_TEXTS.length - 1];

    override public function create() {

        // Start the main menu music
        FlxG.sound.playMusic(PathUtil.ofMusic('Jam Out By Myself'), 1, true);

        titleText = new FlxText('Memes in Combat');
        titleText.size = 90;
        titleText.color = FlxColor.WHITE;
        titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
        titleText.x = 60;
        titleText.y = 80;
        titleText.visible = CacheUtil.alreadySawIntro;
        add(titleText);

        introText = new FlxText();
        introText.size = 60;
        add(introText);

        pressAnyKeyText = new FlxText('Press any key to skip');
        pressAnyKeyText.size = 20;
        pressAnyKeyText.alignment = FlxTextAlign.CENTER;
        pressAnyKeyText.setPosition((FlxG.width - pressAnyKeyText.width) / 2, FlxG.height - pressAnyKeyText.height - 10);
        pressAnyKeyText.alpha = 0;
        add(pressAnyKeyText);

        FlxTween.angle(titleText, -8, 8, 2.1, {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(pressAnyKeyText, { alpha: 1 }, 2, {
            type: FlxTweenType.ONESHOT
        });

        if (!CacheUtil.alreadySawIntro) {
            _startIntro();
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ANY) {
            _setupMainMenu();
        }
    }

    private function _startIntro():Void {
        // Start timer(s) that loops through the different stages
        // of the intro
        var stage:Int = 0;
        introStageTimer1.start(
            // Time
            2.5,
            // Callback
            (timer:FlxTimer) -> {
                stage++;
                _switchIntroStage(stage);
            },
            // Loops
            9
        );

        new FlxTimer().start(
            22.5,
            (timer:FlxTimer) -> {
                introStageTimer2.start(
                    0.5,
                    (timer:FlxTimer) -> {
                        stage++;
                        _switchIntroStage(stage);
                    },
                    4
                );
            }
        );
    }

    private function _switchIntroStage(stage:Int):Void {
        switch (stage) {
            case (1):
                _setIntroText('A game by', true);
            case (2):
                _setIntroText('korithekoder', true);
            case (3):
                _setIntroText('');
            case (4):
                _setIntroText('Music by', true);
            case (5):
                _setIntroText('Basket', true);
            case (6):
                _setIntroText('');
            case (7):
                _setIntroText(chosenSplashText[0], true);
            case (8):
                _setIntroText(chosenSplashText[1], true);
            case (9):
                _setIntroText('');
            case (10):
                _setIntroText('Memes', true);
            case (11):
                _setIntroText('in', true);
            case (12):
                _setIntroText('Combat', true);
            case (13):
                _setupMainMenu();
        }
    }

    private function _setIntroText(text:String, append:Bool = false):Void {
        if (!append) {
            introText.text = text;
        } else {
            introText.text += '$text\n';
        }
        introText.setPosition((FlxG.width - introText.width) / 2, (FlxG.height - introText.height) / 2);
        introText.alignment = FlxTextAlign.CENTER;
    }

    private function _setupMainMenu():Void {
        introText.visible = false;
        titleText.visible = true;
        pressAnyKeyText.visible = false;
        FlxG.camera.bgColor = FlxColor.WHITE;
        CacheUtil.alreadySawIntro = true;
        introStageTimer1.cancel();
        introStageTimer2.cancel();
    }
}
